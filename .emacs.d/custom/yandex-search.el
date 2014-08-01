;;; yandex-search.el --- Yet another front-end for ack
;;
;; Copyright (C) 2013 Jacob Helwig <jacob@technosorcery.net>
;; Alexey Lebedeff <binarin@binarin.ru>
;; Andrew Pennebaker <andrew.pennebaker@gmail.com>
;; Andrew Stine <stine.drew@gmail.com>
;; Derek Chen-Becker <derek@precog.com>
;; Gleb Peregud <gleber.p@gmail.com>
;; Kim van Wyk <vanwykk@gmail.com>
;; Lars Andersen <expez@expez.com>
;; Ronaldo M. Ferraz <ronaldoferraz@gmail.com>
;; Ryan Thompson <rct@thompsonclan.org>
;;
;; Author: Jacob Helwig <jacob+ack@technosorcery.net>
;; Homepage: http://technosorcery.net
;; Version: 20130815.1917
;; X-Original-Version: 1.2.0
;; URL: https://github.com/jhelwig/yandex-search
;;
;; This file is NOT part of GNU Emacs.
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of
;; this software and associated documentation files (the "Software"), to deal in
;; the Software without restriction, including without limitation the rights to
;; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is furnished to do
;; so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;;; Commentary:
;;
;; yandex-search.el provides a simple compilation mode for the perl
;; grep-a-like ack (http://petdance.com/ack/).
;;
;; Add the following to your .emacs:
;;
;;     (add-to-list 'load-path "/path/to/yandex-search")
;;     (require 'yandex-search)
;;     (defalias 'ack 'yandex-search)
;;     (defalias 'ack-same 'yandex-search-same)
;;     (defalias 'ack-find-file 'yandex-search-find-file)
;;     (defalias 'ack-find-file-same 'yandex-search-find-file-same)
;;
;; Run `ack' to search for all files and `ack-same' to search for
;; files of the same type as the current buffer.
;;
;; `next-error' and `previous-error' can be used to jump to the
;; matches.
;;
;; `ack-find-file' and `ack-find-same-file' use ack to list the files
;; in the current project.  It's a convenient, though slow, way of
;; finding files.
;;

;;; Code:

(eval-when-compile (require 'cl))
(require 'compile)
(require 'grep)
(require 'thingatpt)

(add-to-list 'debug-ignored-errors
             "^Moved \\(back before fir\\|past la\\)st match$")
(add-to-list 'debug-ignored-errors "^File .* not found$")

(define-compilation-mode yandex-search-mode "YandexSearch"
  "Yandex Codesearch results compilation mode."
  (set (make-local-variable 'truncate-lines) t)
  (set (make-local-variable 'compilation-disable-input) t)
  (let ((smbl  'compilation-ack-nogroup)
        (pttrn '("^\\([^:\n]+?\\):\\([0-9]+\\):" 1 2 3)))
    (set (make-local-variable 'compilation-error-regexp-alist) (list smbl))
    (set (make-local-variable 'compilation-error-regexp-alist-alist) (list (cons smbl pttrn))))
  (set (make-local-variable 'compilation-process-setup-function) 'yandex-search-mode-setup)
  (set (make-local-variable 'compilation-error-face) grep-hit-face))

(defgroup yandex-search nil "Yet another front end for Yndex CodeSearch."
  :group 'tools
  :group 'matching)

(defcustom yandex-search-executable (executable-find "f")
  "*The location of the f script executable."
  :group 'yandex-search
  :type 'file)

(defcustom yandex-search-buffer-name "*yandex-search*"
  "*The name of the yandex-search buffer."
  :group 'yandex-search
  :type 'string)

(defun ack-buffer-name (mode) yandex-search-buffer-name)

(defcustom yandex-search-arguments nil
  "*Extra arguments to pass to f."
  :group 'yandex-search
  :type '(repeat (string)))

(defcustom yandex-search-mode-type-alist nil
  "*File type(s) to search per major mode.  (yandex-search-same)
This overrides values in `yandex-search-mode-type-default-alist'.
The car in each list element is a major mode, and the rest
is a list of strings passed to the --type flag of ack when running
`yandex-search-same'."
  :group 'yandex-search
  :type '(repeat (cons (symbol :tag "Major mode")
                       (repeat (string :tag "ack --type")))))

(defcustom yandex-search-mode-extension-alist nil
  "*File extensions to search per major mode.  (yandex-search-same)
This overrides values in `yandex-search-mode-extension-default-alist'.
The car in each list element is a major mode, and the rest
is a list of file extensions to be searched in addition to
the type defined in `yandex-search-mode-type-alist' when
running `yandex-search-same'."
  :group 'yandex-search
  :type '(repeat (cons (symbol :tag "Major mode")
                       (repeat :tag "File extensions" (string)))))

(defcustom yandex-search-ignore-case 'smart
  "*Whether or not to ignore case when searching.
The special value 'smart enables the ack option \"smart-case\"."
  :group 'yandex-search
  :type '(choice (const :tag "Case sensitive" nil)
                 (const :tag "Smart case" 'smart)
                 (const :tag "Case insensitive" t)))

(defcustom yandex-search-regexp-search t
  "*Default to regular expression searching.
Giving a prefix argument to `yandex-search' toggles this option."
  :group 'yandex-search
  :type '(choice (const :tag "Literal searching" nil)
                 (const :tag "Regular expression searching" t)))

(defcustom yandex-search-use-environment t
  "*Use .ackrc and ACK_OPTIONS when searching."
  :group 'yandex-search
  :type '(choice (const :tag "Ignore environment" nil)
                 (const :tag "Use environment" t)))

(defcustom yandex-search-root-directory-functions '(yandex-search-guess-project-root)
  "*List of functions used to find the base directory to ack from.
These functions are called until one returns a directory.  If successful,
`yandex-search' is run from that directory instead of from `default-directory'.
The directory is verified by the user depending on `yandex-search-prompt-for-directory'."
  :group 'yandex-search
  :type '(repeat function))

(defcustom yandex-search-project-root-file-patterns
  '(".project\\'"
    ".xcodeproj\\'"
    ".sln\\'"
    "\\`Project.ede\\'"
    "\\`.git\\'"
    "\\`.bzr\\'"
    "\\`_darcs\\'"
    "\\`.arcadia.root\\'"
    "\\`.hg\\'")
  "*List of file patterns for the project root (used by `yandex-search-guess-project-root').
Each element is a regular expression.  If a file matching any element is
found in a directory, then that directory is assumed to be the project
root by `yandex-search-guess-project-root'."
  :group 'yandex-search
  :type '(repeat (string :tag "Regular expression")))

(defcustom yandex-search-prompt-for-directory 'unless-guessed
  "*Prompt for directory in which to run ack.
If this is 'unless-guessed, then the value determined by
`yandex-search-root-directory-functions' is used without
confirmation.  If it is nil, then the directory is never
confirmed.  If t, then always prompt for the directory to use."
  :group 'yandex-search
  :type '(choice (const :tag "Don't prompt" nil)
                 (const :tag "Don't prompt when guessed" unless-guessed)
                 (const :tag "Always prompt" t)))

(defcustom yandex-search-use-ido nil
  "Whether or not yandex-search should use ido to provide
  completion suggestions when prompting for directory.")

;;; Default setting lists ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst yandex-search-mode-type-default-alist
  '((c++-mode ".*\.(cpp|h)$")
    (python-mode ".*\.(py)$"))
  "Default values for `yandex-search-mode-type-alist'.")

(defconst yandex-search-mode-extension-default-alist
  '((d-mode "d"))
  "Default values for `yandex-search-mode-extension-alist'.")

(defun yandex-search-create-type (extensions)
  (list "--type-set"
        (concat "yandex-search-custom-type=" (mapconcat 'identity extensions ","))
        "--type" "yandex-search-custom-type"))

(defun yandex-search-type-for-major-mode (mode)
  "Return the --type and --type-set arguments to use with ack for major mode MODE."
  (let ((types (cdr (or (assoc mode yandex-search-mode-type-alist)
                        (assoc mode yandex-search-mode-type-default-alist))))
        (ext (cdr (or (assoc mode yandex-search-mode-extension-alist)
                      (assoc mode yandex-search-mode-extension-default-alist))))
        result)
    (dolist (type types)
      (push type result)
      (push "--type" result))
    (if ext
        (if types
            `("--type-add" ,(concat (car types)
                                    "=" (mapconcat 'identity ext ","))
              . ,result)
          (yandex-search-create-type ext))
      result)))

;;; Project root ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun yandex-search-guess-project-root ()
  "Guess the project root directory.
This is intended to be used in `yandex-search-root-directory-functions'."
  (catch 'root
    (let ((dir (expand-file-name (if buffer-file-name
                                     (file-name-directory buffer-file-name)
                                   default-directory)))
          (pattern (mapconcat 'identity yandex-search-project-root-file-patterns "\\|")))
      (while (not (equal dir "/"))
        (when (directory-files dir nil pattern t)
          (throw 'root dir))
        (setq dir (file-name-directory (directory-file-name dir)))))))

;;; Commands ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar yandex-search-directory-history nil
  "Directories recently searched with `yandex-search'.")
(defvar yandex-search-literal-history nil
  "Strings recently searched for with `yandex-search'.")
(defvar yandex-search-regexp-history nil
  "Regular expressions recently searched for with `yandex-search'.")

(defun yandex-search-initial-contents-for-read ()
  (when (yandex-search-use-region-p)
    (buffer-substring-no-properties (region-beginning) (region-end))))

(defun yandex-search-default-for-read ()
  (unless (yandex-search-use-region-p)
    (thing-at-point 'symbol)))

(defun yandex-search-use-region-p ()
  (or (and (fboundp 'use-region-p) (use-region-p))
      (and transient-mark-mode mark-active
           (> (region-end) (region-beginning)))))

(defsubst yandex-search-read (regexp)
  (let* ((default (yandex-search-default-for-read))
         (type (if regexp "pattern" "literal search"))
         (history-var )
         (prompt  (if default
                      (format "CodeSearch %s (default %s): " type default)
                    (format "CodeSearch %s: " type))))
    (read-string prompt
                 (yandex-search-initial-contents-for-read)
                 (if regexp 'ack-regexp-history 'ack-literal-history)
                 default)))

(defun yandex-search-read-dir ()
  (let ((dir (run-hook-with-args-until-success 'yandex-search-root-directory-functions)))
    (if yandex-search-prompt-for-directory
        (if (and dir (eq yandex-search-prompt-for-directory 'unless-guessed))
            dir
          (if yandex-search-use-ido
              (ido-read-directory-name "Directory: " dir dir t)
            (read-directory-name "Directory: " dir dir t)))
      (or dir
          (and buffer-file-name (file-name-directory buffer-file-name))
          default-directory))))

(defsubst yandex-search-xor (a b)
  (if a (not b) b))

(defun yandex-search-interactive ()
  "Return the (interactive) arguments for `yandex-search' and `yandex-search-same'."
  (let ((regexp (yandex-search-xor current-prefix-arg yandex-search-regexp-search)))
    (list (yandex-search-read regexp)
          regexp
          (yandex-search-read-dir))))

(defun yandex-search-type ()
  (or (yandex-search-type-for-major-mode major-mode)
      (when buffer-file-name
        (yandex-search-create-type (list (file-name-extension buffer-file-name))))))

(defun yandex-search-option (name enabled)
  (format "--%s%s" (if enabled "" "no") name))

(defun yandex-search-arguments-from-options (regexp)
  (let ((arguments (list "--no-colors" "-j" "-c" "-m 1000" "-N"
;;                         (yandex-search-option "smart-case" (eq yandex-search-ignore-case 'smart))
;;                         (yandex-search-option "env" yandex-search-use-environment)
                         )))
    (unless yandex-search-ignore-case
      (push "-i" arguments))
    (unless regexp
      (push "--files" arguments))
    arguments))

(defun yandex-search-string-replace (from to string &optional re)
  "Replace all occurrences of FROM with TO in STRING.
All arguments are strings.  When optional fourth argument (RE) is
non-nil, treat FROM as a regular expression."
  (let ((pos 0)
        (res "")
        (from (if re from (regexp-quote from))))
    (while (< pos (length string))
      (if (setq beg (string-match from string pos))
          (progn
            (setq res (concat res
                              (substring string pos (match-beginning 0))
                              to))
            (setq pos (match-end 0)))
        (progn
          (setq res (concat res (substring string pos (length string))))
          (setq pos (length string)))))
    res))

(defun yandex-search-run (directory regexp pattern &rest arguments)
  "Run ack in DIRECTORY with ARGUMENTS."
  (let ((default-directory (if directory
                               (file-name-as-directory (expand-file-name directory))
                             default-directory)))
    (setq arguments (append yandex-search-arguments
                            (yandex-search-arguments-from-options regexp)
                            arguments
                            (list "--")
                            (list (shell-quote-argument pattern))
                            (when (eq system-type 'windows-nt)
                              (list (concat " < " null-device)))
                            ))
    (make-local-variable 'compilation-buffer-name-function)
    (let (compilation-buffer-name-function)
      (setq compilation-buffer-name-function 'ack-buffer-name)
      (compilation-start (mapconcat 'identity (nconc (list yandex-search-executable) arguments) " ")
                         'yandex-search-mode))))

(defun yandex-search-read-file (prompt choices)
  (if ido-mode
      (ido-completing-read prompt choices nil t)
    (require 'iswitchb)
    (with-no-warnings
      (let ((iswitchb-make-buflist-hook
             (lambda () (setq iswitchb-temp-buflist choices))))
        (iswitchb-read-buffer prompt nil t)))))

(defun yandex-search-list-files (directory &rest arguments)
  (with-temp-buffer
    (let ((default-directory directory))
      (when (eq 0 (apply 'call-process yandex-search-executable nil t nil "-f" "--print0"
                         arguments))
        (goto-char (point-min))
        (let ((beg (point-min))
              files)
          (while (re-search-forward "\0" nil t)
            (push (buffer-substring beg (match-beginning 0)) files)
            (setq beg (match-end 0)))
          files)))))

(defun yandex-search-version-string ()
  "Return the ack version string."
  (with-temp-buffer
    (call-process yandex-search-executable nil t nil "--version")
    (goto-char (point-min))
    (re-search-forward " +")
    (buffer-substring (point) (point-at-eol))))

(defun yandex-search-mode-setup ()
  "Setup compilation variables and buffer for `yandex-search'.
Set up `compilation-exit-message-function'."
  (set (make-local-variable 'compilation-exit-message-function)
       (lambda (status code msg)
         (if (eq status 'exit)
             (cond ((and (zerop code) (buffer-modified-p))
                    '("finished (matches found)\n" . "matched"))
                   ((not (buffer-modified-p))
                    '("finished with no matches found\n" . "no match"))
                   (t
                    (cons msg code)))
           (cons msg code)))))

;;; Public interface ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defun yandex-search (pattern &optional regexp directory)
  "Run ack.
PATTERN is interpreted as a regular expression, iff REGEXP is
non-nil.  If called interactively, the value of REGEXP is
determined by `yandex-search-regexp-search'.  A prefix arg
toggles the behavior.  DIRECTORY is the root directory.  If
called interactively, it is determined by
`yandex-search-project-root-file-patterns'.  The user is only
prompted, if `yandex-search-prompt-for-directory' is set."
  (interactive (yandex-search-interactive))
  (yandex-search-run directory regexp pattern))

;;;###autoload
(defun yandex-search-same (pattern &optional regexp directory)
  "Run ack with --type matching the current `major-mode'.
The types of files searched are determined by
`yandex-search-mode-type-alist' and
`yandex-search-mode-extension-alist'.  If no type is configured,
the buffer's file extension is used for the search.  PATTERN is
interpreted as a regular expression, iff REGEXP is non-nil.  If
called interactively, the value of REGEXP is determined by
`yandex-search-regexp-search'.  A prefix arg toggles that value.
DIRECTORY is the directory in which to start searching.  If
called interactively, it is determined by
`yandex-search-project-root-file-patterns`.  The user is only
prompted, if `yandex-search-prompt-for-directory' is set.`"
  (interactive (yandex-search-interactive))
  (let ((type (yandex-search-type)))
    (if type
        (apply 'yandex-search-run directory regexp pattern type)
      (yandex-search pattern regexp directory))))

;;;###autoload
(defun yandex-search-find-file (&optional directory)
  "Prompt to find a file found by ack in DIRECTORY."
  (interactive (list (yandex-search-read-dir)))
  (find-file (expand-file-name
              (yandex-search-read-file
               "Find file: "
               (yandex-search-list-files directory))
              directory)))

;;;###autoload
(defun yandex-search-find-file-same (&optional directory)
  "Prompt to find a file found by ack in DIRECTORY."
  (interactive (list (yandex-search-read-dir)))
  (find-file (expand-file-name
              (yandex-search-read-file
               "Find file: "
               (apply 'yandex-search-list-files directory (yandex-search-type)))
              directory)))

;;; End yandex-search.el ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'yandex-search)

;;; yandex-search.el ends here
