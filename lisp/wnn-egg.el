;; Japanese Character Input Package for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Egg on Nemacs (Japanese Environment)

;; Egg is distributed in the forms of patches to GNU
;; Emacs under the terms of the GNU EMACS GENERAL PUBLIC
;; LICENSE which is distributed along with GNU Emacs by the
;; Free Software Foundation.

;; Egg is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
;; more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs; see the file COPYING.
;; If not, write to the Free Software Foundation, 675 Mass
;; Ave, Cambridge, MA 02139, USA.

;;;==================================================================
;;;
;;; ���ܸ�Ķ� �֤��ޤ��� �裲��    
;;;
;;;=================================================================== 

;;;
;;;�֤��ޤ��פϥͥåȥ�����ʴ����Ѵ������Ф����Ѥ���Nemacs �Ǥ�����
;;; ��Ķ����󶡤��륷���ƥ�Ǥ����֤��ޤ����裲�ǤǤ� Wnn V3 ����� 
;;; Wnn V4 �Τ��ʴ����Ѵ������Ф���Ѥ��Ƥ��ޤ���
;;;

;;; ̾���� ������/�Ԥ�����/�����ʤ����פγ�ʸ�����Ƭ�����Ǥ���֤���
;;; �ȡ֤ޡפȡ֤��פ��äơ��֤��ޤ��פȸ����ޤ����Żҵ�����縦���
;;; �ζӸ� �����һ��̿̾�˰ͤ��ΤǤ���egg �ϡ֤��ޤ��פα����Ǥ���

;;;
;;; ����ˡ�� etc/NEMACS.egg �򸫤Ʋ�������
;;;

;;;
;;; �֤��ޤ��פ˴ؤ�����ơ������� tomura@etl.junet �ˤ����겼������
;;;

;;;
;;;                      �� 305 ��븩�Ĥ��л��߱�1-1-4
;;;                      �̻��ʹ��ȵ��ѱ��Żҵ�����縦���
;;;                      ���󥢡����ƥ����������쥷���ƥฦ�漼
;;;
;;;                                                     ��¼ ů  

;;;
;;; (���)���Υե�����ϴ��������ɤ�ޤ�Ǥ��ޤ��� 
;;;
;;;   �裲��  ��������ǯ����  ����
;;;   �裱��  ��������ǯ�������
;;;   ������  ��������ǯ�������

;;;=================================================================== 
;;;
;;; (eval-when (load) (require 'wnn-client))
;;;
(provide 'wnn-egg)
(if (not (or (boundp 'WNN3) 
	     (boundp 'WNN4V3)))
    (require 'wnn-client))

(defvar egg-version "2.24" "Version number of this version of Egg. ")
;;; Last modified date: Wed Feb  7 11:22:23 1990

;;;;  ������⡨��

;;;;  Mar-4-90 by K.Handa
;;;;  New variable alphabet-mode-indicator, transparent-mode-indicator,
;;;;  and henkan-mode-indicator.

;;;;  Feb-27-90 by enami@ptgd.sony.co.jp
;;;;  menu:select-from-menu �ǣ��սꤢ�� ((and (<= ?0 ch) (<= ch ?9)...
;;;;  �ΰ����� ((and (<= ?0 ch) (<= ch ?9)... �˽���

;;;;  Feb-07-89
;;;;  bunsetu-length-henko ����� egg:*attribute-off �ΰ��֤� KKCP ��Ƥ�����
;;;;  �ѹ����롣 wnn-client �Ǥ� KKCP ��Ƥ֤�ʸ������Ѳ����롣

;;;;  Feb-01-89
;;;;  henkan-goto-kouho �� egg:set-bunsetu-attribute �ΰ���
;;;;  �ν��֤��ְ�äƤ����Τ�����������toshi@isvax.isl.melco.co.jp
;;;;  (Toshiyuki Ito)�λ�Ŧ�ˤ�롣��

;;;;  Dec-25-89
;;;;  meta-flag t �ξ����б���ƽ������롣
;;;;  overwrite-mode �Ǥ� undo ��������롣

;;;;  Dec-21-89
;;;;  bug fixed by enami@ptdg.sony.co.jp
;;;;     (fboundp 'minibuffer-window-selected )
;;;;  -->(boundp  'minibuffer-window-selected )
;;;;  self-insert-after-hook �� buffer local �ˤ�������� kanji.el �ذ�ư��

;;;;  Dec-15-89
;;;;  kill-all-local-variables ������� kanji.el �ذ�ư���롣

;;;;  Dec-14-89
;;;;  meta-flag t �ξ��ν�����������
;;;;  overwrite-mode ���б����롣

;;;;  Dec-12-89
;;;;  egg:*henkan-open*, egg:*henkan-close* ���ɲá�
;;;;  egg:*henkan-attribute* ���ɲ�
;;;;  set-egg-fence-mode-format, set-egg-henkan-mode-format ���ɲ�

;;;;  Dec-12-89
;;;;  *bunpo-code* �� 1000: "����¾" ���ɲ�

;;;;  Dec-11-89
;;;;  egg:*fence-attribute* ����
;;;;  egg:*bunsetu-attribute* ����

;;;;  Dec-11-89
;;;;  attribute-*-region �����Ѥ���褦���ѹ����롣
;;;;  menu:make-selection-list �� width ������������loop ���롣�������������

;;;;  Dec-10-89
;;;;  set-marker-type �����Ѥ����������ѹ���

;;;;  Dec-07-89
;;;;  egg:search-path ���ɲá�
;;;;  egg-default-startup-file ���ɲä��롣

;;;;  Nov-22-89
;;;;  egg-startup-file ���ɲä��롣
;;;;  eggrc-search-path �� egg-startup-file-search-path ��̾���ѹ���

;;;;  Nov-21-89
;;;;  Nemacs 3.2 ���б����롣kanji-load* ���ѻߤ��롣
;;;;  wnnfns.c ���б�����������ä��롣
;;;;  *Notification* buffer �򸫤��ʤ����롣

;;;;  Oct-2-89
;;;;  *zenkaku-alist* �� ʸ������ν������ְ�äƤ�����

;;;;  Sep-19-89
;;;;  toggle-egg-mode �ν�����kanji-flag��
;;;;  egg-self-insert-command �ν��� ��kanji-flag��

;;;;  Sep-18-89
;;;;  self-insert-after-hook ���ɲ�

;;;;  Sep-15-89
;;;;  EGG:open-wnn bug fix
;;;;  provide wnn-egg feature

;;;;  Sep-13-89
;;;;  henkan-kakutei-before-point ����������
;;;;  enter-fence-mode ���ɲá�
;;;;  egg-exit-hook ���ɲá�
;;;;  henkan-region-internal ���ɲá�henkan-region�� point ��mark ���롣
;;;;  eggrc-search-path ���ɲá�

;;;;  Aug-30-89
;;;;  kanji-kanji-1st ������������

;;;;  May-30-89
;;;;  EGG:open-wnn �� get-wnn-host-name �� nil �ξ�硢(system-name) ����Ѥ��롣

;;;;  May-9-89
;;;;  KKCP:make-directory added.
;;;;  KKCP:file-access bug fixed.
;;;;  set-default-usr-dic-directory modified.

;;;;  Mar-16-89
;;;;  minibuffer-window-selected ��Ȥä� minibuffer �� egg-modeɽ����ǽ�ɲ�

;;;;  Mar-13-89
;;;;   mode-line-format changed. 

;;;;  Feb-27-89
;;;;  henkan-saishou-bunsetu added
;;;;  henkan-saichou-bunsetu added
;;;;  M-<    henkan-saishou-bunsetu
;;;;  M->    henkan-saichou-bunsetu

;;;;  Feb-14-89
;;;;   C-h in henkan mode: help-command added

;;;;  Feb-7-89
;;;;   egg-insert-after-hook is added.

;;;;   M-h   fence-hiragana
;;;;   M-k   fence-katakana
;;;;   M->   fence-zenkaku
;;;;   M-<   fence-hankaku

;;;;  Dec-19-88 henkan-hiragana, henkan-katakara���ɲá�
;;;;    M-h     henkan-hiragana
;;;;    M-k     henkan-katakana

;;;;  Ver. 2.00 kana2kanji.c ��Ȥ鷺 wnn-client.el ����Ѥ���褦���ѹ���
;;;;            ��Ϣ���ư����ؿ����ѹ�

;;;;  Dec-2-88 special-symbol-input ���ɲá�
;;;;    C-^   special-symbol-input

;;;;  Nov-18-88 henkan-mode-map �����ѹ���
;;;;    M-i  henkan-inspect-bunsetu
;;;;    M-s  henkan-select-kouho
;;;;    C-g  henkan-quit

;;;;  Nov-18-88 jserver-henkan-kakutei �λ����ѹ���ȼ����kakutei �Υ���
;;;;  �ɤ��ѹ�������

;;;;  Nov-17-88 kakutei-before-point �� point �ʹߤδְ�ä���ʬ���Ѵ�
;;;;  �����پ������Ͽ����ʤ��褦�˽�������������ˤ�KKCC:henkan-end 
;;;;  �ΰ������ͤ��б�����kana2kanji.c���ѹ�������

;;;;  Nov-17-88 henkan-inspect-bunsetu ���ɲä�����

;;;;  Nov-17-88 ������ kana2kanji.c ���ѹ����롣

;;;;  Sep-28-88 defrule���ͤȤ���nil���֤��褦���ѹ�������

;;;;  Aug-25-88 �Ѵ��ؽ����������Ԥʤ��褦���ѹ�������
;;;;  KKCP:henkan-kakutei��KKCP:jikouho-list��Ƥ��ʸ����Ф��ƤΤ�Ŭ
;;;;  �ѤǤ�������ʳ��ξ��η�̤��ݾڤ���ʤ������ξ����������褦
;;;;  ��KKCP:jikouho-list��Ƥ�Ǥ��ʤ�ʸ����Ф��Ƥ�
;;;;  KKCP:henkan-kakutei��ƤФʤ��褦�ˤ�����

;;;;  Aug-25-88 egg:do-auto-fill ��������ʣ���Ԥˤ錄��auto-fill����
;;;;  �����Ԥʤ��褦�˽���������

;;;;  Aug-25-88 menu command��\C-l: redraw ���ɲä�����

;;;;  Aug-25-88 toroku-region����Ͽ����ʸ���󤫤�no graphic character��
;;;;  ��ưŪ�˽������Ȥˤ�����

;;;----------------------------------------------------------------------
;;;
;;; Version control routine
;;;
;;;----------------------------------------------------------------------

(and (equal (user-full-name) "Satoru Tomura")
     (defun egg-version-update (arg)
       (interactive "P")
       (if (equal (buffer-name (current-buffer)) "wnn-egg.el")
	   (save-excursion
	    (goto-char (point-min))
	    (re-search-forward "(defvar egg-version \"[0-9]+\\.")
	    (let ((point (point))
		  (minor))
	      (search-forward "\"")
	      (backward-char 1)
	      (setq minor (string-to-int (buffer-substring point (point))))
	      (delete-region point (point))
	      (if (<= minor 8) (insert "0"))
	      (insert  (int-to-string (1+ minor)))
	      (search-forward "Egg last modified date: ")
	      (kill-line)
	      (insert (current-time-string)))
	    (save-buffer)
	    (if arg (byte-compile-file (buffer-file-name)))
	 )))
     )
;;;
;;;----------------------------------------------------------------------
;;;
;;; Utilities
;;;
;;;----------------------------------------------------------------------

;;; kill-all-local-variables �����ݸ�� local variables �����Ǥ���
;;; �褦���ѹ����롣

(defconst *protected-local-variables* 
  (append 
   '(egg:*input-mode* 
     egg:*mode-on*
     egg:*current-mode*
     egg:*current-map*
     mode-line-egg-mode)
   *protected-local-variables*)
  "*List of buffer local variables protected from ""kill-all-local-variables"" ."
  )

;;;----------------------------------------------------------------------
;;;
;;; 16��ɽ����JIS ���������ɤ� minibuffer �����ɤ߹���
;;;
;;;----------------------------------------------------------------------

;;;
;;; User entry:  jis-code-input
;;;

(defun jis-code-input ()
  (interactive)
  (insert-jis-code-from-minibuffer "JIS ����������(16�ʿ�ɽ��): "))

(defun insert-jis-code-from-minibuffer (prompt)
  (let ((str (read-from-minibuffer prompt)) val)
    (while (null (setq val (read-jis-code-from-string str)))
      (beep)
      (setq str (read-from-minibuffer prompt str)))
    (insert (logior (car val) 128)  (logior (cdr val) 128))))

(defun hexadigit-value (ch)
  (cond((and (<= ?0 ch) (<= ch ?9))
	(- ch ?0))
       ((and (<= ?a ch) (<= ch ?f))
	(+ (- ch ?a) 10))
       ((and (<= ?A ch) (<= ch ?F))
	(+ (- ch ?A) 10))))

(defun read-jis-code-from-string (str)
  (if (and (= (length str) 4)
	   (<= 2 (hexadigit-value (aref str 0)))
	   (hexadigit-value (aref str 1))
	   (<= 2 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3)))
  (cons (+ (* 16 (hexadigit-value (aref str 0)))
	       (hexadigit-value (aref str 1)))
	(+ (* 16 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3))))))

;;;----------------------------------------------------------------------	
;;;
;;; �֤��ޤ��� Notification System
;;;
;;;----------------------------------------------------------------------

(defconst *notification-window* " *Notification* ")

;;;(defmacro notify (str &rest args)
;;;  (list 'notify-internal
;;;	(cons 'format (cons str args))))

(defun notify (str &rest args)
  (notify-internal (apply 'format (cons str args))))

(defun notify-internal (message &optional noerase)
  (save-excursion
    (let ((notify-buff (get-buffer-create *notification-window*)))
      (set-buffer notify-buff)
      (goto-char (point-max))
      (setq buffer-read-only nil)
      (insert (substring (current-time-string) 4 19) ":: " message ?\n )
      (setq buffer-read-only t)
      (bury-buffer notify-buff)
      (message message)
      (if noerase nil
	(sleep-for 1) (message "")))))

;;;(defmacro notify-yes-or-no-p (str &rest args)
;;;  (list 'notify-yes-or-no-p-internal 
;;;	(cons 'format (cons str args))))

(defun notify-yes-or-no-p (str &rest args)
  (notify-yes-or-no-p-internal (apply 'format (cons str args))))

(defun notify-yes-or-no-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (yes-or-no-p "�����Ǥ�����")))

(defun notify-y-or-n-p (str &rest args)
  (notify-y-or-n-p-internal (apply 'format (cons str args))))

(defun notify-y-or-n-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (y-or-n-p "�����Ǥ�����")))

(defun select-notification ()
  (interactive)
  (pop-to-buffer *notification-window*)
  (setq buffer-read-only t))

;;;----------------------------------------------------------------------
;;;
;;; �֤��ޤ��� Menu System
;;;
;;;----------------------------------------------------------------------

;;;
;;;  minibuffer �� menu ��ɽ�������򤹤�
;;;

;;;
;;; menu �λ�����ˡ��
;;;
;;; <menu item> ::= ( menu <prompt string>  <menu-list> )
;;; <menu list> ::= ( ( <string> . <value> ) ... )
;;;

(defvar menu:*select-items* nil)
(defvar menu:*select-menus* nil)
(defvar menu:*select-item-no* nil)
(defvar menu:*select-menu-no* nil)
(defvar menu:*select-menu-stack* nil)
(defvar menu:*select-start* nil)
(defvar menu:*select-positions* nil)

(defun menu:select-from-menu (menu &optional initial position)
  (let ((previous-window (selected-window))
	(echo-keystrokes 0)
	(inhibit-quit t)
	value)
    (select-window (minibuffer-window))
    (delete-region (point-min) (point-max))
    (insert (nth 1 menu))
    (let* ((window-width (window-width (selected-window)))
	   (finished nil))
      (setq menu:*select-menu-stack* nil
	    menu:*select-positions* nil
	    menu:*select-start* (point)
	    menu:*select-menus*
	    (menu:make-selection-list (nth 2 menu)
				     (- window-width  
					(length (nth 1 menu)))))
      (if (and (numberp initial)
	       (<= 0 initial)
	       (< initial (length (nth 2 menu))))
	  (menu:select-goto-item-position initial)
	(progn (setq menu:*select-item-no* 0)
	       (menu:select-goto-menu 0)))
      (while (not finished)
	(let ((ch (read-char)))
	  (setq quit-flag nil)
	  (cond
	   ((= ch ?\C-a)
	    (menu:select-goto-item 0))
	   ((= ch ?\C-e)
	    (menu:select-goto-item (1- (length menu:*select-items*))))
	   ((= ch ?\C-f)
	    ;;(menu:select-goto-item (1+ menu:*select-item-no*))
	    (menu:select-next-item)
	    )
	   ((= ch ?\C-b)
	    ;;(menu:select-goto-item (1- menu:*select-item-no*))
	    (menu:select-previous-item)
	    )
	   ((= ch ?\C-n)
	    (menu:select-goto-menu (1+ menu:*select-menu-no*)))
	   ((= ch ?\C-g)
	    (if menu:*select-menu-stack*
		(let ((save (car menu:*select-menu-stack*)))
		  (setq menu:*select-menu-stack* (cdr menu:*select-menu-stack*))
		  (setq menu:select-menu-items (nth 0 save)
			menu:*select-menus*      (nth 1 save)
			menu:*select-item-no*    (nth 2 save)
			menu:*select-menu-no*    (nth 3 save)
			menu                  (nth 4 save))
		  (setq menu:*select-positions*
			(cdr menu:*select-positions*))
		  (delete-region (point-min) (point-max))
		  (insert (nth 1 menu))
		  (setq menu:*select-start* (point))
		  (menu:select-goto-menu menu:*select-menu-no*)
		  (menu:select-goto-item menu:*select-item-no*)
		  )
	      (setq finished t
		    value nil)))
	   ((= ch ?\C-p)
	    (menu:select-goto-menu (1- menu:*select-menu-no*)))
	   ((= ch ?\C-l)  ;;; redraw menu
	    (menu:select-goto-menu menu:*select-menu-no*))
	   ((and (<= ?0 ch) (<= ch ?9)
		 (<= ch (+ ?0 (1- (length menu:*select-items*)))))
	    (menu:select-goto-item (- ch ?0)))
	   ((and (<= ?a ch) (<= ch ?z)
		 (<= ch (+ ?a (1- (length menu:*select-items*)))))
	    (menu:select-goto-item (+ 10 (- ch ?a))))
	   ((and (<= ?A ch) (<= ch ?Z)	; patch by enami@ptgd.sony.co.jp
		 (<= ch (+ ?A (1- (length menu:*select-items*)))))
	    (menu:select-goto-item (+ 10 (- ch ?A))))
	   ((= ch ?\C-m)
	    (setq value (cdr (nth menu:*select-item-no* 
					   menu:*select-items*)))
	    (setq menu:*select-positions* 
		  (cons (menu:select-item-position)
			menu:*select-positions*))
	    (if (and (listp value)
		     (eq (car value) 'menu))
		(progn
		  (setq menu:*select-menu-stack*
			(cons
			 (list menu:*select-items* menu:*select-menus*
			       menu:*select-item-no* menu:*select-menu-no*
			       menu)
			 menu:*select-menu-stack*))
		  (setq menu value)
		  (delete-region (point-min) (point-max))
		  (insert (nth 1 menu))
		  (setq menu:*select-start* (point))
		  (setq menu:*select-menus*
			(menu:make-selection-list (nth 2 menu)
						 (- window-width
						    (length (nth 1 menu)))))
		  (setq menu:*select-item-no* 0)
		  (menu:select-goto-menu 0)
		  (setq value nil)
		  )
	      (setq finished t)))
	   (t (beep))))))
    (delete-region (point-min) (point-max))
    (select-window previous-window)
    (setq menu:*select-positions*
	  (reverse menu:*select-positions*))
    (if (null value)
	(setq quit-flag t)
      (if position
	  (cons value menu:*select-positions*)
	value))))

(defun menu:select-item-position ()
  (let ((p 0) (m 0))
    (while (< m menu:*select-menu-no*)
      (setq p (+ p (length (nth m menu:*select-menus*))))
      (setq m (1+ m)))
    (+ p menu:*select-item-no*)))
    
(defun menu:select-goto-item-position (pos)
  (let ((m 0) (i 0) (p 0))
    (while (<= (+ p (length (nth m menu:*select-menus*))) pos)
      (setq p (+ p (length (nth m menu:*select-menus*))))
      (setq m (1+ m)))
    (setq menu:*select-item-no* (- pos p))
    (menu:select-goto-menu m)))

(defun menu:select-goto-menu (no)
  (setq menu:*select-menu-no*
	(check-number-range no 0 (1- (length menu:*select-menus*))))
  (setq menu:*select-items* (nth menu:*select-menu-no* menu:*select-menus*))
  (delete-region menu:*select-start* (point-max))
  (if (<= (length menu:*select-items*) menu:*select-item-no*)
      (setq menu:*select-item-no* (1- (length menu:*select-items*))))
  (goto-char menu:*select-start*)
  (let ((l menu:*select-items*) (i 0))
    (while l
      (insert (if (<= i 9) (format "  %d." i)
		(format "  %c." (+ (- i 10) ?a)))
	      (car (car l)))
      (setq l (cdr l)
	    i (1+ i))))
  (menu:select-goto-item menu:*select-item-no*))

(defun menu:select-goto-item (no)
  (setq menu:*select-item-no* 
	(check-number-range no 0
			    (1- (length menu:*select-items*))))
  (let ((p (+ 2 menu:*select-start*)) (i 0))
    (while (< i menu:*select-item-no*)
      (setq p (+ p (length (car (nth i menu:*select-items*))) 4))
      (setq i (1+ i)))
    (goto-char p)))
    
(defun menu:select-next-item ()
  (if (< menu:*select-item-no* (1- (length menu:*select-items*)))
      (menu:select-goto-item (1+ menu:*select-item-no*))
    (progn
      (setq menu:*select-item-no* 0)
      (menu:select-goto-menu (1+ menu:*select-menu-no*)))))

(defun menu:select-previous-item ()
  (if (< 0 menu:*select-item-no*)
      (menu:select-goto-item (1- menu:*select-item-no*))
    (progn 
      (setq menu:*select-item-no* 1000)
      (menu:select-goto-menu (1- menu:*select-menu-no*)))))

(defun menu:make-selection-list (list width)
  (let ((whole nil) (line nil) (size 0))
    (while list
      (if (<= width (+ size 4 (length (car(car list)))))
	  (if line
	      (setq whole (cons (reverse line) whole)
		    line nil
		    size 0)
	    (setq whole (cons (list (car list)) whole)
		  size 0
		  list (cdr list)))
	(setq line (cons (car list) line)
	      size (+ size 4 (length(car (car list))))
	      list (cdr list))))
    (if line
	(reverse (cons (reverse line) whole))
      (reverse whole))))

;;;----------------------------------------------------------------------
;;;
;;;  ��緿�Ѵ���ǽ
;;;
;;;----------------------------------------------------------------------

(defvar ascii-char "[\40-\176]")

(defvar ascii-space "[ \t]")
(defvar ascii-symbols "[\40-\57\72-\100\133-\140\173-\176]")
(defvar ascii-numeric "[\60-\71]")
(defvar ascii-English-Upper "[\101-\132]")
(defvar ascii-English-Lower "[\141-\172]")

(defvar ascii-alphanumeric "[\60-\71\101-\132\141-\172]")

(defvar kanji-char "\\z")
(defvar kanji-space "��")
(defvar kanji-symbols "\\cs")
(defvar kanji-numeric "[��-��]")
(defvar kanji-English-Upper "[��-��]")
(defvar kanji-English-Lower  "[��-��]")
;;; Bug fixed by Yoshida@CSK on 88-AUG-24
(defvar kanji-hiragana "[��-��]")
(defvar kanji-katakana "[��-��]")
;;;
(defvar kanji-Greek-Upper "[��-��]")
(defvar kanji-Greek-Lower "[��-��]")
(defvar kanji-Russian-Upper "[��-��]")
(defvar kanji-Russian-Lower "[��-��]")
(defvar kanji-Kanji-1st-Level  "[��-��]")
(defvar kanji-Kanji-2nd-Level  "[С-��]")

(defvar kanji-kanji-char "\\(\\ch\\|\\ck\\|\\cc\\)")

(defvar aletter (concat "\\(" ascii-char "\\|" kanji-char "\\)"))

;;;
;;; �Ҥ餬���Ѵ�
;;;

(defun hiragana-region (start end)
  (interactive "r")
  (let ((point (point)))
    (goto-char start)
    (while (re-search-forward kanji-katakana end end)
      (let ((ch2 (preceding-char)))
	(delete-char -1)
	(insert ?\244 ch2)))))

(defun hiragana-paragraph ()
  "hiragana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (hiragana-region (point) end ))))

(defun hiragana-sentence ()
  "hiragana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (hiragana-region (point) end ))))

;;;
;;; ���������Ѵ�
;;;

(defun katakana-region (start end)
  (interactive "r")
  (let ((point (point)))
    (goto-char start)
    (while (re-search-forward kanji-hiragana end end)
      (let ((ch2 (preceding-char)))
	(delete-char -1)
	(insert ?\245 ch2)))))

(defun katakana-paragraph ()
  "katakana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (katakana-region (point) end ))))

(defun katakana-sentence ()
  "katakana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (katakana-region (point) end ))))

;;;
;;; Ⱦ���Ѵ�
;;; 

(defun hankaku-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "\\cs\\|\\ca" (point-max) (point-max))
      (let ((ch1 (char-after (- (point) 2)))
	    (ch2 (preceding-char)))
	  (cond((= ?\241 ch1)
		(let ((val (cdr(assq ch2 *hankaku-alist*))))
		  (if val (progn
			    (delete-char -1)
			    (insert val)))))
	       ((= ?\243 ch1)
		(delete-char -1)
		(insert (- ch2 ?\200 ))))))))

(defun hankaku-paragraph ()
  "hankaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (hankaku-region (point) end ))))

(defun hankaku-sentence ()
  "hankaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (hankaku-region (point) end ))))

(defun hankaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (hankaku-region start (point))))

(defvar *hankaku-alist*
  '(( 161 . ?\  ) 
    ( 170 . ?\! )
    ( 201 . ?\" )
    ( 244 . ?\# )
    ( 240 . ?\$ )
    ( 243 . ?\% )
    ( 245 . ?\& )
    ( 199 . ?\' )
    ( 202 . ?\( )
    ( 203 . ?\) )
    ( 246 . ?\* )
    ( 220 . ?\+ )
    ( 164 . ?\, )
    ( 221 . ?\- )
    ( 165 . ?\. )
    ( 191 . ?\/ )
    ( 167 . ?\: )
    ( 168 . ?\; )
    ( 227 . ?\< )
    ( 225 . ?\= )
    ( 228 . ?\> )
    ( 169 . ?\? )
    ( 247 . ?\@ )
    ( 206 . ?\[ )
    ( 239 . ?\\ )
    ( 207 . ?\] )
    ( 176 . ?\^ )
    ( 178 . ?\_ )
    ( 208 . ?\{ )
    ( 195 . ?\| )
    ( 209 . ?\} )
    ( 177 . ?\~ )
    ))

;;;
;;; �����Ѵ�
;;;

(defun zenkaku-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "[ -~]" (point-max) (point-max))
      (let ((ch (preceding-char)))
	(if (and (<= ?  ch) (<= ch ?~))
	    (progn (delete-char -1)
		   (let ((zen (cdr (assq ch *zenkaku-alist*))))
		     (if zen (insert zen)
		       (insert ?\243 (+ ?\200 ch))))))))))

(defun zenkaku-paragraph ()
  "zenkaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (zenkaku-region (point) end ))))

(defun zenkaku-sentence ()
  "zenkaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (zenkaku-region (point) end ))))

(defun zenkaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (zenkaku-region start (point))))

(defvar *zenkaku-alist*
  '((?  . "��") 
    (?! . "��")
    (?\" . "��")
    (?# . "��")
    (?$ . "��")
    (?% . "��")
    (?& . "��")
    (?' . "��")
    (?( . "��")
    (?) . "��")
    (?* . "��")
    (?+ . "��")
    (?, . "��")
    (?- . "��")
    (?. . "��")
    (?/ . "��")
    (?: . "��")
    (?; . "��")
    (?< . "��")
    (?= . "��")
    (?> . "��")
    (?? . "��")
    (?@ . "��")
    (?[ . "��")
    (?\\ . "��")
    (?] . "��")
    (?^ . "��")
    (?_ . "��")
    (?{ . "��")
    (?| . "��")
    (?} . "��")
    (?~ . "��")))

;;;
;;; ���޻������Ѵ�
;;;

(defun roma-kana-region (start end )
  (interactive "r")
  (let ((egg:*current-map* (egg:get-mode-map "roma-kana")))
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (while (not (eobp))
	(if (null (get-key-action egg:*current-map* (following-char)))
	    (forward-char 1)
	  ;;; ��Ĺ���Ѵ����Ľ������롣
	  (let ((current-map egg:*current-map*)
		(ch nil)
		(action nil)
		(output nil)
		(kana-quit-flag nil)
		(point (1- (point)))
		(start (point)))
	    (while (not kana-quit-flag)
	      (setq point (1+ point))
	      (setq ch (char-after point))
	      (setq action (if (null ch) nil 
			     (get-key-action current-map ch)))
	      (cond((null action)
		    (cond(output 
			  (goto-char point)
			  (delete-region start (point))
			  (insert output)
			  (setq kana-quit-flag t))
			 (t (goto-char point)
			    (setq kana-quit-flag t))))

		   ((null(action-get-output action))
		    (setq current-map (action-get-map action)))
	       
		   ((symbolp (car (action-get-map action))) ;;; top or next
		    (goto-char (1+ point))
		    (delete-region start (point))
		    (insert (action-get-output action))
		    (setq current-map (action-get-map action))
		    (cond((eq (car current-map) 'top)
			  (setq kana-quit-flag t))
			 ((eq (car current-map) 'next)
			  (setq start (point))
			  (insert (nth 1 current-map))
			  (setq point (1- (point)))
			  (if (null(nth 2 current-map))
			      (setcar (nthcdr 2 current-map)
				      (egg:simulate-input 0 (length (nth 1 current-map))
							  (nth 1 current-map)
							  egg:*current-map*)))
			  (setq current-map (nth 2 current-map)))))

	       ;;; output is non nil and action is active
		   (t
		    (setq output (action-get-output action)
			  current-map (action-get-map action)))))
	    ))))))

(defun roma-kana-paragraph ()
  "roma-kana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kana-region (point) end ))))

(defun roma-kana-sentence ()
  "roma-kana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kana-region (point) end ))))

;;;
;;; ���޻������Ѵ�
;;;

(defun roma-kanji-region (start end)
  (interactive "r")
  (roma-kana-region start end)
  (save-restriction
    (narrow-to-region start (point))
    (goto-char (point-min))
    (replace-regexp "\\(��\\| \\)" "")
    (goto-char (point-max)))
  (henkan-region-internal start (point)))

(defun roma-kanji-paragraph ()
  "roma-kanji  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kanji-region (point) end ))))

(defun roma-kanji-sentence ()
  "roma-kanji  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kanji-region (point) end ))))

;;;----------------------------------------------------------------------
;;;
;;; �֤��ޤ�������ʸ���Ѵ���
;;; 
;;;----------------------------------------------------------------------

(defun egg:member (elt list)
  (while (not (or (null list) (equal elt (car list))))
    (setq list (cdr list)))
  list)

;;;
;;; Mode name --> map
;;;

(defvar egg:*mode-alist* nil)

;;; egg mode name is a string.

(defun egg:get-mode-map (name)
  (cdr (assoc name egg:*mode-alist*)))

(defun egg:set-mode-map (name map )
  (let ((place (assoc name egg:*mode-alist*)))
    (if place (let ((mapplace (cdr place)))
		(setcar mapplace (car map))
		(setcdr mapplace (cdr map)))
      (progn (setq place (cons name map))
	     (setq egg:*mode-alist* (cons place egg:*mode-alist*))))))

;;;
;;; egg mode indicators
;;; Mode name --> indicator
;;;

(defvar egg:*mode-indicator* nil)

(defun egg:get-mode-indicator (name)
  (if (assoc name egg:*mode-indicator*)
      (cdr (assoc name egg:*mode-indicator*))
    name))

(defun egg:set-mode-indicator (name indicator)
  (if (assoc name egg:*mode-indicator*)
      (setcdr (assoc name egg:*mode-indicator*) indicator)
    (setq egg:*mode-indicator* (cons (cons name indicator)
				     egg:*mode-indicator*))))

;;;
;;; egg mode declaration
;;;

(defvar egg:*processing-map* nil)

(defun define-egg-mode (name &optional reset)
  (if (null(egg:get-mode-map name))
      (progn 
	(setq egg:*processing-map* (cons nil nil))
	(egg:set-mode-map name egg:*processing-map*)
	)
    (progn (setq egg:*processing-map* (egg:get-mode-map name))
	   (if reset
	       (progn
		 (setcar egg:*processing-map* nil)
		 (setcdr egg:*processing-map* nil))))))

;;; 
;;; ����ʸ���Ѵ���§����ѥ���
;;;
;;; �Ѵ���§��defrule�ˤ�ͭ�¾��֥����ȥޥȥ�˥���ѥ��뤹�롣
;;;

(defun egg:collect-symbols(form)
  (egg:collect-symbol* form nil))

(defun egg:collect-symbol* (form alist)
  (cond((null form) alist)
       ((symbolp form)
	(if (egg:member form alist) alist
	  (cons form alist)))
       ((consp form)
	(egg:collect-symbol* (car form) 
			 (egg:collect-symbol* (cdr form) alist)))
       (t alist)))

(defun egg:fetch-value (form alist)
  (cond ((null form) nil)
	((symbolp form)
	 (cdr (assq form alist)))
	((consp form)
	 (cons (egg:fetch-value (car form) alist)
	       (egg:fetch-value (cdr form) alist)))
	(t form)))

(defun egg:flatten-to-string (form)
  (cond ((null form) "")
	((stringp form) form)
	((symbolp form) (symbol-name form))
	((numberp form) (make-string 1 form))
	(t (apply 'concat 
		  (mapcar 'egg:flatten-to-string
			  form)))))

(defun egg:generate-all-subst (vars)
  (cond((null vars) nil)
       (t (let ((r (egg:generate-all-subst (cdr vars))))
	    (cond ((boundp (car vars))
		   (apply 'append 
			  (mapcar (function (lambda (val)
			      (if r
				  (mapcar (function
					   (lambda (assign)
					     (cons (cons (car vars) val)
						   assign)))
					  r)
				(list (list (cons (car vars) val))))))
				  (and (boundp (car vars))
				       (eval (car vars))))))
		  (t r))))))

;;;
;;; defrule
;;; 

(defun defrule (input output &optional next)
  (let* ((vars (egg:collect-symbols (list input output next)))
	 (substs (egg:generate-all-subst vars)))
    (if substs
	(while substs
	  (let((in  (egg:fetch-value input (car substs)))
	       (out (egg:fetch-value output(car substs)))
	       (next(egg:fetch-value next  (car substs))))
	    (defrule* 0 (egg:flatten-to-string in)
	      (egg:flatten-to-string out)
	      (and next (egg:flatten-to-string next))
	      egg:*processing-map*))
	  (setq substs (cdr substs)))
      (defrule* 0 (egg:flatten-to-string input)
	(egg:flatten-to-string output)
	(and next (egg:flatten-to-string next))
	egg:*processing-map*))))

(defun defrule* (i input output next map)
  (let((action 
	(progn
	  (if (null(get-key-action map (aref input i)))
	    (set-key-action map (aref input i) (make-action)))
	  (get-key-action map (aref input i)))))
    (cond((= (length input) (1+ i))  ;;; end of input
	  (if (action-get-output action)
	      (if (not(and
		       (equal output (action-get-output action))
		       (equal next   (action-get-next   action))))
		  (let ((debug-on-error nil))
		    (error "(defrule ""%s"" ""%s"" ""%s"") is ambiguous" 
			   input output next)))
	    (action-set-output action output))
	  (if next
	      (cond((null (action-get-map action)) 
		    (action-set-next action next))
		   ((not (equal next (action-get-next action)))
		    (let ((debug-on-error nil))
		      (error "(defrule ""%s"" ""%s"" ""%s"") is ambiguous" 
			     input output next))))
	    (if (null (action-get-map action))
		(action-set-top action input map))))

	 ((action-get-next action)
	  (let ((debug-on-error nil))
	    (error "(defrule ""%s"" ""%s"" ""%s"") is ambiguous" 
		 input output next)))

	 (t (if (or(null (action-get-map action))
		   (action-get-top action))
		(action-set-map action (cons map nil)))
	    (defrule* (1+ i) input output next
	      (action-get-map (get-key-action map (aref input i)))))))
  nil ;;; return void value
  )

;;;
;;;  Map structure
;;;
;;;  A map is a pair of the upper level map and 
;;;  alist from keys to actions.
;;;
;;; <map> ::=
;;; ( <map> . ( ( <ch1> . <act1> ) ( <ch2> . <act2> ) ..... ))
;;;

(defun make-map (&optional map alist)
  (cons map alist))

(defun get-key-action (map ch)
  (cdr (assq ch (cdr map))))

(defun set-key-action (map ch val)
  (let ((place (assq ch (cdr map))))
    (if place
	(setcdr place val)
      (setcdr map (cons (cons ch val) (cdr map))))))

;;; (null (car map)) means the map is toplevel.

(defun map-toplevelp (map) (null (car map)))

;;;
;;; Action structure
;;;
;;; An action is a list of a map and an output.
;;;
;;; <action> ::= ( <map>                  <output> )
;;;           |  ( ( top  <input> <map> ) <output> )
;;;           |  ( ( next <next>  nil )   <output> )

(defun make-action (&optional map output) (list map output))

(defun action-get-map (action) (nth 0 action))

(defun action-set-map (action val)
  (setcar (nthcdr 0 action) val))

(defun action-get-output (action) (nth 1 action))

(defun action-set-output (action output)
  (setcar (nthcdr 1 action) output))

(defun action-get-top (action)
  (eq (car (nth 0 action)) 'top))

(defun action-set-top (action input map)
  (action-set-map action 
		  (list 'top (substring input 0 (1- (length input))) map)))

(defun action-get-next (action) 
  (and (eq (car(nth 0 action)) 'next)
       (nth 1 (nth 0 action))))

(defun action-set-next (action next)
  (action-set-map action (list 'next next nil)))

;;;----------------------------------------------------------------------
;;;
;;; Runtime translators
;;;
;;;----------------------------------------------------------------------
      
(defun egg:simulate-input (i j  input map)
  (while (< i j)
    (setq map (action-get-map  (get-key-action map (aref input i))))
    (setq i (1+ i)))
  map)

;;; meta-flag �� on �λ��ˤϡ����ϥ����ɤ� \200 �� or ������Τ����Ϥ�
;;; ��롣������ʬ�λ�Ŧ���칩������� ��Ƿ����ˤ�롣
;;; pointted by nakagawa@titisa.is.titech.ac.jp Dec-11-89
;;;
;;; emacs �Ǥ� ʸ�������ɤ� 0-127 �ǰ�����
;;;
(defun fence-self-insert-command ()
  (interactive)
  (if (or (not egg:*input-mode*)
	  (null (get-key-action egg:*current-map* last-command-char)))
      (insert last-command-char)
      (let ((current-map egg:*current-map*)
	    (ch last-command-char)
	    (action nil)
	    (output nil)
	    (start (point))
	    (inhibit-quit t)
	    (kana-quit-flag nil)
	    (echo-keystrokes 0))
	(while (not kana-quit-flag)
	  (setq action (get-key-action current-map ch))
	  (cond((and (null action) (map-toplevelp current-map))
		(setq kana-quit-flag t))

	       ((and (<= ch 127)
		     (eq (aref fence-mode-map ch)
			 'fence-backward-delete-char) ;;; DEL key?
		     )
		(if (map-toplevelp (car current-map))
		    (setq kana-quit-flag t)
		  (progn
		    (delete-char -1)
		    (setq current-map (car current-map)
			  ch (read-char)))))

	       ((null action)
		(cond(output 
		      (delete-region start (point))
		      (insert output)
		      (setq kana-quit-flag t))
		     ((and (<= ch 127)
			   (or (eq (aref fence-mode-map ch) 'fence-self-insert-command)
			       (eq (aref fence-mode-map ch) 'undefined)))
		      (beep)(setq ch (read-char)))
		     (t
		      (setq kana-quit-flag t))))

	       ((null(action-get-output action))
		(insert ch)
		(setq current-map (action-get-map action)
		      ch  (read-char)))
	       
	       ((symbolp (car (action-get-map action))) ;;; top or next
		(delete-region start (point))
		(insert (action-get-output action))
		(setq current-map (action-get-map action))
		(cond((eq (car current-map) 'top)
		      (setq ch (read-char))
		      (if (and (<= ch 127)
			       (eq (aref fence-mode-map ch)
				   'fence-backward-delete-char) ;;; DEL key?
			       )
			  (progn 
			    (if (map-toplevelp (nth 2 current-map))
				(setq kana-quit-flag t)
			      (progn
				(delete-region start (point))
				(insert (nth 1 current-map))
				(setq current-map (nth 2 current-map))
				(setq ch (read-char)))))
			(setq kana-quit-flag t)))
		     ((eq (car current-map) 'next)
		      (setq start (point))
		      (insert (nth 1 current-map))
		      (if (null(nth 2 current-map))
			  (setcar (nthcdr 2 current-map)
				  (egg:simulate-input 0 (length (nth 1 current-map))
						  (nth 1 current-map)
						  egg:*current-map*)))
		      (setq current-map (nth 2 current-map)
			    ch (read-char)))))
	       ;;; output is non nil and action is active
	       (t(insert ch)
		 (setq output (action-get-output action)
		       current-map (action-get-map action)
		       ch (read-char))))
	  )
	(setq unread-command-char ch)))
  )

;;;----------------------------------------------------------------------
;;; 
;;; egg-map dump routine:
;;;
;;;----------------------------------------------------------------------

;;;
;;; Load time support routine
;;;

(defun setf-key-action (map key action)
  (setcdr map (cons (cons key action) (cdr map))))

;;;;;
;;;;; User entry: dump-egg-mode-map
;;;;;

(defun dump-egg-mode-map (name filename)
  (interactive (list (completing-read "EGG mode: " egg:*mode-alist*)
		     (read-file-name "Output file name:" )))
  (save-excursion 
    (let ((buff (get-buffer-create "*EggModeDumpBuffer*")))
      (set-buffer buff)
      (let ((standard-output buff))
	(setq buffer-read-only nil)
	(erase-buffer)
	(terpri)(princ "(egg:set-mode-indicator ")
	(prin1 name)(princ " ") (prin1 (egg:get-mode-indicator name))
	(princ " )")
	(terpri)
	(terpri)(princ "(egg:set-mode-map ")
	(prin1 name)
	(egg:dump-map (egg:get-mode-map name))
	(princ " )"))
      (write-region (point-min) (point-max)  (expand-file-name filename))
      (byte-compile-file (expand-file-name filename)))))

(defun egg:dump-map (map)
  (if (null (car map))
      (progn
	(terpri)
	(princ "(let ((map (cons nil nil)))" )
	(egg:dump-map-alist (cdr map))
	(terpri)
	(princ " map)"))
    (error "ARG map is not toplevel.")))

(defun egg:dump-map-alist (alist )
  (let ((l alist))
    (while (not (null l))
      (let ((ch (car(car l)))
	    (action (cdr (car l))))
	(terpri)
	(princ "(setf-key-action map ")
	;;;(princ (format "?\\%c " ch))
	(princ ch) (princ " ")
	(egg:dump-map-action action)
	(princ ")")
	(setq l (cdr l)))))
  )

(defun egg:dump-map-action (action)
  (let ((map (action-get-map action))
	(output (action-get-output action)))
    (princ "(list ")
    (cond((null map)
	  (princ "nil "))
	 ((eq (car map) 'next)
	  (princ "(list 'next ")
	  (prin1 (nth 1 map))
	  (princ " nil)"))
	 ((eq (car map) 'top)
	  (princ "(list 'top ")
	  (prin1 (nth 1 map))
	  (princ " map)"))
	 (t 
	  (princ "(let ((map (cons map nil)))")
	  (egg:dump-map-alist (cdr map))
	  (princ " map)")))
    (prin1 output) (princ " )")))
	  
;;;
;;; EGG mode variables
;;;

(defvar egg:*mode-on* nil "T if egg mode is on.")
(make-variable-buffer-local 'egg:*mode-on*)
(set-default 'egg:*mode-on* nil)

(defvar egg:*input-mode* t "T if egg map is active.")
(make-variable-buffer-local 'egg:*input-mode*)
(set-default 'egg:*input-mode* t)

(defvar egg:*in-fence-mode* nil "T if in fence mode.")

(define-egg-mode "roma-kana")
(egg:set-mode-indicator "roma-kana" " a��")

(defvar egg:*current-map* nil)
(make-variable-buffer-local 'egg:*current-map*)
(setq-default egg:*current-map* (egg:get-mode-map "roma-kana"))

(defvar egg:*current-mode* nil)
(make-variable-buffer-local 'egg:*current-mode*)
(setq-default egg:*current-mode* (egg:get-mode-indicator "roma-kana"))

;;;----------------------------------------------------------------------
;;;
;;; Mode line control functions;
;;;
;;;----------------------------------------------------------------------

(defconst mode-line-egg-mode "----")
(make-variable-buffer-local 'mode-line-egg-mode)

(defvar   mode-line-egg-mode-in-minibuffer "----" "global variable")
(defvar   egg-in-minibuffer nil "global variable")

(defun egg:find-symbol-in-tree (item tree)
  (if (consp tree)
      (or (egg:find-symbol-in-tree item (car tree))
	  (egg:find-symbol-in-tree item (cdr tree)))
    (equal item tree)))

;;;
;;; nemacs Ver. 3.0 �Ǥ� Fselect_window ���ѹ��ˤʤꡢminibuffer-window
;;; ¾�� window �Ȥδ֤ǽ����꤬����ȡ�mode-line �ι�����Ԥʤ����ѿ� 
;;; minibuffer-window-selected ���ͤ����������
;;;

(or (fboundp 'si:select-window)
    (fset 'si:select-window (symbol-function 'select-window)))

(defun new:select-window (window)
  (let ((was-in-minibuf  (eq (selected-window) (minibuffer-window)))
	(enter-minibuf   (eq window (minibuffer-window))))
    (or (eq was-in-minibuf enter-minibuf)
	(set-buffer-modified-p (buffer-modified-p)))
    (setq minibuffer-window-selected enter-minibuf)
    (si:select-window window)))
	
(or (fboundp 'si:other-window)
    (fset 'si:other-window (symbol-function 'other-window)))

(defun new:other-window (arg)
  (interactive "p")
  (let ((window (selected-window)))
    (cond((< arg 0)
	  (while (< arg 0)
	    (setq window (previous-window window))
	    (setq arg (1+ arg))))
	 ((> arg 0)
	  (while (> arg 0)
	    (setq window (next-window window nil))
	    (setq arg  (1- arg)))))
    (select-window window)
    nil))

(if (not (boundp 'minibuffer-window-selected))
    (progn (fset 'select-window (symbol-function 'new:select-window))
	   (fset 'other-window  (symbol-function 'new:other-window))))

(setq minibuffer-window-selected nil)

(defvar display-minibuffer-mode nil)

(defvar *minibuffer-window* (minibuffer-window))

(if (not (egg:find-symbol-in-tree 'mode-line-egg-mode mode-line-format))
    (setq-default mode-line-format
		  (cons (list 'kanji-flag
			      (list 
			       (list 'minibuffer-window-selected
				     (list 'display-minibuffer-mode
					   "m"
					   " ")
				     " ")
			       "["
			       (list 'minibuffer-window-selected
				     (list 'display-minibuffer-mode
					   'mode-line-egg-mode-in-minibuffer
					   'mode-line-egg-mode)
				     'mode-line-egg-mode)
			       "]"))
			mode-line-format)))

(defun mode-line-egg-mode-update (str)
  (if (or minibuffer-window-selected
	  (eq (selected-window) *minibuffer-window*))
      (setq minibuffer-window-selected t
	    display-minibuffer-mode t
	    mode-line-egg-mode-in-minibuffer str)
    (setq minibuffer-window-selected nil
	  display-minibuffer-mode nil
	  mode-line-egg-mode str))
  (set-buffer-modified-p (buffer-modified-p)))

(mode-line-egg-mode-update mode-line-egg-mode)

;;;
;;; egg mode line display
;;;

(defvar alphabet-mode-indicator " a a")
(defvar transparent-mode-indicator "----")

(defun egg:mode-line-display ()
  (mode-line-egg-mode-update 
   (cond((and egg:*in-fence-mode* (not egg:*input-mode*))
	 alphabet-mode-indicator)
	((and egg:*mode-on* egg:*input-mode*)
	 egg:*current-mode*)
	(t transparent-mode-indicator))))

(defun egg:toggle-egg-mode-on-off ()
  (interactive)
  (setq egg:*mode-on* (not egg:*mode-on*))
  (egg:mode-line-display))

(defun egg:goto-input-mode (name)
  (interactive (list (completing-read "EGG mode: " egg:*mode-alist*)))
  (if (egg:get-mode-map name)
      (progn
	(setq egg:*current-mode* (egg:get-mode-indicator name)
	      egg:*current-map* (egg:get-mode-map name))
	(egg:mode-line-display))
    (beep))
  )

(defun toggle-egg-mode ()
  (interactive)
  (if kanji-flag 
      (if egg:*mode-on* (fence-toggle-egg-mode)
	(progn
	  (setq egg:*mode-on* t)
	  (egg:mode-line-display)))))

(defun fence-toggle-egg-mode ()
  (interactive)
  (if egg:*current-map*
      (progn
	(setq egg:*input-mode* (not egg:*input-mode*))
	(egg:mode-line-display))
    (beep)))

;;;
;;; Changes on Global map 
;;;

(defvar si:*global-map* (copy-keymap global-map))

(let ((ch 32))
  (while (< ch 127)
    (aset global-map ch 'egg-self-insert-command)
    (setq ch (1+ ch))))

;;;
;;; Currently entries C-\ and C-^ at global-map are undefined.
;;;

(define-key global-map "\C-\\" 'toggle-egg-mode)

;;;
;;; C-X SPC is bound to henkan-region
;;;

(define-key ctl-x-map " " 'henkan-region)

;;;
;;;  Keyboard quit
;;;

(if (not (fboundp 'si:keyboard-quit))
    (fset 'si:keyboard-quit (symbol-function 'keyboard-quit)))

(defun keyboard-quit ()
  "See documents for si:keyboard-quit"
  (interactive)
  (setq minibuffer-window-selected nil
	display-minibuffer-mode nil)
  (if egg:*mode-on*
      (progn
	(setq egg:*mode-on* nil)
	(setq egg:*in-fence-mode* nil)
	(egg:mode-line-display)))
  (si:keyboard-quit))

;;;
;;; Abort recursive edit
;;;

(if (not (fboundp 'si:abort-recursive-edit))
 (fset 'si:abort-recursive-edit (symbol-function 'abort-recursive-edit)))

(defun abort-recursive-edit ()
  "See documents for si:abort-recursive-edit"
  (interactive)
  (setq minibuffer-window-selected nil
	display-minibuffer-mode nil)
  (if egg:*mode-on*
      (progn 
	(setq egg:*mode-on* nil)
	(setq egg:*in-fence-mode* nil)
	(egg:mode-line-display))
    (si:abort-recursive-edit)))

;;;
;;;  Exit-minibuffer
;;;

(if (not (fboundp 'si:exit-minibuffer))
 (fset 'si:exit-minibuffer (symbol-function 'exit-minibuffer)))

(defun exit-minibuffer ()
  "See documents for si:exit-minibuffer"
  (interactive)
  (setq egg:*mode-on* nil)
  (egg:mode-line-display)
  (setq minibuffer-window-selected nil
	display-minibuffer-mode nil)
  (si:exit-minibuffer))

;;;
;;; auto fill controll
;;;

(defun egg:do-auto-fill ()
  (if (and auto-fill-hook (not buffer-read-only)
	   (> (current-column) fill-column))
      (let ((ocolumn (current-column)))
	(run-hooks 'auto-fill-hook)
	(while (and (< fill-column (current-column))
		    (< (current-column) ocolumn))
  	  (setq ocolumn (current-column))
	  (run-hooks 'auto-fill-hook)))))

;;;----------------------------------------------------------------------
;;;
;;;  Egg fence mode
;;;
;;;----------------------------------------------------------------------

(defconst egg:*fence-open*   "|" "*�ե��󥹤λ����򼨤�ʸ����")
(defconst egg:*fence-close*  "|" "*�ե��󥹤ν����򼨤�ʸ����")
(defconst egg:*fence-attribute* nil  "*�ե���ɽ�����Ѥ���attribute �ޤ��� nil")

(defvar egg:*attribute-alist* '(("nil" . nil) ("inverse" . inverse) ("underline" . underline)))

(defun set-egg-fence-mode-format (open close &optional attr)
  "fence mode ��ɽ����ˡ�����ꤹ�롣OPEN �ϥե��󥹤λ����򼨤�ʸ����ޤ��� nil��\n\
CLOSE�ϥե��󥹤ν����򼨤�ʸ����ޤ��� nil��\n\
optional ATTR �ϥե��󥹶�֤�ɽ������°�� �ޤ��� nil��x11term �Τߤ�ͭ����"
  (interactive (list (read-string "�ե��󥹳���ʸ����: ")
		     (read-string "�ե��󥹽�λʸ����: ")
		     (cdr (assoc (completing-read "�ե���ɽ��°��: " egg:*attribute-alist*)
				 egg:*attribute-alist*))))

  (if (and (or (stringp open) (null open))
	   (or (stringp close) (null close))
	   (egg:member attr '(underline inverse nil)))
      (progn
	(setq egg:*fence-open* (or open "")
	      egg:*fence-close* (or close "")
	      egg:*fence-attribute* attr)
	(if attr (require 'attribute))
	t)
    (error "Wrong type of argument: %s %s %s" open close attr)))

(defconst egg:*region-start* (make-marker))
(defconst egg:*region-end*   (set-marker-type (make-marker) t))
(defvar egg:*global-map-backup* nil)
(defvar egg:*local-map-backup*  nil)


;;;
;;; (defvar disable-undo nil "*Compatibility for Nemacs")
;;;
;;; Moved to kanji.el
;;; (defvar self-insert-after-hook nil
;;;  "Hook to run when extended self insertion command exits. Should take
;;; two arguments START and END correspoding to character position.")

(defun egg-self-insert-command (arg)
  (interactive "p")
  (if (and (not buffer-read-only)
	   kanji-flag
	   egg:*mode-on* egg:*input-mode* 
	   (not egg:*in-fence-mode*) ;;; inhibit recursive fence mode
	   (not (= last-command-char  ?  )))
      (egg:enter-fence-mode-and-self-insert)
    (progn
      (self-insert-command arg) 
      (if egg-insert-after-hook
	  (run-hooks 'egg-insert-after-hook))
      (if self-insert-after-hook
	  (if (<= 1 arg)
	      (funcall self-insert-after-hook
		       (- (point) arg) (point)))
	(if (= last-command-char ? ) (egg:do-auto-fill))))))


(defun egg:enter-fence-mode-and-self-insert () 
  (enter-fence-mode)
  (setq unread-command-char last-command-char))

(defun egg:fence-attribute-on ()
  (egg:set-region-attribute egg:*fence-attribute* t))

(defun egg:fence-attribute-off ()
  (egg:set-region-attribute egg:*fence-attribute* nil))

(defun enter-fence-mode ()
  ;;;(buffer-flush-undo (current-buffer))
  (and (boundp 'disable-undo) (setq disable-undo t))
  (setq egg:*in-fence-mode* t)
  (egg:mode-line-display)
  ;;;(setq egg:*global-map-backup* (current-global-map))
  (setq egg:*local-map-backup*  (current-local-map))
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map nil)
  (use-local-map fence-mode-map)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (insert egg:*fence-close*)
  (set-marker egg:*region-end* egg:*region-start*)
  (egg:fence-attribute-on)
  (goto-char egg:*region-start*)
  )

(defun henkan-fence-region-or-single-space ()
  (interactive)
  (if egg:*input-mode*   
      (henkan-fence-region)
    (insert ? )))

(defun henkan-fence-region ()
  (interactive)
  (henkan-region-internal egg:*region-start* egg:*region-end* ))

(defun fence-katakana  ()
  (interactive)
  (katakana-region egg:*region-start* egg:*region-end* ))

(defun fence-hiragana  ()
  (interactive)
  (hiragana-region egg:*region-start* egg:*region-end*))

(defun fence-hankaku  ()
  (interactive)
  (hankaku-region egg:*region-start* egg:*region-end*))

(defun fence-zenkaku  ()
  (interactive)
  (zenkaku-region egg:*region-start* egg:*region-end*))

(defun fence-backward-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (backward-char)
    (beep)))

(defun fence-forward-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (forward-char)
    (beep)))

(defun fence-beginning-of-line ()
  (interactive)
  (goto-char egg:*region-start*))

(defun fence-end-of-line ()
  (interactive)
  (goto-char egg:*region-end*))

(defun fence-transpose-chars (arg)
  (interactive "P")
  (if (and (< egg:*region-start* (point))
	   (< (point) egg:*region-end*))
      (transpose-chars arg)
    (beep)))

(defun egg:exit-if-empty-region ()
  (if (= egg:*region-start* egg:*region-end*)
      (fence-exit-mode)))

(defun fence-delete-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (progn
	(delete-char 1)
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-backward-delete-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (progn
	(delete-char -1)
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-kill-line ()
  (interactive)
  (delete-region (point) egg:*region-end*)
  (egg:exit-if-empty-region))

(defun fence-exit-mode ()
  (interactive)
  (delete-region (- egg:*region-start* (length egg:*fence-open*)) egg:*region-start*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*fence-close*)))
  (egg:fence-attribute-off)
  (egg:quit-egg-mode))

(defvar egg-insert-after-hook nil)
(make-variable-buffer-local 'egg-insert-after-hook)

(defvar egg-exit-hook nil
  "Hook to run when egg exits. Should take two arguments START and END
correspoding to character position.")

(defun egg:quit-egg-mode ()
  ;;;(use-global-map egg:*global-map-backup*)
  (use-local-map egg:*local-map-backup*)
  (setq egg:*in-fence-mode* nil)
  (egg:mode-line-display)
  (if overwrite-mode
      (let ((length (- egg:*region-end* egg:*region-start*))
	    (rest (- (save-excursion (end-of-line) (point))
		     egg:*region-end*)))
	(kanji-delete-region egg:*region-end*
			     (+ egg:*region-end* (min rest length)))
	))
       
  (if self-insert-after-hook
      (funcall self-insert-after-hook egg:*region-start* egg:*region-end*)
    (if egg-exit-hook
	(funcall egg-exit-hook egg:*region-start* egg:*region-end*)
      (if (not (= egg:*region-start* egg:*region-end*))
	  (egg:do-auto-fill))))
  (set-marker egg:*region-start* nil)
  (set-marker egg:*region-end*   nil)
  ;;;(buffer-enable-undo)
  ;;;(undo-boundary)
  (and (boundp 'disable-undo) (setq disable-undo nil))
  (if egg-insert-after-hook
      (run-hooks 'egg-insert-after-hook))
  )

(defun fence-cancel-input ()
  (interactive)
  (delete-region egg:*region-start* egg:*region-end*)
  (fence-exit-mode))

(defvar fence-mode-map (make-keymap))

(defvar fence-mode-esc-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset fence-mode-map ch 'undefined)
    (aset fence-mode-esc-map ch 'undefined)
    (setq ch (1+ ch))))

(let ((ch 32))
  (while (< ch 127)
    (aset fence-mode-map ch 'fence-self-insert-command)
    (setq ch (1+ ch))))

(define-key fence-mode-map "\e"   fence-mode-esc-map)
(define-key fence-mode-map "\eh"  'fence-hiragana)
(define-key fence-mode-map "\ek"  'fence-katakana)
(define-key fence-mode-map "\e<"  'fence-hankaku)
(define-key fence-mode-map "\e>"  'fence-zenkaku)
(define-key fence-mode-map " "    'henkan-fence-region-or-single-space)
(define-key fence-mode-map "\C-@" 'henkan-fence-region)
(define-key fence-mode-map "\C-a" 'fence-beginning-of-line)
(define-key fence-mode-map "\C-b" 'fence-backward-char)
(define-key fence-mode-map "\C-c" 'fence-cancel-input)
(define-key fence-mode-map "\C-d" 'fence-delete-char)
(define-key fence-mode-map "\C-e" 'fence-end-of-line)
(define-key fence-mode-map "\C-f" 'fence-forward-char)
(define-key fence-mode-map "\C-g" 'fence-cancel-input)
(define-key fence-mode-map "\C-h" 'help-command)
(define-key fence-mode-map "\C-i" 'undefined)  
(define-key fence-mode-map "\C-j" 'undefined)  ;;; LFD
(define-key fence-mode-map "\C-k" 'fence-kill-line)
(define-key fence-mode-map "\C-l" 'fence-exit-mode)
(define-key fence-mode-map "\C-m" 'fence-exit-mode)  ;;; RET
(define-key fence-mode-map "\C-n" 'undefined)
(define-key fence-mode-map "\C-o" 'undefined)
(define-key fence-mode-map "\C-p" 'undefined)
(define-key fence-mode-map "\C-q" 'undefined)
(define-key fence-mode-map "\C-r" 'undefined)
(define-key fence-mode-map "\C-s" 'undefined)
(define-key fence-mode-map "\C-t" 'fence-transpose-chars)
(define-key fence-mode-map "\C-u" 'undefined)
(define-key fence-mode-map "\C-v" 'undefined)
(define-key fence-mode-map "\C-w" 'henkan-fence-region)
(define-key fence-mode-map "\C-x" 'undefined)
(define-key fence-mode-map "\C-y" 'undefined)
(define-key fence-mode-map "\C-z" 'eval-expression)
(define-key fence-mode-map "\C-|" 'fence-toggle-egg-mode)
(define-key fence-mode-map "\C-_" 'jis-code-input)
(define-key fence-mode-map "\177" 'fence-backward-delete-char)

;;;----------------------------------------------------------------------
;;;
;;; Read hiragana from minibuffer
;;;
;;;----------------------------------------------------------------------

(defvar egg:*minibuffer-local-hiragana-map* (copy-keymap minibuffer-local-map))

(let ((ch 32))
  (while (< ch 127)
    (define-key egg:*minibuffer-local-hiragana-map*
      (make-string 1 ch) 'fence-self-insert-command)
    (setq ch (1+ ch))))

(defun read-hiragana-string (prompt &optional initial-input)
  (save-excursion
    (let ((minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (let ((egg:*input-mode* t)
	    (egg:*current-map* (egg:get-mode-map "roma-kana")))
	(read-from-minibuffer prompt initial-input
			      egg:*minibuffer-local-hiragana-map*)))))

;;;----------------------------------------------------------------------
;;;
;;; KKCP package: Kana Kanji Conversion Protocol
;;;
;;; KKCP to JSERVER interface; 
;;;
;;;----------------------------------------------------------------------

(defvar *KKCP:error-flag* t)

(defun KKCP:error (errorCode &rest form)
  (cond((eq errorCode ':WNN_SOCK_OPEN_FAIL)
	(notify "EGG: %s ��� WNN ������ޤ���" (or (get-wnn-host-name) "local"))
	(if debug-on-error
	    (error "EGG: No WNN on %s is running." (or (get-wnn-host-name) "local"))
	  (error  "EGG: %s ��� WNN ������ޤ���" (or (get-wnn-host-name) "local"))))
       ((eq errorCode ':WNN_JSERVER_DEAD)
	(notify "EGG: %s ���WNN �����Ǥ��ޤ���" (or (get-wnn-host-name) "local"))
	(if debug-on-error
	    (error "EGG: WNN on %s is dead." (or (get-wnn-host-name) "local"))
	  (error  "EGG: %s ��� WNN �����Ǥ��ޤ���" (or (get-wnn-host-name) "local"))))
       ((and (consp errorCode)
	     (eq (car errorCode) ':WNN_UNKNOWN_HOST))
	(notify "EGG: �ۥ��� %s ���ߤĤ���ޤ���" (car(cdr errorCode)))
	(if debug-on-error
	    (error "EGG: Host %s is unknown." (car(cdr errorCode)))
	  (error "EGG: �ۥ��� %s ���ߤĤ���ޤ���" (car(cdr errorCode)))))
       ((and (consp errorCode)
	     (eq (car errorCode) ':WNN_UNKNOWN_SERVICE))
	(notify "EGG: Network service %s ���ߤĤ���ޤ���" (car(cdr errorCode)))
	(if debug-on-error
	    (error "EGG: Service %s is unknown." (car(cdr errorCode)))
	  (error "EGG: Network service %s ���ߤĤ���ޤ���" (cdr errorCode))))
       (t
	(notify "KKCP: ���� %s �� %s �˼��Ԥ��ޤ�����" errorCode form)
	(if debug-on-error
	    (error "KKCP: %s failed because of %s." form errorCode)
	  (error  "KKCP: ���� %s �� %s �˼��Ԥ��ޤ�����" errorCode form)))))

(defun KKCP:server-open (hostname loginname)
  (let ((result (wnn-server-open hostname loginname)))
    (cond((null wnn-error-code) result)
	 (t (KKCP:error wnn-error-code 'KKCP:server-open hostname loginname)))))

(defun KKCP:use-dict (dict hindo priority file-mode)
  (let ((result (wnn-server-use-dict dict hindo  priority file-mode)))
    (cond((null wnn-error-code) result)
	 ((eq wnn-error-code ':wnn-no-connection)
	  (EGG:open-wnn)
	  (KKCP:use-dict dict hindo priority file-mode))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error wnn-error-code 
			'kkcp:use-dict dict hindo priority file-mode)))))

(defun KKCP:henkan-begin (henkan-string)
  (let ((result (wnn-server-henkan-begin henkan-string)))
    (cond((null wnn-error-code) result)
	 ((eq wnn-error-code ':wnn-no-connection)
	  (EGG:open-wnn)
	  (KKCP:henkan-begin henkan-string))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error wnn-error-code 'KKCP:henkan-begin henkan-string)))))

(defun KKCP:henkan-next (bunsetu-no)
  (let ((result (wnn-server-henkan-next bunsetu-no)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:henkan-next bunsetu-no))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:henkan-next bunsetu-no)))))

(defun KKCP:henkan-inspect (bunsetu-no jikouho-no)
  (let ((result (wnn-bunsetu-kouho-inspect bunsetu-no jikouho-no)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:henkan-inspect bunsetu-no jikouho-no))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 
			 'KKCP:henkan-inspect bunsetu-no jikouho-no)))))

(defun KKCP:henkan-kakutei (bunsetu-no jikouho-no)
  ;;; NOTE: ������ꥹ�Ȥ����ꤵ��Ƥ��뤳�Ȥ��ǧ���ƻ��Ѥ��뤳�ȡ�
  (let ((result (wnn-server-henkan-kakutei bunsetu-no jikouho-no)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:henkan-kakutei bunsetu-no jikouho-no))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:henkan-kakutei bunsetu-no jikouho-no)))))

(defun KKCP:bunsetu-henkou (bunsetu-no bunsetu-length)
  (let ((result (wnn-server-bunsetu-henkou bunsetu-no bunsetu-length)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:bunsetu-henkou bunsetu-no bunsetu-length))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'kkcp:bunsetu-henkou bunsetu-no bunsetu-length)))))


(defun KKCP:henkan-quit ()
  (let ((result (wnn-server-henkan-quit)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:henkan-quit))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:henkan-quit)))))

(defun KKCP:henkan-end (&optional bunsetuno)
  (let ((result (wnn-server-henkan-end bunsetuno)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:henkan-end bunsetuno))	  
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:henkan-end)))))

(defun KKCP:set-current-dict (dict-no)
  (let ((result (wnn-server-set-current-dict dict-no)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:set-current-dict dict-no))	  
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'kkcp:set-current-dict dict-no)))))

(defun KKCP:dict-add (kanji yomi bunpo)
  (let ((result (wnn-server-dict-add kanji yomi bunpo)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:dict-add kanji yomi bunpo))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:dict-add kanji yomi bunpo)))))

(defun KKCP:dict-delete (serial-no yomi)
  (let ((result (wnn-server-dict-delete serial-no yomi)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:dict-delete serial-no yomi))	  
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:dict-delete serial-no yomi)))))

(defun KKCP:dict-info (yomi)
  (let ((result (wnn-server-dict-info yomi)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:dict-info yomi))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:dict-info yomi)))))

(defun KKCP:make-directory (pathname)
  (let ((result (wnn-server-make-directory pathname)))
    (cond ((null wnn-error-code) result)
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:make-directory pathname))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'kkcp:make-directory pathname)))))

(defun KKCP:file-access (pathname mode)
  (let ((result (wnn-server-file-access pathname mode)))
    (cond ((null wnn-error-code)
	   (if (= result 0) t nil))
	  ((eq wnn-error-code ':wnn-no-connection)
	   (EGG:open-wnn)
	   (KKCP:file-access pathname mode))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'kkcp:file-access pathname mode)))))

(defun KKCP:server-close ()
  (let ((result (wnn-server-close)))
    (cond ((null wnn-error-code) result)
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error wnn-error-code 'KKCP:server-close)))))

;;;----------------------------------------------------------------------
;;;
;;; Kana Kanji Henkan 
;;;
;;;----------------------------------------------------------------------

;;;
;;; Entry functions for egg-startup-file
;;;

(defvar *default-sys-dic-directory* "~/")

(defun set-default-sys-dic-directory (pathname)
  "�����ƥ༭���ɸ��directory PATHNAME����ꤹ�롣
PATHNAME�ϴĶ��ѿ���ޤ�Ǥ褤��"

  (setq pathname (substitute-in-file-name pathname))

  (if (not (file-name-absolute-p pathname))
      (error "Default directory must be absolute pathname")
    (if (null (KKCP:file-access pathname 0))
	(error 
	 (format "System Default directory(%s) ������ޤ���" pathname))
      (setq *default-sys-dic-directory* (file-name-as-directory pathname)))))

(defvar *default-usr-dic-directory* "~/")

(defun set-default-usr-dic-directory (pathname)
  "���ѼԼ����ɸ��directory PATHNAME����ꤹ�롣
PATHNAME�ϴĶ��ѿ���ޤ�Ǥ褤��"

  (setq pathname (file-name-as-directory (substitute-in-file-name pathname)))

  (if (not (file-name-absolute-p pathname))
      (error "Default directory must be absolute pathname")
    (if (null (KKCP:file-access  pathname 0))
	(let ((updir (file-name-directory (substring pathname 0 -1))))
	  (if (null (KKCP:file-access updir 0))
	      (error 
	       (format "User Default directory(%s) ������ޤ���" pathname))
	    (if (yes-or-no-p (format "User Default directory(%s) ����ޤ�����" pathname))
		(progn
		  (KKCP:make-directory pathname)
		  (notify "User Default directory(%s) ����ޤ�����" pathname))
	      nil ;;; do nothing
	      ))))
      (setq *default-usr-dic-directory* pathname)))

(defun setsysdic (dict hindo priority &optional noextend)
  (let ((dictfile
	 (concat (if (not (file-name-absolute-p dict)) 
		     *default-sys-dic-directory*
		   "")
		 dict
		 (if noextend "" ".sys")))
	(hindofile
	 (concat (if (not (file-name-absolute-p dict)) 
		     *default-usr-dic-directory*
		   "")
		 hindo
		 (if noextend "" ".hindo"))))
    (egg:setsysdict (expand-file-name dictfile)
		    (expand-file-name hindofile)
		    priority)))

(defun setusrdic (dict priority &optional noextend)
  (let ((dictfile
	 (concat (if (not (file-name-absolute-p dict))
		     *default-usr-dic-directory*
		   "")
		 dict 
		 (if noextend ""  ".usr")
		 )))
  (egg:setusrdict (expand-file-name dictfile)
		  priority)))

(defvar egg:*dict-list* nil)

;;; dict-no --> dict-name
(defvar egg:*sys-dict* nil)

(defun egg:setsysdict (dict hindo priority)
  (cond((assoc (file-name-nondirectory dict) egg:*dict-list*)
	(beep)
	(notify "����Ʊ̾�Υ����ƥ༭�� %s ����Ͽ����Ƥ��ޤ���"
		(file-name-nondirectory dict))
	)
       ((null (KKCP:file-access dict 0))
	(beep)
	(notify "�����ƥ༭�� %s ������ޤ���" dict))
       ((null (KKCP:file-access hindo 0))
	(notify "���٥ե����� %s ������ޤ���" hindo)
	(if (yes-or-no-p 
	     (format "���٥ե����� %s ����ޤ�����" hindo))
	    (let* ((*KKCP:error-flag* nil)
		   (rc (KKCP:use-dict dict hindo priority nil)))
	      (if rc (progn
		       (notify "���٥ե����� %s ����ޤ�����" hindo)
		       (setq egg:*sys-dict* (cons (cons rc dict) egg:*sys-dict*)))
		(error "EGG: setsysdict failed.: %s" hindo)))))
       (t(let* ((*KKCP:error-flag* nil)
		(rc (KKCP:use-dict dict hindo priority nil)))
	   (if (null rc)
	       (error "EGG: setsysdict failed. :%s" dict)
	     (progn
	       (setq egg:*sys-dict* (cons (cons rc dict) egg:*sys-dict*))
	       (setq egg:*dict-list*
		     (cons (cons (file-name-nondirectory dict) dict)
			   egg:*dict-list*))))))))

;;; dict-no --> dict-name
(defvar egg:*usr-dict* nil)

;;; dict-name --> dict-no
(defvar egg:*dict-menu* nil)

(defmacro push-end (val loc)
  (list 'push-end-internal val (list 'quote loc)))

(defun push-end-internal (val loc)
  (set loc
       (if (eval loc)
	   (nconc (eval loc) (cons val nil))
	 (cons val nil))))

(defun egg:setusrdict (dict priority)
  (cond((assoc (file-name-nondirectory dict) egg:*dict-list*)
	(beep)
	(notify "����Ʊ̾�����ѼԼ��� %s ����Ͽ����Ƥ��ޤ���"
		(file-name-nondirectory dict))
	)
       ((null (KKCP:file-access dict 0))
	(notify "���ѼԼ��� %s ������ޤ���" dict)
	(if (yes-or-no-p (format "���ѼԼ��� %s ����ޤ�����" dict))
	    (let* ((*KKCP:error-flag* nil)
		   (dict-no (KKCP:use-dict dict "" priority nil)))
	      (if (numberp dict-no)
		  (progn
		    (notify "���ѼԼ��� %s ����ޤ�����" dict)
		    (setq egg:*usr-dict* 
			  (cons (cons dict-no dict) egg:*usr-dict*))
		    (push-end (cons (file-name-nondirectory dict) dict-no)
			      egg:*dict-menu*))
		(error "EGG: setusrdict failed. : %s" dict)))))
       (t (let* ((*KKCP:error-flag* nil)
		 (dict-no (KKCP:use-dict dict "" priority nil)))
	    (cond((numberp dict-no)
		  (setq egg:*usr-dict* (cons(cons dict-no dict) 
					    egg:*usr-dict*))
		  (push-end (cons (file-name-nondirectory dict) dict-no)
			    egg:*dict-menu*)
		  (setq egg:*dict-list*
			(cons (cons (file-name-nondirectory dict) dict)
			      egg:*dict-list*)))
		 (t (error "EGG: setusrdict failed. : %s" dict)))))))


;;;
;;; WNN interface
;;;

(defun get-wnn-host-name ()
  (cond((and (boundp 'wnn-host-name) (stringp wnn-host-name))
	wnn-host-name)
       ((and (boundp 'jserver-host-name) (stringp jserver-host-name))
	jserver-host-name)
       (t(getenv "JSERVER"))))

(fset 'get-jserver-host-name (symbol-function 'get-wnn-host-name))

(defun set-wnn-host-name (name)
  (interactive "sHost name: ")
  (let ((*KKCP:error-flag* nil))
    (disconnect-wnn))
  (setq wnn-host-name name)
  )

(defvar egg-default-startup-file "eggrc"
  "*Egg startup file name (system default)")

(defvar egg-startup-file ".eggrc"
  "*Egg startup file name.")

(defvar egg-startup-file-search-path (append '("~" ".") load-path)
  "*List of directories to search for start up file to load.")

(defun egg:search-file (filename searchpath)
  (let ((result nil))
    (if (null (file-name-directory filename))
	(let ((path searchpath))
	  (while (and path (null result ))
	    (let ((file (substitute-in-file-name
			 (expand-file-name filename (if (stringp (car path)) (car path) nil)))))
	      (if (file-exists-p file) (setq result file)
		(setq path (cdr path))))))
      (let((file (substitute-in-file-name (expand-file-name filename))))
	(if (file-exists-p file) (setq result file))))
    result))

(defun EGG:open-wnn ()
  (KKCP:server-open (or (get-wnn-host-name) (system-name))
  		    (user-login-name))
  (setq egg:*sys-dict* nil
	egg:*usr-dict* nil
	egg:*dict-list* nil
	egg:*dict-menu* nil)
  (notify "�ۥ��� %s �� WNN ��ư���ޤ�����" (or (get-wnn-host-name) "local"))
  (let ((eggrc (or (egg:search-file egg-startup-file egg-startup-file-search-path)
		   (egg:search-file egg-default-startup-file load-path))))
    (if eggrc (load-file eggrc)
      (progn
	(KKCP:server-close)
	(error "eggrc-search-path ��� egg-startup-file ������ޤ���")))))

(defun disconnect-wnn ()
  (interactive)
  (KKCP:server-close))

(defun close-wnn ()
  (interactive)
  (if (wnn-server-active-p)
      (progn (wnn-server-dict-save)
	     (message "Wnn�����پ��󡦼����������򤷤ޤ�����")
	     (sit-for 0)))
  (KKCP:server-close))

;;;
;;; Kanji henkan
;;;

(defvar egg:*kanji-kanabuff* nil)

(defvar *bunsetu-number* nil)

(defun bunsetu-su ()
  (wnn-bunsetu-suu))

(defun bunsetu-length (number)
  (wnn-bunsetu-yomi-moji-suu number))

(defun kanji-moji-suu (str)
  (let ((max (length str)) (count 0) (i 0))
    (while (< i max)
      (setq count (1+ count))
      (if (< (aref str i) 128) (setq i (1+ i)) (setq i (+ i 2))))
    count))

(defun bunsetu-position (number)
  (let ((pos egg:*region-start*) (i 0))
    (while (< i number)
      (setq pos (+ pos (bunsetu-kanji-length  i) (length egg:*bunsetu-kugiri*)))
      (setq i (1+ i)))
    pos))

(defun bunsetu-kanji-length (bunsetu-no)
  (wnn-bunsetu-kanji-length bunsetu-no))

(defun bunsetu-kanji (number)
  (wnn-bunsetu-kanji number))

(defun bunsetu-kanji-insert (bunsetu-no)
  (wnn-bunsetu-kanji bunsetu-no (current-buffer)))

(defun bunsetu-set-kanji (bunsetu-no kouho-no) 
  (wnn-server-henkan-kakutei bunsetu-no kouho-no))

(defun bunsetu-yomi  (number) 
  (wnn-bunsetu-yomi number))

(defun bunsetu-yomi-insert (bunsetu-no)
  (wnn-bunsetu-yomi bunsetu-no (current-buffer)))

(defun bunsetu-yomi-equal (number yomi)
  (wnn-bunsetu-yomi-equal number yomi))

(defun bunsetu-kouho-suu (bunsetu-no)
  (let ((no (wnn-bunsetu-kouho-suu bunsetu-no)))
    (if (< 1 no) no
      (KKCP:henkan-next bunsetu-no)
      (wnn-bunsetu-kouho-suu bunsetu-no))))

(defun bunsetu-kouho-list (number) 
  (let ((no (bunsetu-kouho-suu number)))
    (if (= no 1)
	(KKCP:henkan-next number))
    (wnn-bunsetu-kouho-list number)))

(defun bunsetu-kouho-number (bunsetu-no)
  (wnn-bunsetu-kouho-number bunsetu-no))

;;;;
;;;; User entry : henkan-region, henkan-paragraph, henkan-sentence
;;;;

(defun egg:henkan-attribute-on ()
  (egg:set-region-attribute egg:*henkan-attribute* t))

(defun egg:henkan-attribute-off ()
  (egg:set-region-attribute egg:*henkan-attribute* nil))

(defun henkan-region (start end)
  (interactive "r")
  (if (interactive-p) (set-mark (point))) ;;; to be fixed
  (henkan-region-internal start end))

(defvar henkan-mode-indicator "����")

(defun henkan-region-internal (start end)
  "region�򤫤ʴ����Ѵ����롣"
  (setq egg:*kanji-kanabuff* (buffer-substring start end))
  (setq *bunsetu-number* nil)
  (let ((result (KKCP:henkan-begin egg:*kanji-kanabuff*)))
    (if  result
	(progn
	  (mode-line-egg-mode-update henkan-mode-indicator)
	  (goto-char start)
	  (if (null (marker-position egg:*region-start*))
	      (progn
		;;;(setq egg:*global-map-backup* (current-global-map))
		(setq egg:*local-map-backup* (current-local-map))
		(and (boundp 'disable-undo) (setq disable-undo t))
		(goto-char start)
		(delete-region start end)
		(insert egg:*henkan-open*)
		(set-marker egg:*region-start* (point))
		(insert egg:*henkan-close*)
		(set-marker egg:*region-end* egg:*region-start*)
		(egg:henkan-attribute-on)
		(goto-char egg:*region-start*)
		)
	    (progn
	      (egg:fence-attribute-off)
	      (delete-region (- egg:*region-start* (length egg:*fence-open*)) 
			     egg:*region-start*)
	      (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*fence-close*)))
	      (goto-char egg:*region-start*)
	      (insert egg:*henkan-open*)
	      (set-marker egg:*region-start* (point))
	      (goto-char egg:*region-end*)
	      (let ((point (point)))
		(insert egg:*henkan-close*)
		(set-marker egg:*region-end* point))
	      (goto-char start)
	      (delete-region start end)
	      (egg:henkan-attribute-on))
	    )
	  (henkan-insert-kouho 0)
	  (henkan-goto-bunsetu 0)
	  ;;;(use-global-map henkan-mode-map)
	  ;;;(use-local-map nil)
	  (use-local-map henkan-mode-map)
	  )))
  )

(defun henkan-paragraph ()
  "Kana-kanji henkan  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (henkan-region-internal (point) end ))))

(defun henkan-sentence ()
  "Kana-kanji henkan sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (henkan-region-internal (point) end ))))

;;;
;;; Kana Kanji Henkan Henshuu mode
;;;

(defconst egg:*bunsetu-kugiri* " " "*ʸ��ζ��ڤ�򼨤�ʸ����")
(defconst egg:*bunsetu-attribute* nil "*ʸ��ɽ�����Ѥ���attribute �ޤ��� nil")

(defconst egg:*henkan-attribute* nil "*�Ѵ��ΰ��ɽ������attribute �ޤ��� nil")
(defconst egg:*henkan-open*  "|" "*�Ѵ��λ����򼨤�ʸ����")
(defconst egg:*henkan-close* "|" "*�Ѵ��ν����򼨤�ʸ����")

(defun set-egg-henkan-mode-format (open close kugiri &optional attr1 attr2)
   "�Ѵ� mode ��ɽ����ˡ�����ꤹ�롣OPEN ���Ѵ��λ����򼨤�ʸ����ޤ��� nil��\n\
CLOSE���Ѵ��ν����򼨤�ʸ����ޤ��� nil��\n\
KUGIRI��ʸ��ζ��ڤ��ɽ������ʸ����ޤ��� nil��\n\
optional ATTR1 ���Ѵ���֤�ɽ������°�� �ޤ��� nil��x11term �Τߤ�ͭ����\n\
optional ATTR2 ��ʸ���֤�ɽ������°�� �ޤ��� nil��x11term �Τߤ�ͭ����"

  (interactive (list (read-string "�Ѵ�����ʸ����: ")
		     (read-string "�Ѵ���λʸ����: ")
		     (read-string "ʸ����ڤ�ʸ����: ")
		     (cdr (assoc (completing-read "�Ѵ����ɽ��°��: " egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     (cdr (assoc (completing-read "ʸ����ɽ��°��: " egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     ))

  (if (and (or (stringp open)  (null open))
	   (or (stringp close) (null close))
	   (or (stringp kugiri) (null kugiri))
	   (egg:member attr1 '(underline inverse nil))
	   (egg:member attr2 '(underline inverse nil)))
      (progn
	(setq egg:*henkan-open* open
	      egg:*henkan-close* close
	      egg:*bunsetu-kugiri* (or kugiri "")
	      egg:*henkan-attribute* attr1
	      egg:*bunsetu-attribute* attr2)
	(if (or attr1 attr2) (require 'attribute))
	nil)
    (error "Wrong type of arguments: %1 %2 %3 %4 %5" open close kugiri attr1 attr2)))

(defun henkan-insert-kouho (bunsetu-no)
  (let ((max (bunsetu-su)) (i bunsetu-no))
    (while (< i max)
      (bunsetu-kanji-insert i) 
      (insert  egg:*bunsetu-kugiri* )
      (setq i (1+ i)))
    (if (< bunsetu-no max) (delete-char (- (length egg:*bunsetu-kugiri*))))))

(defun henkan-kakutei ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (let ((i 0) (max (bunsetu-su)))
    (while (< i max)
      ;;;(KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (bunsetu-kanji-insert i)
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (KKCP:henkan-end)
  (egg:quit-egg-mode)
  )

(defun henkan-kakutei-before-point ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region egg:*region-start* egg:*region-end*)
  (goto-char egg:*region-start*)
  (let ((i 0) (max *bunsetu-number*))
    (while (< i max)
      ;;;(KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (bunsetu-kanji-insert i)
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (KKCP:henkan-end *bunsetu-number*)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-end*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point))
  (goto-char egg:*region-start*)
  (egg:fence-attribute-on)
  (let ((point (point))
	(i *bunsetu-number*) (max (bunsetu-su)))
    (while (< i max)
      (bunsetu-yomi-insert i)
      (setq i (1+ i)))
    ;;;(insert "|")
    ;;;(insert egg:*fence-close*)
    ;;;(set-marker egg:*region-end* (point))
    (goto-char point))
  (setq egg:*mode-on* t)
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map  nil)
  (use-local-map fence-mode-map)
  (egg:mode-line-display))

(defun egg:set-region-attribute (attr on)
  (if attr 
      (attribute-on-off-region attr egg:*region-start* egg:*region-end* on)))

(defun egg:set-bunsetu-attribute (no attr switch)
  (if (and no attr)
      (attribute-on-off-region
       attr
       (if (eq attr 'inverse)
	   (let ((point (bunsetu-position no)))
	     (+ point
		(if (<=  128
			 (char-after (if (markerp point)
					 (marker-position point) 
				       point)))
		    2 1)))
	 (bunsetu-position no))

       (if (= no (1- (bunsetu-su)))
	   egg:*region-end*
	 (- (bunsetu-position (1+ no))
	    (length egg:*bunsetu-kugiri*)))
       switch)))

(defun egg:bunsetu-attribute-on (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute* t))

(defun egg:bunsetu-attribute-off (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute* nil))

(defun henkan-goto-bunsetu (number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-on)
  (setq *bunsetu-number*
	(check-number-range number 0 (1- (bunsetu-su))))
  (goto-char (bunsetu-position *bunsetu-number*))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
  (egg:bunsetu-attribute-on *bunsetu-number*)
  )

(defun henkan-forward-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1+ *bunsetu-number*))
  )

(defun henkan-backward-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1- *bunsetu-number*))
  )

(defun henkan-first-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu 0))

(defun henkan-last-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1- (bunsetu-su)))
  )
 
(defun check-number-range (i min max)
  (cond((< i min) max)
       ((< max i) min)
       (t i)))

(defun henkan-hiragana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number*) 1)))

(defun henkan-katakana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number*) 2)))

(defun henkan-next-kouho ()
  (interactive)
  (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number*))))

(defun henkan-previous-kouho ()
  (interactive)
  (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number*))))

(defun henkan-goto-kouho (kouho-number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-on)
  (let ((point (point))
	(yomi  (bunsetu-yomi *bunsetu-number*))
	(i *bunsetu-number*)
	(max (bunsetu-su)))
    (setq kouho-number 
	  (check-number-range kouho-number 
			      0
			      (1- (bunsetu-kouho-suu *bunsetu-number*))))
    (while (< i max)
      (if (bunsetu-yomi-equal i yomi)
	  (let ((p1 (bunsetu-position i)))
	    (delete-region p1
			   (+ p1 (bunsetu-kanji-length i)))
	    (goto-char p1)
	    (bunsetu-set-kanji i kouho-number)
	    (bunsetu-kanji-insert i)))
      (setq i (1+ i)))
    (goto-char point))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
  (egg:bunsetu-attribute-on *bunsetu-number*))

(defun henkan-bunsetu-chijime ()
  (interactive)
  (or (= (bunsetu-length *bunsetu-number*) 1)
      (bunsetu-length-henko (1-  (bunsetu-length *bunsetu-number*)))))

(defun henkan-bunsetu-nobasi ()
  (interactive)
  (if (not (= (1+ *bunsetu-number*) (bunsetu-su)))
      (bunsetu-length-henko (1+ (bunsetu-length *bunsetu-number*)))))

(defun henkan-saishou-bunsetu ()
  (interactive)
  (bunsetu-length-henko 1))

(defun henkan-saichou-bunsetu ()
  (interactive)
  (let ((max (bunsetu-su)) (i *bunsetu-number*)
	(l 0))
    (while (< i max)
      (setq l (+ l (bunsetu-length i)))
      (setq i (1+ i)))
    (bunsetu-length-henko l)))

(defun bunsetu-length-henko (length)
  (egg:henkan-attribute-off)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (let ((r (KKCP:bunsetu-henkou *bunsetu-number* length)))
    (cond(r
	  (delete-region 
	   (bunsetu-position *bunsetu-number*) egg:*region-end*)
	  (goto-char (bunsetu-position *bunsetu-number*))
	  (henkan-insert-kouho *bunsetu-number*)
	  (henkan-goto-bunsetu *bunsetu-number*))
	 (t
	  (egg:henkan-attribute-on)
	  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
	  (egg:bunsetu-attribute-on *bunsetu-number*)))))

(defun henkan-quit ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (insert egg:*kanji-kanabuff*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point)
    )
  (goto-char egg:*region-end*)
  (egg:fence-attribute-on)
  (KKCP:henkan-quit)
  (setq egg:*mode-on* t)
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map  nil)
  (use-local-map fence-mode-map)
  (egg:mode-line-display)
  )

(defun henkan-select-kouho ()
  (interactive)
  (if (not (eq (selected-window) (minibuffer-window)))
      (let ((kouho-list (bunsetu-kouho-list *bunsetu-number*))
	    menu)
	(setq menu
	      (list 'menu "������:"
		    (let ((l kouho-list) (r nil) (i 0))
		      (while l
			(setq r (cons (cons (car l) i) r))
			(setq i (1+ i))
			(setq l (cdr l)))
		      (reverse r))))
	(henkan-goto-kouho 
	 (menu:select-from-menu menu 
			       (bunsetu-kouho-number *bunsetu-number*))))
    (beep)))

(defun henkan-kakutei-and-self-insert ()
  (interactive)
  (setq unread-command-char last-command-char)
  (henkan-kakutei))


(defvar henkan-mode-map (make-keymap))

(defvar henkan-mode-esc-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset henkan-mode-map ch 'undefined)
    (aset henkan-mode-esc-map ch 'undefined)
    (setq ch (1+ ch))))

(let ((ch 32))
  (while (< ch 127)
    (aset henkan-mode-map ch 'henkan-kakutei-and-self-insert)
    (setq ch (1+ ch))))
	
(define-key henkan-mode-map "\e"    henkan-mode-esc-map)
(define-key henkan-mode-map "\ei"  'henkan-inspect-bunsetu)
(define-key henkan-mode-map "\es"  'henkan-select-kouho)
(define-key henkan-mode-map "\eh"  'henkan-hiragana)
(define-key henkan-mode-map "\ek"  'henkan-katakana)
(define-key henkan-mode-map "\e<"  'henkan-saishou-bunsetu)
(define-key henkan-mode-map "\e>"  'henkan-saichou-bunsetu)
(define-key henkan-mode-map " "    'henkan-next-kouho)
(define-key henkan-mode-map "\C-@" 'henkan-next-kouho)
(define-key henkan-mode-map "\C-a" 'henkan-first-bunsetu)
(define-key henkan-mode-map "\C-b" 'henkan-backward-bunsetu)
(define-key henkan-mode-map "\C-c" 'henkan-quit)
(define-key henkan-mode-map "\C-d" 'undefined)
(define-key henkan-mode-map "\C-e" 'henkan-last-bunsetu)
(define-key henkan-mode-map "\C-f" 'henkan-forward-bunsetu)
(define-key henkan-mode-map "\C-g" 'henkan-quit)
(define-key henkan-mode-map "\C-h" 'help-command)
(define-key henkan-mode-map "\C-i" 'henkan-bunsetu-chijime)
(define-key henkan-mode-map "\C-j" 'undefined)
(define-key henkan-mode-map "\C-k" 'henkan-kakutei-before-point)
(define-key henkan-mode-map "\C-l" 'henkan-kakutei)
(define-key henkan-mode-map "\C-m" 'henkan-kakutei)
(define-key henkan-mode-map "\C-n" 'henkan-next-kouho)
(define-key henkan-mode-map "\C-o" 'henkan-bunsetu-nobasi)
(define-key henkan-mode-map "\C-p" 'henkan-previous-kouho)
(define-key henkan-mode-map "\C-q" 'undefined)
(define-key henkan-mode-map "\C-r" 'undefined)
(define-key henkan-mode-map "\C-s" 'undefined)
(define-key henkan-mode-map "\C-t" 'undefined)
(define-key henkan-mode-map "\C-u" 'undefined)
(define-key henkan-mode-map "\C-v" 'undefined)
(define-key henkan-mode-map "\C-w" 'undefined)
(define-key henkan-mode-map "\C-x" 'undefined)
(define-key henkan-mode-map "\C-y" 'undefined)
(define-key henkan-mode-map "\C-z" 'undefined)
(define-key henkan-mode-map "\177" 'henkan-quit)

(defun henkan-help-command ()
  "Display documentation fo henkan-mode."
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ (substitute-command-keys henkan-mode-document-string))
    (print-help-return-message)))

(defvar henkan-mode-document-string "�����Ѵ��⡼��:
ʸ���ư
  \\[henkan-first-bunsetu]\t��Ƭʸ��\t\\[henkan-last-bunsetu]\t����ʸ��  
  \\[henkan-backward-bunsetu]\tľ��ʸ��\t\\[henkan-forward-bunsetu]\tľ��ʸ��
�Ѵ��ѹ�
  ������    \\[henkan-previous-kouho]  \t������    \\[henkan-next-kouho]
  ʸ�῭��  \\[henkan-bunsetu-nobasi]  \tʸ��̤�  \\[henkan-bunsetu-chijime]
  �Ѵ���������  \\[henkan-select-kouho]
�Ѵ�����
  ��ʸ�����  \\[henkan-kakutei]  \tľ��ʸ��ޤǳ���  \\[henkan-kakutei-before-point]
�Ѵ����    \\[henkan-quit]
")
  

;;;----------------------------------------------------------------------
;;;
;;; Dictionary management Facility
;;;
;;;----------------------------------------------------------------------

;;;
;;; ������Ͽ 
;;;

;;;;
;;;; User entry: toroku-region
;;;;

(defun remove-regexp-in-string (regexp string)
  (cond((not(string-match regexp string))
	string)
       (t(let ((str nil)
	     (ostart 0)
	     (oend   (match-beginning 0))
	     (nstart (match-end 0)))
	 (setq str (concat str (substring string ostart oend)))
	 (while (string-match regexp string nstart)
	   (setq ostart nstart)
	   (setq oend   (match-beginning 0))
	   (setq nstart (match-end 0))
	   (setq str (concat str (substring string ostart oend))))
	 str))))

(defun toroku-region (start end)
  (interactive "r")
  (let*((kanji
	 (remove-regexp-in-string "[\0-\37]" (buffer-substring start end)))
	(yomi (read-hiragana-string
	       (format "������Ͽ��%s��  �ɤ� :" kanji)))
	(type (menu:select-from-menu *bunpo-menu*))
	(dict-no 
	 (menu:select-from-menu (list 'menu "��Ͽ����̾:" egg:*dict-menu*))))
    ;;;(if (string-match "[\0-\177]" kanji)
    ;;;	(error "Kanji string contains hankaku character. %s" kanji))
    ;;;(if (string-match "[\0-\177]" yomi)
    ;;;	(error "Yomi string contains hankaku character. %s" yomi))
    (KKCP:set-current-dict dict-no)
    (KKCP:dict-add kanji yomi type)
    (let ((hinshi (nth 1 (assq type *bunpo-code*)))
	  (gobi   (nth 2 (assq type *bunpo-code*)))
	  (dict-name (cdr (assq dict-no egg:*usr-dict*))))
      (notify "������ܡ�%s��(%s: %s)��%s����Ͽ���ޤ�����"
	      (if gobi (concat kanji " " gobi) kanji)
	      (if gobi (concat yomi  " " gobi) yomi)
	      hinshi dict-name))))



;;; (lsh 1 18)
(defvar *bunpo-menu*
  '(menu "�ʻ�:"
   (("̾��"      . 18)
    ("��ͭ̾��"  . 29)
    ("ư��"      .
	  (menu "�ʻ�:ư��:"
		(("���Ը��ʸ촴"        . 0)   
		 ("���Ը��ʸ촴(�ü�)"  . 1)   
		 ("���Ը��ʸ촴"        . 2)   
		 ("���Ը��ʸ촴"        . 3)   
		 ("���Ը��ʸ촴"        . 4)   
		 ("�ʹԸ��ʸ촴"        . 5)   
		 ("�йԸ��ʸ촴"        . 6)   
		 ("�޹Ը��ʸ촴"        . 7)   
		 ("��Ը��ʸ촴"        . 8)   
		 ("�異�Ը��ʸ촴"      . 9)   
		 ("�������Ѳ���(�θ�)"  . 10)
		 ("�������Ѳ���(���θ�)" . 11)
		 ("����(̾�췿)�촴"     . 12)
		 ("����(���뷿)�촴"     . 13)
		 ("����(���뷿)�촴"     . 14)
		 ("���Ѵ�����"           . 15)
		 ("����ư��(��)"         . 22)
		 ("����ư��(��)"         . 23)
		 ("����ư��"             . 28))))
    ("���ƻ�촴"     . 16)
    ("����ư��촴"   . 17)
    ("Ϣ�λ�"         . 19)
    ("����"           . 20)
    ("��³�졦��ư��" . 21)
    ("��Ƭ��"         . 24)
    ("������"         . 25)
    ("������"         . 26)
    ("����"           . 27)
    ("ñ����"         . 31))))

(defvar *bunpo-code*
  '(
    ( 0   "���Ը��ʸ촴"         "��" ("���ʤ�" "���ޤ�" "��" "���Ȥ�" "��"))   
    ( 1   "���Ը��ʸ촴(�ü�)"   "��" ("" "" "" "" ""))   
    ( 2   "���Ը��ʸ촴"         "��" ("���ʤ�" "���ޤ�" "" "" ""))   
    ( 3   "���Ը��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 4   "���Ը��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 5   "�ʹԸ��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 6   "�йԸ��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 7   "�޹Ը��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 8   "��Ը��ʸ촴"         "��" ("" "" "" "" ""))   
    ( 9   "�異�Ը��ʸ촴"       "��" ("" "" "" "" ""))   
    ( 10  "�������Ѳ���(�θ�)"   "��" ("" "" "" "" ""))
    ( 11  "�������Ѳ���(���θ�)" "��" ("" "" "" "" ""))
    ( 12  "����(̾�췿)�촴"     "����" ("" "" "" "" ""))
    ( 13  "����(���뷿)�촴"     "����" ("" "" "" "" ""))
    ( 14  "����(���뷿)�촴"     "����" ("" "" "" "" ""))
    ( 15  "���Ѵ�����"           "��"  ("" "" "" "" ""))
    ( 16  "���ƻ�촴"           "��" ("" "" "" "" ""))
    ( 17  "����ư��촴"         "��" ("" "" "" "" "") )
    ( 18  "̾��" )
    ( 19  "Ϣ�λ�" )
    ( 20  "����" )
    ( 21  "��³�졦��ư��" )
    ( 22  "����ư��(��)"         "��" ("" "" "" "" ""))
    ( 23  "����ư��(��)"         "��" ("" "" "" "" ""))
    ( 24  "��Ƭ��" )
    ( 25  "������" )
    ( 26  "������" )
    ( 27  "����"   )
    ( 28  "����ư��" "��" ("" "" "" "" ""))
    ( 29  "��ͭ̾��")
    ( 31  "ñ����"  )
    ( 1000  "����¾"  )
    ))

;;;
;;; �����Խ��� DicEd
;;;

(defvar *diced-window-configuration* nil)

(defvar *diced-dict-info* nil)

(defvar *diced-yomi* nil)

;;;;;
;;;;; User entry : edit-dict-item
;;;;;

(defun edit-dict-item (yomi)
  (interactive (list (read-hiragana-string "��ߡ�")))
  (let ((dict-info (KKCP:dict-info yomi  )))
    (if (null dict-info)
	(message "��%s�٤μ�����ܤϤ���ޤ���" yomi)
      (progn
	(setq *diced-yomi* yomi)
	(setq *diced-window-configuration* (current-window-configuration))
	(pop-to-buffer "*Nihongo Dictionary Information*")
	(setq major-mode 'diced-mode)
	(setq mode-name "Diced")
	(setq mode-line-buffer-identification 
	      (concat "DictEd: " yomi
		      (make-string  (max 0 (- 17 (length yomi))) ?  )))
	(sit-for 0) ;; will redislay.
	;;;(use-global-map diced-mode-map)
	(use-local-map diced-mode-map)
	(diced-display dict-info)
	))))

(defun diced-redisplay ()
  (let ((dict-info (KKCP:dict-info *diced-yomi*)))
    (if (null dict-info)
	(progn
	  (message "��%s�٤μ�����ܤϤ���ޤ���" *diced-yomi*)
	  (diced-quit))
      (diced-display dict-info))))

(defun diced-display (dict-info)
	;;; (values (list (record kanji bunpo hindo dict-no serial-no)))
	;;;                         0     1     2      3       4
  (setq dict-info
	(sort dict-info
	      (function (lambda (x y)
			  (or (< (nth 1 x) (nth 1 y))
			      (if (= (nth 1 x) (nth 1 y))
				  (or (> (nth 2 x) (nth 2 y))
				      (if (= (nth 2 x) (nth 2 y))
					  (< (nth 3 x) (nth 3 y))))))))))
  (setq *diced-dict-info* dict-info)
  (setq buffer-read-only nil)
  (erase-buffer)
  (let ((l-kanji 
	 (apply 'max
		(mapcar (function (lambda (l) (length(nth 0 l))))
			dict-info)))
	(l-bunpo
	 (apply 'max
		(mapcar (function(lambda (l)
				   (length (nth 1 (assq (nth 1 l) *bunpo-code*)))))
			dict-info))))
    (while dict-info
      (let*((kanji (nth 0 (car dict-info)))
	    (bunpo (nth 1 (car dict-info)))
	    (gobi   (nth 2 (assq bunpo *bunpo-code*)))
	    (hinshi (nth 1 (assq bunpo *bunpo-code*)))
	    (hindo (nth 2 (car dict-info)))
	    (dict-no (nth 3 (car dict-info)))
	    (dict-name (or (cdr (assq dict-no egg:*sys-dict*))
			   (cdr (assq dict-no egg:*usr-dict*))
			   (int-to-string dict-no)))
	    (sys-dict-p (assq dict-no egg:*sys-dict*))
	    (serial-no (nth 4 (car dict-info)))
	    )
	      

	(insert (if sys-dict-p " *" "  "))
	(insert kanji)
	(if gobi (insert " " gobi))
	(insert-char ?  
		     (- (+ l-kanji 10) (length kanji)
			(if gobi (+ 1 (length gobi)) 0)))
	(insert hinshi)
	(insert-char ?  (- (+ l-bunpo 2) (length hinshi)))
	(insert "����" (file-name-nondirectory dict-name)
		"/" (int-to-string serial-no)
		" ���١�" (int-to-string hindo) ?\n )
	(setq dict-info (cdr dict-info))))
    (goto-char (point-min)))
  (setq buffer-read-only t))

(defun diced-add ()
  (interactive)
  (diced-execute t)
  (let*((kanji  (read-from-minibuffer "������"))
	(bunpo (menu:select-from-menu *bunpo-menu*))
	(dict-no 
	 (menu:select-from-menu (list 'menu "��Ͽ����̾:" egg:*dict-menu*)))
	(dict-name (cdr (assq dict-no egg:*usr-dict*)))
	(gobi   (nth 2 (assq bunpo *bunpo-code*)))
	(hinshi (nth 1 (assq bunpo *bunpo-code*)))
	(item (if gobi (concat kanji " " gobi) kanji))
	(item-yomi (if gobi (concat *diced-yomi* " " gobi)
		     *diced-yomi*))
	)
    (if (notify-yes-or-no-p "������ܡ�%s��(%s: %s)��%s����Ͽ���ޤ���" 
	      item item-yomi hinshi dict-name)
	(progn
	  (KKCP:set-current-dict dict-no)
	  (KKCP:dict-add kanji *diced-yomi* bunpo)
	  (notify "������ܡ�%s��(%s: %s)��%s����Ͽ���ޤ�����" 
		  item item-yomi hinshi dict-name)
	  (diced-redisplay)))))
	      
(defun diced-delete ()
  (interactive)
  (beginning-of-line)
  (if (= (char-after (1+ (point))) ?* )
      (progn (message "�����ƥ༭����ܤϺ���Ǥ��ޤ���") (beep) )
    (if (= (following-char) ?  )
	(let ((buffer-read-only nil))
	  (delete-char 1) (insert "D") (backward-char 1))
      )))
    
(defun diced-undelete ()
  (interactive)
  (beginning-of-line)
  (if (= (following-char) ?D)
      (let ((buffer-read-only nil))
	(delete-char 1) (insert " ") (backward-char 1))
    (beep)))

(defun diced-quit ()
  (interactive)
  (setq buffer-read-only nil)
  (erase-buffer)
  (setq buffer-read-only t)
  (bury-buffer (get-buffer "*Nihongo Dictionary Information*"))
  (set-window-configuration *diced-window-configuration*)
  )

(defun diced-execute (&optional display)
  (interactive)
  (goto-char (point-min))
  (let ((no  0))
    (while (not (eobp))
      (if (= (following-char) ?D)
	  (let* ((dict-item (nth no *diced-dict-info*))
		 (kanji (nth 0 dict-item))
		 (bunpo (nth 1 dict-item))
		 (gobi   (nth 2 (assq bunpo *bunpo-code*)))
		 (hinshi (nth 1 (assq bunpo *bunpo-code*)))
		 (hindo (nth 2 dict-item))
		 (dict-no (nth 3 dict-item))
		 (dict-name (or (cdr (assq dict-no egg:*sys-dict*))
				(cdr (assq dict-no egg:*usr-dict*))
				(int-to-string dict-no)))
		 (sys-dict-p (assq dict-no egg:*sys-dict*))
		 (serial-no (nth 4 dict-item))
		 (item (if gobi (concat kanji " " gobi) kanji))
		 )
	    (if (notify-yes-or-no-p "�������%s(%s)��%s���������ޤ���"
				item hinshi dict-name)
		(progn
		  (KKCP:set-current-dict dict-no)
		  (KKCP:dict-delete serial-no *diced-yomi*)
		  (notify "�������%s(%s)��%s���������ޤ�����" item hinshi dict-name)
		  ))))
      (setq no (1+ no))
      (forward-line 1)))
  (forward-line -1)
  (if (not display) (diced-redisplay)))

(defun diced-next-line ()
  (interactive)
  (beginning-of-line)
  (forward-line 1)
  (if (eobp) (progn (beep) (forward-line -1))))

(defun diced-end-of-buffer ()
  (interactive)
  (end-of-buffer)
  (forward-line -1))

(defun diced-scroll-down ()
  (interactive)
  (scroll-down)
  (if (eobp) (forward-line -1)))

(defun diced-mode ()
  "Mode for \"editing\" dictionaries.
In diced, you are \"editing\" a list of the entries in dictionaries.
You can move using the usual cursor motion commands.
Letters no longer insert themselves. Instead, 

Type  a to Add new entry.
Type  d to flag an entry for Deletion.
Type  n to move cursor to Next entry.
Type  p to move cursor to Previous entry.
Type  q to Quit from DicEd.
Type  u to Unflag an entry (remove its D flag).
Type  x to eXecute the deletions requested.
"
 )

(defvar diced-mode-map (let ((map (make-keymap))) (suppress-keymap map) map))

(define-key diced-mode-map "a"    'diced-add)
(define-key diced-mode-map "d"    'diced-delete)
(define-key diced-mode-map "n"    'diced-next-line)
(define-key diced-mode-map "p"    'previous-line)
(define-key diced-mode-map "q"    'diced-quit)
(define-key diced-mode-map "u"    'diced-undelete)
(define-key diced-mode-map "x"    'diced-execute)

(define-key diced-mode-map "\C-h" 'help-command)
(define-key diced-mode-map "\C-n" 'diced-next-line)
(define-key diced-mode-map "\C-p" 'previous-line)
(define-key diced-mode-map "\C-v" 'scroll-up)
(define-key diced-mode-map "\e<"  'beginning-of-buffer)
(define-key diced-mode-map "\e>"  'diced-end-of-buffer)
(define-key diced-mode-map "\ev"  'diced-scroll-down)


;;;
;;; Pure inspect facility
;;;

(defun henkan-inspect-bunsetu ()
  (interactive)
  (let*((info (KKCP:henkan-inspect
	       *bunsetu-number* 
	       (bunsetu-kouho-number *bunsetu-number*)))
	(jiritugo (nth 0 info))
	(fuzokugo (nth 1 info))
	(yomi (nth 2 info))
	(jishono  (nth 3 info))
	(jishoname (file-name-nondirectory 
		    (or (cdr (assq jishono egg:*sys-dict*))
			(cdr (assq jishono egg:*usr-dict*))
			(int-to-string jishono))))
	(serial   (nth 4 info))
	(bunpo    nil)
	(hinshi   nil)
	(hindo    nil))
    (if (or (= serial -1)
	    (equal yomi ""))
	(notify-internal 
	 (format  "��%s�סʤҤ餬�ʡ����������Ѵ��ˡܡ�%s��"
		  jiritugo fuzokugo)
	 t)	
      (let ((list (KKCP:dict-info yomi)))
	(while (and list (null bunpo))
	  (if (and (equal jiritugo (nth 0 (car list)))
		   (= jishono  (nth 3 (car list)))
		   (= serial   (nth 4 (car list))))
	      (setq bunpo (nth 1 (car list))
		    hindo (nth 2 (car list))))
	  (setq list (cdr list))))
      (setq hinshi (nth 1 (assq bunpo *bunpo-code*)))

      (notify-internal
       (format "��%s�ס��ʻ졧%s ����%s �ֹ桧%s ���١�%s �ˡܡ�%s��"
	       jiritugo hinshi jishoname serial hindo fuzokugo)
       t))))


;;; ��������

(defvar *ku1-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
))
(defvar *ku2-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
))

(defvar egg:*symbol-alist* (append *ku1-alist* *ku2-alist*))

(defvar *ku3-alist* '(
;I	 ( "��" . "��")
;II	 ( "��" . "��")
;III	 ( "��" . "��")
;IV	 ( "��" . "��")
;V       ( "��" . "��")
;VI	 ( "��" . "��")
;VII	 ( "��" . "��")
;VIII	 ( "��" . "��")
;IX	 ( "��" . "��")
;X	 ( "��" . "��")
;XI	 ( "��" . "��")
;XII	 ( "��" . "��")
;XIII	 ( "��" . "��")
;XIV	 ( "��" . "��")
;XV	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;1/2	 ( "��" . "��")
;1/3	 ( "��" . "��")
;1/4	 ( "��" . "��")
;2/3	 ( "��" . "��")
;3/4	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
))

(defvar egg:*alphanumeric-alist* *ku3-alist*)

(defvar *ku4-alist* '(

	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
))

(defvar egg:*hiragana-alist* *ku4-alist*)

(defvar *ku5-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
))

(defvar egg:*katakana-alist* *ku5-alist*)

(defvar *ku6-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;(a)	 ( "��" . "��")
;(b)	 ( "��" . "��")
;(c)	 ( "��" . "��")
;(d)	 ( "��" . "��")
;(e)	 ( "��" . "��")
;(f)	 ( "��" . "��")
;(g)	 ( "��" . "��")
;(h)	 ( "��" . "��")
;(i)	 ( "��" . "��")
;(j)	 ( "��" . "��")
;(k)	 ( "��" . "��")
;(l)	 ( "��" . "��")
;(m)	 ( "��" . "��")
;(n)	 ( "��" . "��")
;(o)	 ( "��" . "��")
;(p)	 ( "��" . "��")
;(q)	 ( "��" . "��")
;(r)	 ( "��" . "��")
;(s)	 ( "��" . "��")
;(t)	 ( "��" . "��")
;(u)	 ( "��" . "��")
;(v)	 ( "��" . "��")
;(w)	 ( "��" . "��")
;(x)	 ( "��" . "��")
;(y)	 ( "��" . "��")
;(z)	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
))

(defvar egg:*greek-alist* *ku6-alist*)

(defvar *ku7-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;(1)	 ( "��" . "��")
;(2)	 ( "��" . "��")
;(3)	 ( "��" . "��")
;(4)	 ( "��" . "��")
;(5)	 ( "��" . "��")
;(6)	 ( "��" . "��")
;(7)	 ( "��" . "��")
;(8)	 ( "��" . "��")
;(9)	 ( "��" . "��")
;(10)	 ( "��" . "��")
;(11)	 ( "��" . "��")
;(12)	 ( "��" . "��")
;(13)	 ( "��" . "��")
;(14)	 ( "��" . "��")
;(15)	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;i	 ( "��" . "��")
;ii	 ( "��" . "��")
;iii	 ( "��" . "��")
;iv	 ( "��" . "��")
;v	 ( "��" . "��")
;vi	 ( "��" . "��")
;vii	 ( "��" . "��")
;viii	 ( "��" . "��")
;ix	 ( "��" . "��")
;x	 ( "��" . "��")
;|	 ( "��" . "��")
;'	 ( "��" . "��")
;''	 ( "��" . "��")
))

(defvar egg:*russian-alist* *ku7-alist*)

(defvar *ku8-alist* '(
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;*	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
;	 ( "��" . "��")
))

(defvar egg:*keisen-alist* *ku8-alist*)

(defun make-all-jis-code-alist ()
  (let ((result nil) (ku 116))
    (while (<  32 ku)
      (let ((ten 126))
	(while (< 32 ten)
	  (setq result (cons 
			(let ((str (make-string 2 0)))
			  (aset str 0 (+ 128 ku))
			  (aset str 1 (+ 128 ten))
			  (cons str str))
			result))
	  (setq ten (1- ten))))
      (setq ku (1- ku)))
    result))

(defun make-jis-first-level-code-alist ()
  (let ((result nil) (ku 79))
    (while (<=  48 ku)
      (let ((ten 126))
	(while (<= 33 ten)
	  (setq result (cons 
			(let ((str (make-string 2 0)))
			  (aset str 0 (+ 128 ku))
			  (aset str 1 (+ 128 ten))
			  (cons str str))
			result))
	  (setq ten (1- ten))))
      (setq ku (1- ku)))
    result))

(defun make-jis-second-level-code-alist ()
  (let ((result nil) (ku 116))
    (while (<= 80 ku)
      (let ((ten 126))
	(while (<= 33 ten)
	  (setq result (cons 
			(let ((str (make-string 2 0)))
			  (aset str 0 (+ 128 ku))
			  (aset str 1 (+ 128 ten))
			  (cons str str))
			result))
	  (setq ten (1- ten))))
      (setq ku (1- ku)))
    result))

;;;(defvar egg:*all-jis-code-alist* (make-all-jis-code-alist))

(defvar egg:*first-level-alist*  (make-jis-first-level-code-alist))
(defvar egg:*second-level-alist* (make-jis-second-level-code-alist))

(defvar *symbol-input-menu*
  (list 'menu "��������:"
	(list 
	 (cons "JIS����"
	       '(jis-code-input))
	 (cons "����"
	       (list 'menu "����:" egg:*symbol-alist*))
	 (cons "�ѿ���"
	       (list 'menu "�ѿ���:" egg:*alphanumeric-alist*))
	 (cons "�Ҥ餬��"
	       (list 'menu "�Ҥ餬��:" egg:*hiragana-alist*))
	 (cons "��������"
	       (list 'menu "��������:" egg:*katakana-alist*))
	 (cons "���ꥷ��ʸ��"
	       (list 'menu "���ꥷ��ʸ��:" egg:*greek-alist*))
	 (cons "����ʸ��"
	       (list 'menu "����ʸ��:" egg:*russian-alist*))
	 (cons "����"
	       (list 'menu "����:" egg:*keisen-alist*))
	 (cons "�����"
	       (list 'menu "�����:" egg:*first-level-alist*))
	 (cons "������"
	       (list 'menu "������:" egg:*second-level-alist*))
	;; (cons "�������ɡʾ������֤��ݤ���ޤ�����"
	;;       (list 'menu "��������:" egg:*all-jis-code-alist*))
	 )))


(defun special-symbol-input ()
  (interactive)
  (let ((code (menu:select-from-menu *symbol-input-menu*)))
    (cond((stringp code) (insert code))
	 ((consp code) (eval code))
	 )))

(define-key global-map "\C-^"  'special-symbol-input)

