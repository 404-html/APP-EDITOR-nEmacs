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
;;; Ver. 3.2  3.2 ÂÐ±þ¤ËÊÑ¹¹
;;; Nemacs 3.0 created by S. Tomura 89-Mar-17
;;; Ver. 2.1a modified by S. Tomura 88-Nov-17
;;;           word¤ÎÅÓÃæ¤ÇÊ¬³ä¤·¤Ê¤¤¤è¤¦¤Ë½¤Àµ¤·¤¿¡£
;;; Ver. 2.1  modified by S. Tomura 88-Jun-24
;;;           kinsoku-shori moves the point <= fill-column + kinsoku-nobashi
;;; Nemacs V.2.1
;;; Ver. 1.1  modified by S. Tomura 88-Feb-29
;;;           Bug fix:  regexp-quote is used.
;;; Ver. 1.0  Created by S. Tomura
;;;           ¶ØÂ§½èÍýµ¡Ç½¤òÄó¶¡¤¹¤ë¡£
;;;

(defvar kanji-kinsoku-version "3.21")
;;; Last modified date: Wed Nov 15 11:59:00 1989

;;; The followings must be merged into kanji.el
;;; patched by S.Tomura 87-Dec-7
;;;    JIS code¤ÎÆÃ¼ìÊ¸»ú¤Î°ìÍ÷É½¤Ç¤¹¡£¡Ê¸ÍÂ¼¡Ë
;;;;     "¡¡¡¢¡£¡¤¡¥¡¦¡§¡§¡¨¡©¡ª¡«¡¬¡­¡®¡¯"
;;;;   "¡°¡±¡²¡³¡´¡µ¡¶¡·¡¸¡¹¡º¡»¡¼¡½¡¾¡¿"
;;;;   "¡À¡Á¡Â¡Ã¡Ä¡Å¡Æ¡Ç¡È¡É¡Ê¡Ë¡Ì¡Í¡Î¡Ï"
;;;;   "¡Ð¡Ñ¡Ò¡Ó¡Ô¡Õ¡Ö¡×¡Ø¡Ù¡Ú¡Û¡Ü¡Ý¡Þ¡ß"
;;;;   "¡à¡á¡â¡ã¡ä¡å¡æ¡ç¡è¡é¡ê¡ë¡ì¡í¡î¡ï"
;;;;   "¡ð¡ñ¡ò¡ó¡ô¡õ¡ö¡÷¡ø¡ù¡ú¡û¡ü¡ý¡þ"
;;;;     "¢¡¢¢¢£¢¤¢¥¢¦¢§¢¨¢©¢ª¢«¢¬¢­¢® "
;;;;     "¦¡¦¢¦£¦¤¦¥¦¦¦§¦¨¦©¦ª¦«¦¬¦­¦®¦¯"
;;;;   "¦°¦±¦²¦³¦´¦µ¦¶¦·¦¸"
;;;;     "¦Á¦Â¦Ã¦Ä¦Å¦Æ¦Ç¦È¦É¦Ê¦Ë¦Ì¦Í¦Î¦Ï"
;;;;   "¦Ð¦Ñ¦Ò¦Ó¦Ô¦Õ¦Ö¦×¦Ø"
;;;;     "§¡§¢§£§¤§¥§¦§§§¨§©§ª§«§¬§­§®§¯"
;;;;   "§°§±§²§³§´§µ§¶§·§¸§¹§º§»§¼§½§¾§¿"
;;;;   "§À§Á"
;;;;     "§Ñ§Ò§Ó§Ô§Õ§Ö§×§Ø§Ù§Ú§Û§Ü§Ý§Þ§ß¡É
;;;;   "§à§á§â§ã§ä§å§æ§ç§è§é§ê§ë§ì§í§î§ï"
;;;;   "§ð§ñ"
;;;;    £°£±£²£³£´£µ£¶£·£¸£¹£Á£Â£Ã£Ä£Å£Æ
;;;;   "¤¡¤£¤¥¤§¤©¤Ã¤ã¤å¤ç¤î"
;;;;   "¥¡¥£¥¥¥§¥©¥Ã¥ã¥å¥ç¥î¥õ¥ö"

(defvar kinsoku-bol-chars 
  (concat  "!)-_~}]:;',.?"
	   "¡¢¡£¡¤¡¥¡¦¡§¡¨¡©¡ª¡«¡¬¡­¡®¡¯¡°¡±¡²¡³¡´¡µ¡¶¡·¡¸¡¹¡º¡»¡¼¡½¡¾"
	   "¡¿¡À¡Á¡Â¡Ã¡Ä¡Å¡Ç¡É¡Ë¡Í¡Ï¡Ñ¡Ó¡Õ¡×¡Ù¡Û¡ë¡ì¡í¡î"
	   "¤¡¤£¤¥¤§¤©¤Ã¤ã¤å¤ç¤î¥¡¥£¥¥¥§¥©¥Ã¥ã¥å¥ç¥î¥õ¥ö"
	   )
  "¹ÔÆ¬¶ØÂ§¤ò¹Ô¤Ê¤¦Ê¸»ú¤ò»ØÄê¤¹¤ë¡£
¡ÊEUC¤Î¥³¡¼¥É¤ÎÊ¸»úÎó¤ò»ÈÍÑ¤¹¤ë¡£¡Ë"
   )

