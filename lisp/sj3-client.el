;; Sj3 server interface for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)
;;      and K.Ishii, Sony Corp. (kiyoji@sm.sony.co.jp)

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
;;; Nemacs - Sj3 server interface in elisp
;;;

(provide 'sj3-client)

;;;
;;;  Sj3 deamon command constants
;;;

(defconst SJ3_OPEN       1  "���Ѽ���Ͽ")
(defconst SJ3_CLOSE      2  "���ѼԺ��")
;;;
(defconst SJ3_DICADD     11 "�����ɲ�")
(defconst SJ3_DICDEL     12 "������")
;;;
(defconst SJ3_OPENSTDY	 21  "�ؽ��ե����륪���ץ�")
(defconst SJ3_CLOSESTDY	 22  "�ؽ��ե����륯����")
(defconst SJ3_STDYSIZE	 23  "")
;;;
(defconst SJ3_LOCK       31 "�����å�")
(defconst SJ3_UNLOCK     32 "���񥢥��å�")
;;;
(defconst SJ3_BEGIN      41 "�Ѵ�����")
;;;
(defconst SJ3_TANCONV    51 "���Ѵ���ʸ�῭�̡�")
(defconst SJ3_KOUHO      54 "����")
(defconst SJ3_KOUHOSU    55 "�����")
;;;
(defconst SJ3_STDY       61 "ʸ��ؽ�")
(defconst SJ3_END        62 "ʸ��Ĺ�ؽ�")
;;;
(defconst SJ3_WREG       71 "ñ����Ͽ")
(defconst SJ3_WDEL       72 "ñ����")
;;;
(defconst SJ3_MKDIC      81 "")
(defconst SJ3_MKSTDY     82 "")
(defconst SJ3_MKDIR      83 "")
(defconst SJ3_ACCESS     84 "")
;;;
(defconst SJ3_WSCH       91 "ñ�측��")
(defconst SJ3_WNSCH      92 "")
;;;
(defconst SJ3_VERSION    103 "")


(defvar sj3-server-buffer nil  "Buffer associated with Sj3 server process.")

(defvar sj3-server-process nil  "Sj3 Kana Kanji hankan process.")

(defvar sj3-command-tail-position nil)
(defvar sj3-command-buffer nil)

(defvar sj3-result-buffer nil)
(defvar sj3-henkan-string nil)
(defvar sj3-bunsetu-suu   nil)

(defvar sj3-return-code nil)
(defvar sj3-error-code nil)

(defvar sj3-stdy-size nil)
(defvar sj3-user-dict-list nil)
(defvar sj3-sys-dict-list nil)
(defvar sj3-yomi-llist nil)
;;;
;;;  Put data into buffer 
;;;

(defun sj3-put-4byte (integer)
  (insert (if (<= 0 integer) 0 255)
	  (logand 255 (lsh integer -16))
	  (logand 255 (lsh integer -8))
	  (logand 255 integer)))

(defun sj3-put-string (str)
  (insert str 0))

(defun sj3-put-string* (str)
  (let ((sstr (convert-string-kanji-code str 3 1)))
    (insert sstr 0)))

(defun sj3-put-bit-position  (pos)
  (if (< pos  24) (sj3-put-4byte (lsh 1 pos))
    (insert (lsh 1 (- pos 24)) 0 0 0)))

;;;
;;; Get data from buffer
;;;

(defun sj3-get-4byte ()

  (let ((c 0) (point (point)))
    ;;;(goto-char (point-min))
    (while (< (point-max) (+ point 4))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point))

  (let ((point (point)))
    (if (not (or (and (= (char-after point) 0)
		      (< (char-after (+ point 1)) 128))
		 (and (= (char-after point) 255)
		      (<= 128 (char-after (+ point 1))))))
	(error "sj3-get-4byte: integer range overflow."))
    (prog1
	(logior 
	 (lsh (char-after point)       24)
	 (lsh (char-after (+ point 1)) 16)
	 (lsh (char-after (+ point 2))  8)
	 (lsh (char-after (+ point 3))  0))
      (goto-char (+ (point) 4)))))

(defun sj3-peek-4byte ()

  (let ((c 0) (point (point)))
    (while (< (point-max) (+ point 4))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point))

  (let ((point (point)))
    (if (not (or (and (= (char-after point) 0)
		      (< (char-after (+ point 1)) 128))
		 (and (= (char-after point) 255)
		      (<= 128 (char-after (+ point 1))))))
	(error "sj3-get-4byte: integer range overflow."))
    (prog1
	(logior 
	 (lsh (char-after point)       24)
	 (lsh (char-after (+ point 1)) 16)
	 (lsh (char-after (+ point 2))  8)
	 (lsh (char-after (+ point 3))  0)))))

(defun sj3-get-byte ()
  (let ((c 0) (point (point)))
    (while (< (point-max) (1+ point))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point)
    (prog1
	(lsh (char-after point) 0)
      (forward-char 1))))

(defun sj3-get-string ()
  (let ((point (point)))
    (skip-chars-forward "^\0")
    (let ((c 0))
      (while (not (= (following-char) 0))
	(forward-char -1)
	(accept-process-output)
	(if (= c 10) (error "Count exceed"))
	(setq c (1+ c))
	(skip-chars-forward "^\0")))
    (prog1 
	(buffer-substring point (point))
      (forward-char 1))))

(defun sj3-skip-nbyte (n)
  (let ((c 0) (point (point)))
    (while (< (point-max) (+ point n))
      (accept-process-output)
      (if (= c (* n 2)) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char (+ point n))))

(defun sj3-get-string* ()
  (let ((point (point)) str)
    (while (not (= (sj3-get-byte) 0)))
    (setq str (buffer-substring point (1- (point))))
    (convert-string-kanji-code str 1 3)))

;;;
;;; Sj3 Server Command Primitives
;;;

(defun sj3-command-start (command)
  (set-buffer sj3-command-buffer)
  (goto-char (point-min))
  (if (not (= (point-max) (+ sj3-command-tail-position 1024)))
      (error "sj3 command start error"))
  (delete-region (point-min) sj3-command-tail-position)
  (sj3-put-4byte command))

(defun sj3-command-reset ()
  (save-excursion
    (progn  
      ;;; for Nemacs 3.0 and later
      (if (fboundp 'set-process-kanji-code)
	  (set-process-kanji-code sj3-server-process 0))
      (set-buffer sj3-command-buffer)
      (setq kanji-flag nil)
      (setq kanji-fileio-code 0)   ;;; for Nemacs 2.1
      (buffer-flush-undo sj3-command-buffer)
      (erase-buffer)
      (setq sj3-command-tail-position (point-min))
      (let ((max 1024) (i 0))
	(while (< i max)
	  (insert 0)
	  (setq i (1+ i)))))))

(defun sj3-command-end ()
  (set-buffer sj3-server-buffer)
  (erase-buffer)
  (set-buffer sj3-command-buffer)
  (setq sj3-command-tail-position (point))
  (process-send-region sj3-server-process (point-min)
	       (+ (point-min) (lsh (1+ (lsh (- (point) (point-min)) -10)) 10)))
  )

;;;
;;; Sj3 Server Reply primitives
;;;

(defun sj3-get-result ()
  (set-buffer sj3-server-buffer)
  (condition-case ()
      (accept-process-output sj3-server-process)
    (error nil))
  (goto-char (point-min)))

(defun sj3-get-return-code ()
  (setq sj3-return-code (sj3-get-4byte))
  (setq sj3-error-code  (if (= sj3-return-code 0) nil
			  (sj3-error-symbol sj3-return-code)))
  (if sj3-error-code nil
    sj3-return-code))

;;;
;;; Sj3 Server Interface:  sj3-server-open
;;;

;(defvar *sj3-server-max-kana-string-length* 1000)
;(defvar *sj3-server-max-bunsetu-suu* 1000)

(defvar *sj3-server-version* 1)
(defvar *sj3-program-name* "sj3-egg")
(defvar *sj3-service-name* "sj3")

(defun sj3-server-open (server-host-name login-name)
  (if (sj3-server-active-p) t
     (let ((server_version *sj3-server-version*)
	   (sj3serv_name 
	   (if (or (null  server-host-name)
		   (equal server-host-name "")
		   (equal server-host-name "unix"))
	       (system-name)
	     server-host-name))
	  (user_name
	   (if (or (null login-name) (equal login-name ""))
	       (user-login-name)
	     login-name))
	  (host_name (system-name)))
      (setq sj3-server-process 
	    (condition-case var
		(open-network-stream "Sj3" " [Sj3 Output Buffer] "
				     sj3serv_name *sj3-service-name* )
	      (error 
	        (cond((string-match "Unknown host" (car (cdr var)))
		      (setq sj3-error-code (list ':SJ3_UNKNOWN_HOST
						 sj3serv_name)))
		     ((string-match "Unknown service" (car (cdr var)))
		      (setq sj3-error-code (list ':SJ3_UNKNOWN_SERVICE
						 *sj3-service-name*)))
		     (t ;;; "Host ... not respoding"
		      (setq sj3-error-code ':SJ3_SOCK_OPEN_FAIL)))
		     nil)))
      (if (null sj3-server-process) nil
	(setq sj3-server-buffer (get-buffer " [Sj3 Output Buffer] "))
	(setq sj3-command-buffer (get-buffer-create " [Sj3 Command Buffer] "))
	(setq sj3-result-buffer (get-buffer-create " [Sj3 Result Buffer] "))

	(save-excursion 
	  ;;; for Nemacs 3.0 
	  (if (fboundp 'set-process-kanji-code)
	      (set-process-kanji-code sj3-server-process 0))
	  (progn
	    (set-buffer sj3-server-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1
	    (setq kanji-fileio-code 0) 
	    (buffer-flush-undo sj3-server-buffer)
	    )
	  (progn
	    (set-buffer sj3-result-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1 
	    (setq kanji-fileio-code 0)
	    (buffer-flush-undo sj3-result-buffer))
	  (progn  
	    (set-buffer sj3-command-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1
	    (setq kanji-fileio-code 0)
	    (buffer-flush-undo sj3-command-buffer)
	    (erase-buffer)
	    (setq sj3-command-tail-position (point-min))
	    (let ((max 1024) (i 0))
	      (while (< i max)
		(insert 0)
		(setq i (1+ i)))))
	  (sj3-clear-dict-list)
	  (sj3-command-start SJ3_OPEN)
	  (sj3-put-4byte server_version)
	  (sj3-put-string user_name)
	  (sj3-put-string host_name)
	  (sj3-put-string *sj3-program-name*)
	  (sj3-command-end)
	  (sj3-get-result)
	  (sj3-get-return-code)
	  (if (= sj3-return-code 0)
	      (sj3-get-stdy-size)
	    nil))))))

(defun sj3-server-active-p ()
  (and sj3-server-process
       (eq (process-status sj3-server-process) 'open)))

(defun sj3-connection-error ()
  (setq sj3-error-code ':sj3-no-connection)
  (setq sj3-return-code -1)
  nil)

(defun sj3-zero-arg-command (op)
  (if (sj3-server-active-p)
      (save-excursion
	(sj3-command-start op)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code))
    (sj3-connection-error)))

(defun sj3-server-close ()
  (let (dict-no)
    (while (and (sj3-server-active-p) (setq dict-no (car sj3-sys-dict-list)))
      (sj3-server-close-dict dict-no)
      (setq sj3-sys-dict-list (cdr sj3-sys-dict-list)))
    (while (and (sj3-server-active-p) (setq dict-no (car sj3-user-dict-list)))
      (sj3-server-close-dict dict-no)
      (setq sj3-user-dict-list (cdr sj3-user-dict-list)))
    (sj3-clear-dict-list))
  (sj3-server-close-stdy)
  (sj3-zero-arg-command SJ3_CLOSE)
  (if (sj3-server-active-p)
      (delete-process sj3-server-process))
  (if sj3-server-buffer
      (kill-buffer sj3-server-buffer))
  (if sj3-command-buffer
      (kill-buffer sj3-command-buffer))
  (if sj3-result-buffer
      (kill-buffer sj3-result-buffer))
  (setq sj3-server-process nil)
  (setq sj3-server-buffer nil)
  (setq sj3-command-buffer nil)
  (setq sj3-result-buffer nil))

(defun sj3-clear-dict-list ()
  (setq sj3-sys-dict-list nil)
  (setq sj3-user-dict-list nil))

(or (fboundp 'si:kill-emacs)
    (fset 'si:kill-emacs (symbol-function 'kill-emacs)))

(defun kill-emacs (&optional arg)
  (interactive "P")
  (if (sj3-server-active-p)
      (progn
;;	(sj3-server-dict-save)
;;	(message "Sj3�μ�����󡦳ؽ���������򤷤ޤ�����") (sit-for 0)
	(sj3-server-close)))
  (si:kill-emacs arg))

;;(or (fboundp 'si:do-auto-save)
;;    (fset 'si:do-auto-save (symbol-function 'do-auto-save)))

;;(defvar *sj3-do-auto-save-dict* nil)

;;(defun do-auto-save (&optional nomsg)
;;  (interactive)
;;  (if (and *sj3-do-auto-save-dict*
;;	   (sj3-server-dict-save))
;;      (progn
;;	(sj3-serve-dict-save)
;;	(message "Sj3�μ�����󡦳ؽ���������򤷤ޤ�����")
;;	(sit-for 1)))
;;  (si:do-auto-save nomsg))

(defun sj3-get-stdy-size ()
  (sj3-zero-arg-command SJ3_STDYSIZE)
  (if (not (= (sj3-get-4byte) 0)) nil
      (setq sj3-stdy-size (sj3-get-4byte))))

(defun sj3-put-stdy-dmy ()
  (let ((i 0))
    (while (< i sj3-stdy-size)
      (insert 0)
      (setq i (1+ i)))))

;;; Sj3 Result Buffer's layout:
;;;
;;; { length:4  kana 0 kouhoSuu:4 kouhoNo:4 studyData
;;;   {kanji 0 } ...
;;; }
;;;   0 0 0 0

(defun sj3-skip-length ()
  (goto-char (+ (point) 4)))

(defun sj3-skip-4byte ()
  (goto-char (+ (point) 4)))

(defun sj3-skip-yomi ()
  (skip-chars-forward "^\0") (forward-char 1))

(defun sj3-skip-stdy ()
  (goto-char (+ (point) sj3-stdy-size)))

(defun sj3-forward-char (n)
  (let ((i 1))
    (while (<= i n)
      (if (<= 128 (following-char))
	  (forward-char 2)
	(forward-char 1))
      (setq i (1+ i)))))

;;;
;;; entry function
;;;
(defun sj3-server-henkan-begin (henkan-string)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(setq sj3-henkan-string henkan-string)
	(set-buffer sj3-result-buffer)
	(erase-buffer)
	(setq sj3-bunsetu-suu 0)
	(setq sj3-yomi-llist nil)
	(goto-char (point-min))
	(sj3-command-start SJ3_BEGIN)
	(sj3-put-string* henkan-string)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)
	(if (not (= sj3-return-code 0)) nil
	  (let (p0 yl kanji offset)
	    (sj3-get-4byte)
	    (set-buffer sj3-result-buffer)
	    (delete-region (point) (point-max))
	    (setq p0 (point))
	    (insert sj3-henkan-string 0 0 0 0)
	    (goto-char p0)
	    (set-buffer sj3-server-buffer)
	    (while (> (setq yl (sj3-get-byte)) 0)
	      (sj3-skip-nbyte sj3-stdy-size) ;;; skip study-data
	      (setq kanji (sj3-get-string*))
	      (set-buffer sj3-result-buffer)
	      (setq p0 (point))
	      (forward-char yl)
	      (setq sj3-yomi-llist (append sj3-yomi-llist (list yl)))
	      (insert 0)  ;;; yomi
	      (sj3-put-4byte 1) ;;; kouho suu
	      (sj3-put-4byte 0)  ;;; current kouho number
	      (sj3-put-stdy-dmy) ;;; study-data
	      (insert kanji 0)
	      (setq offset (- (point) p0))
	      (goto-char p0) (sj3-put-4byte offset)
	      (goto-char (+ (point) offset))
	      (setq sj3-return-code (1+ sj3-return-code))
	      (set-buffer sj3-server-buffer))
	    (setq sj3-bunsetu-suu sj3-return-code)
	    sj3-return-code))))))
;;;
;;; entry function
;;;
(defun sj3-server-henkan-quit () t)

(defun sj3-get-yomi-suu-org ()
  (if (setq sj3-yomi-llist (cdr sj3-yomi-llist))
      (car sj3-yomi-llist)
    0))

;;;
;;; entry function
;;;
(defun sj3-server-henkan-end (bunsetu-no)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(let (length ystr len kouho-no kouho-suu p0 (ylist nil))
	  (set-buffer sj3-result-buffer)
	  (goto-char (point-min))
	  (let ((max (if (and (integerp bunsetu-no)
			      (<= 0 bunsetu-no)
			      (<= bunsetu-no sj3-bunsetu-suu))
			 bunsetu-no
		       sj3-bunsetu-suu))
		(i 0))
	    (while (< i max)
	      (setq length (sj3-get-4byte))
	      (setq p0 (point))
	      (setq ystr (sj3-get-string))
	      (setq len (1- (- (point) p0)))
	      (setq kouho-suu (sj3-get-4byte)) ;;; kouho suu
	      (setq kouho-no (sj3-get-4byte))
	      (if (and (> kouho-no 0) (< kouho-no (- kouho-suu 2)))
		  (sj3-server-t-study len ystr kouho-no))
	      (setq ylist (cons (list len ystr kouho-suu (point)) ylist))
	      (goto-char (+ p0 length))
	      (setq i (1+ i)))
	    (setq ylist (nreverse ylist))
	    (setq i 1)
	    (let ((yp 0) (op 0) (ydata (car ylist)) (ol (car sj3-yomi-llist)))
	      (while (< i max)
		(let ((yl (nth 0 ydata)))
		  (setq ylist (cdr ylist))
		  (if (and (= yp op) (= yl ol))
		      (let ((pp (+ yp yl)))
			(setq yp pp)
			(setq op pp)
			(setq ydata (car ylist))
			(setq ol (sj3-get-yomi-suu-org)))
		    (let ((str (nth 1 ydata))
			  (ent (nth 2 ydata)))
		      (setq ydata (car ylist))
		      (setq yp (+ yp yl))
		      (while (< op yp)
			(setq op (+ op ol))
			(setq ol (sj3-get-yomi-suu-org)))
		      (if (or (= ent 2) (= (nth 2 ydata) 2)) nil
			(let ((sub (- op yp)) (yl1 (nth 0 ydata)))
			  (set-buffer sj3-result-buffer)
			  (goto-char (nth 3 ydata))
			  (sj3-server-b-study str (nth 1 ydata))
			  (if (and (not (= sub yl1)) (not (= sub (- yl1 ol))))
			      nil
			    (setq i (1+ i))
			    (setq ylist (cdr ylist))
			    (setq ydata (car ylist))
			    (if (= sub yl1) nil
			      (setq op (+ op ol))
			      (setq ol (sj3-get-yomi-suu-org))))))))
		      (setq i (1+ i))))
	    (if (or (null ydata) (= (nth 0 ydata) ol) (= (nth 2 ydata) 2))
		sj3-return-code
	      (goto-char (nth 3 ydata))
	      (sj3-server-b-study (nth 1 ydata) "")))))))))

(defun sj3-server-b-study (str1 str2)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (save-excursion
      (sj3-command-start SJ3_END)
      (sj3-put-string* str1)
      (sj3-put-string* str2)
      (if (string= str2 "")
	  (let ((i 0))
	    (while (< i sj3-stdy-size)
	      (insert 0)
	      (setq i (1+ i))))
	(let ((i 0) ch)
	  (while (< i sj3-stdy-size)
	    (set-buffer sj3-result-buffer)
	    (setq ch (sj3-get-byte))
	    (set-buffer sj3-command-buffer)
	    (insert ch)
	    (setq i (1+ i)))))
      (sj3-command-end)
      (sj3-get-result)
      (sj3-get-return-code))))
    
(defun sj3-server-t-study (len str no)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (save-excursion
      (sj3-command-start SJ3_KOUHO)
      (sj3-put-4byte len)
      (sj3-put-string* str)
      (sj3-command-end)
      (sj3-get-result)
      (sj3-get-return-code)
      (if (not (= sj3-return-code 0)) nil
	(let ((i 0))
	  (set-buffer sj3-server-buffer)
	  (while (not (= (sj3-get-4byte) 0))
	    (if (= i no)
	      (let ((c 0) ch)
		(sj3-command-start SJ3_STDY)
		(while (< c sj3-stdy-size)
		  (set-buffer sj3-server-buffer)
		  (setq ch (sj3-get-byte))
		  (set-buffer sj3-command-buffer)
		  (insert ch)
		  (setq c (1+ c)))
		(set-buffer sj3-server-buffer))
	      (sj3-skip-nbyte sj3-stdy-size))
	    (sj3-get-string*)
	    (setq i (1+ i)))
	  (sj3-command-end)
	  (sj3-get-result)
	  (sj3-get-return-code))))))

(defun sj3-result-goto-bunsetu (bunsetu-no)
  (goto-char (point-min))
  (let (length (i 0))
    (while (< i bunsetu-no)
      (setq length (sj3-get-4byte))
      (goto-char (+ (point) length))
      (setq i (1+ i)))))
	      
;;;
;;; entry function
;;;
(defun sj3-server-henkan-kakutei (bunsetu-no jikouho-no)
  (cond((not (sj3-server-active-p)) (sj3-connection-error))
       ((or (< bunsetu-no 0) (<= sj3-bunsetu-suu bunsetu-no))
	nil)
       (t 
	(let ((inhibit-quit t))
	  (save-excursion
	    (set-buffer sj3-result-buffer)
	    (let (kouho-suu)
	      (sj3-result-goto-bunsetu bunsetu-no)
	      (sj3-skip-length)
	      (sj3-skip-yomi)
	      (setq kouho-suu (sj3-get-4byte))
	      (if (or (< jikouho-no 0) (<= kouho-suu jikouho-no)) nil
		(delete-char 4) (sj3-put-4byte jikouho-no)
		t)))))))

(defun sj3-server-henkan-kouho-suu (yomi-length yomi)
  (save-excursion
    (sj3-command-start SJ3_KOUHOSU)
    (sj3-put-4byte yomi-length)
    (sj3-put-string* yomi)
    (sj3-command-end)
    (sj3-get-result)
    (sj3-get-return-code)
    (if (not (= sj3-return-code 0)) -1
      (sj3-get-4byte))))

;;;
;;; entry function
;;;
(defun sj3-server-henkan-next (bunsetu-no)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(let (p0 p1 kouho-suu length ystr yl)
	  (set-buffer sj3-result-buffer)
	  (sj3-result-goto-bunsetu bunsetu-no)
	  (setq length (sj3-get-4byte))
	  (setq p0 (point))
	  (setq p1 (+ p0 length))
	  (setq ystr (sj3-get-string))
	  (setq yl (1- (- (point) p0)))
	  (setq kouho-suu (sj3-peek-4byte))
	  (cond((< 1 kouho-suu) t)
	       (t
		(let ((ksuu (sj3-server-henkan-kouho yl ystr)))
		  (if (< ksuu 0) sj3-return-code
		    (let (kanji yp)
		      (setq ksuu (+ ksuu 2))
		      (set-buffer sj3-result-buffer)
		      (delete-char 4)
		      (sj3-put-4byte ksuu)
		      (delete-char 4)
		      (sj3-put-4byte 0) ;;; current jikouho number
		      (sj3-skip-stdy)
		      (delete-region (point) p1)
		      (if (<= ksuu 2) nil
			(set-buffer sj3-server-buffer)
			(while (not (= (sj3-get-4byte) 0))
			  (sj3-skip-nbyte sj3-stdy-size)
			  (setq kanji (sj3-get-string*))
			  (set-buffer sj3-result-buffer)
			  (insert kanji 0)
			  (set-buffer sj3-server-buffer)))
		      (set-buffer sj3-result-buffer)
		      (sj3-put-kata yl ystr)
		      (insert ystr 0)
		      (setq length (- (point) p0))
		      (goto-char p0) (delete-char -4)
		      (sj3-put-4byte length))
		    t)))))))))

(defun sj3-server-henkan-kouho (len str)
  (save-excursion
    (let ((kouho-suu (sj3-server-henkan-kouho-suu len str)))
      (if (<= kouho-suu 0) nil
	(sj3-command-start SJ3_KOUHO)
	(sj3-put-4byte len)
	(sj3-put-string* str)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)
	(if (not (= sj3-return-code 0))
	    (setq kouho-suu -1)))
      kouho-suu)))

