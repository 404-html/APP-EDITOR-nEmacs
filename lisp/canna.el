;; This file is a part of Canna on Nemacs.

;; Canna on Nemacs is distributed in the forms of patches
;; to Nemacs under the terms of the GNU EMACS GENERAL
;; PUBLIC LICENSE which is distributed along with GNU Emacs
;; by the Free Software Foundation.

;; Canna on Nemacs is distributed in the hope that it will
;; be useful, but WITHOUT ANY WARRANTY; without even the
;; implied warranty of MERCHANTABILITY or FITNESS FOR A
;; PARTICULAR PURPOSE.  See the GNU EMACS GENERAL PUBLIC
;; LICENSE for more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs; see the file COPYING.
;; If not, write to the Free Software Foundation, 675 Mass
;; Ave, Cambridge, MA 02139, USA.

;; Egg offered some influences to the implementation of
;; Canna on Nemacs, and this file contains a few part of
;; Egg which is written by S.Tomura, Electrotechnical Lab. 
;; (tomura@etl.go.jp)

;; Written by Akira Kon, NEC Corporation.
;; E-Mail:  kon@d1.bs2.mt.nec.co.jp.

;; -*-mode: emacs-lisp-*-

(defconst canna-rcs-version "$Id: canna.el,v 1.41 92/06/12 11:26:07 kon Exp $")

(defun canna-version ()
  (interactive)
  (message canna-rcs-version))

