;; wnnfns.c support package for Egg
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

;;;
;;;  wnnfns.el  (renamed from wnnfns-support.el)
;;;

;;;  Written by Satoru Tomura at ElectroTechnical Laboratory
;;;
;;;  Email address: tomura@etl.go.jp

;;;
;;; このファイルは wnnfns.c の機能と wnn-egg.el の機能の調整をする。
;;; wnn-egg.el を load した後でロードする。
;;;

(defvar wnnfns-support-version "1.09")
;;; Last modified date: Mon Dec 25 23:34:00 1989

(defvar egg:*kanji-buffer* nil)

(defun bunsetu-su ()
  (length egg:*kanji-buffer*))
  
(defun make-bunsetu (kanji yomi)
  (list kanji yomi nil 0))

(defun bunsetu-length (number)
  (kanji-moji-suu (bunsetu-yomi number)))
  
(defun bunsetu-position (number)
  (let ((pos egg:*region-start*) (i 0))
    (while (< i number)
      (setq pos (+ pos (length (bunsetu-kanji  i)) (length egg:*bunsetu-kugiri*)))
      (setq i (1+ i)))
    pos))
  
(defun bunsetu-kanji (number) (nth 0 (aref egg:*kanji-buffer* number)))
  
(defun bunsetu-set-kanji (number kanji) 
  (setcar (nthcdr 0 (aref egg:*kanji-buffer* number)) kanji))

(defun bunsetu-yomi  (number) (nth 1 (aref egg:*kanji-buffer* number)))
(defun bunsetu-set-yomi (number yomi)
  (setcar (nthcdr 1 (aref egg:*kanji-buffer* number)) yomi))

(defun bunsetu-kouho-list (number) 
  (let ((x (nth 2 (aref egg:*kanji-buffer* number))))
    (or x
	(let((jikouho (KKCP:henkan-next number)))
	  (if jikouho
	      (setcar (nthcdr 2 (aref egg:*kanji-buffer* number))
		      jikouho)
	    (progn (beep) (beep) (beep)
		   (notify 
		    "変換候補が多すぎます。wnnfsn.c を修正して nemacs を作り直して下さい。")
		   (setcar (nthcdr 2 (aref egg:*kanji-buffer* number))
			   (list (bunsetu-kanji number)
				 (bunsetu-yomi  number)))))))))
  
(defun bunsetu-kouho-suu (number)
  (length (bunsetu-kouho-list number)))

  
(defun bunsetu-set-kouho-list (number kouho-list)
  (setcar (nthcdr 2 (aref egg:*kanji-buffer* number)) kouho-list))

(defun bunsetu-kouho-number (number) (nth  3  (aref egg:*kanji-buffer* number)))

(defun bunsetu-set-kouho-number (bunsetu-no number)
  (setcar (nthcdr 3 (aref egg:*kanji-buffer* bunsetu-no)) number))

(defun make-henkan-buffer (list)
  (let ((buff (make-vector (length list) 0)))
    (let ((i 0) (max (length list)))
      (while (< i max)
	(aset buff i (make-bunsetu (car (car list))
				   (cdr (car list))))
	(setq list (cdr list))
	(setq i (1+ i)))
      buff)))

(defun update-henkan-buffer (buffer from list)
  (let ((vec (make-vector (length list) 0)))
    (let ((i 0))
      (while (< i from)
	(aset vec i (aref buffer i))
	(setq i (1+ i))))
    (let ((i from) (max (length list)))
      (while (< i max)
	(aset vec i (make-bunsetu (car (nth i list))
				(cdr (nth i list))))
	(setq i (1+ i))))
    vec))

(defun henkan-region-internal (start end)
  "regionをかな漢字変換する。"
  (setq egg:*kanji-kanabuff* (buffer-substring start end))
  (setq *bunsetu-number* nil)
  (let ((result (KKCP:henkan-begin egg:*kanji-kanabuff*)))
    (if  result
	(progn
	  (mode-line-egg-mode-update henkan-mode-indicator)
	  (setq egg:*kanji-buffer* (make-henkan-buffer result))
	  (goto-char start)
	  (if (null (marker-position egg:*region-start*))
	      (progn
		;;;(setq egg:*global-map-backup* (current-global-map))
		(setq egg:*local-map-backup* (current-local-map))
		(and (boundp 'disable-undo) (setq disable-undo t))
		(delete-region start end)
		(goto-char start)
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
	  (henkan-insert-kouho result)
	  (henkan-goto-bunsetu 0)
	  ;;;(use-global-map henkan-mode-map)
	  ;;;(use-local-map nil)
	  (use-local-map henkan-mode-map)
	  )))
  )

(defun henkan-insert-kouho (list)
  (let ((l list))
    (while l
      (insert (car (car l)) egg:*bunsetu-kugiri* )
      (setq l (cdr l)))
    (if list (delete-char (- (length egg:*bunsetu-kugiri*))))))
  
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
      (KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (insert (bunsetu-kanji i ))
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
      (KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (insert (bunsetu-kanji i ))
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
      (insert (bunsetu-yomi i))
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
			      (1- (length (bunsetu-kouho-list
					   *bunsetu-number*)))))
    (while (< i max)
      (if (equal yomi (bunsetu-yomi i))
	  (progn 
	    (delete-region (bunsetu-position i)
			   (+ (bunsetu-position i)
			      (length (bunsetu-kanji i))))
	    (bunsetu-set-kanji i
			       (nth kouho-number
				    (bunsetu-kouho-list i)))
	    (bunsetu-set-kouho-number i  kouho-number)
	    (goto-char (bunsetu-position i))
	    (insert (bunsetu-kanji i))))
      (setq i (1+ i)))
    (goto-char point))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
  (egg:bunsetu-attribute-on *bunsetu-number*))
  
(defun bunsetu-length-henko (length)
  (let ((r (KKCP:bunsetu-henkou *bunsetu-number* length)))
    (cond(r
	  (egg:henkan-attribute-off)
	  (egg:bunsetu-attribute-off *bunsetu-number*)
	  (delete-region 
	   (bunsetu-position *bunsetu-number*) egg:*region-end*)
	  (goto-char (bunsetu-position *bunsetu-number*))
	  (henkan-insert-kouho (nthcdr *bunsetu-number* r))
	  (setq egg:*kanji-buffer* 
		(update-henkan-buffer egg:*kanji-buffer* *bunsetu-number*
				      r))
	  (henkan-goto-bunsetu *bunsetu-number*)))))