(defun sj3-put-kata (len str)
  (let ((point (point)))
    (insert str 0)
    (goto-char point)
    (let ((i 0) ch)
      (while (< i len)
	(setq ch (sj3-get-byte))
	(if (< ch 128)
	    (setq i (1+ i))
	  (setq i (+ i 2))
	  (if (not (= ch 164))
	      (forward-char 1)
	    (delete-char -1)
	    (insert 165)
	    (forward-char 1)))))
    (forward-char 1)))

;;;
;;; entry function
;;;
(defun sj3-server-bunsetu-henkou (bunsetu-no bunsetu-length)
  (cond((not (sj3-server-active-p)) (sj3-connection-error))
       ((or (< bunsetu-no 0) (<= sj3-bunsetu-suu bunsetu-no))
	nil)
       (t
	(let ((inhibit-quit t))
	  (save-excursion
	    (let (yp0 p0 p1 str len1 len2 bunsetu-suu (bno bunsetu-no))
	      (set-buffer sj3-result-buffer)
	      (setq yp0 (sj3-yomi-point bunsetu-no))
	      (setq p0 (point))
	      (setq str (sj3-get-yomi* yp0 bunsetu-length))
	      (setq len1 (length str))
	      (setq bunsetu-suu sj3-bunsetu-suu)
	      (let (point length)
		(setq len2 len1)
		(while (and (< bno sj3-bunsetu-suu) (> len2 0))
		  (setq length (sj3-get-4byte))
		  (setq point (point))
		  (skip-chars-forward "^\0")
		  (setq len2 (- len2 (- (point) point)))
		  (goto-char (+ point length))
		  (setq bno (1+ bno))))
	      (setq p1 (point))
	      (delete-region p0 p1)
	      (goto-char p0)
	      (setq sj3-bunsetu-suu (- sj3-bunsetu-suu (- bno bunsetu-no)))
	      (if (not (= (sj3-put-tanconv len1 str) 0)) nil)
	      (if (= len2 0) nil
		(let ((len (- 0 len2)) (yp1 (+ yp0 len1)) ystr)
		  (if (or (> bno (1+ bunsetu-no)) (= bno bunsetu-suu))
		      (setq ystr (sj3-get-yomi yp1 len))
		    (let (ll length i)
		      (set-buffer sj3-result-buffer)
		      (setq p0 (point))
		      (setq length (sj3-get-4byte))
		      (skip-chars-forward "^\0")
		      (setq ll (+ len (- (point) (+ p0 4))))
		      (setq p1 (+ p0 (+ length 4)))
		      (setq ystr (sj3-get-yomi yp1 ll))
		      (setq i (sj3-server-henkan-kouho-suu ll ystr))
		      (set-buffer sj3-result-buffer)
		      (if (= i 0) (setq ystr (sj3-get-yomi yp1 len))
			(delete-region p0 p1)
			(setq sj3-bunsetu-suu (1- sj3-bunsetu-suu))
			(setq len ll))
		      (goto-char p0)))
		      (sj3-put-tanconv len ystr)))
	      (if (= sj3-return-code -1) nil
		sj3-bunsetu-suu)))))))

