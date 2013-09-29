;; Kinsoku shori for Egg
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

;;; Nemacs 3.2 created by S. Tomura 89-Nov-15
;;; Ver. 3.2  3.2 �б����ѹ�
;;; Nemacs 3.0 created by S. Tomura 89-Mar-17
;;; Ver. 2.1a modified by S. Tomura 88-Nov-17
;;;           word�������ʬ�䤷�ʤ��褦�˽���������
;;; Ver. 2.1  modified by S. Tomura 88-Jun-24
;;;           kinsoku-shori moves the point <= fill-column + kinsoku-nobashi
;;; Nemacs V.2.1
;;; Ver. 1.1  modified by S. Tomura 88-Feb-29
;;;           Bug fix:  regexp-quote is used.
;;; Ver. 1.0  Created by S. Tomura
;;;           ��§������ǽ���󶡤��롣
;;;

(defvar kanji-kinsoku-version "3.21")
;;; Last modified date: Wed Nov 15 11:59:00 1989

;;; The followings must be merged into kanji.el
;;; patched by S.Tomura 87-Dec-7
;;;    JIS code���ü�ʸ���ΰ���ɽ�Ǥ����ʸ�¼��
;;;;     "��������������������������������"
;;;;   "��������������������������������"
;;;;   "�����¡áġšơǡȡɡʡˡ̡͡Ρ�"
;;;;   "�Сѡҡӡԡա֡סء١ڡۡܡݡޡ�"
;;;;   "�����������������"
;;;;   "��������������������������"
;;;;     "���������������������������� "
;;;;     "������������������������������"
;;;;   "������������������"
;;;;     "���¦æĦŦƦǦȦɦʦ˦̦ͦΦ�"
;;;;   "�ЦѦҦӦԦզ֦צ�"
;;;;     "������������������������������"
;;;;   "��������������������������������"
;;;;   "����"
;;;;     "�ѧҧӧԧէ֧קا٧ڧۧܧݧާߡ�
;;;;   "�����������������"
;;;;   "���"
;;;;    �����������������������£ãģţ�
;;;;   "�����������ä����"
;;;;   "�����������å�������"

(defvar kinsoku-bol-chars 
  (concat  "!)-_~}]:;',.?"
	   "����������������������������������������������������������"
	   "�������¡áġšǡɡˡ͡ϡѡӡաס١ۡ����"
	   "�����������ä������������å�������"
	   )
  "��Ƭ��§��Ԥʤ�ʸ������ꤹ�롣
��EUC�Υ����ɤ�ʸ�������Ѥ��롣��"
   )

(defvar  kinsoku-eol-chars
   "({[�ơȡʡ̡ΡСҡԡ֡ءڡ�������"
  "������§��Ԥʤ�ʸ������ꤹ�롣
��EUC�Υ����ɤ�ʸ�������Ѥ��롣��"
  )

;;;
;;; Buffers for kinsoku-shori
;;;
(defvar $kinsoku-buff1$ " "  "��§�����Τ����Ⱦ��ʸ���Ѻ���ΰ�")
(defvar $kinsoku-buff2$ "  " "��§�����Τ��������ʸ���Ѻ���ΰ�")

(defun kinsoku-bol-p ()
  "point�ǲ��Ԥ���ȹ�Ƭ��§�˿���뤫�ɤ����򤫤�����
��Ƭ��§ʸ����kinsoku-bol-chars�ǻ��ꤹ�롣"
  (string-match "" "") ;;;�����regex comp�Υꥻ�åȤǤ���
  (string-match 
   (if (<= 128 (following-char)) 
       (progn
	 (aset $kinsoku-buff2$ 0 (following-char))
	 (aset $kinsoku-buff2$ 1 (char-after (1+ (point))))
	 $kinsoku-buff2$)
     (progn
       (aset $kinsoku-buff1$ 0 (following-char))
       (regexp-quote $kinsoku-buff1$)))
   kinsoku-bol-chars))

(defun kinsoku-eol-p ()
    "point�ǲ��Ԥ���ȹ�����§�˿���뤫�ɤ����򤫤�����
������§ʸ����kinsoku-eol-chars�ǻ��ꤹ�롣"
    (string-match "" "") ;;;�����regex comp�Υꥻ�åȤǤ���
    (string-match
     (if (<= 128 (preceding-char))
	 (progn
	   (aset $kinsoku-buff2$ 0 (char-after (- (point) 2)))
	   (aset $kinsoku-buff2$ 1 (preceding-char))
	   $kinsoku-buff2$)
       (progn
	(aset $kinsoku-buff1$ 0 (preceding-char))
	(regexp-quote $kinsoku-buff1$)))
     kinsoku-eol-chars))

(defvar kinsoku-nobashi-limit nil
  "��§�����ǹԤ򿭤Ф����ɤ�Ⱦ��ʸ��������ꤹ�롣
���������ʳ��ξ���̵������̣���롣")

(defun kinsoku-shori ()
  "��§�˿���ʤ����ذ�ư���롣
point����Ƭ��§�˿������ϹԤ򿭤Ф��ơ���§�˿���ʤ�����õ����
point��������§�˿������ϹԤ�̤�ơ���§�˿���ʤ�����õ����
���������Կ��Ф�Ⱦ��ʸ������kinsoku-nobashi-limit��ۤ���ȡ�
�Ԥ�̤�ƶ�§�˿���ʤ�����õ����"

  (let ((bol-kin nil) (eol-kin nil))
    (if (and (not (bolp))
	     (not (eolp))
	     (or (setq bol-kin (kinsoku-bol-p))
		 (setq eol-kin (kinsoku-eol-p))))
	(cond(bol-kin (kinsoku-shori-nobashi))
	     (eol-kin (kinsoku-shori-chizime))))))

(defun kinsoku-shori-nobashi ()
  "�Ԥ򿭤Ф��ƶ�§�˿���ʤ����ذ�ư���롣"
  (let ((max-column (+ fill-column 
		       (if (and (numberp kinsoku-nobashi-limit)
				(>= kinsoku-nobashi-limit 0))
			   kinsoku-nobashi-limit
			 10000)))) ;;; 10000��̵����ΤĤ��Ǥ���
    (while (and (<= (+ (current-column)
		       (if (<= 128 (following-char)) 1 2))
		    max-column)
		(not (bolp))
		(not (eolp))
		(or (kinsoku-eol-p)
		    (kinsoku-bol-p)
	            ;;; English word ������Ǥ�ʬ�䤷�ʤ���
		    (and (= ?w (char-syntax (preceding-char)))
			 (= ?w (char-syntax (following-char))))))
      (forward-char))
    (if (or (kinsoku-eol-p) (kinsoku-bol-p))
	(kinsoku-shori-chizime))))

(defun kinsoku-shori-chizime ()
  "�Ԥ�̤�ƶ�§�˿���ʤ����ذ�ư���롣"
    (while (and (not (bolp))
		(not (eolp))
		(or (kinsoku-bol-p)
		    (kinsoku-eol-p)
		;;; word ������Ǥ�ʬ�䤷�ʤ���
		    (and (= ?w (char-syntax (preceding-char)))
			 (= ?w (char-syntax (following-char))))))
      (backward-char)))


