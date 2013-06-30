;; SLIME FiveAM integration.
;; Copyright (C) 2013 Russell Sim <russell.sim@gmail.com>
;;
;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public
;; License along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.


(defvar slime-fiveam-history nil
  "History list for fiveam tests.")

(defun slime-list-fiveam-tests ()
  (slime-eval '(fiveam:test-names)))

(defun slime-choose-fiveam-test ()
  (completing-read "Fiveam Test :"
                   (slime-bogus-completion-alist (slime-list-fiveam-tests))
                   nil nil nil 'slime-fiveam-history))

(defmacro deffiveam-repl-shortcut (command)
  (let ((command-string (symbol-name command)))
    `(defslime-repl-shortcut ,(make-symbol (concat "slime-fiveam-" command-string))
       (,command-string)
       (:handler (lambda ()
                   (interactive)
                   (let ((test (slime-choose-fiveam-test)))
                     (insert "(fiveam:" ,command-string " '" test ")")
                     (slime-repl-send-input t))))
       (:one-liner "Run a Fiveam test."))))

(deffiveam-repl-shortcut run!)
(deffiveam-repl-shortcut debug!)

(provide 'slime-fiveam)