(defun sj3-put-tanconv (len str)
  (let ((point (point)) (ksuu (sj3-server-henkan-kouho-suu len str)) offset)
    (if (< ksuu 0) nil
      (set-buffer sj3-result-buffer)
      (insert str 0)
      (if (= ksuu 0)
	  (put-kata-and-hira len str)
	(put-tanconv len str))
      (set-buffer sj3-result-buffer)
      (setq offset (- (point) point))
      (goto-char point) (sj3-put-4byte offset)
      (goto-char (+ (point) offset))
      (setq sj3-bunsetu-suu (1+ sj3-bunsetu-suu))))
  sj3-return-code)
		    
(defun put-tanconv (len str)
  (sj3-command-start SJ3_TANCONV)
  (sj3-put-4byte len)
  (sj3-put-string* str)
  (sj3-command-end)
  (sj3-get-result)
  (sj3-get-return-code)
  (if (not (= sj3-return-code 0))
      (put-kata-and-hira len str)
    (let ((i 0) c kanji)
      (set-buffer sj3-result-buffer)
      (sj3-put-4byte 1)
      (sj3-put-4byte 0)
      (set-buffer sj3-server-buffer)
      (sj3-get-4byte)
      (while (< i sj3-stdy-size)
	(setq c (sj3-get-byte))
	(set-buffer sj3-result-buffer)
	(insert c)
	(set-buffer sj3-server-buffer)
	(setq i (1+ i)))
      (setq kanji (sj3-get-string*))
      (set-buffer sj3-result-buffer)
      (insert kanji 0))))

