;; Basic commands for Nemacs
;; Coded by K.Handa, Electrotechnical Lab. (handa@etl.go.jp)
;;      and S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Nemacs (Japanese version of GNU Emacs).

;; Nemacs is distributed in the forms of patches to GNU
;; Emacs under the terms of the GNU EMACS GENERAL PUBLIC
;; LICENSE which is distributed along with GNU Emacs by the
;; Free Software Foundation.

;; Nemacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
;; more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs; see the file COPYING.
;; If not, write to the Free Software Foundation, 675 Mass
;; Ave, Cambridge, MA 02139, USA.

;;; 87.6.15  created by K.Handa
;;; 87.6.24  modified by K.Handa & H.Nakahara<a32275@tansei.u-tokyo.junet>
;;; 88.1.18  modified for Nemacs Ver.2.0 by K.Handa
;;; 88.6.19  modified for Nemacs Ver.2.1 by K.Handa
;;; 89.3.14  modified for Nemacs Ver.3.0 by K.Handa
;;; 89.11.17 modified for Nemacs Ver.3.2 by K.Handa and S.Tomura
;;; 90.2.28  modified for Nemacs Ver.3.3.1 by K.Handa
;;; 90.6.6   modified for Nemacs Ver.3.3.2 by K.Handa

(defconst nemacs-version "3.3.2" "\
Version numbers of this version of Nemacs.")

(defconst nemacs-version-date "1990.6.6" "\
Distribution date of this version of Nemacs.")

(defun nemacs-version () "\
Return string describing the version of Nemacs that is running."
  (interactive)
  (if (interactive-p)
      (message "%s" (nemacs-version))
    (format "Nemacs version %s of %s" nemacs-version nemacs-version-date)))
  
(defconst mode-line-nemacs-header "N")

(setq-default mode-line-format
  (list (purecopy "")
   'mode-line-modified
   'mode-line-nemacs-header
   'mode-line-buffer-identification
   (purecopy "   ")
   'global-mode-string
   (purecopy "  %[(")
   '(kanji-flag ("%c" ":"))
   'mode-name 'minor-mode-alist "%n" 'mode-line-process
   (purecopy ")%]--")
   (purecopy '(-3 . "%p"))
   (purecopy "-%-")))

(defun kanji-code-p (code)
  (and (numberp code) (<= kanji-code-min code) (<= code kanji-code-max)))

(defun invoke-find-kanji-file-input-code (filename visit start end)
  (save-excursion
    (let ((kanji-flag nil)
	  (buffer-read-only t))
      (condition-case ()
	  (let ((code (funcall find-kanji-file-input-code
			       filename visit start end)))
	    (if (kanji-code-p code) code nil))
	(error nil)))))

(setq find-kanji-file-input-code
      'find-kanji-file-input-code-by-file-contents)

(defun find-kanji-file-input-code-by-file-contents (filename visit start end)
  (setq kanji-fileio-code (check-region-kanji-code start end)))

(defun invoke-find-kanji-file-output-code (start end filename append visit)
  (save-excursion
    (let ((buffer-read-only t))
      (condition-case ()
	  (let ((code (funcall find-kanji-file-output-code
			       start end filename append visit)))
	    (if (kanji-code-p code) code nil))
	(error nil)))))

(setq find-kanji-file-output-code 'kanji-fileio-code)

(defun kanji-fileio-code (&rest rest)
  kanji-fileio-code)

(defun invoke-find-kanji-process-code (buffer program
					      &optional servicep &rest args)
  (save-excursion
    (let ((buffer-read-only t))
      (condition-case ()
	  (let ((code (apply find-kanji-process-code
			     buffer program servicep args)))
	    (if (kanji-code-p code) code nil))
	(error nil)))))

(defconst load-hook 'load-hook   
  "* Called in `load' before normal loading procedure.\n\
Passed two arguments, FILENAME and NOMESSAGE.\n\
FILENAME is a really existing filename.\n\
If this function returns NIL,\n\
`load' proceeds to the rest of normal loading procedure." )

(defun load-hook (file nomessage)
  "Current definition of this function is that\n\
all non *.elc files are at first read in a buffer, the buffer is evaled,\n\
and then T is returned.  As for *.elc, NIL is returned."
  (if (not (string-match "\\.elc$" file))
      (progn
	(let ((buffer (generate-new-buffer "*load-temp*"))
	      (filename (file-name-nondirectory file))
	      (load-in-progress t)
	      return)
	  (if nomessage nil
	    (message "LOADING %s..." filename)
	    (sit-for 0))
	  (unwind-protect
	      (condition-case err
		  (progn
		    (save-excursion
		      (set-buffer buffer)
		      (insert-file-contents file)
		      (goto-char (point-min)))
		    (while t
		      (eval (read buffer))))
		(end-of-file (setq return t)))
	    (if (and return (not noninteractive) (not nomessage))
		(message "LOADING %s...done" filename))
	    (kill-buffer buffer))
	  t))))

(defun nemacs-lisp-interaction-mode ()
  "Major mode for typing and evaluating Lisp forms in Nemacs.\n\
It first sets lisp-interaction-mode and then sets kanji-flag\n\
and kanji-fileio-code to their defautl values.\n\
See lisp-interaction-mode for more detail."
  (funcall 'lisp-interaction-mode)
  (setq kanji-flag default-kanji-flag)
  (setq kanji-fileio-code default-kanji-fileio-code))

;;;
;;;  Modification of kill-all-local-variables  by S.Tomura  89.12.15
;;;
;;;  protect specified local variables from kill-all-local-variables
;;;

(defconst *protected-local-variables* 
  '(kanji-flag
    kanji-fileio-code
    )
  "*List of buffer local variables protected from 'kill-all-local-variables' ."
  )

(defun save-protected-local-variables (vlist)
  (let ((vlist vlist)
	  (alist nil))
    (while vlist
      (if (boundp (car vlist))
	  (setq alist (cons (cons (car vlist) (eval (car vlist)))
			alist)))
      (setq vlist (cdr vlist)))
    alist))

(defun recover-protected-local-variables (alist)
  (let ((alist alist))
    (while alist
      (set (car (car alist)) (cdr (car alist)))
      (setq alist (cdr alist)))))

(if (not (fboundp 'si:kill-all-local-variables))
    (fset 'si:kill-all-local-variables (symbol-function 'kill-all-local-variables)))

(defun kill-all-local-variables ()
  "Eliminate all the buffer-local variable values of the current buffer\n\
except variables in *protected-local-variables* of the current buffer.\n\
This buffer will then see the default values of such variables."
  (let ((alist (save-protected-local-variables *protected-local-variables*)))
    ;;; We can use "buffer-local-variables". Which is better?
    (unwind-protect
	(si:kill-all-local-variables)
      (recover-protected-local-variables alist))))

(defvar self-insert-after-hook nil
  "Hook to run when extended self insertion command exits. Should take
two arguments START and END correspoding to character position.")

(make-variable-buffer-local 'self-insert-after-hook)
