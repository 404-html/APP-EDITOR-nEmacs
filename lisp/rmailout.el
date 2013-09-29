;; "RMAIL" mail reader for Emacs: output message to a file.
;; Copyright (C) 1985, 1987 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; patch by S. Tomura 89-Mar-27
(defvar rmail-output-default-directory nil)
(defvar rmail-output-from-alist nil)
(defvar rmail-output-to-alist   nil)

(defun rmail-output-default-file (symbol)
  (let((from-field (mail-fetch-field "from"))
       (from-alist rmail-output-from-alist)
       (to-field   (mail-fetch-field "to"))
       (to-alist   rmail-output-to-alist)
       (cc-field   (mail-fetch-field "cc"))
       (cc-alist   rmail-output-to-alist)
       (result nil))
    (if (stringp from-field)
	(while (and (null result) from-alist)
	  (if (string-match (car (car from-alist)) from-field)
	      (setq result (cdr (car from-alist))))
	  (setq from-alist (cdr from-alist))))
    (if (stringp to-field)
	(while (and (null result) to-alist)
	  (if (string-match (car (car to-alist)) to-field)
	      (setq result (cdr (car to-alist))))
	  (setq to-alist (cdr to-alist))))
    (if (stringp cc-field)
	(while (and (null result) cc-alist)
	  (if (string-match (car (car cc-alist)) cc-field)
	      (setq result (cdr (car cc-alist))))
	  (setq cc-alist (cdr cc-alist))))
    (if result
	(if (null (file-name-directory result))
	    (set  symbol
		  (concat rmail-output-default-directory
			  result))
	  (set symbol result))))
  )
;;; end of patch

;; Temporary until Emacs always has this variable.
(defvar rmail-delete-after-output nil
  "*Non-nil means automatically delete a message that is copied to a file.")

(defun rmail-output-to-rmail-file (file-name)
  "Append the current message to an Rmail file named FILE-NAME.
If the file does not exist, ask if it should be created.
If file is being visited, the message is appended to the Emacs
buffer visiting that file."
;;; patch by S. Tomura 89-Mar-72
;;;  (interactive (list (read-file-name
   (interactive (list 
		      (progn
			(rmail-output-default-file 'rmail-last-rmail-file)
			(read-file-name
;;; end of patch		       
		      (concat "Output message to Rmail file: (default "
			      (file-name-nondirectory rmail-last-rmail-file)
			      ") ")
		      (file-name-directory rmail-last-rmail-file)
		      rmail-last-rmail-file)))
;;; patch by S. Tomura 89-Mar-72
		)
;;; end of patch
  (setq file-name (expand-file-name file-name))
  (setq rmail-last-rmail-file file-name)
  (rmail-maybe-set-message-counters)
  (or (get-file-buffer file-name)
      (file-exists-p file-name)
      (if (yes-or-no-p
	   (concat "\"" file-name "\" does not exist, create it? "))
	  (let ((file-buffer (create-file-buffer file-name)))
	    (save-excursion
	      (set-buffer file-buffer)
	      (rmail-insert-rmail-file-header)
	      (let ((require-final-newline nil))
		(write-region (point-min) (point-max) file-name t 1)))
	    (kill-buffer file-buffer))
	(error "Output file does not exist")))
  (save-restriction
    (widen)
    ;; Decide whether to append to a file or to an Emacs buffer.
    (save-excursion
      (let ((buf (get-file-buffer file-name))
	    (cur (current-buffer))
	    (beg (1+ (rmail-msgbeg rmail-current-message)))
	    (end (1+ (rmail-msgend rmail-current-message))))
	(if (not buf)
	    (append-to-file beg end file-name)
	  (if (eq buf (current-buffer))
	      (error "Can't output message to same file it's already in"))
	  ;; File has been visited, in buffer BUF.
	  (set-buffer buf)
	  (let ((buffer-read-only nil)
		(msg (and (boundp 'rmail-current-message)
			  rmail-current-message)))
	    ;; If MSG is non-nil, buffer is in RMAIL mode.
	    (if msg
		(rmail-maybe-set-message-counters))
	    (widen)
	    (narrow-to-region (point-max) (point-max))
	    (insert-buffer-substring cur beg end)
	    (if msg
		(progn
		  (goto-char (point-min))
		  (widen)
		  (search-backward "\^_")
		  (narrow-to-region (point) (point-max))
		  (goto-char (1+ (point-min)))
		  (rmail-count-new-messages t)
		  (rmail-show-message msg))))))))
  (rmail-set-attribute "filed" t)
  (and rmail-delete-after-output (rmail-delete-forward)))

(defun rmail-output (file-name)
  "Append this message to Unix mail file named FILE-NAME."
  (interactive
   (list
;;; patch by S. Tomura 89-Mar-27
    (progn
      (rmail-output-default-file 'rmail-last-file)
;;; end of patch
    (read-file-name
     (concat "Output message to Unix mail file"
	     (if rmail-last-file
		 (concat " (default "
			 (file-name-nondirectory rmail-last-file)
			 "): " )
	       ": "))			
     (and rmail-last-file (file-name-directory rmail-last-file))
     rmail-last-file)))
;;; patch by S. Tomura 89-Mar-27
   )
;;; end of patch
  (setq file-name (expand-file-name file-name))
  (setq rmail-last-file file-name)
  (let ((rmailbuf (current-buffer))
	(tembuf (get-buffer-create " rmail-output"))
	(case-fold-search t))
    (save-excursion
      (set-buffer tembuf)
      (erase-buffer)
      (insert-buffer-substring rmailbuf)
      (insert "\n")
      (goto-char (point-min))
      (insert "From "
	      (if (mail-fetch-field "from")
		  (mail-strip-quoted-names (mail-fetch-field "from"))
		"unknown")
	      " " (current-time-string) "\n")
      ;; ``Quote'' "\nFrom " as "\n>From "
      ;;  (note that this isn't really quoting, as there is no requirement
      ;;   that "\n[>]+From " be quoted in the same transparent way.)
      (while (search-forward "\nFrom " nil t)
	(forward-char -5)
	(insert ?>))
      (append-to-file (point-min) (point-max) file-name))
    (kill-buffer tembuf))
  (if (equal major-mode 'rmail-mode)
      (progn
	(rmail-set-attribute "filed" t)
	(and rmail-delete-after-output (rmail-delete-forward)))))
