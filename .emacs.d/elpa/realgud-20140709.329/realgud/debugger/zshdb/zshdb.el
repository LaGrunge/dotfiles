;;; Copyright (C) 2011, 2014 Rocky Bernstein <rocky@gnu.org>
;;  `zshdb' Main interface to zshdb via Emacs
(require 'list-utils)
(require 'load-relative)
(require-relative-list '("../../common/helper") "realgud-")
(require-relative-list '("../../common/track")  "realgud-")
(require-relative-list '("../../common/run")    "realgud:")
(require-relative-list '("core" "track-mode")   "realgud:zshdb-")

(declare-function zshdb-track-mode (bool))
(declare-function zshdb-query-cmdline  'realgud:zshdb-core)
(declare-function zshdb-parse-cmd-args 'realgud:zshdb-core)
(declare-function realgud-run-process 'realgud-core)

;; This is needed, or at least the docstring part of it is needed to
;; get the customization menu to work in Emacs 23.
(defgroup zshdb nil
  "The Zsh debugger: zshdb"
  :group 'processes
  :group 'realgud
  :version "23.1")

;; -------------------------------------------------------------------
;; User definable variables
;;

(defcustom zshdb-command-name
  ;;"zshdb --emacs 3"
  "zshdb"
  "File name for executing the zshdb and its command options.
This should be an executable on your path, or an absolute file name."
  :type 'string
  :group 'zshdb)

(declare-function zshdb-track-mode (bool))

;; -------------------------------------------------------------------
;; The end.
;;

(declare-function zshdb-track-mode     'realgud-bashdb-track-mode)
(declare-function zshdb-query-cmdline  'realgud:zshdb-core)
(declare-function zshdb-parse-cmd-args 'realgud:zshdb-core)
(declare-function realgud:run-debugger 'realgud:run)

; ### FIXME: DRY with other top-level routines
;;;###autoload
(defun realgud:zshdb (&optional opt-cmd-line no-reset)
  "Invoke the zshdb Z-shell debugger and start the Emacs user interface.

String COMMAND-LINE specifies how to run zshdb.

OPT-CMD-LINE is treated like a shell string; arguments are
tokenized by `split-string-and-unquote'. The tokenized string is
parsed by `zshdb-parse-cmd-args' and path elements found by that
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
  (realgud:run-debugger "zshdb" 'zshdb-query-cmdline 'zshdb-parse-cmd-args
			'zshdb-track-mode-hook opt-cmd-line no-reset)
  )

(defalias 'zshdb 'realgud:zshdb)

(provide-me "realgud-")