(defun put-kata-and-hira (len str)
  (sj3-put-4byte 2)
  (sj3-put-4byte 0)
  (sj3-put-stdy-dmy)
  (sj3-put-kata len str)
  (insert str 0))

(defun sj3-get-yomi (offset length)
  (substring sj3-henkan-string offset (+ offset length)))

(defun sj3-get-yomi* (offset bunsetu-length)
  (let (henkan-string)
    (setq henkan-string (substring sj3-henkan-string offset nil))
    (let ((i 0) (c 0))
      (while (< i bunsetu-length)
	(let (ch)
	  (setq ch (substring henkan-string c (1+ c)))
	  (if (string-lessp ch "\200")
	      (setq c (1+ c))
	    (setq c (+ c 2)))
	  (setq i (1+ i))))
      (substring henkan-string 0 c))))
      
(defun sj3-bunsetu-suu () sj3-bunsetu-suu)

(defun sj3-bunsetu-kanji (bunsetu-no &optional buffer)
  (let ((savebuffer (current-buffer)))
    (unwind-protect 
	(progn
	  (set-buffer sj3-result-buffer)
	  (if (or (< bunsetu-no 0)
		  (<= sj3-bunsetu-suu bunsetu-no))
	      nil
	    (sj3-result-goto-bunsetu bunsetu-no)
	    (sj3-skip-length)
	    (sj3-skip-yomi)

	    (sj3-skip-4byte) ;;; kouho-suu
	    (let ((i 0) (max (sj3-get-4byte)))
	      (sj3-skip-stdy)
	      (while (< i max)
		(sj3-skip-yomi)
		(setq i (1+ i))))
	    
	    (let ( p1 p2 )
	      (setq p1 (point))
	      (skip-chars-forward "^\0") (setq p2 (point))
	      (forward-char 1)
	      (if (null buffer)
		  (concat (buffer-substring p1 p2))
		(set-buffer buffer)
		(insert-buffer-substring sj3-result-buffer p1 p2)
		nil))))
      (set-buffer savebuffer))))

