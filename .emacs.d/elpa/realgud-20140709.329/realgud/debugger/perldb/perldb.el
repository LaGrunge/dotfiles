;;; Copyright (C) 2011, 2014 Rocky Bernstein <rocky@gnu.org>
;;  `perldb' Main interface to perl debugger via Emacs
(require 'load-relative)
(require-relative-list '("../../common/helper") "realgud-")
(require-relative-list '("../../common/run")    "realgud:")
(require-relative-list '("core" "track-mode")   "realgud:perldb-")

(declare-function realgud:run-debugger 'realgud:run)

;; This is needed, or at least the docstring part of it is needed to
;; get the customization menu to work in Emacs 23.
(defgroup realgud:perldb nil
  "The Perl debugger (realgud variant)"
  :group 'processes
  :group 'realgud
  :group 'perl
  :version "23.1")

;; -------------------------------------------------------------------
;; User-definable variables
;;

(defcustom realgud:perldb-command-name
  "perl -d"
  "Option to needed to run the Perl debugger"
  :type 'string
  :group 'realgud:perldb)

;; -------------------------------------------------------------------
;; The end.
;;

(declare-function perldb-track-mode (bool))
(declare-function realgud:perldb-query-cmdline  'realgud:perldb-core)
(declare-function realgud:perldb-parse-cmd-args 'realgud:perldb-core)
(declare-function realgud-run-process 'realgud-core)

;;;###autoload
(defun realgud:perldb (&optional opt-cmd-line no-reset)
  "Invoke the Perl debugger and start the Emacs user interface.

String OPT-CMD-LINE specifies how to run nodejs.

OPT-CMD-LINE is treated like a shell string; arguments are
tokenized by `split-string-and-unquote'. The tokenized string is
parsed by `perldb-parse-cmd-args' and path elements found by that
are expanded using `expand-file-name'.

Normally, command buffers are reused when the same debugger is
reinvoked inside a command buffer with a similar command. If we
discover that the buffer has prior command-buffer information and
NO-RESET is nil, then that information which may point into other
buffers and source buffers which may contain marks and fringe or
marginal icons is reset. See `loc-changes-clear-buffer' to clear
fringe and marginal icons.
"
  (interactive)
  (let ((cmd-buf
	 (realgud:run-debugger "perldb"
			       'realgud:perldb-query-cmdline
			       'realgud:perldb-parse-cmd-args
			       'perldb-track-mode-hook
			       opt-cmd-line no-reset))
	)
    (if cmd-buf
	(with-current-buffer cmd-buf
	  ;; FIXME: figure out why track mode is not set initially
	  (setq perldb-track-mode 't)
	  (perldb-track-mode)
	  )
      )))


(defalias 'perl5db 'realgud:perldb)
(defalias 'perldb 'realgud:perldb)

(provide-me "realgud-")
