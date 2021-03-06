;;; Copyright (C) 2011-2014 Rocky Bernstein <rocky@gnu.org>
(declare-function realgud-terminate &optional cmdbuf)

(defconst realgud-track-char-range 10000
  "Max number of characters from end of buffer to search for stack entry.")

;; Shell process buffers that we can hook into:
(require 'esh-mode)
(require 'comint)

(require 'load-relative)
(require-relative-list
 '("core"           "file"     "fringe"
   "helper"         "init"     "loc"    "lochist"
   "regexp"         "shortkey" "window"
   "bp"
   ) "realgud-")

(require-relative-list
 '("buffer/command" "buffer/helper" "buffer/source") "realgud-buffer-")

(defcustom realgud-short-key-on-tracing? nil
"If non-nil, set short-key mode for any source buffer that is traced into"
  :type 'symbolp
  :group 'realgud)

(make-variable-buffer-local  (defvar realgud-track-mode))
(fn-p-to-fn?-alias 'realgud-loc-p)

(declare-function realgud-bp-add-info                 'realgud-bp)
(declare-function realgud-bp-del-info                 'realgud-bp)
(declare-function realgud-cmdbuf-add-srcbuf           'realgud-buffer-command)
(declare-function realgud-cmdbuf-debugger-name        'realgud-buffer-command)
(declare-function realgud-cmdbuf-info-bp-list=        'realgud-buffer-command)
(declare-function realgud-cmdbuf-info-divert-output?= 'realgud-buffer-command)
(declare-function realgud-cmdbuf-info-in-debugger?    'realgud-buffer-command)
(declare-function realgud-cmdbuf-info-in-debugger?=   'realgud-buffer-command)
(declare-function realgud-cmdbuf-info-last-input-end= 'realgud-buffer-command)
(declare-function realgud-cmdbuf-init                 'realgud-buffer-command)
(declare-function realgud-cmdbuf-loc-hist             'realgud-buffer-command)
(declare-function realgud-cmdbuf-mode-line-update     'realgud-buffer-command)
(declare-function realgud-cmdbuf-mode-line-update     'realgud-buffer-command)
(declare-function realgud-cmdbuf-pat                  'realgud-buffer-command)
(declare-function realgud-cmdbuf?                     'realgud-buffer-command)
(declare-function realgud-terminate                   'realgud-core)
(declare-function realgud-file-loc-from-line          'realgud-file)
(declare-function realgud-fringe-history-set          'realgud-fringe)
(declare-function realgud-get-cmdbuf                  'realgud-buffer-command)
(declare-function realgud-loc-goto                    'realgud-loc)
(declare-function realgud-loc-hist-add                'realgud-lochist)
(declare-function realgud-loc-hist-index              'realgud-lochist)
(declare-function realgud-loc-hist-item               'realgud-lochist)
(declare-function realgud-loc?                        'realgud-loc)
(declare-function realgud-srcbuf-init-or-update       'realgud-source)
(declare-function realgud-srcbuf-loc-hist             'realgud-source)
(declare-function realgud-window-src                  'realgud-window)

(defvar realgud-track-divert-string)

(defun realgud-track-comint-output-filter-hook(text)
  "An output-filter hook custom for comint shells.  Find
location/s, if any, and run the action(s) associated with
finding a new location/s.  The parameter TEXT appears because it
is part of the comint-output-filter-functions API. Instead we use
marks set in buffer-local variables to extract text"

  ;; Instead of trying to piece things together from partial text
  ;; (which can be almost useless depending on Emacs version), we
  ;; monitor to the point where we have the next dbgr prompt, and then
  ;; check all text from comint-last-input-end to process-mark.

  ;; FIXME: Add unwind-protect?
  (if (and realgud-track-mode (realgud-cmdbuf? (current-buffer)))
      (let* ((cmd-buff (current-buffer))
	     (cmd-mark (point-marker))
	     (curr-proc (get-buffer-process cmd-buff))
	     (cmdbuf-last-output-end
	      (realgud-cmdbuf-info-last-input-end realgud-cmdbuf-info))
	     (last-output-end (process-mark curr-proc))
	     (last-output-start (max comint-last-input-end
				     (- last-output-end realgud-track-char-range))))
	;; Sometimes we get called twice and the second time nothing
	;; changes. Guard against this.
	(unless (= last-output-start last-output-end)
	  (unless (= last-output-end cmdbuf-last-output-end)
	    (setq last-output-start (max last-output-start
					 cmdbuf-last-output-end))
	    )
	  ;; Done with using old command buffer's last-input-end.
	  ;; Update that for next time.
	  (realgud-cmdbuf-info-last-input-end= last-output-start)
	  (realgud-track-from-region last-output-start
				  last-output-end cmd-mark cmd-buff
				  't 't))
	)
    )
  )

(defun realgud-track-eshell-output-filter-hook()
  "An output-filter hook custom for eshell shells.  Find
location(s), if any, and run the action(s) associated with We use
marks set in buffer-local variables to extract text"

  ;; FIXME: Add unwind-protect?
  (if realgud-track-mode
      (lexical-let* ((cmd-buff (current-buffer))
		     (cmd-mark (point-marker))
		     (loc (realgud-track-from-region eshell-last-output-start
						  eshell-last-output-end cmd-mark)))
	(realgud-track-loc-action loc cmd-buff 't)))
  )

(defun realgud-track-term-output-filter-hook(text)
  "An output-filter hook custom for ansi-term shells.  Find
location/s, if any, and run the action(s) associated with
finding a new location/s.  The parameter TEXT appears because it
is part of the comint-output-filter-functions API. Instead we use
marks set in buffer-local variables to extract text"
  (if (and realgud-track-mode (realgud-cmdbuf? (current-buffer)))
      (realgud-track-loc text (point-marker))
    ))

(defun realgud-track-from-region(from to &optional cmd-mark opt-cmdbuf
				   shortkey-on-tracing? no-warn-if-no-match?)
  "Find and position a buffer at the location found in the marked region.

You might want to use this function interactively after marking a
region in a debugger-tracked shell buffer (see `realgud-track-mode')
or a more dedicated debugger command buffer.

The marked region location should match the regexp found in the
buffer-local variable `realgud-cmdbuf-info' structure under the
field loc-regexp. You can see what this is by
evaluating (realgud-cmdbuf-info-loc-regexp realgud-cmdbuf-info)"

  (interactive "r")
  (if (> from to) (psetq to from from to))
  (let* ((text (buffer-substring-no-properties from to))
	 (loc (realgud-track-loc text cmd-mark nil nil nil no-warn-if-no-match?))
	 ;; If we see a selected frame number, it is stored
	 ;; in frame-num. Otherwise, nil.
	 (frame-num)
	 (text-sans-loc)
	 (bp-loc)
	 (cmdbuf (or opt-cmdbuf (current-buffer)))
	 )
    (if (realgud-cmdbuf? cmdbuf)
	(if (not (equal "" text))
	    (with-current-buffer cmdbuf
	      (if (realgud-sget 'cmdbuf-info 'divert-output?)
		  (realgud-track-divert-prompt text cmdbuf to))
	      ;; FIXME: instead of these fixed filters,
	      ;; put into a list and iterate over that.
	      (realgud-track-termination? text)
	      (setq text-sans-loc (or (realgud-track-loc-remaining text) text))
	      (setq frame-num (realgud-track-selected-frame text) text)
	      (setq bp-loc (realgud-track-bp-loc text-sans-loc cmd-mark cmdbuf))
	      (if bp-loc
		  (let ((src-buffer (realgud-loc-goto bp-loc)))
		    (realgud-cmdbuf-add-srcbuf src-buffer cmdbuf)
		    (with-current-buffer src-buffer
		      (realgud-bp-add-info bp-loc)
		      )))
	      (if loc
		  (let ((selected-frame
			 (or (not frame-num)
			     (eq frame-num (realgud-cmdbuf-pat "top-frame-num")))))
		    (realgud-track-loc-action loc cmdbuf (not selected-frame)
					   shortkey-on-tracing?)
		    (realgud-cmdbuf-info-in-debugger?= 't)
		    (realgud-cmdbuf-mode-line-update)
		    )
		(progn
		  (setq bp-loc (realgud-track-bp-delete text-sans-loc cmd-mark cmdbuf))
		  (if bp-loc
		      (let ((src-buffer (realgud-loc-goto bp-loc)))
			(realgud-cmdbuf-add-srcbuf src-buffer cmdbuf)
			(with-current-buffer src-buffer
			  (realgud-bp-del-info bp-loc)
			  ))))
		)
	      )
	  )
      ;; else
      (error "Buffer %s is not a debugger command buffer" cmdbuf))
    )
  )

(defun realgud-track-hist-fn-internal(fn)
  "Update both command buffer and a source buffer to reflect the
selected location in the location history. If we started in a
command buffer, we stay in a command buffer. Moving inside a
command buffer always shows the corresponding source
file. However it is possible in shortkey mode to show only the
source code window, even the commmand buffer is updated albeit
unshown."

  (let ((cmdbuf (realgud-get-cmdbuf (current-buffer))))
    (if cmdbuf
	(let* ((loc-hist (realgud-cmdbuf-loc-hist cmdbuf))
	       (window (selected-window))
	       (position (funcall fn loc-hist))
	       (stay-in-cmdbuf?
		(or (eq (current-buffer) cmdbuf)
		    (with-current-buffer cmdbuf
		      (not (realgud-sget 'cmdbuf-info 'in-srcbuf?)))))
	       (loc (realgud-loc-hist-item loc-hist))
	       (srcbuf (realgud-get-srcbuf-from-cmdbuf cmdbuf loc))
	       )
	  (set-buffer (realgud-loc-goto loc))

	  ;; Make sure command buffer is updated
	  (realgud-window-update-position cmdbuf
				       (realgud-loc-cmd-marker loc))

	  ;; FIXME turn into fn. combine with realgud-track-loc-action.
	  (if stay-in-cmdbuf?
	      (let ((cmd-window (realgud-window-src-undisturb-cmd srcbuf)))
		(if cmd-window (select-window cmd-window)))
	    (realgud-window-src srcbuf)
	  )

	  ;; Make sure source buffer is updated
	  (realgud-window-update-position srcbuf
				       (realgud-loc-marker loc))

	  (message "history position %s line %s"
		   (realgud-loc-hist-index loc-hist)
		   (realgud-loc-line-number loc))
	  (select-window window)))
  ))

;; FIXME: Can we dry code more via a macro?
(defun realgud-track-hist-newer()
  (interactive)
  (realgud-track-hist-fn-internal 'realgud-loc-hist-newer))

(defun realgud-track-hist-newest()
  (interactive)
  (realgud-track-hist-fn-internal 'realgud-loc-hist-newest))

(defun realgud-track-hist-older()
  (interactive)
  (realgud-track-hist-fn-internal 'realgud-loc-hist-older))

(defun realgud-track-hist-oldest()
  (interactive)
  (realgud-track-hist-fn-internal 'realgud-loc-hist-oldest))

(defun realgud-track-loc-action (loc cmdbuf &optional not-selected-frame
				  shortkey-on-tracing?)
  "If loc is valid, show loc and do whatever actions we do for
encountering a new loc."
  (if (realgud-loc? loc)
      (let*
	  ((cmdbuf-loc-hist (realgud-cmdbuf-loc-hist cmdbuf))
	   (cmdbuf-local-overlay-arrow?
	    (with-current-buffer cmdbuf
	      (local-variable-p 'overlay-arrow-variable-list)))
	   (stay-in-cmdbuf?
	    (with-current-buffer cmdbuf
	      (not (realgud-sget 'cmdbuf-info 'in-srcbuf?))))
	   (shortkey-mode?
	    (with-current-buffer cmdbuf
	      (realgud-sget 'cmdbuf-info 'src-shortkey?)))
	   (srcbuf)
	   (srcbuf-loc-hist)
	   )

	(setq srcbuf (realgud-loc-goto loc))
	(realgud-srcbuf-init-or-update srcbuf cmdbuf)
	(setq srcbuf-loc-hist (realgud-srcbuf-loc-hist srcbuf))
	(realgud-cmdbuf-add-srcbuf srcbuf cmdbuf)

	(with-current-buffer srcbuf
	  (realgud-short-key-mode-setup
	   (and shortkey-on-tracing?
		(or realgud-short-key-on-tracing? shortkey-mode?))
	   ))

        ;; Do we need to go back to the process/command buffer because other
        ;; output-filter hooks run after this may assume they are in that
        ;; buffer? If so, we may have to use set-buffer rather than
	;; switch-to-buffer in some cases.
	(set-buffer cmdbuf)

	(unless (realgud-sget 'cmdbuf-info 'no-record?)
	  (realgud-loc-hist-add srcbuf-loc-hist loc)
	  (realgud-loc-hist-add cmdbuf-loc-hist loc)
	  (realgud-fringe-history-set cmdbuf-loc-hist cmdbuf-local-overlay-arrow?)
	  )

	;; FIXME turn into fn. combine with realgud-track-hist-fn-internal
	(if stay-in-cmdbuf?
	    (let ((cmd-window (realgud-window-src-undisturb-cmd srcbuf)))
	      (with-current-buffer srcbuf
		(if (and (boundp 'realgud-overlay-arrow1)
			 (markerp realgud-overlay-arrow1))
		    (progn
		      ;; Doesn't work
		      ;; (if not-selected-frame
		      ;; 	  (set-fringe-bitmap-face 'hollow-right-triangle
		      ;; 				  'realgud-overlay-arrow1)
		      ;; 			; else
		      ;; 	(set-fringe-bitmap-face 'realgud-right-triangle1
		      ;; 				'realgud-overlay-arrow1)
		      ;; 	)
		      (realgud-window-update-position srcbuf realgud-overlay-arrow1)))
		)
	      (if cmd-window (select-window cmd-window)))
	  ; else
	  (with-current-buffer srcbuf
	    (realgud-window-src srcbuf)
	    (realgud-window-update-position srcbuf realgud-overlay-arrow1))
	  ;; reset 'in-srcbuf' to allow the command buffer to keep point focus
	  ;; when used directly. 'in-srcbuf' is set 't' early in the stack
	  ;; (prior to common command code, e.g. this) when any command is run
	  ;; from a source buffer
	  (with-current-buffer cmdbuf
	    (realgud-cmdbuf-info-in-srcbuf?= nil))
	  )
	))
  )

(defun realgud-track-loc(text cmd-mark &optional opt-regexp opt-file-group
			   opt-line-group no-warn-on-no-match?
			   opt-ignore-file-re)
  "Do regular-expression matching to find a file name and line number inside
string TEXT. If we match, we will turn the result into a realgud-loc struct.
Otherwise return nil."

  ;; NOTE: realgud-cmdbuf-info is a buffer variable local to the process running
  ;; the debugger. It contains a realgud-cmdbuf-info "struct". In that struct are
  ;; the fields loc-regexp, file-group, and line-group. By setting the
  ;; the fields of realgud-cmdbuf-info appropriately we can accomodate a family
  ;; of debuggers -- one at a time -- for the buffer process.

  (if (realgud-cmdbuf?)
      (let
	  ((loc-regexp (or opt-regexp
			   (realgud-sget 'cmdbuf-info 'loc-regexp)))
	   (file-group (or opt-file-group
			   (realgud-sget 'cmdbuf-info 'file-group)))
	   (line-group (or opt-line-group
			   (realgud-sget 'cmdbuf-info 'line-group)))
	   (ignore-file-re (or opt-ignore-file-re
			       (realgud-sget 'cmdbuf-info 'ignore-file-re)))
	   )
	(if loc-regexp
	    (if (string-match loc-regexp text)
		(let* ((filename (match-string file-group text))
		       (line-str (match-string line-group text))
		       (lineno (string-to-number (or line-str "1"))))
		  (unless line-str (message "line number not found -- using 1"))
		  (if (and filename lineno)
		      (realgud-file-loc-from-line filename lineno cmd-mark nil
					       ignore-file-re)
		    nil))
	      (unless no-warn-on-no-match?
		(message "Unable to file and line number for given line"))
	      )
	  (and (message (concat "Buffer variable for regular expression pattern not"
				" given and not passed as a parameter")) nil)))
    (and (message "Current buffer %s is not a debugger command buffer"
		  (current-buffer)) nil)
    )
  )

(defun realgud-track-bp-loc(text &optional cmd-mark cmdbuf ignore-file-re)
  "Do regular-expression matching to find a file name and line number inside
string TEXT. If we match, we will turn the result into a realgud-loc struct.
Otherwise return nil. CMD-MARK is set in the realgud-loc object created.
"

  ; NOTE: realgud-cmdbuf-info is a buffer variable local to the process
  ; running the debugger. It contains a realgud-cmdbuf-info "struct". In
  ; that struct is the regexp hash to match positions. By setting the
  ; the fields of realgud-cmdbuf-info appropriately we can accomodate a
  ; family of debuggers -- one at a time -- for the buffer process.

  (setq cmdbuf (or cmdbuf (current-buffer)))
  (with-current-buffer cmdbuf
    (if (realgud-cmdbuf?)
	(let* ((loc-pat (realgud-cmdbuf-pat "brkpt-set")))
	  (if loc-pat
	      (let ((bp-num-group   (realgud-loc-pat-num loc-pat))
		    (loc-regexp     (realgud-loc-pat-regexp loc-pat))
		    (file-group     (realgud-loc-pat-file-group loc-pat))
		    (line-group     (realgud-loc-pat-line-group loc-pat))
		    (ignore-file-re (realgud-loc-pat-ignore-file-re loc-pat))
		    )
		(if loc-regexp
		    (if (string-match loc-regexp text)
			(let* ((bp-num (match-string bp-num-group text))
			       (filename (match-string file-group text))
			       (line-str (match-string line-group text))
			       (lineno (string-to-number (or line-str "1")))
			       )
			  (unless line-str
			    (message "line number not found -- using 1"))
			  (if (and filename lineno)
			      (let ((loc-or-error
				     (realgud-file-loc-from-line
				      filename lineno
				      cmd-mark
				      (string-to-number bp-num)
				      ignore-file-re
				      )))
				(if (stringp loc-or-error)
				    (progn
				      (message loc-or-error)
				      ;; set to return nil
				      nil)
				  ;; else
				  (progn
				    ;; Add breakpoint to list of breakpoints
				    (realgud-cmdbuf-info-bp-list=
				     (cons loc-or-error (realgud-sget 'cmdbuf-info 'bp-list)))
				    ;; Set to return location
				    loc-or-error)))
			    nil)))
		  nil))
	    nil))
      (and (message "Current buffer %s is not a debugger command buffer"
		    (current-buffer)) nil)
      )
    )
)

(defun realgud-track-bp-delete(text &optional cmd-mark cmdbuf ignore-file-re)
  "Do regular-expression matching see if a breakpoint has been delete inside
string TEXT. If we match, we will return the location of the breakpoint found
from in command buffer. Otherwise nil is returned."

  ; NOTE: realgud-cmdbuf-info is a buffer variable local to the process
  ; running the debugger. It contains a realgud-cmdbuf-info "struct". In
  ; that struct is the regexp hash to match positions. By setting the
  ; the fields of realgud-cmdbuf-info appropriately we can accomodate a
  ; family of debuggers -- one at a time -- for the buffer process.

  (setq cmdbuf (or cmdbuf (current-buffer)))
  (with-current-buffer cmdbuf
    (if (realgud-cmdbuf?)
	(let* ((loc-pat (realgud-cmdbuf-pat "brkpt-del"))
	       (found-loc nil)
	       )
	  (if loc-pat
	      (let ((bp-num-group   (realgud-loc-pat-num loc-pat))
		    (loc-regexp     (realgud-loc-pat-regexp loc-pat))
		    (loc))
		(if (and loc-regexp (string-match loc-regexp text))
		    (let* ((bp-num (string-to-number (match-string bp-num-group text)))
			   (info realgud-cmdbuf-info)
			   (bp-list (realgud-cmdbuf-info-bp-list info))
			   )
		      (while (and (not found-loc) (setq loc (car-safe bp-list)))
			(setq bp-list (cdr bp-list))
			(if (eq (realgud-loc-num loc) bp-num)
			    (progn
			      (setq found-loc loc)
			      ;; Remove loc from breakpoint list
			      (realgud-cmdbuf-info-bp-list=
			       (remove loc (realgud-cmdbuf-info-bp-list info))))
			))
		      ;; return the location:
		      found-loc)
		  nil))
	    nil))
      (and (message "Current buffer %s is not a debugger command buffer"
		    (current-buffer)) nil)
      )
    )
)

(defun realgud-track-loc-remaining(text)
  "Return the portion of TEXT starting with the part after the
loc-regexp pattern"
  (if (realgud-cmdbuf?)
      (let* ((loc-pat (realgud-cmdbuf-pat "loc"))
	     (loc-regexp (realgud-loc-pat-regexp loc-pat))
	     )
	(if loc-regexp
	    (if (string-match loc-regexp text)
		(substring text (match-end 0))
	      nil)
	  nil))
    nil)
  )

(defun realgud-track-selected-frame(text)
  "Return a selected frame number found in TEXT or nil if none found."
  (if (realgud-cmdbuf?)
      (let ((selected-frame-pat (realgud-cmdbuf-pat "selected-frame"))
	    (frame-num-regexp)
	    )
	(if (and selected-frame-pat
		 (setq frame-num-regexp (realgud-loc-pat-regexp
					 selected-frame-pat)))
	    (if (string-match frame-num-regexp text)
		(let ((frame-num-group (realgud-loc-pat-num selected-frame-pat)))
		  (string-to-number (match-string frame-num-group text)))
	      nil)
	  nil))
    nil)
  )


(defun realgud-track-termination?(text)
  "Return 't and call realgud-terminate-cmdbuf we we have a termination message"
  (if (realgud-cmdbuf?)
      (let ((termination-re (realgud-cmdbuf-pat "termination"))
	    )
	(if (and termination-re (string-match termination-re text))
	    (progn
	      (realgud-terminate (current-buffer))
	      't)
	  nil)
	)
    )
  )

(defun realgud-track-divert-prompt(text cmdbuf to)
  "Return a cons node of the part before the prompt-regexp and the part
   after the prompt-regexp-prompt. If not found return nil."
  (with-current-buffer cmdbuf
    ;; (message "+++3 %s, buf: %s" text (buffer-name))
    (if (realgud-cmdbuf?)
	(let* ((prompt-pat (realgud-cmdbuf-pat "prompt"))
	       (prompt-regexp (realgud-loc-pat-regexp prompt-pat))
	       )
	  (if prompt-regexp
	      (if (string-match prompt-regexp text)
		  (progn
		    (setq realgud-track-divert-string
			  (substring text 0 (match-beginning 0)))
		    ;; We've got desired output, so reset divert output.
		    (realgud-cmdbuf-info-divert-output?= nil)
		    (kill-region realgud-last-output-start to)
		    ;; FIXME: DELETE output. Or do elsewhere?
		    )
	      ))
	  )
      )
    )
  )

(defun realgud-goto-line-for-loc-pat (pt &optional opt-realgud-loc-pat)
  "Display the location mentioned in line described by
PT. OPT-REALGUD-LOC-PAT is used to get regular-expresion pattern
matching information. If not supplied we use the current buffer's \"location\"
pattern found via realgud-cmdbuf information. nil is returned if we can't
find a location. non-nil if we can find a location.
"
  (interactive "d")
  (save-excursion
    (goto-char pt)
    (let*
	((cmdbuf (current-buffer))
	 (cmd-mark (point-marker))
	 (curr-proc (get-buffer-process cmdbuf))
	 (start (line-beginning-position))
	 (end (line-end-position))
	 (loc-pat (or opt-realgud-loc-pat (realgud-cmdbuf-pat "loc")))
	 (loc)
	 )
      (unless (and loc-pat (realgud-loc-pat-p loc-pat))
	(error "Can't find location information for %s" cmdbuf))
      (setq loc (realgud-track-loc (buffer-substring-no-properties start end)
				cmd-mark
				(realgud-loc-pat-regexp loc-pat)
				(realgud-loc-pat-file-group loc-pat)
				(realgud-loc-pat-line-group loc-pat)
				nil
				(realgud-loc-pat-ignore-file-re loc-pat)
				))
      (if (stringp loc)
	  (message loc)
	(if loc (or (realgud-track-loc-action loc cmdbuf) 't)
	  nil))
      ))
    )

(defun realgud-track-set-debugger (debugger-name)
  "Set debugger name and information associated with that debugger for
the buffer process. This info is returned or nil if we can't find a
debugger with that information"
  ;; FIXME: turn in to fn which can be used by realgud-backtrack-set-debugger
  (interactive
   (list (completing-read "Debugger name: " realgud-pat-hash)))

  (let ((regexp-hash (gethash debugger-name realgud-pat-hash))
	(command-hash (gethash debugger-name realgud-command-hash))
	)
    (if regexp-hash
	(let* ((prefix
		(cond
		 ((equal debugger-name "gdb") "realgud:gdb")
		 ((or (equal debugger-name "trepan.pl")
		      (equal debugger-name "trepanpl"))
			     "realgud:trepanpl")
		 ('t debugger-name)))
	       (specific-track-mode (intern (concat prefix "-track-mode")))
	       )
	  (realgud-cmdbuf-init (current-buffer) debugger-name regexp-hash
			    command-hash)
	  (if (and (not (eval specific-track-mode))
		   (functionp specific-track-mode))
	      (funcall specific-track-mode 't))
	  )
      (progn
	(message "I Don't have %s listed as a debugger." debugger-name)
	nil)
      )))

;; FIXME: need better name for this and next fn.
(defun realgud-goto-line-for-pt-and-type (pt type pat-hash)
  "Display the location mentioned for PT given type PAT-HASH indexed TYPE."
  (realgud-goto-line-for-loc-pat pt (gethash type pat-hash)))


(defun realgud-goto-line-for-pt (pt pattern-key)
  "Display the location mentioned by a backtrace line (e.g. Ruby $!)
described by PT."
  (interactive "d")
  (unless (realgud-cmdbuf?)
    (error "You need to be in a debugger command buffer to run this"))
  (let* ((debugger-name (realgud-cmdbuf-debugger-name))
	 (debugger-pat-hash (gethash debugger-name realgud-pat-hash)))
    (realgud-goto-line-for-pt-and-type pt pattern-key debugger-pat-hash)
    )
  )

(defun realgud:goto-debugger-backtrace-line (pt)
  "Display the location mentioned by the debugger backtrace line
described by PT."
  (interactive "d")
  (unless (realgud-goto-line-for-pt pt "debugger-backtrace")
    (message "Didn't match a debugger backtrace location.")
    ))

(defun realgud:goto-lang-backtrace-line (pt)
  "Display the location mentioned by the programming-language backtrace line
described by PT."
  (interactive "d")
  (unless (realgud-goto-line-for-pt pt "lang-backtrace")
    (message "Didn't match a programming-language backtrace location.")
    ))

(provide-me "realgud-")