(defun sj3-bunsetu-kanji-length (bunsetu-no)
  (save-excursion
    (set-buffer sj3-result-buffer)
    (if (or (< bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (sj3-skip-yomi)

      (sj3-skip-4byte) ;;; kouho-suu
      (let ((i 0) (max (sj3-get-4byte)))
	(sj3-skip-stdy)
	(while (< i max)
	  (sj3-skip-yomi)
	  (setq i (1+ i))))

      (let ( p1 p3 )
	(setq p1 (point))
	(skip-chars-forward "^\0")
	(setq p3 (point))
	(- p3 p1)))))

(defun sj3-bunsetu-yomi-moji-suu (bunsetu-no)
  (save-excursion
    (set-buffer sj3-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (let ((c 0) ch)
	(while (not (zerop (setq ch (following-char))))
	  (if (<= 128 ch) (forward-char 2)
	    (forward-char 1))
	  (setq c (1+ c)))
	c))))

(defun sj3-yomi-point (bunsetu-no)
  (let ((i 0) (len 0) point length)
    (goto-char (point-min))
    (while (< i bunsetu-no)
      (setq length (sj3-get-4byte))
      (setq point (point))
      (skip-chars-forward "^\0")
      (setq len (+ len (- (point) point)))
      (goto-char (+ point length))
      (setq i (1+ i)))
      len))

(defun sj3-bunsetu-yomi (bunsetu-no &optional buffer)
  (let ((savebuff (current-buffer)))
    (unwind-protect 
	(progn
	  (set-buffer sj3-result-buffer)
	  (if (or (<  bunsetu-no 0)
		  (<= sj3-bunsetu-suu bunsetu-no))
	      nil
	    (sj3-result-goto-bunsetu bunsetu-no)
	    (sj3-skip-length)
	    (let (p1 p2 )
	      (setq p1 (point))
	      (skip-chars-forward "^\0")
	      (if (null buffer ) (buffer-substring p1 (point))
		(setq p2 (point))
		(set-buffer buffer)
		(insert-buffer-substring sj3-result-buffer p1 p2)
		t))))
      (set-buffer savebuff))))

(defun sj3-bunsetu-yomi-equal (bunsetu-no yomi)
  (save-excursion
    (set-buffer sj3-result-buffer)
      (if (or (<  bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (looking-at yomi))))

(defun sj3-bunsetu-kouho-suu (bunsetu-no)
  (save-excursion
    (set-buffer sj3-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (sj3-skip-yomi)
      (sj3-get-4byte))))

(defun sj3-bunsetu-kouho-list (bunsetu-no)
  (save-excursion
    (set-buffer sj3-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (sj3-skip-yomi)
      (let ((max (sj3-get-4byte)) (i 0) (result nil) p0)
	(sj3-skip-4byte) ;;; current kouhou number
	(sj3-skip-stdy)
	(while (< i max)
	  (setq p0 (point))
	  (skip-chars-forward "^\0")
	  (setq result
		(cons (concat (buffer-substring p0 (point)))
		      result))
	  (forward-char 1)
	  (setq i (1+ i)))
	(nreverse result)))))

(defun sj3-bunsetu-kouho-number (bunsetu-no)
  (save-excursion
    (set-buffer sj3-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= sj3-bunsetu-suu bunsetu-no))
	nil
      (sj3-result-goto-bunsetu bunsetu-no)
      (sj3-skip-length)
      (sj3-skip-yomi)
      (sj3-skip-4byte)
      (sj3-get-4byte)))
  )

(defun sj3-simple-command (op arg)
  (if (sj3-server-active-p)
      (let ((inhibit-quit t))
	(save-excursion
	  (sj3-command-start op)
	  (sj3-put-4byte arg)
	  (sj3-command-end)
	  (sj3-get-result)
	  (sj3-get-return-code)))
    (sj3-connection-error)))

(defun sj3-server-open-dict (dict-file-name password)
  (if (not (sj3-server-active-p))(sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_DICADD)
	(sj3-put-string dict-file-name)
	(if (stringp password)
	    (sj3-put-string password)
	  (sj3-put-string 0))
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)
	(if (not (= sj3-return-code 0)) nil
	  (let ((dict-no (sj3-get-4byte)))
	    (if (stringp password)
		(setq sj3-user-dict-list
		      (append sj3-user-dict-list (list dict-no)))
	      (setq sj3-sys-dict-list
		    (append sj3-sys-dict-list (list dict-no))))
	    dict-no))))))

