;; SLIME FiveAM integration.
;; Copyright (C) 2013 Russell Sim <russell.sim@gmail.com>
;;
;; Author   : Russell Sim <russell.sim@gmail.com>
;; URL      : https://github.com/russell/slime-fiveam
;; Version  : 0.1
;; Keywords : lisp, testing, repl, slime
;;
;; This file is part of GNU Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

(eval-when-compile
  (require 'slime)
  (require 'cl))

(defvar slime-fiveam-history nil
  "History list for fiveam tests.")

(defun slime-list-fiveam-tests ()
  (slime-eval '(fiveam:test-names)))

(defun slime-choose-fiveam-test ()
  (completing-read "FiveAM Test :"
                   (slime-bogus-completion-alist (slime-list-fiveam-tests))
                   nil nil nil 'slime-fiveam-history))

(defmacro deffiveam-repl-shortcut (command)
  (let ((command-string (symbol-name command)))
    `(defslime-repl-shortcut ,(intern (concat "slime-fiveam-" command-string))
       (,command-string)
       (:handler (lambda ()
                   (interactive)
                   (let ((test (slime-choose-fiveam-test)))
                     (insert "(fiveam:" ,command-string " '" test ")")
                     (slime-repl-send-input t))))
       (:one-liner "Run a FiveAM test."))))

(deffiveam-repl-shortcut run!)
(deffiveam-repl-shortcut debug!)

(provide 'slime-fiveam)
