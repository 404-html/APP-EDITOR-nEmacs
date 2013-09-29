;; Kanji Utility commands for Nemacs
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)
;;      and K.Handa, Electrotechnical Lab. (handa@etl.go.jp)

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

;;; Ver.1.18  modified by K.Handa 90-Feb-27
;;;	      list-kanji-code-briefly shows FIDP in this order
;;; Ver.1.17  modified by S.Tomura 90-Jan-13
;;;           *-kanji-code-match uses strict-string-match
;;; Ver.1.16  modified by yosikawa@spls8.ccs.mt.nec.co.jp 90-Jan-12
;;;	      Now list-kanji-coded-briefly sees kanji-expected-code
;;;	      change-kanji-expected-code added
;;; Ver.1.15  modified by S.Tomura 90-Jan-9
;;;           (1) in completing-read for kanji-code input, 
;;;           change REQUIRE-MATCH from nil to t
;;;           (2) several *-kanji-code-alist are added.
;;; Ver.1.14  modified by S.Tomura 89-Dec-16
;;;           Bugs in server-kanji-code-match and
;;;           program-kanji-code-match are fixed
;;; Ver.1.13  modified by S.Tomura 89-Dec-15
;;;           server-kanji-code-match and 
;;;           program-kanji-code-match changed 
;;; Ver. 1.12 modified by T. Nakagawa 89-Dec-14
;;;           find-kanji-process-code-env modified
;;; Ver. 1.11 modified by S. Tomura 89-Dec-12
;;;           find-file-read-only modified
;;;           find-file-other-window modified
;;; Ver. 1.10 modified by S. Tomura 89-Dec-11
;;;           find-kanji-file-input-code changed
;;; Ver. 1.9  modified by S. Tomura 89-Dec-11
;;;           find-alternate-file modified
;;; Ver. 1.8  modified by S. Tomura 89-Sep-18
;;;           kanji-file-output-code-query-flag added
;;; Ver. 1.7  modified by S. Tomura 89-Sep-4
;;;           invoke-find-* are added.
;;; Ver. 1.6  modified by S. Tomura 89-Aug-29
;;;           function find-kanji-file-input-code
;;;           function find-kanji-file-output-code added
;;; Ver. 1.5  modified by S. Tomura 89-Aug-21
;;;           function find-kanji-fileio-code added
;;; Ver. 1.4  modified by S. Tomura 89-Aug-18
;;;           functions "get-*" are renamed to "find-*"
;;; Ver. 1.3  modified by S. Tomura 89-Jun-30
;;;           name set-default-kanji-fileio-code fixed.
;;; Ver. 1.2  modified by S. Tomura 89-Apr-20
;;;;          service-kanji-code-match modified.
;;;;          SERIVCE of open-network-stream may be an integer.
;;; Ver. 1.1  modified by S. Tomura 89-Apr-19
;;;;          kanji-code-internal added
;;; Nemacs 3.0 created by S. Tomura 89-Mar-16
;;; Nemacs 2.1 created by S. Tomura 88-Jun-14

(defvar kanji-util-version "1.17")
;;; Last modified date: Sat Jan 13 12:11:03 1990