(defun sj3-server-close-dict (dict-no)
  (if (not (sj3-server-active-p))(sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_DICDEL)
	(sj3-put-4byte dict-no)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-make-dict (dict-file-name)
  (if (not (sj3-server-active-p))(sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_MKDIC)
	(sj3-put-string dict-file-name)
	(sj3-put-4byte 2048)  ;;; Index length
	(sj3-put-4byte 2048)  ;;; Length
	(sj3-put-4byte 256)   ;;; Number
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-open-stdy (stdy-file-name)
  (if (not (sj3-server-active-p))(sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_OPENSTDY)
	(sj3-put-string stdy-file-name)
	(sj3-put-string 0)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-close-stdy ()
  (sj3-zero-arg-command SJ3_CLOSESTDY))

(defun sj3-server-make-stdy (stdy-file-name)
  (if (not (sj3-server-active-p))(sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_MKSTDY)
	(sj3-put-string stdy-file-name)
	(sj3-put-4byte 2048)  ;;; Number
	(sj3-put-4byte 1)     ;;; Step
	(sj3-put-4byte 2048)  ;;; Length
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-dict-add (dictno kanji yomi bunpo)
  (if (not (sj3-server-active-p))(sj3-connection-error) 
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_WREG)
	(sj3-put-4byte dictno)
	(sj3-put-string* yomi)
	(sj3-put-string* kanji)
	(sj3-put-4byte bunpo)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-dict-delete (dictno kanji yomi bunpo)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_WDEL)
	(sj3-put-4byte dictno)
	(sj3-put-string* yomi)
	(sj3-put-string* kanji)
	(sj3-put-4byte bunpo)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-dict-info (yomi)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(let (kouho-suu (ylen (length yomi)))
	  (setq kouho-suu (sj3-server-henkan-kouho ylen yomi))
	  (if (<= kouho-suu 0) nil
	    (let (kanji (sysdic (car sj3-sys-dict-list)) (result nil))
	      (set-buffer sj3-server-buffer)
	      (while (not (= (sj3-get-4byte) 0))
		(sj3-skip-nbyte sj3-stdy-size)
		(setq kanji (sj3-get-string*))
		(setq result (cons (list kanji 190 sysdic) result)))
	      (setq result (nreverse result))
	      (let (dict-no (dict-list sj3-user-dict-list))
		(while (and (sj3-server-active-p) 
			    (setq dict-no (car dict-list)))
		  (setq dict-list (cdr dict-list))
		  (sj3-simple-command SJ3_WSCH dict-no)
		  (while (= sj3-return-code 0)
		    (sj3-get-4byte)
		    (let ((ystr (sj3-get-string*)))
		      (if (string-lessp yomi ystr)
			  (setq sj3-return-code -1)
			(if (not (string= ystr yomi)) nil
			  (let ((resl nil)
				(kstr1 (sj3-get-string*))
				(bunpo (sj3-get-4byte))
				res)
			    (while (setq res (car result))
			      (let ((kstr2 (nth 0 res))
				    (dicno (nth 2 res)))
				(setq result (cdr result))
				(if (or (not (= dicno sysdic))
					(not (string= kstr1 kstr2))) nil
				  (setq res (list kstr1 bunpo dict-no))
				  (setq kstr1 ""))
				(setq resl (cons res resl))))
			    (setq result (nreverse resl))))))
			(sj3-simple-command SJ3_WNSCH dict-no))))
	      (setq sj3-error-code nil)
	      result)))))))

