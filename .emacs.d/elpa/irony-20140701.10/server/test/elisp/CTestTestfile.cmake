# CMake generated Testfile for 
# Source directory: /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/test/elisp
# Build directory: /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/test/elisp
# 
# This file includes the relevent testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(irony-el "/home/lagrunge/local/bin/emacs" "-batch" "-l" "package" "--eval" "(package-initialize) (unless (require 'cl-lib nil t) (package-refresh-contents) (package-install 'cl-lib))" "-l" "/home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/test/elisp/irony.el" "-f" "ert-run-tests-batch-and-exit")
ADD_TEST(irony-cdb-el "/home/lagrunge/local/bin/emacs" "-batch" "-l" "package" "--eval" "(package-initialize) (unless (require 'cl-lib nil t) (package-refresh-contents) (package-install 'cl-lib))" "-l" "/home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/test/elisp/irony-cdb.el" "-f" "ert-run-tests-batch-and-exit")
