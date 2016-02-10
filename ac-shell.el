;;; ac-shell.el --- auto-complete for shellscript -*- lexical-binding: t; -*-

;; Copyright (C) 2016 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/
;; Version: 0.01
;; Package-Requires: ((emacs "24.3") (auto-complete "1.5.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; auto-complete source for shell script. This is port of company-shell
;; (https://github.com/Alexander-Miller/company-shell)

;;; Code:

(require 'auto-complete)
(require 'cl-lib)

(defvar ac-shell--cache nil)

(defun ac-shell--collect-executables (dir)
  (let ((default-directory dir))
    (cl-loop for entry in (directory-files default-directory)
             when (and (not (file-directory-p entry))
                       (file-executable-p entry))
             collect entry)))

(defun ac-shell--collect-candidates ()
  (delete-dups
   (cl-loop for path in (cl-remove-if-not #'file-directory-p exec-path)
            appending (ac-shell--collect-executables path))))

(defun ac-shell--candidates ()
  (cl-loop for cand in (or ac-shell--cache
                           (setq ac-shell--cache (ac-shell--collect-candidates)))
           when (string-prefix-p ac-prefix cand)
           collect cand))

(ac-define-source shell
  '((candidates . ac-shell--candidates)))

;;;###autoload
(defun ac-shell-setup ()
  (interactive)
  (auto-complete-mode +1)
  (add-to-list 'ac-sources 'ac-source-shell))

(provide 'ac-shell)

;;; ac-shell.el ends here