(defun sj3-server-make-directory (dir-name)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_MKDIR)
	(sj3-put-string dir-name)
	(sj3-command-end)
	(sj3-get-result)
	(sj3-get-return-code)))))

(defun sj3-server-file-access (file-name access-mode)
  (if (not (sj3-server-active-p)) (sj3-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(sj3-command-start SJ3_ACCESS)
	(sj3-put-string file-name)
	(sj3-put-4byte access-mode)
	(sj3-command-end)
	(sj3-get-result)
	(setq sj3-error-code nil)
	(sj3-get-4byte)))))

(defun sj3_lock ()
  (sj3-zero-arg-command SJ3_LOCK))

(defun sj3_unlock ()
  (sj3-zero-arg-command SJ3_UNLOCK))

(defun sj3_version ()
  (sj3-zero-arg-command SJ3_VERSION))

(defconst *sj3-error-alist*
  '(
    (1 :SJ3_SERVER_DEAD
       "�����Ф����Ǥ��ޤ���")
    (2 :SJ3_SOCK_OPEN_FAIL
       "socket��open�˼��Ԥ��ޤ�����")
    (6 :SJ3_ALLOC_FAIL
       "����alloc�Ǽ��Ԥ��ޤ�����")
    (12 :SJ3_BAD_HOST
	" �ۥ���̾���ʤ� ")
    (13 :SJ3_BAD_USER
	" �桼��̾���ʤ� ")
    (31 :SJ3_NOT_A_DICT
	"����������ǤϤ���ޤ���")
    (35 :SJ3_NO_EXIST     
	"�ե����뤬¸�ߤ��ޤ���")
    (37 :SJ3_OPENF_ERR
	"�ե����뤬�����ץ�Ǥ��ޤ���")
    (39 :SJ3_PARAMR
	"�ե�������ɤ߹��߸��¤�����ޤ���")
    (40 :SJ3_PARAMW
	"�ե�����ν񤭹��߸��¤�����ޤ���")
    (71 :SJ3_NOT_A_USERDICT
	"���ꤵ��Ƽ���ϡ��桼��������ǤϤ���ޤ���")
    (72 :SJ3_RDONLY
	"�꡼�ɥ���꡼�μ������Ͽ���褦�Ȥ��ޤ�����")
    (74 :SJ3_BAD_YOMI
	"�ɤߤ���Ŭ����ʸ�����ޤޤ�Ƥ��ޤ���")
    (75 :SJ3_BAD_KANJI
	"��������Ŭ����ʸ�����ޤޤ�Ƥ��ޤ���")
    (76 :SJ3_BAD_HINSHI
	"���ꤵ�줿�ʻ��ֹ椬����ޤ���")
    (82 :SJ3_WORD_ALREADY_EXIST
	"���ꤵ�줿ñ��Ϥ��Ǥ�¸�ߤ��Ƥ��ޤ���")
    (84 :SJ3_JISHOTABLE_FULL
	"����ơ��֥뤬���դǤ���")
    (92 :SJ3_WORD_NO_EXIST
	"���ꤵ�줿ñ�줬¸�ߤ��ޤ���")
    (102 :SJ3_MKDIR_FAIL
	" �ǥ��쥯�ȥ����»�ʤä� ")
    ))

(defun sj3-error-symbol (code)
  (let ((pair (assoc code *sj3-error-alist*)))
    (if (null pair)
	(list ':sj3-unknown-error-code code)
      (car (cdr pair)))))

