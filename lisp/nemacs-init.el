;; Nemacs site configuration file
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


;;; 87.6.9   created by K.handa
;;; 87.6.15  modified by K.Handa
;;; 88.1.15  modified for Nemacs Ver.2.0 by K.Handa
;;; 88.5.26  modified for Nemacs Ver.2.1 by K.handa
;;; 88.3.23  modified for Nemacs Ver.3.0 by K.handa
;;; 89.11.21 modified for Nemacs Ver.3.2 by K.Handa and S.Tomura
;;; 89.12.15 modified for Nemacs Ver.3.2.1 by S.Tomura
;;; 90.2.28  copied from site-init.el for Nemacs Ver.3.3.0 by K.Handa

;;;
;;; Any one can change the following lines if you never key in JIS code
;;; modified by K.handa 88.5.26
(defvar esc-dol-map (make-keymap))
(defvar esc-par-map (make-keymap))

(define-key esc-map "$" esc-dol-map)
(define-key esc-map "(" esc-par-map)

(define-key esc-dol-map "@" 'kanji-jis-start)
(define-key esc-dol-map "B" 'kanji-jis-start)

(define-key esc-par-map "B" 'kanji-jis-end)
(define-key esc-par-map "H" 'kanji-jis-end)
(define-key esc-par-map "J" 'kanji-jis-end)

;;; Initialization of kanji code related variables for each site
;;; Any one can overwrite the followings in $home/.emacs
(define-key esc-map "#" 'spell-word)
(define-key esc-map "{" 'insert-parentheses)
(setq-default kanji-flag t)
; 0: No-conversion
; 1: Shift-JIS
; 2: JIS
; 3: EUC
; nil: not decided
; t: guess (only for kanji-expected-code)
(setq-default kanji-fileio-code 2)
(setq default-kanji-process-code 2)
(setq kanji-display-code 2)
(setq kanji-input-code 2)

(setq to-kanji-display 66)	;ESC-$-@	@=64 / B=66
(setq to-ascii-display 66)	;ESC-(-J	B=66 / H=72 / J=74
(setq to-kanji-fileio 66)
(setq to-ascii-fileio 66)
(setq to-kanji-process 66)
(setq to-ascii-process 66)

;;; Convenient Utilities provided by S.Tomura and K.Handa
;;; Change Kanji codes according to your environment
(load-library "kanji-util")
(define-program-kanji-code nil ".*mail.*" 2)
(define-program-kanji-code nil ".*inews.*" 2)
(define-service-kanji-code "wnn"  nil 0)
(define-service-kanji-code "sj3"  nil 0)
(define-service-kanji-code "nntp" nil 0)
(garbage-collect)

;;; For gnus user only
(autoload 'gnus "gnus" "Read network news." t)
;;(autoload 'gnus-post-news "gnuspost" "Post a new news." t)
(garbage-collect)
(setq gnus-nntp-service 119 )
(setq gnus-nntp-server "ntttsd")
(setq gnus-your-domain "ntttsd.ntt.jp"
      gnus-your-organization "NTT Transmission Systems Laboratories, Yokosuka, JAPAN"
      gnus-use-generic-from t)
;(setq gnus-your-domain "your.domain.address"
;      gnus-your-organization "Your site name"
;      gnus-use-generic-from t)
(garbage-collect)

;;; For EGG user only
(if (boundp 'EGG)
    (progn
      (if (boundp 'SJ3)
	  (progn
	    (load-library "sj3-client")
	    (load-library "sj3-egg")
	    (load-library "egg-rkdump")
	    (setq egg-default-startup-file "eggrc-sj3"))
      (if (not (or (boundp 'WNN3) (boundp 'WNN4V3)))
	  (progn
	    (load-library "wnn-client")))
      (load-library "wnn-egg")
      (load-library "egg-rkdump")
      (if (or (boundp 'WNN3) (boundp 'WNN4V3))
	  (load-library "wnnfns"))
      (if (boundp 'WNN4V3)
	(setq egg-default-startup-file "eggrc-v4")
	  (setq egg-default-startup-file "eggrc-v3")))
      (garbage-collect)))

;;; For rnews user only
(setq news-inews-program "/usr/lib/news/inews")

;;; Do not change the following line.
(setq initial-major-mode 'nemacs-lisp-interaction-mode)