(provide 'canna)

;;; ����ʤ��ѿ�

(defvar canna-save-undo-text-predicate nil)
(defvar canna-undo-hook nil)

(defvar canna-do-keybind-for-functionkeys t)
(defvar canna-use-functional-numbers nil)
(defvar canna-use-space-key-as-henkan-region t)

(defvar canna-server nil)
(defvar canna-file   nil)

(defvar canna-underline nil)
(defvar canna-with-fences (not canna-underline))

(if canna-underline
    (require 'attribute) )

;;;
;;; �⡼�ɥ饤��ν���
;;;

(defvar canna:*kanji-mode-string* "[ �� ]")
(defvar canna:*alpha-mode-string* "------")
(defvar canna:*saved-mode-string* "[ �� ]")

(defvar mode-line-canna-mode canna:*alpha-mode-string*)

(make-variable-buffer-local 'mode-line-canna-mode)

(defun mode-line-canna-mode-update (str)
  (setq mode-line-canna-mode str)
  (set-buffer-modified-p (buffer-modified-p))
  )

(if (not (fboundp 'member))
    (defun member (x l)
      (cond ((atom l) nil)
	    ((equal x (car l)) l)
	    (t (member x (cdr l))))) )

(defun canna:create-mode-line ()
  (if (not (memq 'mode-line-canna-mode mode-line-format))
      (setq-default mode-line-format
		    (append (list (purecopy "-")
				  'mode-line-canna-mode)
			    mode-line-format)))
  (mode-line-canna-mode-update mode-line-canna-mode) )

(defun canna:mode-line-display ()
  (mode-line-canna-mode-update mode-line-canna-mode))

;;;
;;; Canna local variables
;;;

(defvar canna:*japanese-mode* nil "T if canna mode is ``japanese''.")
(make-variable-buffer-local 'canna:*japanese-mode*)
(set-default 'canna:*japanese-mode* nil)

(defvar canna:*fence-mode* nil)
(make-variable-buffer-local 'canna:*fence-mode*)
(setq-default canna:*fence-mode* nil)

;;;
;;; global variables
;;;

(defvar canna-sys:*global-map* (copy-keymap global-map))
(defvar canna:*region-start* (make-marker))
(defvar canna:*region-end*   (make-marker))
(defvar canna:*spos-undo-text* (make-marker))
(defvar canna:*epos-undo-text* (make-marker))
(defvar canna:*undo-text-yomi* nil)
(defvar canna:*local-map-backup*  nil)
(defvar canna:*last-kouho* 0)
(defvar canna:*initialized* nil)
(defvar canna:*previous-window* nil)
(defvar canna:*minibuffer-local-map-backup* nil)
(defvar canna:*cursor-was-in-minibuffer* nil)
(defvar canna:*use-region-as-henkan-region* nil)

;;;
;;; �����ޥåץơ��֥�
;;;

;; �ե��󥹥⡼�ɤǤΥ�����ޥå�
(defvar canna-mode-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset canna-mode-map ch 'canna-functional-insert-command)
    (setq ch (1+ ch))))

;; �ߥ˥Хåե��˲�����ɽ�����Ƥ�����Υ�����ޥå�
(defvar canna-minibuffer-mode-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset canna-minibuffer-mode-map ch 'canna-minibuffer-insert-command)
    (setq ch (1+ ch))))


;;;
;;; �����Х�ؿ��ν��ؤ�
;;;


;; Keyboard quit

(if (not (fboundp 'canna-sys:keyboard-quit))
    (fset 'canna-sys:keyboard-quit (symbol-function 'keyboard-quit)) )

(defun canna:keyboard-quit ()
  "See documents for canna-sys:keyboard-quit"
  (interactive)
  (if canna:*japanese-mode*
      (progn
;	(setq canna:*japanese-mode* nil)
	(setq canna:*fence-mode* nil)
	(if (boundp 'disable-undo)
	    (setq disable-undo canna:*fence-mode*))
	(canna:mode-line-display) ))
  (canna-sys:keyboard-quit) )

;; Abort recursive edit

(if (not (fboundp 'canna-sys:abort-recursive-edit))
    (fset 'canna-sys:abort-recursive-edit 
	  (symbol-function 'abort-recursive-edit)) )

(defun canna:abort-recursive-edit ()
  "see documents for canna-sys:abort-recursive-edit"
  (interactive)
  (if canna:*japanese-mode*
      (progn
	(setq canna:*japanese-mode* nil)
	(setq canna:*fence-mode* nil)
	(if (boundp 'disable-undo)
	    (setq disable-undo canna:*fence-mode*))
	(canna:mode-line-display) ))
  (canna-sys:abort-recursive-edit) )


;; Exit-minibuffer

(if (not (fboundp 'canna-sys:exit-minibuffer))
    (fset 'canna-sys:exit-minibuffer (symbol-function 'exit-minibuffer)) )

(defun canna:exit-minibuffer ()
  "See documents for canna-sys:exit-minibuffer"
  (interactive)
;  (setq canna:*japanese-mode* nil)
  (canna-sys:exit-minibuffer) )

;; kill-emacs

(if (not (fboundp 'canna-sys:kill-emacs))
    (fset 'canna-sys:kill-emacs (symbol-function 'kill-emacs)))

(defun canna:kill-emacs (&optional query)
  (interactive "P")
  (message "�ؤ���ʡ٤μ���򥻡��֤��ޤ���")
  (canna:finalize)
  (canna-sys:kill-emacs query))


;;;
;;; keyboard input for japanese language
;;;

(defun canna-functional-insert-command (arg)
  "Use input character as a key of complex translation input such as\n\
kana-to-kanji translation."
  (interactive "p")
  (canna:functional-insert-command2 last-command-char arg) )

(defun canna:functional-insert-command2 (ch arg)
  "This function actualy isert a converted Japanese string."
  ;; ���δؿ���Ϳ����줿ʸ�������ܸ����ϤΤ���Υ������ϤȤ��Ƽ�갷
  ;; �������ܸ����Ϥ���ַ�̤�ޤ᤿������Emacs�ΥХåե���ȿ�Ǥ�����
  ;; �ؿ��Ǥ��롣
  (canna:display-candidates (canna-key-proc ch)) )

(defun canna:display-candidates (strs)
  (cond ((stringp strs) ; ���顼�������ä����
	 (beep)
	 (message strs) )
	(canna-henkan-string
	 ;; �⤷����ɽ�������η�̤����Ѥ�äƤ��ʤ��ʤ��Ȥ���......

	 ;; �ߥ˥Хåե��˴ؤ������κ��
	 (setq canna:*cursor-was-in-minibuffer* nil)

	 ;; ���礨���ǽ�����˽񤤤Ƥ�������ַ�̤�ä���
	 (cond ((not (zerop canna:*last-kouho*))
		(if canna-underline
		    ; �ޤ���°����ä���
		    (progn
		      (attribute-off-region 'inverse
					    canna:*region-start*
					    canna:*region-end*)
		      (attribute-off-region 'underline
					    canna:*region-start*
					    canna:*region-end*)) )
		(delete-region canna:*region-start*
			       canna:*region-end*) ))
	 ;; ��ַ�̤�ä����Τǡ��ѿ���ꥻ�åȤ��Ƥ���
	 (setq canna:*last-kouho* 0)
	 ;; ���ꤷ��ʸ���󤬤���Ф�����������롣
	 (cond ((> strs 0)
		(cond ((and canna-kakutei-yomi
			    (or (null canna-save-undo-text-predicate)
				(funcall canna-save-undo-text-predicate
					 (cons canna-kakutei-yomi
					       canna-kakutei-romaji) )))
		       (setq canna:*undo-text-yomi*
			     (cons canna-kakutei-yomi canna-kakutei-romaji))
		       (set-marker canna:*spos-undo-text* (point))
		       (insert canna-kakutei-string)
		       (canna:do-auto-fill)
		       (set-marker canna:*epos-undo-text* (point)) )
		      (t
		       (insert canna-kakutei-string)
		       (canna:do-auto-fill) ))
		) )


	 ;; ���ϸ���ˤĤ��Ƥκ�ȤǤ��롣

	 ;; ������������롣����Ͻ������ܤˤƶ��ޤ�롣
	 (cond ((> canna-henkan-length 0)
		(set-marker canna:*region-start* (point))
		(if canna-with-fences
		    (progn
		      (insert "||")
		      (set-marker canna:*region-end* (point))
		      (backward-char 1)
		      ))
		(insert canna-henkan-string)
		(if (not canna-with-fences)
		    (set-marker canna:*region-end* (point)) )
		(if canna-underline
		    (attribute-on-region 
		     'underline
		     canna:*region-start* canna:*region-end*) )
		(setq canna:*last-kouho* canna-henkan-length)
		))

	 ;; �����ΰ�Ǥ϶�Ĵ������ʸ����¸�ߤ����Τȹͤ���
	 ;; ��롣��Ĵ������ʸ����Emacs�Ǥϥ�������ݥ������ˤ�ɽ��
	 ;; ���뤳�ȤȤ��롣��Ĵ������ʸ�����ʤ��ΤǤ���С���������
	 ;; �ϰ��ָ����ʬ(���Ϥ��Ԥ���ݥ����)���֤��Ƥ�����

	 ;; ����������ư���롣
	 (if (not canna-underline)
	     (backward-char 
	      (- canna:*last-kouho*
		 ;; ����������֤ϡ�ȿžɽ����ʬ��¸�ߤ��ʤ��ΤǤ���С�
		 ;; ����ʸ����κǸ����ʬ�Ȥ���ȿžɽ����ʬ��¸�ߤ����
		 ;; �Ǥ���С�������ʬ�λϤ�Ȥ��롣
		 (cond ((zerop canna-henkan-revlen)
			canna:*last-kouho*)
		       (t canna-henkan-revpos) )) )
	   (if (and (> canna-henkan-revlen 0)
		    (> canna-henkan-length 0))
		    ; �����Ĺ����0�Ǥʤ���
		    ; ȿžɽ����Ĺ����0�Ǥʤ���С�
		    ; ������ʬ����žɽ�����롣
	       (let ((start (+ canna:*region-start*
			       (if canna-with-fences 1 0)
			       canna-henkan-revpos) ))
		 (attribute-on-region
		  'inverse start (+ start canna-henkan-revlen) )))
	   ) ) )

  ;; �⡼�ɤ�ɽ��ʸ����¸�ߤ���Ф����⡼�ɤȤ��Ƽ�갷����
  (if (stringp canna-mode-string)
      (mode-line-canna-mode-update canna-mode-string))

  ;; ����ɽ�����ʤ���Хե��󥹥⡼�ɤ���ȴ���롣
  (cond ((zerop canna:*last-kouho*)
	 (canna:quit-canna-mode) ) )

  ;; �ߥ˥Хåե��˽񤯤��Ȥ�¸�ߤ���ΤǤ���С������ߥ˥Хåե�
  ;; ��ɽ�����롣
  (cond (canna-ichiran-string
	 (setq canna:*cursor-was-in-minibuffer* t)
	 (canna:minibuffer-input canna-ichiran-string
				 canna-ichiran-length
				 canna-ichiran-revpos
				 canna-ichiran-revlen) )
	(t
	 (cond (canna:*cursor-was-in-minibuffer*
		(setq canna:*previous-window* (selected-window))
		(select-window (minibuffer-window))
		;; �ߥ˥Хåե��Υ����ޥåפ���¸���Ƥ�����
		(setq canna:*minibuffer-local-map-backup* 
		      (current-local-map))
		(use-local-map canna-minibuffer-mode-map)
		) ) )
	)
  )

(defun canna:minibuffer-input (str len revpos revlen)
  "Displaying misc informations for kana-to-kanji input."

  ;; ��Ȥ�ߥ˥Хåե��˰ܤ��Τ˺ݤ��ơ����ߤΥ�����ɥ��ξ������¸
  ;; ���Ƥ�����
  (setq canna:*previous-window* (selected-window))
  (select-window (minibuffer-window))

  ;; �ߥ˥Хåե��򥯥ꥢ���롣
  (if canna-underline
      (attribute-off-region 'inverse (point-min) (point-max)))
  (delete-region (point-min) (point-max))

  ;; �ߥ˥Хåե��Υ����ޥåפ���¸���Ƥ�����
  (setq canna:*minibuffer-local-map-backup* (current-local-map))
  (use-local-map canna-minibuffer-mode-map)
  (insert str)

  ;; �ߥ˥Хåե���ȿžɽ������٤�ʸ���ΤȤ���˥���������ư���롣
  (cond ((> revlen 0)
	 (backward-char (- len revpos)) ))
  ;; �ߥ˥Хåե���ɽ������٤�ʸ���󤬥̥�ʸ����ʤΤǤ���С����Υ���
  ;; ��ɥ�����롣
  (cond ((zerop len)
	 (setq canna:*cursor-was-in-minibuffer* nil)
	 (use-local-map canna:*minibuffer-local-map-backup*)
	 (select-window canna:*previous-window*) )
	(canna-empty-info
	 (delete-region (point-min) (point-max))
	 (setq canna:*cursor-was-in-minibuffer* nil)
	 (use-local-map canna:*minibuffer-local-map-backup*)
	 (select-window canna:*previous-window*)
	 (message str) ))
  )

(defun canna-minibuffer-insert-command (arg)
  "Use input character as a key of complex translation input such as\n\
kana-to-kanji translation, even if you are in the minibuffer."
  (interactive "p")
  (use-local-map canna:*minibuffer-local-map-backup*)
  (select-window canna:*previous-window*)
  (canna:functional-insert-command2 last-command-char arg) )

;;;
;;; ����ʥ⡼�ɤμ���ϡ����� canna-self-insert-command �Ǥ��롣����
;;; ���ޥ�ɤ����ƤΥ���ե��å������˥Х���ɤ���롣
;;;
;;; ���δؿ��Ǥϡ����ߤΥ⡼�ɤ����ܸ����ϥ⡼�ɤ��ɤ���������å����ơ�
;;; ���ܸ����ϥ⡼�ɤǤʤ��ΤǤ���С������ƥ�� self-insert-command 
;;; ��Ƥ֡����ܸ����ϥ⡼�ɤǤ���С��ե��󥹥⡼�ɤ����ꡢ
;;; canna-functional-insert-command ��Ƥ֡�
;;;

(defun canna-self-insert-command (arg)
  "Self insert pressed key and use it to assemble Romaji character."
  (interactive "p")
  (if (and canna:*japanese-mode*
	   ;; �ե��󥹥⡼�ɤ��ä���⤦���٥ե��󥹥⡼�ɤ����ä��ꤷ
	   ;; �ʤ���
	   (not canna:*fence-mode*) )
      (canna:enter-canna-mode-and-functional-insert)
    (self-insert-command arg) ))

(defun canna-toggle-japanese-mode ()
  "Toggle canna japanese mode."
  (interactive)
  (cond (canna:*japanese-mode*
	 (setq canna:*japanese-mode* nil) 
	 (canna-abandon-undo-info)
	 (setq canna:*use-region-as-henkan-region* nil)
	 (setq canna:*saved-mode-string* mode-line-canna-mode)
	 (mode-line-canna-mode-update canna:*alpha-mode-string*) )
	(t
	 (setq canna:*japanese-mode* t)
	 (if (fboundp 'canna-query-mode)
	     (let ((new-mode (canna-query-mode)))
	       (if (string-equal new-mode "")
		   (setq canna:*kanji-mode-string* canna:*saved-mode-string*)
		 (setq canna:*kanji-mode-string* new-mode)
		 )) )
	 (mode-line-canna-mode-update canna:*kanji-mode-string*) ) ))

(defun canna:initialize ()
  (let ((init-val nil))
    (cond (canna:*initialized*) ; initialize ����Ƥ����鲿�⤷�ʤ�
	  (t
	   (setq canna:*initialized* t)
	   (setq init-val (canna-initialize 
			   (if canna-underline 0 1)
			   canna-server canna-file))
	   (cond ((car (cdr (cdr init-val)))
		  (canna:output-warnings (car (cdr (cdr init-val)))) ))
	   (cond ((car (cdr init-val))
		  (error (car (cdr init-val))) ))
	   ) )

    (if (fboundp 'canna-query-mode)
	(progn
	  (canna-change-mode canna-mode-alpha-mode)
	  (setq canna:*alpha-mode-string* (canna-query-mode)) ))

    (canna-do-function canna-func-japanese-mode)

    (if (fboundp 'canna-query-mode)
	(setq canna:*kanji-mode-string* (canna-query-mode)))

    init-val))

(defun canna:finalize ()
  (cond ((null canna:*initialized*)) ; initialize ����Ƥ��ʤ��ä��鲿�⤷�ʤ�
	(t
	 (setq canna:*initialized* nil)
	 (let ((init-val (canna-finalize)))
	   (cond ((car (cdr (cdr init-val)))
		  (canna:output-warnings (car (cdr (cdr init-val)))) ))
	   (cond ((car (cdr init-val))
		  (error (car (cdr init-val))) ))
	   ) )) )

(defun canna:enter-canna-mode ()
  (if (not canna:*initialized*)
      (progn 
	(message "�ؤ���ʡ٤ν������ԤäƤ��ޤ�....")
	(canna:initialize)
	(message "�ؤ���ʡ٤ν������ԤäƤ��ޤ�....done")
	))
  (setq canna:*local-map-backup*  (current-local-map))
  (setq canna:*fence-mode* t)
  (if (boundp 'disable-undo)
      (setq disable-undo canna:*fence-mode*))
  (use-local-map canna-mode-map) )

(defun canna:enter-canna-mode-and-functional-insert ()
  (canna:enter-canna-mode)
  (setq canna:*use-region-as-henkan-region* nil)
  (setq unread-command-char last-command-char))

(defun canna:quit-canna-mode ()
  (cond (canna:*fence-mode*
	 (use-local-map canna:*local-map-backup*)
	 (setq canna:*fence-mode* nil)
	 (if (boundp 'disable-undo)
	     (setq disable-undo canna:*fence-mode*))
	 ))
  (set-marker canna:*region-start* nil)
  (set-marker canna:*region-end* nil)
  )

(defun canna-touroku ()
  "Register a word into a kana-to-kanji dictionary."
  (interactive)
  (if canna:*japanese-mode*
      (progn
	(canna:enter-canna-mode)
	(canna:display-candidates (canna-touroku-string "")) )
    (beep)
  ))

(defun canna-without-newline (start end)
  (and (not (eq start end))
       (or 
	(and (<= end (point))
	     (save-excursion
	       (beginning-of-line)
	       (<= (point) start) ))
	(and (<= (point) start)
	     (save-excursion 
	       (end-of-line) 
	       (<= end (point)) ))
	)))

(defun canna-touroku-region (start end)
  "Register a word which is indicated by region into a kana-to-kanji\n\
dictionary."
  (interactive "r")
  (if (canna-without-newline start end)
      (if canna:*japanese-mode*
	  (progn
	    (canna:enter-canna-mode)
	    (canna:display-candidates
	     (canna-touroku-string (buffer-substring start end))) ))
    (message "�꡼����������Ǥ����̥�꡼����󤫡����Ԥ��ޤޤ�Ƥ��ޤ���")
    ))

(defun canna-extend-mode ()
  "To enter an extend-mode of Canna."
  (interactive)
  (canna:display-candidates
   (canna-do-function canna-func-extend-mode) ))

(defun canna-kigou-mode ()
  "Enter symbol choosing mode."
  (interactive)
  (if canna:*japanese-mode*
      (progn
        (canna:enter-canna-mode)
	(canna:display-candidates (canna-change-mode canna-mode-kigo-mode)) )
    (beep)
  ))

(defun canna-hex-mode ()
  "Enter hex code entering mode."
  (interactive)
  (if canna:*japanese-mode*
      (progn
        (canna:enter-canna-mode)
	(canna:display-candidates (canna-change-mode canna-mode-hex-mode)) )
    (beep)
  ))

(defun canna-bushu-mode ()
  "Enter special mode to convert by BUSHU name."
  (interactive)
  (if canna:*japanese-mode*
      (progn
        (canna:enter-canna-mode)
	(canna:display-candidates (canna-change-mode canna-mode-bushu-mode)) )
    (beep)
  ))

(defun canna-reset ()
  (interactive)
  (message "�ؤ���ʡ٤μ���򥻡��֤��ޤ���");
  (canna:finalize)
  (message "�ؤ���ʡ٤κƽ������ԤäƤ��ޤ�....")
  (canna:initialize)
  (message "�ؤ���ʡ٤κƽ������ԤäƤ��ޤ�....done")
  )
  

(defun canna ()
  (interactive)
  (message "�ؤ���ʡ٤��������Ƥ��ޤ�....")
  (let (init-val)
    (cond ((and (fboundp 'canna-initialize)
		(fboundp 'canna-change-mode) )

	   ;; canna ���Ȥ�����ϼ��ν����򤹤롣
	 
	   ;; �ؤ���ʡ٥����ƥ�ν����

	   (setq init-val (canna:initialize))

	 ;; �����ΥХ���ǥ���

	   (let ((ch 32))
	     (while (< ch 127)
	       (aset global-map ch 'canna-self-insert-command)
	       (setq ch (1+ ch)) ))

	   (cond ((let ((keys (car init-val)) (ok nil))
		    (while keys
		      (cond ((< (car keys) 128)
			     (global-set-key
			      (make-string 1 (car keys))
			      'canna-toggle-japanese-mode)
			     (setq ok t) ))
		      (setq keys (cdr keys))
		      ) ok))
		 (t ; �ǥե���Ȥ�����
		  (global-set-key "\C-o" 'canna-toggle-japanese-mode) ))

	   (if (not (keymapp (global-key-binding "\e[")))
	       (global-unset-key "\e[") )
	   (global-set-key "\e[210z" 'canna-toggle-japanese-mode) ; XFER
	   (if canna-do-keybind-for-functionkeys
	       (progn
		 (global-set-key "\e[28~" 'canna-extend-mode) ; HELP on EWS4800
		 (global-set-key "\e[2~"  'canna-kigou-mode)  ; INS  on EWS4800
		 (global-set-key "\e[11~" 'canna-kigou-mode)
		 (global-set-key "\e[12~" 'canna-hex-mode)
		 (global-set-key "\e[13~" 'canna-bushu-mode)
		 ))

	   (if canna-use-space-key-as-henkan-region
	       (progn
		 (global-set-key "\C-@" 'canna-set-mark-command)
		 (global-set-key " " 'canna-henkan-region-or-self-insert) ))

	 ;; �⡼�ɹԤκ���

	   (canna:create-mode-line)
	   (mode-line-canna-mode-update canna:*alpha-mode-string*)

	 ;; �����ƥ�ؿ��ν��ؤ�

	   (fset 'abort-recursive-edit 
		 (symbol-function 'canna:abort-recursive-edit))
	   (fset 'keyboard-quit 
		 (symbol-function 'canna:keyboard-quit))
	   (fset 'exit-minibuffer
		 (symbol-function 'canna:exit-minibuffer))
	   (fset 'kill-emacs
		 (symbol-function 'canna:kill-emacs)) )

	  ((fboundp 'canna-initialize)
	   (beep)
	   (with-output-to-temp-buffer "*canna-warning*"
	     (princ "���� Emacs �Ǥ� new-canna ���Ȥ��ޤ���")
	     (terpri)
	     (print-help-return-message)) )

	  (t ; �ؤ���ʡ٥����ƥब�Ȥ��ʤ��ä����ν���
	   (beep)
	   (with-output-to-temp-buffer "*canna-warning*"
	     (princ "���� Emacs �Ǥ� canna ���Ȥ��ޤ���")
	     (terpri)
	     (print-help-return-message))
	   ))
    (message "�ؤ���ʡ٤��������Ƥ��ޤ�....done")
    ) )

;;;
;;; auto fill controll (from egg)
;;;

(defun canna:do-auto-fill ()
  (if (and auto-fill-hook (not buffer-read-only)
	   (> (current-column) fill-column))
      (let ((ocolumn (current-column)))
	(run-hooks 'auto-fill-hook)
	(while (and (< fill-column (current-column))
		    (< (current-column) ocolumn))
  	  (setq ocolumn (current-column))
	  (run-hooks 'auto-fill-hook)))))

(defun canna:output-warnings (mesg)
  (with-output-to-temp-buffer "*canna-warning*"
    (while mesg
      (princ (car mesg))
      (terpri)
      (setq mesg (cdr mesg)) )
    (print-help-return-message)))

(defun canna-undo (&optional arg)
  (interactive "*p")
  (if (and canna:*undo-text-yomi*
	   (eq (current-buffer) (marker-buffer canna:*spos-undo-text*))
	   (canna-without-newline canna:*spos-undo-text*
				  canna:*epos-undo-text*)
	   )
      (progn
	(message "�ɤߤ��ᤷ�ޤ���")
	(switch-to-buffer (marker-buffer canna:*spos-undo-text*))
	(goto-char canna:*spos-undo-text*)
	(delete-region canna:*spos-undo-text*
		       canna:*epos-undo-text*)

	(if (null canna:*japanese-mode*)
	    (canna-toggle-japanese-mode) )
	(if (not canna:*fence-mode*)
	    ;; �ե��󥹥⡼�ɤ��ä���⤦���٥ե��󥹥⡼�ɤ����ä��ꤷ
	    ;; �ʤ���
	    (canna:enter-canna-mode) )
	(canna:display-candidates 
	 (let ((texts (canna-store-yomi (car canna:*undo-text-yomi*)
					(cdr canna:*undo-text-yomi*) )) )
	   (cond (canna-undo-hook
		  (funcall canna-undo-hook))
		 (t texts) )))
	(canna-abandon-undo-info)
	)
    (canna-abandon-undo-info)
    (undo arg) ))

(defun canna-abandon-undo-info ()
  (interactive)
  (setq canna:*undo-text-yomi* nil)
  (set-marker canna:*spos-undo-text* nil)
  (set-marker canna:*epos-undo-text* nil) )

(defun canna-henkan-region (start end)
  "Convert a text which is indicated by region into a kanji text."
  (interactive "r")
  (let ((res nil))
    (setq res (canna-store-yomi (buffer-substring start end)))
    (delete-region start end)
    (canna:enter-canna-mode)
    (if (fboundp 'canna-do-function)
	(setq res (canna-do-function canna-func-henkan)))
    (canna:display-candidates res) ))

;;;
;;; �ޡ������ޥ�ɡ�canna-henkan-region-or-self-insert �ǻȤ�����
;;;

(defun canna-set-mark-command (arg)
  "Beside setting mark, set mark as a HENKAN region if it is in\n\
the japanese mode."
  (interactive "P")
  (set-mark-command arg)
  (if canna:*japanese-mode*
      (progn
	(setq canna:*use-region-as-henkan-region* t)
	(message "Mark set(�Ѵ��ΰ賫��)") )))

(defun canna-henkan-region-or-self-insert (arg)
  "Do kana-to-kanji convert region if HENKAN region is defined,\n\
self insert otherwise."
  (interactive "p")
  (if (and canna:*use-region-as-henkan-region*
	   (< (mark) (point))
	   (not (save-excursion (beginning-of-line) (< (mark) (point)))) )
      (progn
	(setq canna:*use-region-as-henkan-region* nil)
	(canna-henkan-region (region-beginning) (region-end)))
    (canna-self-insert-command arg) ))