(defvar  kinsoku-eol-chars
   "({[¡Æ¡È¡Ê¡Ì¡Î¡Ð¡Ò¡Ô¡Ö¡Ø¡Ú¡ë¡ì¡í¡î¡÷¡ø"
  "¹ÔËö¶ØÂ§¤ò¹Ô¤Ê¤¦Ê¸»ú¤ò»ØÄê¤¹¤ë¡£
¡ÊEUC¤Î¥³¡¼¥É¤ÎÊ¸»úÎó¤ò»ÈÍÑ¤¹¤ë¡£¡Ë"
  )

;;;
;;; Buffers for kinsoku-shori
;;;
(defvar $kinsoku-buff1$ " "  "¶ØÂ§½èÍý¤Î¤¿¤á¤ÎÈ¾³ÑÊ¸»úÍÑºî¶ÈÎÎ°è")
(defvar $kinsoku-buff2$ "  " "¶ØÂ§½èÍý¤Î¤¿¤á¤ÎÁ´³ÑÊ¸»úÍÑºî¶ÈÎÎ°è")

(defun kinsoku-bol-p ()
  "point¤Ç²þ¹Ô¤¹¤ë¤È¹ÔÆ¬¶ØÂ§¤Ë¿¨¤ì¤ë¤«¤É¤¦¤«¤ò¤«¤¨¤¹¡£
¹ÔÆ¬¶ØÂ§Ê¸»ú¤Ïkinsoku-bol-chars¤Ç»ØÄê¤¹¤ë¡£"
  (string-match "" "") ;;;¤³¤ì¤Ïregex comp¤Î¥ê¥»¥Ã¥È¤Ç¤¹¡£
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
    "point¤Ç²þ¹Ô¤¹¤ë¤È¹ÔËö¶ØÂ§¤Ë¿¨¤ì¤ë¤«¤É¤¦¤«¤ò¤«¤¨¤¹¡£
¹ÔËö¶ØÂ§Ê¸»ú¤Ïkinsoku-eol-chars¤Ç»ØÄê¤¹¤ë¡£"
    (string-match "" "") ;;;¤³¤ì¤Ïregex comp¤Î¥ê¥»¥Ã¥È¤Ç¤¹¡£
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
  "¶ØÂ§½èÍý¤Ç¹Ô¤ò¿­¤Ð¤·¤ÆÎÉ¤¤È¾³ÑÊ¸»ú¿ô¤ò»ØÄê¤¹¤ë¡£
ÈóÉéÀ°¿ô°Ê³°¤Î¾ì¹ç¤ÏÌµ¸ÂÂç¤ò°ÕÌ£¤¹¤ë¡£")

(defun kinsoku-shori ()
  "¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤Ø°ÜÆ°¤¹¤ë¡£
point¤¬¹ÔÆ¬¶ØÂ§¤Ë¿¨¤ì¤ë¾ì¹ç¤Ï¹Ô¤ò¿­¤Ð¤·¤Æ¡¢¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤òÃµ¤¹¡£
point¤¬¹ÔËö¶ØÂ§¤Ë¿¨¤ì¤ë¾ì¹ç¤Ï¹Ô¤ò½Ì¤á¤Æ¡¢¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤òÃµ¤¹¡£
¤¿¤À¤·¡¢¹Ô¿­¤Ð¤·È¾³ÑÊ¸»ú¿ô¤¬kinsoku-nobashi-limit¤ò±Û¤¨¤ë¤È¡¢
¹Ô¤ò½Ì¤á¤Æ¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤òÃµ¤¹¡£"

  (let ((bol-kin nil) (eol-kin nil))
    (if (and (not (bolp))
	     (not (eolp))
	     (or (setq bol-kin (kinsoku-bol-p))
		 (setq eol-kin (kinsoku-eol-p))))
	(cond(bol-kin (kinsoku-shori-nobashi))
	     (eol-kin (kinsoku-shori-chizime))))))

(defun kinsoku-shori-nobashi ()
  "¹Ô¤ò¿­¤Ð¤·¤Æ¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤Ø°ÜÆ°¤¹¤ë¡£"
  (let ((max-column (+ fill-column 
		       (if (and (numberp kinsoku-nobashi-limit)
				(>= kinsoku-nobashi-limit 0))
			   kinsoku-nobashi-limit
			 10000)))) ;;; 10000¤ÏÌµ¸ÂÂç¤Î¤Ä¤â¤ê¤Ç¤¹¡£
    (while (and (<= (+ (current-column)
		       (if (<= 128 (following-char)) 1 2))
		    max-column)
		(not (bolp))
		(not (eolp))
		(or (kinsoku-eol-p)
		    (kinsoku-bol-p)
	            ;;; English word ¤ÎÅÓÃæ¤Ç¤ÏÊ¬³ä¤·¤Ê¤¤¡£
		    (and (= ?w (char-syntax (preceding-char)))
			 (= ?w (char-syntax (following-char))))))
      (forward-char))
    (if (or (kinsoku-eol-p) (kinsoku-bol-p))
	(kinsoku-shori-chizime))))

(defun kinsoku-shori-chizime ()
  "¹Ô¤ò½Ì¤á¤Æ¶ØÂ§¤Ë¿¨¤ì¤Ê¤¤ÅÀ¤Ø°ÜÆ°¤¹¤ë¡£"
    (while (and (not (bolp))
		(not (eolp))
		(or (kinsoku-bol-p)
		    (kinsoku-eol-p)
		;;; word ¤ÎÅÓÃæ¤Ç¤ÏÊ¬³ä¤·¤Ê¤¤¡£
		    (and (= ?w (char-syntax (preceding-char)))
			 (= ?w (char-syntax (following-char))))))
      (backward-char)))