(defvar kanji-keymap (make-keymap) "Keymap for Kanji manipulation")
(fset 'kanji-prefix kanji-keymap)

(define-key ctl-x-map "\C-k" 'kanji-prefix)
(define-key kanji-keymap "t" 'toggle-kanji-flag)
(define-key kanji-keymap "f" 'change-fileio-code)
(define-key kanji-keymap "i" 'change-input-code)
(define-key kanji-keymap "d" 'change-display-code)
(define-key kanji-keymap "p" 'change-process-code)
(define-key kanji-keymap "e" 'change-kanji-expected-code)
(define-key kanji-keymap "T" 'toggle-default-kanji-flag)
(define-key kanji-keymap "F" 'change-default-fileio-code)
(define-key kanji-keymap "P" 'change-default-process-code)
(define-key kanji-keymap "c" 'list-kanji-codes-briefly)
(define-key kanji-keymap "C" 'list-kanji-codes)

(defun toggle-kanji-flag ()
  "Toggle kanji-flag."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq kanji-flag (not kanji-flag))
  (redraw-display))

(defun toggle-default-kanji-flag ()
  "Toggle default-kanji-flag."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq default-kanji-flag (not default-kanji-flag))
  (redraw-display))

(defun change-fileio-code ()
  "Change kanji-fileio-code.\n\
NIL -> No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> NIL"
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq kanji-fileio-code
	(cond ((not kanji-fileio-code) 0)
	      ((= kanji-fileio-code 3) nil)
	      (t (1+ kanji-fileio-code))))
  (set-buffer-modified-p (buffer-modified-p)))

(defun change-default-fileio-code ()
  "Change default-kanji-fileio-code.\n\
NIL -> No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> NIL\n\
New default-kanji-fileio-code is returned."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq default-kanji-fileio-code
	(cond ((not default-kanji-fileio-code) 0)
	      ((= default-kanji-fileio-code 3) nil)
	      (t (1+ default-kanji-fileio-code))))
  (set-buffer-modified-p (buffer-modified-p))
  default-kanji-fileio-code)

(defun change-input-code ()
  "Change kanji-input-code.\n\
No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> No-conversion(0)"
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq kanji-input-code
	(if (= kanji-input-code 3)
	    0
	  (1+ kanji-input-code)))
  (set-buffer-modified-p (buffer-modified-p)))
	
(defun change-display-code ()
  "Change kanji-display-code.\n\
No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> No-conversion(0)"
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq kanji-display-code
	(if (= kanji-display-code 3)
	    0
	  (1+ kanji-display-code)))
  (redraw-display))

(defun change-process-code ()
  "Change kanji code for the current buffers' process.\n\
No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> No-conversion(0)"
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (let ((p (get-buffer-process (current-buffer))))
    (if (not p)
	(error "no process")
      (let ((code (process-kanji-code p)))
	(set-process-kanji-code
	 p
	 (cond ((= code 3) 0)
	       (t (1+ code)))))))
  (set-buffer-modified-p (buffer-modified-p)))

(defun change-default-process-code ()
  "Change default-kanji-process-code.\n\
No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> No-conversion(0)\n\
New default kanji code for the current process is returned."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq default-kanji-process-code
	(cond ((= default-kanji-process-code 3) 0)
	       (t (1+ default-kanji-process-code))))
  (set-buffer-modified-p (buffer-modified-p))
  default-kanji-process-code)

;;; 90.1.12  patch by yosikawa@spls8.ccs.mt.nec.co.jp
(defun change-kanji-expected-code ()
  "Change kanji-expected-code.\n\
  NIL -> T -> No-conversion(0) -> Shift-JIS(1) -> JIS(2) -> EUC(3) -> NIL\n\
  New kanji-expected-code is returned."
  (interactive)
  (setq kanji-expected-code
	(cond ((null kanji-expected-code) t)
	      ((eq kanji-expected-code t) 0)
	      ((= kanji-expected-code 3) nil)
	      (t (1+ kanji-expected-code))))
  (set-buffer-modified-p (buffer-modified-p))
  kanji-expected-code)
;;; end of patch

(defun list-kanji-codes-briefly ()
  "Display a list of values of kanji-code related valiables\n\
with a brief format in mini-buffer."
  (interactive)
  (message
   "global: [FIDP=%c%c%c%c]  local: [FP=%c%c]  expected: [E=%c]"
   (car (kanji-code-mnemonic-string default-kanji-fileio-code))
   (car (kanji-code-mnemonic-string kanji-input-code))
   (car (kanji-code-mnemonic-string kanji-display-code))
   (car (kanji-code-mnemonic-string default-kanji-process-code))
   (car (kanji-code-mnemonic-string kanji-fileio-code))
   (car (kanji-code-mnemonic-string
	 (let (p (get-buffer-process (current-buffer)))
	   (if p (process-kanji-code p)))))
   (car (kanji-code-mnemonic-string kanji-expected-code))))

(defun list-kanji-codes ()
  "Display a list of kanji-code related valiables.\n\
Inserts the names and values in buffer *Kanji Codes* and displays that."
  (interactive)
  (let ((*kanji-fileio-code* kanji-fileio-code)
	(*kanji-process-code* (process-kanji-code)))
    (with-output-to-temp-buffer "*Kanji Codes*"
      (save-excursion
	(set-buffer standard-output)
	(insert "* List of kanji-code related variables *\n"
		"Global variables:\n"
		"\tdefault-kanji-fileio-code : "
		(cdr (kanji-code-mnemonic-string default-kanji-fileio-code))
		?\n
		"\tdefault-kanji-process-code : "
		(cdr (kanji-code-mnemonic-string default-kanji-process-code))
		?\n
		"\tkanji-expected-code : "
		(cdr (kanji-code-mnemonic-string kanji-expected-code))
		?\n
		"\tkanji-display-code : "
		(cdr (kanji-code-mnemonic-string kanji-display-code))
		?\n
		"\tkanji-input-code : "
		(cdr (kanji-code-mnemonic-string kanji-input-code))
		?\n
		"Buffer local variable:\n"
		"\tkanji-fileio-code : "
		(cdr (kanji-code-mnemonic-string *kanji-fileio-code*))
		?\n
		"Kanji code for a process of the buffer:\n"
		"\t(process-kanji-code) : "
		(if *kanji-process-code*
		    (cdr (kanji-code-mnemonic-string *kanji-process-code*))
		  "No process")
		?\n)))))

(defun kanji-code-mnemonic-string (code)
  "Return as a string the meaning of one character mnemonic CODE."
  (cond ((null code) '(?- . "NIL"))
	((eq code t) '(?T . "T"))
	((eq code 0) '(?N . "No-conversion"))
	((eq code 1) '(?S . "Shift-JIS"))
	((eq code 2) '(?J . "JIS"))
	((eq code 3) '(?E . "EUC"))
	(t '(?  . "Invalid value"))))

(define-key help-map "T" 'help-with-tutorial-for-nemacs)
(define-key help-map "N" 'view-nemacs-news)

(defun help-with-tutorial-for-nemacs ()
  "Select the NEmacs learn-by-doing tutorial."
  (interactive)
  (let ((file (expand-file-name "~/NEMACS.tut")))
    (delete-other-windows)
    (if (get-file-buffer file)
	(switch-to-buffer (get-file-buffer file))
      (switch-to-buffer (create-file-buffer "~/NEMACS.tut"))
      (setq buffer-file-name file)
      (setq default-directory (expand-file-name "~/"))
      (setq auto-save-file-name nil)
      (insert-file-contents (expand-file-name "NEMACS.tut" exec-directory))
      (goto-char (point-min))
      (search-forward "\n<<")
      (beginning-of-line)
      (delete-region (point) (progn (end-of-line) (point)))
      (newline (- (window-height (selected-window))
		  (count-lines (point-min) (point))
		  4))
      (goto-char (point-min))
      (set-buffer-modified-p nil))))

(defun view-nemacs-news ()
  "Display info on recent changes to NEmacs."
  (interactive)
  (find-file-read-only (expand-file-name "NEMACS.nws" exec-directory)))

(defun kanji-word-list (str)
  "Convert STRING into a list of integers.  Each integer represents\n\
two-byte kanji code as one word."
  (let ((tem (mapcar '+ str))
	(result nil)
	c1 c2)
    (while tem
      (setq c1 (car tem)) (setq c2 (car (cdr tem)))
      (cond
       ((or (< c1 128) (not c2) (< c2 128))
	(setq result (nconc result (list c1)))
	(setq tem (cdr tem)))
       (t
	(setq result (nconc result (list (+ (* c1 256) c2))))
	(setq tem (cdr (cdr tem))))))
    result))

;;;
;;; Utility functions for Nemacs
;;;

(defconst kanji-code-alist '(("no conversion" . 0) ("shift jis" . 1) ("jis" . 2) ("euc" . 3) ))

(defconst extended-kanji-code-alist
  (append '(("nil" . nil)) kanji-code-alist))

(defun kanji-code-internal (code)
  (let ((case-fold-search t)
	(string (cond ((stringp code) code)
		      ((symbolp code) (symbol-name code))
		      (t ""))))
    (cond((string-match "s.*jis" string)
	  1)
	 ((string-match "euc" string)
	  3)
	 ((string-match "jis" string )
	  2)
	 (t 0))))

(defun set-kanji-fileio-code (code &optional buffer)
  (interactive (list (completing-read "Kanji Code System : "
				      extended-kanji-code-alist nil t nil)))
  (or (null code)
      (if (symbolp code)
	  (setq code (kanji-code-internal code))
	(if (stringp code)
	    (setq code (cdr (assoc code kanji-code-alist))))
	(if (not (kanji-code-p code))
	    (setq code (cdr (assoc (completing-read "Kanji Code System : "
						    extended-kanji-code-alist nil t nil)
				   extended-kanji-code-alist))))))
  (save-excursion
    (set-buffer (or buffer (current-buffer)))
    (setq kanji-fileio-code code)
    (if (interactive-p)
	(set-buffer-modified-p (buffer-modified-p))  ))
  code)

(defun set-default-kanji-fileio-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      extended-kanji-code-alist nil t nil)))
  (or (null code)
      (if (symbolp code)
	  (setq code (kanji-code-internal code))
	(if (stringp code)
	    (setq code (cdr (assoc code kanji-code-alist))))
	(if (not (kanji-code-p code))
	    (setq code (cdr (assoc (completing-read "Kanji Code System : "
						    extended-kanji-code-alist nil t nil)
				   extended-kanji-code-alist))))))
  (setq-default kanji-fileio-code code)
  )

(defconst expected-kanji-code-alist (append '(("auto" . t)) extended-kanji-code-alist))

(defun set-kanji-expected-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      expected-kanji-code-alist nil t nil)))
  (or (null code)
      (eq t code)
      (if (symbolp code)
	  (setq code (kanji-code-internal code))
	(if (stringp code)
	    (setq code (cdr (assoc code kanji-code-alist))))
	(if (not (kanji-code-p code))
	    (setq code (cdr (assoc (completing-read "Kanji Code System : "
						    expected-kanji-code-alist nil t nil)
				   expected-kanji-code-alist))))))
  (setq kanji-expected-code  code)
  )

(defun set-kanji-input-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      kanji-code-alist nil t nil)))
  (if (symbolp code)
      (setq code (kanji-code-internal code))
    (if (stringp code)
	(setq code (cdr (assoc code kanji-code-alist))))
    (if (not (kanji-code-p code))
	(setq code (cdr (assoc (completing-read "Kanji Code System : "
						kanji-code-alist nil t nil)
			       kanji-code-alist)))))
  (setq kanji-input-code code)
  (set-buffer-modified-p (buffer-modified-p)))

(defun set-kanji-display-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      kanji-code-alist nil t nil)))
  (if (symbolp code)
      (setq code (kanji-code-internal code))
    (if (stringp code)
	(setq code (cdr (assoc code kanji-code-alist))))
    (if (not (kanji-code-p code))
	(setq code (cdr (assoc (completing-read "Kanji Code System : "
						kanji-code-alist nil t nil)
			       kanji-code-alist)))))
  (if (not (kanji-code-p code))
      (setq code (cdr (assoc (completing-read "Kanji Code System : "
					      kanji-code-alist nil t nil)
			     kanji-code-alist))))
  (setq kanji-display-code code)
  (if (interactive-p)
      (set-buffer-modified-p (buffer-modified-p)))
  code)

(defun set-default-kanji-process-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      kanji-code-alist nil t nil)))
  (if (symbolp code)
      (setq code (kanji-code-internal code))
    (if (stringp code)
	(setq code (cdr (assoc code kanji-code-alist))))
    (if (not (kanji-code-p code))
	(setq code (cdr (assoc (completing-read "Kanji Code System : "
						kanji-code-alist nil t nil)
			       kanji-code-alist)))))
  (setq default-kanji-process-code code)
  )

(defun set-kanji-process-code (code)
  (interactive (list (completing-read "Kanji Code System : "
				      kanji-code-alist nil t nil)))
  (if (symbolp code)
      (setq code (kanji-code-internal code))
    (if (stringp code)
	(setq code (cdr (assoc code kanji-code-alist))))
    (if (not (kanji-code-p code))
	(setq code (cdr (assoc (completing-read "Kanji Code System : "
						kanji-code-alist nil t nil)
			       kanji-code-alist)))))
  (condition-case ()
      (set-process-kanji-code nil code)
    (error nil))
  (if (interactive-p)
      (set-buffer-modified-p (buffer-modified-p)))
  code)
   
;;;
;;; Standard Kanji Code Decision Procedure
;;; 

;;;
;;; For kanji-fileio-code
;;;

(defvar kanji-expected-code t 
  "* Expected Kanji code when a file is read.\n\
0:No-conversion  1:Shift-JIS  2:JIS  3:EUC/AT&T/DEC\n\
If T, kanji code is guessed automatically.\n\
If NIL, code conversion is done according to kanji-fileio-code.\n\
After a file is read, kanji-fileio-code of the buffer is set to\n\
the quessed code if kanji-fileio-code is nil.")
(set-default 'kanji-expected-code t)

(or (fboundp 'si:find-file)
    (fset 'si:find-file (symbol-function 'find-file)))

(defun find-file (filename &optional code)
  "Edit file FILENAME.
Switch to a buffer visiting file FILENAME,
creating one if none already exists. Optional argument CODE
specifies the kanji-expected-code for the FILENAME.\n\
If interactive, a numeric argument can be specified.\n\
Just C-u means t for kanji-expected-code."
  (interactive "FFind file: \nP")
  (let ((kanji-expected-code
	 (cond ((null code) kanji-expected-code)
	       ((eq code '-) nil)
	       ((listp code) t)
	       ((or (<  code 0) (> code 3))
		(error "Invalid argument %s" code))
	       (t code))))
    (si:find-file filename)))

(or (fboundp 'si:find-alternate-file)
    (fset 'si:find-alternate-file (symbol-function 'find-alternate-file)))

(defun find-alternate-file (filename &optional code)
  "Find file FILENAME, select its buffer, kill previous buffer.
If the current buffer now contains an empty file that you just visited
\(presumably by mistake), use this command to visit the file you really want.
Optional argument CODE specifies the kanji-expected-code for the FILENAME.
If interactive, a numeric argument can be specified.
Just C-u means t for kanji-expected-code."
  (interactive "FFind alternate file: \nP")
  (let ((kanji-expected-code
	 (cond ((null code) kanji-expected-code)
	       ((eq code '-) nil)
	       ((listp code) t)
	       ((or (<  code 0) (> code 3))
		(error "Invalid argument %s" code))
	       (t code))))
    (si:find-alternate-file filename)))

(or (fboundp 'si:find-file-read-only)
    (fset 'si:find-file-read-only (symbol-function 'find-file-read-only)))

(defun find-file-read-only (filename &optional code)
  "Edit file FILENAME but don't save without confirmation.\n\
Like find-file but marks buffer as read-only.\n\
Optional argument CODE specifies the kanji-expected-code for the FILENAME.\n\
If interactive, a numeric argument can be specified.\n\
Just C-u means t for kanji-expected-code."
  (interactive "FFind file read-only: \nP")
  (let ((kanji-expected-code
	 (cond ((null code) kanji-expected-code)
	       ((eq code '-) nil)
	       ((listp code) t)
	       ((or (<  code 0) (> code 3))
		(error "Invalid argument %s" code))
	       (t code))))
    (si:find-file-read-only filename)))

(or (fboundp 'si:find-file-other-window)
    (fset 'si:find-file-other-window (symbol-function 'find-file-other-window)))

(defun find-file-other-window (filename &optional code)
  "Edit file FILENAME, in another window.
May create a new window, or reuse an existing one;
see the function display-buffer.
Optional argument CODE specifies the kanji-expected-code for the FILENAME.\n\
If interactive, a numeric argument can be specified.\n\
Just C-u means t for kanji-expected-code."
  (interactive "FFind file in other window: \nP")
  (let ((kanji-expected-code
	 (cond ((null code) kanji-expected-code)
	       ((eq code '-) nil)
	       ((listp code) t)
	       ((or (<  code 0) (> code 3))
		(error "Invalid argument %s" code))
	       (t code))))
    (si:find-file-other-window filename)))

(defvar default-kanji-fileio-code-find-file-not-found
  default-kanji-fileio-code)

(defun find-file-not-found-set-kanji-fileio-code ()
  (setq kanji-fileio-code 
	default-kanji-fileio-code-find-file-not-found)
  nil)

(or (memq 'find-file-not-found-set-kanji-fileio-code
	  find-file-not-found-hooks)
    (setq find-file-not-found-hooks
	  (cons 'find-file-not-found-set-kanji-fileio-code
		find-file-not-found-hooks)))

(defun find-kanji-file-input-code (filename visit start end)
  (let ((code kanji-expected-code))
    (if (null code)
	(setq code kanji-fileio-code))
    (if (or (eq code t) (null code))
	(setq code (check-region-kanji-code start end)))
    (if (null kanji-fileio-code) 
	(setq kanji-fileio-code code))
    code))

(fset 'default-find-kanji-file-input-code
      (symbol-function 'find-kanji-file-input-code))

(setq find-kanji-file-input-code 'find-kanji-file-input-code)

(defvar kanji-file-input-code-alist
  '( ("\\.el$" . 3)
     ("/spool/mail/.*$" . convert-mbox-kanji-code )))

(defun find-kanji-file-input-code-from-filename (filename visit start end)
  (let ((alist kanji-file-input-code-alist)
	(found nil)
	(code nil))
    (let ((case-fold-search (eq system-type 'vax-vms)))
      (setq filename (file-name-sans-versions filename))
      (while (and (not found) alist)
	(if (string-match (car (car alist)) filename)
	    (setq code (cdr (car alist))
		  found t))
	(setq alist (cdr alist))))
    (if code
	(cond( (numberp code) code)
	     ( (and (symbolp code) (fboundp code))
	       (funcall code filename visit start end))))))

(defun convert-mbox-kanji-code (filename visit start end)
  (let ((buffer-read-only nil))
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (while (not (eobp))
	(let ((start (point))
	      code
	      end)
	  (forward-char 1)
	  (if (re-search-forward "^From" nil 'move)
	      (beginning-of-line))
	  (setq end (point))
	  (setq code (check-region-kanji-code start end))
	  (if (and code (or (= code 1) (= code 2)))
	      (convert-region-kanji-code start end code 3)))))))

;;;
;;; hack from files.el : hack-local-variables
;;;

(defun find-kanji-file-input-code-from-file-variables ()
  "Parse, and bind or evaluate as appropriate, any local variables
for current buffer."
  ;; Look for "Local variables:" line in last page.
  (save-excursion
    (goto-char (point-max))
    (search-backward "\n\^L" (max (- (point-max) 3000) (point-min)) 'move)
    (if (let ((case-fold-search t))
	  (search-forward "Local Variables:" nil t))
	(let ((continue t)
	      prefix prefixlen suffix beg)
	  ;; The prefix is what comes before "local variables:" in its line.
	  ;; The suffix is what comes after "local variables:" in its line.
	  (skip-chars-forward " \t")
	  (or (eolp)
	      (setq suffix (buffer-substring (point)
					     (progn (end-of-line) (point)))))
	  (goto-char (match-beginning 0))
	  (or (bolp)
	      (setq prefix
		    (buffer-substring (point)
				      (progn (beginning-of-line) (point)))))
	  (if prefix (setq prefixlen (length prefix)
			   prefix (regexp-quote prefix)))
	  (if suffix (setq suffix (regexp-quote suffix)))
	  (while continue
	    ;; Look at next local variable spec.
	    (if selective-display (re-search-forward "[\n\C-m]")
	      (forward-line 1))
	    ;; Skip the prefix, if any.
	    (if prefix
		(if (looking-at prefix)
		    (forward-char prefixlen)
		  (error "Local variables entry is missing the prefix")))
	    ;; Find the variable name; strip whitespace.
	    (skip-chars-forward " \t")
	    (setq beg (point))
	    (skip-chars-forward "^:\n")
	    (if (eolp) (error "Missing colon in local variables entry"))
	    (skip-chars-backward " \t")
	    (let* ((str (buffer-substring beg (point)))
		   (var (read str))
		  val)
	      ;; Setting variable named "end" means end of list.
	      (if (string-equal (downcase str) "end")
		  (setq continue nil)
		;; Otherwise read the variable value.
		(skip-chars-forward "^:")
		(forward-char 1)
		(setq val (read (current-buffer)))
		(skip-chars-backward "\n")
		(skip-chars-forward " \t")
		(or (if suffix (looking-at suffix) (eolp))
		    (error "Local variables entry is terminated incorrectly"))
		;; Set the variable.  "Variables" mode and eval are funny.
		(if (eq var 'kanji-fileio-code)  (setq kanji-fileio-code val)))))))))


;;;
;;; kanji-file-output-code
;;;

(defvar kanji-file-output-code-query-flag nil
  "*non-nil means that kanji code is queried when kanji-fileio-code is nil.")

(defun find-kanji-file-output-code (start end filename append visit)
  (if kanji-file-output-code-query-flag
      (if (null kanji-fileio-code)
	  (setq kanji-fileio-code
		(kanji-code-internal
		 (completing-read
		  (format "Kanji Code System for %s: " filename)
		  kanji-code-alist nil t nil)))))
  kanji-fileio-code)

(fset 'default-find-kanji-file-output-code
      (symbol-function 'find-kanji-file-output-code))

(setq find-kanji-file-output-code 'find-kanji-file-output-code)

;;;
;;; For kanji-process-code
;;;

(defvar default-kanji-process-code 0 
  "* Default kanji code for process I/O.\n\ 0:No-conversion 1:Shift-JIS
2:JIS 3:EUC/AT&T/DEC\n\ Used when kanji-process-code-hook is not set
or the function\n\ set to the variable returns invalid code. ")

(defun find-kanji-process-code (buffer program &optional servicep &rest args)
 "Arguments are BUFFER, PROGRAM, SERVICEP, and ARGS. BUFFER is output\n\
buffer name of a process or nil.  If SERVICEP is nil, PROGRAM is a path name\n\
of a program to be executed and ARGS is a list of the arguments.\n\
If SERVICEP is not nil, PROGRAM is a name of a service for\n\
open-network-stream and ARGS is a list of hosts.\n\
Kanji code of the process is set to the return value of this function\n\
Please redefine this function as you wish."

  (if (null buffer) (setq buffer "")
    (if (eq buffer t) (setq buffer (buffer-name))))

  (let ((place (if servicep
		   (find-service-kanji-code program (car args))
		 (find-program-kanji-code buffer program))))
    (if place
	(cond( (numberp (cdr place)) (cdr place))
	     ( (null (cdr place)) nil)
	     ( t (condition-case ()
		     (apply (cdr place) buffer program servicep args)
		   (error default-kanji-process-code))))
      default-kanji-process-code)))
	  
(fset 'default-find-kanji-process-code
      (symbol-function 'find-kanji-process-code))

(setq find-kanji-process-code 'find-kanji-process-code)

;;;
;;;  program --> kanji code translation
;;;

(defun strict-string-match (regexp string &optional start)
  (and (eq 0 (string-match regexp string (or start 0)))
       (eq (match-end 0) (length string))))

(defvar program-kanji-code-alist nil)

(defun define-program-kanji-code (buffer program code)
  (let* ((key  (cons buffer program))
	 (place (assoc key program-kanji-code-alist)))
    (if place
	(setcdr place code)
      (setq place (cons key code)
	    program-kanji-code-alist (cons place program-kanji-code-alist)))
    place))

(defun find-program-kanji-code (buffer program)
  (let ((alist program-kanji-code-alist) (place nil))
    (while (and alist (null place))
      (if (program-kanji-code-match buffer program (car (car alist)))
	  (setq place (car alist)))
      (setq alist (cdr alist)))
    place))

(defun program-kanji-code-match (buffer program patpair)
  (let ((bpat (car patpair)) (ppat (cdr patpair)))
    (if (and (symbolp ppat) (boundp ppat)
	     (stringp (symbol-value ppat)))
	(setq ppat (symbol-value ppat)))
    (and (or (null bpat)
	     (and (stringp bpat) (string-match bpat buffer)))
	 (or (null ppat)
	     (and (stringp ppat)
		  (or
		   (strict-string-match ppat program)
		   (strict-string-match ppat (file-name-nondirectory program))))))))
  		      
(define-program-kanji-code nil "rsh" 'find-kanji-process-code-rsh)

(defun find-kanji-process-code-rsh (buffer rsh
					   &optional servicep host &rest args)
  (if (equal (car args) "-l")
      (setq args (cdr (cdr args))))
  (if (equal (car args) "-n")
      (setq args (cdr args)))
  (find-kanji-process-code buffer (car args) nil (cdr args)))


;;;
;;; 
;;; 
(define-program-kanji-code nil (concat exec-directory "env") 'find-kanji-process-code-env)

;;;(defun find-kanji-process-code-env (buffer env &optional servicep &rest args)
;;;  (while (string-match "[-=]" (car args))
;;;    (setq args (cdr args)))
;;;  (find-kanji-process-code buffer (car args) nil (cdr args)))

;;;
;;; coded by nakagawa@titisa.is.titech.ac.jp 1989
;;; modified by tomura@etl.go.jp 
;;;
;;; env command syntax:   See etc/env.c
;;; env [ - ]
;;; ;;; GNU env only
;;;     { variable=value 
;;;      | -u     variable
;;;      | -unset variable
;;;      | -s     variable value 
;;;      | -set   variable value }*
;;;     [ - | -- ] 
;;; ;;; end of GNU env only
;;;      <program> <args>
;;;

(defun find-kanji-process-code-env (buffer env &optional servicep &rest args)
  (if (string= (car args) "-") (setq args (cdr args)))
  (while (or (string-match "=" (car args))
	     (string= "-s"     (car args))
	     (string= "-set"   (car args))
	     (string= "-u"     (car args))
	     (string= "-unset" (car args)))
    (cond((or (string= "-s" (car args))
	      (string= "-set" (car args)))
	  (setq args (cdr(cdr(cdr args)))))
	 ((or (string= "-u" (car args))
	      (string= "-unset" (car args)))
	  (setq args (cdr(cdr args))))
	 (t 
	  (setq args (cdr args)))))
  (if (or (string= (car args) "-")
	  (string= (car args) "--"))
      (setq args (cdr args)))
  (find-kanji-process-code buffer (car args) nil (cdr args)))

;;;
;;; service --> kanji code translation
;;;

(defvar service-kanji-code-alist nil)

(defun define-service-kanji-code (service host code)
  (let* ((key (cons service host))
	 (place (assoc key service-kanji-code-alist)))
    (if place
	(setcdr place code)
      (setq place (cons key code)
	    service-kanji-code-alist (cons place service-kanji-code-alist)))
    place))
	
(defun find-service-kanji-code (service host)
  (let ((alist service-kanji-code-alist) (place nil))
    (while (and alist (null place))
      (if (service-kanji-code-match service host (car (car alist)))
	  (setq place (car alist)))
      (setq alist (cdr alist)))
    place))

(defun service-kanji-code-match (service host patpair)
  (let ((spat (car patpair)) (hpat (cdr patpair)))
    (and (or (null spat)
	     (eq service spat)
	     (and (stringp spat) (stringp service)
		  (strict-string-match spat service)))
	 (or (null hpat)
	     (strict-string-match hpat host)))))

