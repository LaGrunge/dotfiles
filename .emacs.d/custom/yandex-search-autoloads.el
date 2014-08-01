;;; ack-and-a-half-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (yandex-search-find-file-same yandex-search-find-file
;;;;;;  yandex-search-same yandex-search) "yandex-search" "yandex-search.el"
;;;;;;  (21452 62177 726108 390000))
;;; Generated autoloads from yandex-search.el

(autoload 'yandex-search "yandex-search" "\
Run ack.
PATTERN is interpreted as a regular expression, iff REGEXP is
non-nil.  If called interactively, the value of REGEXP is
determined by `yandex-search-regexp-search'.  A prefix arg
toggles the behavior.  DIRECTORY is the root directory.  If
called interactively, it is determined by
`yandex-search-project-root-file-patterns'.  The user is only
prompted, if `yandex-search-prompt-for-directory' is set.

\(fn PATTERN &optional REGEXP DIRECTORY)" t nil)

(autoload 'yandex-search-same "yandex-search" "\
Run ack with --type matching the current `major-mode'.
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
prompted, if `yandex-search-prompt-for-directory' is set.`

\(fn PATTERN &optional REGEXP DIRECTORY)" t nil)

(autoload 'yandex-search-find-file "yandex-search" "\
Prompt to find a file found by ack in DIRECTORY.

\(fn &optional DIRECTORY)" t nil)

(autoload 'yandex-search-find-file-same "yandex-search" "\
Prompt to find a file found by ack in DIRECTORY.

\(fn &optional DIRECTORY)" t nil)

;;;***

;;;### (autoloads nil nil ("yandex-search-pkg.el") (21452 62177
;;;;;;  839430 828000))

;;;***

(provide 'yandex-search-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; yandex-search-autoloads.el ends here
