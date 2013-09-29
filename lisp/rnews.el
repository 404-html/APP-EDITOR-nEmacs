;;;  Ver.18.42f  modified by S. Tomura 89-Sep-4
;;;              a bug fixed.
;;;  Ver.18.52e  modified by S. Tomura 89-Aug-8
;;;              "A" "D" command added.
;;;  Ver.18.52d  mofified by S. Tomura 89-Aug-8
;;;              gred-open modified. (open check)
;;;  Ver.18.52c  modified by S. Tomura 89-Aug-6
;;;              *-force-update-to-end added.
;;;  Ver.18.52b  modified by S. Tomura 89-Jul-5
;;;              regexp-quote added
;;;  Ver.18.52b  modified by S. Tomura 89-May-11
;;;              nntp-server-active-p ==> nntp-server-opened
;;;  Ver.18.52a  modified by S. Tomura 89-Apr-3
;;;              bind require-final-newline to nil
;;;; Ver.18.52   created by S. Tomura 89-Mar-16
;;; Nemacs Ver.3.0
;;;  Ver.18.50c  modified by S. Tomura 88-Jul-14
;;;              Use egrep to make a news summary
;;;  Ver.18.50b  modified by S. Tomura 88-Jul-11
;;;              Use write-region instead of write-file because of kill-local-variable bug.
;;;; Ver.18.50a  modified by S. Tomura 88-Jul-8
;;;;             news-summary makes headers from current article.
;;;; Ver.18.50   created by S. Tomura 88-Jun-11
;;; Nemacs Ver.2.1   
;;;; Ver.18.47j  modified by S. Tomura 88-May-23
;;;;             some mistypes corrected
;;;; Ver.18.47i  modified by S. Tomura 88-May-20
;;;;             "C": Cancel command entry added.
;;;; Ver.18.47h  modified by S. Tomura 88-May-15
;;;;             news-goto-next-message modified
;;;; Ver.18.47g  modified by S. Tomura 88-Mar-29
;;;;             news-find-new-news-group added
;;;; Ver.18.47f  modified by S. Tomura 88-Mar-25
;;;;             Minor modifications done.
;;;; Ver.18.47e  modified by S. Tomura 88-Feb-14
;;;;             changed not to use news-list-of-files and ...pruned-... .
;;;; Ver.18.47d  modified by S. Tomura 88-Feb-13
;;;;             Bugs in ...pruned-... fixed.
;;;;             Changed not to use certification file.
;;;; Ver.18.47c  modefied by S. Tomura 88-Feb-12
;;;;             Rnews summary mode added.
;;;; Ver.18.47b  modified by S. Tomura 88-Feb-9
;;;;             Misuse of rmail-last-file fixed.
;;;; Ver.18.47a  modified by S. Tomura 88-Feb-8
;;;;             "Add group" command prompts group name 
;;;;             with completion facility.
;;;; modified by S.Tomura 87.6.18 /usr/lib/news/active is used
;;;; modified by T.Tomura 87.6.15 rn compatibility
;;;; modified by K.Handa  87.5.1  "N" and "P" command added
;;;
;;; USENET news reader for gnu emacs
;; Copyright (C) 1985, 1986, 1987 Free Software Foundation, Inc.

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

;; Created Sun Mar 10,1985 at 21:35:01 ads and sundar@hernes.ai.mit.edu
;; Should do the point pdl stuff sometime
;; finito except pdl.... Sat Mar 16,1985 at 06:43:44
;; lets keep the summary stuff out until we get it working ..
;;	sundar@hermes.ai.mit.edu Wed Apr 10,1985 at 16:32:06
;; hack slash maim. mly@prep.ai.mit.edu Thu 18 Apr, 1985 06:11:14
;; modified to correct reentrance bug, to not bother with groups that
;;   received no new traffic since last read completely, to find out
;;   what traffic a group has available much more quickly when
;;   possible, to do some completing reads for group names - should
;;   be much faster...
;;	KING@KESTREL.arpa, Thu Mar 13 09:03:28 1986
;; made news-{next,previous}-group skip groups with no new messages; and
;; added checking for unsubscribed groups to news-add-news-group
;;	tower@prep.ai.mit.edu Jul 18 1986
;; bound rmail-output to C-o; and changed header-field commands binding to
;; agree with the new C-c C-f usage in sendmail
;; 	tower@prep Sep  3 1986
;; added news-rotate-buffer-body
;;	tower@prep Oct 17 1986
;; made messages more user friendly, cleanuped news-inews
;; move posting and mail code to new file rnewpost.el
;;	tower@prep Oct 29 1986
;; added caesar-region, rename news-caesar-buffer-body, hacked accordingly
;;	tower@prep Nov 21 1986
;; added (provide 'rnews)	tower@prep 22 Apr 87
(provide 'rnews)
(require 'mail-utils)

(autoload 'rmail-output "rmailout"
  "Append this message to Unix mail file named FILE-NAME."
  t)

(autoload 'news-reply "rnewspost"
  "Compose and post a reply to the current article on USENET.
While composing the reply, use \\[mail-yank-original] to yank the original
message into it."
  t)

;;; patch by S. Tomura 88-May-20
(autoload 'news-cancel-news "rnewspost"
  "Cancel the current article."
  t)
;;; end of patch 

(autoload 'news-mail-other-window "rnewspost"
  "Send mail in another window.
While composing the message, use \\[mail-yank-original] to yank the
original message into it."
  t)

(autoload 'news-post-news "rnewspost"
  "Begin editing a new USENET news article to be posted."
  t)

(autoload 'news-mail-reply "rnewspost"
  "Mail a reply to the author of the current article.
While composing the reply, use \\[mail-yank-original] to yank the original
message into it."
  t)

;;; patch by S. Tomura 88-Feb-9
;;; The next defvar is harmfull to rmail system.  Commentted out.
;;;(defvar rmail-last-file (expand-file-name "~/mbox.news"))
;;; end of patch

;Now in paths.el.
;(defvar news-path "/usr/spool/news/"
;  "The root directory below which all news files are stored.")

;;; patch by S. Tomura 89-Sep-6
(defvar archived-news-path nil
  "The root directory below which some news files are archived.")
;;; end of patch

(defvar news-startup-file "$HOME/.newsrc" "Contains ~/.newsrc")
;;; patch by S. Tomura 88-Feb-15
;;;(defvar news-certification-file "$HOME/.news-dates" "Contains ~/.news-dates")
;;;

;; random headers that we decide to ignore.
(defvar news-ignored-headers
  "^Path:\\|^Posting-Version:\\|^Article-I.D.:\\|^Expires:\\|^Date-Received:\\|^References:\\|^Control:\\|^Xref:\\|^Lines:\\|^Posted:\\|^Relay-Version:\\|^Message-ID:\\|^Nf-ID:\\|^Nf-From:\\|^Approved:\\|^Sender:"
  "All random fields within the header of a message.")

(defvar news-mode-map nil)
(defvar news-read-first-time-p t)
;; Contains the (dotified) news groups of which you are a member. 
(defvar news-user-group-list nil)

;;; patch by S.Tomura 88-Feb-14
(defvar news-current-new-articles-p nil)
;;; end of patch
(defvar news-current-news-group nil)
(defvar news-current-group-begin nil)
(defvar news-current-group-end  nil)

;;; patch by S.Tomura 88-Feb-13
;;;(defvar news-current-certifications nil
;;;   	"An assoc list of a group name and the time at which it is
;;;known that the group had no new traffic")
;;;(defvar news-current-certifiable nil
;;;	"The time when the directory we are now working on was written")
;;; end of patch

(defvar news-message-filter nil
  "User specifiable filter function that will be called during
formatting of the news file")

;(defvar news-mode-group-string "Starting-Up"
;  "Mode line group name info is held in this variable")
;;; patch by S. Tomura 88-Feb-14
;;;(defvar news-list-of-files nil
;;;  "Global variable in which we store the list of files
;;;associated with the current newsgroup")
;;; end of patch

;;; patch by S.Tomura 88-Feb-14
;;;(defvar news-list-of-files-possibly-bogus nil
;;;  "variable indicating we only are guessing at which files are available.
;;;Not currently used.")
;;; end of patch

;;; patch by S. Tomura 88-Feb-15
;;;;; association list in which we store lists of the form
;;;;; (pointified-group-name (first last old-last))
;;;(defvar news-group-article-assoc nil)
;;; end of patch
;;; patch by S. Tomura 88-Feb-15
(defvar news-group-article-status nil)
;;; end of patch
  
(defvar news-current-message-number 0 "Displayed Article Number")
(defvar news-total-current-group 0 "Total no of messages in group")

(defvar news-unsubscribe-groups ())
(defvar news-point-pdl () "List of visited news messages.")
(defvar news-no-jumps-p t)
(defvar news-buffer () "Buffer into which news files are read.")

(defmacro news-push (item ref)
  (list 'setq ref (list 'cons item ref)))

(defmacro news-cadr (x) (list 'car (list 'cdr x)))
(defmacro news-cdar (x) (list 'cdr (list 'car x)))
(defmacro news-caddr (x) (list 'car (list 'cdr (list 'cdr x))))
(defmacro news-cadar (x) (list 'car (list 'cdr (list 'car x))))
(defmacro news-caadr (x) (list 'car (list 'car (list 'cdr x))))
(defmacro news-cdadr (x) (list 'cdr (list 'car (list 'cdr x))))

(defmacro news-wins (pfx index)
  (` (file-exists-p (concat (, pfx) "/" (int-to-string (, index))))))

;;; patch by S.Tomura 88-Feb-14
;;;(defvar news-max-plausible-gap 2
;;;	"* In an rnews directory, the maximum possible gap size.
;;;A gap is a sequence of missing messages between two messages that exist.
;;;An empty file does not contribute to a gap -- it ends one.")
;;; end of patch

;;; patch by S.Tomura 87-06-17,87-06-22
;;;(defun news-find-first-and-last (prefix base)
;;;  (and (news-wins prefix base)
;;;       (cons (news-find-first-or-last prefix base -1)
;;;	     (news-find-first-or-last prefix base 1))))
(defvar news-active-file "/usr/lib/news/active" 
  "News system active file name")

(defvar news-active-file-last-modified nil
  "Last modified time of news-active-file")

(defvar news-all-news-group-assoc nil
  "All news group assoc list: Cache of news-active-file contents")

(defun news-get-all-news-group-assoc ()
  (let ((file (substitute-in-file-name news-active-file)))
    (if (not (equal news-active-file-last-modified
		    (nth 5 (file-attributes
			    (or (file-symlink-p file) file)))))
	(save-excursion
	  (let ((activebuf (get-buffer-create "*News Active Group*")))
	    (unwind-protect
		(progn
		  (set-buffer activebuf)
		  (erase-buffer)
		  (setq buffer-read-only nil)
		  (insert-file-contents file)
		  (setq buffer-read-only t)
		  (goto-char 0)
		  (setq news-all-news-group-assoc nil)
		  (while (not (eobp))
		    (let (idstart laststart firststart )
		      (setq idstart (point))
		      (search-forward " ")
		      (setq laststart (point))
		      (search-forward " ")
		      (setq firststart (point))
		      (search-forward " ")
		      (setq news-all-news-group-assoc
			    (cons
			     (cons (buffer-substring idstart (1- laststart))
				   (cons (string-to-int
					  (buffer-substring firststart 
							    (1- (point))))
					 (string-to-int
					  (buffer-substring laststart
							    (1- firststart)))))
			     news-all-news-group-assoc)))
		    (beginning-of-line 2))
		  (setq news-active-file-last-modified
			(nth 5 (file-attributes
				(or (file-symlink-p file) file)))))
	    (kill-buffer activebuf)))))
    news-all-news-group-assoc))

(defun previous-news-get-first-and-last-article-number (groupname)
  ;;;(interactive "sNewsgroup:")
  (cdr (assoc groupname (news-get-all-news-group-assoc))))
;;; end of patch

;;; patch by S.Tomura 88-Jul-14

(defun news-get-first-and-last-article-number (groupname)
  (if (null news-active-file-last-modified)
      (news-get-all-news-group-data)
    (news-get-news-group-data groupname))
  (let ((data (get (intern groupname) ':news-group-data)))
    (if (null data) nil
      (if (equal (get (intern groupname) ':news-update-time)
		 news-active-file-last-modified)
	  data
	nil))))

(defun news-get-news-group-data-from-nntp (gpname)
  (if (nntp-server-opened)
      nil
    (nntp-open-server 
     (or (and (boundp 'nntp-server-host) nntp-server-host)
	 (setq nntp-server-host (read-string "nntp server host name: ")))))
  (and (nntp-request-group gpname)
  (save-excursion
    (set-buffer nntp-server-buffer)
    (goto-char (point-min))
    (re-search-forward "[0-9]+ +[0-9]+ \\([0-9]*\\) +\\([0-9]*\\) +")
    (cons (string-to-int (buffer-substring (match-beginning 1)
					   (match-end 1)))
	  (string-to-int (buffer-substring (match-beginning 2)
					   (match-end 2)))))))
    
(defvar news-news-group-toplevel nil)

(defvar news-user-toplevel nil)

(defun news-make-upper-news-group-name-list (symbol)
  (let ((i 0)next result
	(groupname (symbol-name symbol)))
    (while (string-match "\\." groupname i)
      (setq result (cons (intern (substring groupname 0 (match-beginning 0))) result))
      (setq i (match-end 0)))
    (cons symbol result)))

(defun news-enter-news-group-data (name first last)
  (put name ':news-update-time news-active-file-last-modified)
  (let ((loc (get name ':news-group-data)))
    (if loc (progn
	      (setcar loc first)
	      (setcdr loc last))
      (put name ':news-group-data (cons first last))
      (let ((list (news-make-upper-news-group-name-list name)))
	(while (and (cdr list)
		    (null (memq (car list)
				(get (car(cdr list)) ':news-lower-group))))
	  (put (car (cdr list)) ':news-lower-group-sorted nil)
	  (put (car(cdr list)) ':news-lower-group
	       (cons (car list)
		     (get (car (cdr list)) ':news-lower-group)))
	  (setq list (cdr list)))
	(if (and (null (cdr list))
		 (null (memq (car list) news-news-group-toplevel)))
	    (progn (put 'news-news-group-toplevel ':news-lower-group-sorted nil)
		   (setq news-news-group-toplevel (cons (car list)
					       news-news-group-toplevel)))))))
  )
	
(defun news-get-all-news-group-data ()
  (let ((file (substitute-in-file-name news-active-file)))
    (if (not (equal news-active-file-last-modified
		    (nth 5 (file-attributes
			    (or (file-symlink-p file) file)))))
	(save-excursion
	  (let ((activebuf (get-buffer-create "*News Active Group*")))
	    (message "Wait. Reading active file .....")
	    (set-buffer activebuf)
	    (setq buffer-read-only nil)
	    (erase-buffer)
	    (insert-file-contents file)
	    (setq news-active-file-last-modified
		  (nth 5 (file-attributes
			  (or (file-symlink-p file) file))))
	    (setq buffer-read-only t)
	    (goto-char 0)
	    (while (not (eobp))
	      (let (idstart laststart firststart )
		(setq idstart (point))
		(search-forward " ")
		(setq laststart (point))
		(search-forward " ")
		(setq firststart (point))
		(search-forward " ")
		(news-enter-news-group-data 
		 (intern (buffer-substring idstart (1- laststart)))
		 (string-to-int (buffer-substring firststart  (1- (point))))
		 (string-to-int (buffer-substring laststart   (1- firststart)))))
	      (beginning-of-line 2))
	    ;;;(kill-buffer activebuf)
	    (message "")))))
  )

(defun news-get-news-group-data (groupname)
  (let* ((groupsym (intern groupname))
	 (file (substitute-in-file-name news-active-file))
	 (last-modified 
	  (nth 5 (file-attributes
		  (or (file-symlink-p file) file)))))
    (if (equal (get groupsym ':news-update-time)
	       last-modified)
	nil
      (save-excursion
	(message "Wait. Active file has been modified....")
	(let ((activebuf (get-buffer-create "*News Active Group*")))
	  (set-buffer activebuf)
	  (if (equal news-active-file-last-modified
		     last-modified)
	      nil
	    (let ((buffer-read-only nil))
	      (erase-buffer)
	      (insert-file-contents file)
	      (setq news-active-file-last-modified
		    (nth 5 (file-attributes
			    (or (file-symlink-p file) file))))))
	  (goto-char (point-min))
	  (if (re-search-forward (concat "^" (regexp-quote groupname) " ") (point-max) t)
	      (let (idstart laststart firststart )
		(beginning-of-line)
		(setq idstart (point))
		(search-forward " ")
		(setq laststart (point))
		(search-forward " ")
		(setq firststart (point))
		(search-forward " ")
		(news-enter-news-group-data 
		 (intern (buffer-substring idstart (1- laststart)))
		 (string-to-int (buffer-substring firststart  (1- (point))))
		 (string-to-int (buffer-substring laststart   (1- firststart)))))
	    ))
	(message "")))))

(defun news-get-lower-group-list (group-symbol)
  (news-get-all-news-group-data)
  (if group-symbol
      (if (get group-symbol ':news-lower-group-sorted)
	  (get group-symbol ':news-lower-group)
	(put group-symbol ':news-lower-group-sorted t)
	(put group-symbol ':news-lower-group 
	     (sort (get group-symbol ':news-lower-group) 'string-lessp)))
    (if (get 'news-news-group-toplevel ':news-lower-group-sorted)
	(append '(====\ User\ Top\ Level\ ====)
		news-user-toplevel
		'(====\ End\ of\ Top\ Level====)
		news-news-group-toplevel)
      (put 'news-news-group-toplevel ':news-lower-group-sorted t)
      (append '(====\ User\ Top\ Level\ ====)
	      news-user-toplevel
	      '(====\ End\ of\ Top\ Level====)
	      (setq news-news-group-toplevel
		    (sort news-news-group-toplevel 'string-lessp))))))
  
(defvar news-gred-unsubscribed-group-visible nil)

(defvar gred-mode-map (make-keymap))

(suppress-keymap gred-mode-map)
(define-key gred-mode-map "o" 'news-gred-open)
(define-key gred-mode-map "c" 'news-gred-close)
(define-key gred-mode-map "D" 'news-gred-delete-toplevel)
(define-key gred-mode-map "a" 'news-gred-add)
(define-key gred-mode-map "A" 'news-gred-add-toplevel)
(define-key gred-mode-map "u" 'news-gred-unsubscribe)
(define-key gred-mode-map "n" 'news-gred-next-group)
(define-key gred-mode-map "\C-n" 'news-gred-next-group)
(define-key gred-mode-map "p" 'news-gred-previous-group)
(define-key gred-mode-map "\C-p" 'news-gred-previous-group)
(define-key gred-mode-map "r" 'news-gred-read)
(define-key gred-mode-map "q" 'news-gred-quit)
(define-key gred-mode-map "t" 'news-gred-make-unsubscribed-group-visible)

(defun news-gred-make-unsubscribed-group-visible ()
  (interactive)
  (let ((buffer-read-only nil))
    (setq news-gred-unsubscribed-group-visible (not news-gred-unsubscribed-group-visible))
    (erase-buffer)
    (news-gred-open)
    (delete-char 1)))

(defvar news-gred-buffer nil)

(defun gred-mode ()
  (interactive)
  (setq major-mode 'gred-mode)
  (setq mode-name "GrEd")
  (use-local-map gred-mode-map)
  )

(defvar news-gred-unsubscribed-mark ?\\)
(defvar news-gred-unseen-mark       ?!)
(defvar news-gred-newgroup-mark     ??)
(defvar news-gred-bogus-mark        ?<)
(defvar news-gred-nothing-mark      ? )
(defvar news-gred-nonleaf-mark      ?>) 

(defun news-gred ()
  (interactive)
  ;;; setup for rnews buffer
    (let ((last-buffer (buffer-name)))
      (news-read-group-article-status)
      (setq news-buffer (get-buffer-create "*news*")
	    news-summary-buffer (get-buffer-create "*News Summary*")
	    news-gred-buffer (get-buffer-create  "*News Group Editor*"))
      (switch-to-buffer news-gred-buffer)
      (delete-other-windows)

      (set-buffer news-buffer)
      (news-mode)
      (setq news-buffer-save last-buffer)
      (let ((buffer-read-only nil))
	(erase-buffer))
      ;;(set-buffer-modified-p t)
      ;;(sit-for 0)
      (news-set-mode-line)
      ;;;
      (or news-group-article-status
	  (news-read-group-article-status))
      (set-buffer news-summary-buffer)
      (setq news-summary-minor-modes (list ": " nil))
      (news-summary-mode)
      (let ((buffer-read-only nil))
	(erase-buffer))
      ;;;
      (set-buffer news-gred-buffer)
      (gred-mode)
      (setq buffer-read-only t)
      (let ((buffer-read-only nil))
	(erase-buffer)
	(news-gred-open)
	(delete-char 1))
      ))
;;; 
(defconst news-gred-prefix-pat " *[^ ]? +[^ ]")

(defun news-gred-level-prefix (level)
  (cond((= level 0) "  ")
       ((= level 1) "   ")
       ((= level 2) "    ")
       ((= level 3) "     ")
       (t (make-string (+ level 2) ?  ))))

(defun news-gred-level-prefix-regexp (level)
  (cond ((= level 0) "^. [^ ]")
	((= level 1) "^ . [^ ]")
	((= level 2) "^  . [^ ]")
	((= level 3) "^   . [^ ]")
	(t (concat "^" (make-string level ? ) ". [^ ]"))))

(defun news-gred-upper-level-prefix-regexp (level)
  (cond ((= level 0) "^. [^ ][^ ]")
	((= level 1) "^.?. [^ ][^ ]")
	((= level 2) "^.?.?. [^ ][^ ]")
	((= level 3) "^.?.?.?. [^ ][^ ]")
	(t (let ((pat (make-string (* level 2) ?? ))
		 (i (- (* level 2) 1)))
	     (while (<= 0 i) (aset pat i ?.) (setq i (- i 2)))
	     (concat "^" pat ". [^ ][^ ]")))))

(defun news-gred-open ()
  (interactive)
  (beginning-of-line)
  (save-excursion
    (let ((buffer-read-only nil))
      (let (level newlevel group lower nextlevel)
	(if (looking-at news-gred-prefix-pat)
	    (progn
	      (setq level (- (match-end 0) (match-beginning 0) 3))
	      (setq newlevel (news-gred-level-prefix (1+ level)))
	      (setq group (intern (buffer-substring (1- (match-end 0)) (progn (end-of-line) (point)))))
	      (setq lower (news-get-lower-group-list group)))
	  (setq level -1)
	  (setq newlevel (news-gred-level-prefix 0))
	  (setq group nil)
	  (setq lower (news-get-lower-group-list group)))
	(end-of-line)
	(if (eobp) (setq nextlevel -1)
	  (forward-char 1)
	  (looking-at news-gred-prefix-pat)
	  (setq nextlevel (- (match-end 0)(match-beginning 0) 3))
	  (forward-line -1))
	(if lower
	    (if (<= nextlevel level)
		(progn
		  (end-of-line)
		  (while lower
		    (let ((status (get (car lower) ':news-status)))
		      (if (and (null news-gred-unsubscribed-group-visible)
			       status
			       (null (car status)))
			  nil
			(insert ?\n newlevel (symbol-name (car lower)))
			(let ((status (get (car lower) ':news-status)))
			  ;;;(search-backward "  ") (delete-char 1)
			  (beginning-of-line) (looking-at news-gred-prefix-pat) (goto-char (- (match-end 0) 3))
			  (delete-char 1)
			  (if status  ;;; have status
			      (if (car status) ;;; subscribed news
				  (let ((data (news-get-first-and-last-article-number (symbol-name (car lower)))))
				    (if (null data)
					(insert news-gred-bogus-mark)
				      (if (news-exists-article-unseen (cdr status) (car data) (cdr data))
					  (insert news-gred-unseen-mark)
					(insert news-gred-nothing-mark))))
				(insert news-gred-unsubscribed-mark))
			    (if (get (car lower) ':news-lower-group) 
				(insert news-gred-nonleaf-mark)
			      (if (news-get-first-and-last-article-number (symbol-name (car lower)))
				  (insert news-gred-newgroup-mark)
				(insert " "))))
			  (end-of-line))))
		    (setq lower (cdr lower))))
	      (message "Already opened") (beep))
	  (message "No lower news group") (beep))))))
    
(defun news-gred-update-group-status ()
  (let* ((groupname (news-gred-get-group-name))
	 (groupsym  (intern groupname))
	 (status    (get groupsym ':news-status)))
    (beginning-of-line) (looking-at news-gred-prefix-pat) (goto-char (- (match-end 0) 3))
    (delete-char 1)
    (if status
	(if (car status) ;;; subscribed news
	    (let ((data (news-get-first-and-last-article-number groupname)))
	      (if (null data) (insert news-gred-bogus-mark)
		(if (news-exists-article-unseen (cdr status) (car data) (cdr data))
		    (insert news-gred-unseen-mark)
		  (insert news-gred-nothing-mark))))
	  (if news-gred-unsubscribed-group-visible
	      (insert news-gred-unsubscribed-mark)
	    (beginning-of-line) (kill-line 1)))
      (if (get groupsym ':news-lower-group)
	  (insert news-gred-nonleaf-mark)
	(if (news-get-first-and-last-article-number groupname)
	(insert news-gred-newgroup-mark) (insert " "))))
    (beginning-of-line)))

(defun news-exists-article-unseen (status first last)
  ;;; simple version: to be precise
  (if (< (cdr (car status)) first)
      (setcdr (car status) first))
  (and (not (= first last))
       (<= (1+ first) (1+ (cdr (car status))))
       (<= (1+ (cdr (car status))) last)))

(defun news-gred-close ()
  (interactive)
  (let ((buffer-read-only nil))
    (beginning-of-line)
    (looking-at news-gred-prefix-pat)
    (let ((level (- (match-end 0) (match-beginning 0) 3)))
      (if (= level 0)
	  (progn (beginning-of-line) (message "Top level") (beep))
	(let (point1 point2 (uplevelpat (news-gred-upper-level-prefix-regexp (1- level))))
	  (re-search-backward uplevelpat)
	  (end-of-line) 
	  (setq point1 (point))
	  (if (re-search-forward  uplevelpat nil (point-max))
	      (progn (beginning-of-line) (backward-char 1)))
	  (setq point2 (point))
	  (delete-region point1 point2)
	  (goto-char point1) (beginning-of-line))))))

(defun news-gred-get-group-name ()
  (beginning-of-line)
  (save-excursion
    (looking-at news-gred-prefix-pat)
    (buffer-substring (1- (match-end 0)) (progn (end-of-line) (point)))))

(defun news-gred-add-toplevel (grpname)
  (interactive (list (completing-read "NewsGroup: "
				      news-group-article-status)))
  (let ((prevgrpname (progn (beginning-of-line)
			    (if (bobp) nil (news-gred-get-group-name))))
	(toplevel    (assq ':toplevel news-group-article-status))
	(find nil)
	level)
    (beginning-of-line)
    (looking-at news-gred-prefix-pat)
    (setq level (- (match-end 0) (match-beginning 0) 3))
    (if (not (= level 0))
	(progn (message "Not toplevel.") (beep))
      (if prevgrpname
	  (while (and (not find) toplevel)
	    (if (equal prevgrpname (car toplevel))
		(progn
		  (setcdr toplevel (cons grpname (cdr toplevel)))
		  (setq find t))
	      (setq toplevel (cdr toplevel))))
	(setcdr toplevel (cons grpname (cdr toplevel)))
	(setq find t))
      (setq prevgrpname (if prevgrpname (intern prevgrpname) nil)
	    grpname     (intern grpname)
	    find        nil
	    toplevel    news-user-toplevel)
      (if prevgrpname
	  (while (and (not find) toplevel)
	    (if (eq prevgrpname (car toplevel))
		(progn
		  (setcdr toplevel (cons grpname (cdr toplevel)))
		  (setq find t)
		  )
	      (setq toplevel (cdr toplevel))))
	(setq news-user-toplevel (cons grpname news-user-toplevel))
	(setq find t))
      (if (not find) (progn (message "Not toplevel.") (beep))
	(let((buffer-read-only nil) point)
	  (beginning-of-line)
	  (setq point (point))
	  (erase-buffer)
	  (news-gred-open)
	  (delete-char 1)
	  (goto-char point)
	  (forward-line))))
    ))

(defun news-gred-delete-toplevel ()
  (interactive)
  (let ((grpname (news-gred-get-group-name))
	(toplevel (assq ':toplevel news-group-article-status))
	(find nil)
	list level)
    (beginning-of-line)
    (looking-at news-gred-prefix-pat)
    (setq level (- (match-end 0) (match-beginning 0) 3))
    (if (not (= level 0)) 
	(progn (message "Not toplevel") (beep))
      (while (and (not find) toplevel)
	(if (equal grpname (car (cdr toplevel)))
	    (progn
	      (setcdr toplevel (cdr (cdr toplevel)))
	      (setq find t))
	  (setq toplevel (cdr toplevel))))
      (setq grpname (intern grpname)
	    find    nil
	    list (cons nil news-user-toplevel))
      (setq toplevel list)
      (while (and (not find) toplevel)
	(if (eq grpname (car (cdr toplevel)))
	    (progn
	      (setcdr toplevel (cdr (cdr toplevel)))
	      (setq news-user-toplevel (cdr list))
	      (setq find t))
	  (setq toplevel (cdr toplevel))))
      (if (not find) (progn (message "Not toplevel!" )(beep))
	(let ((buffer-read-only nil) point)
	  (beginning-of-line)
	  (setq point (point))
	  (erase-buffer)
	  (news-gred-open)
	  (delete-char 1)
	  (goto-char point))))))


(defun news-gred-add ()
  (interactive)
  (let* ((buffer-read-only nil)
	 (groupname (news-gred-get-group-name))
	 (groupsym  (intern groupname)))
    (if (news-get-first-and-last-article-number groupname)
	(progn
	  (set-buffer news-buffer)
	  (news-add-news-group groupname)
	  (set-buffer news-gred-buffer)
	  (end-of-line)
	  (search-backward " ")
	  (backward-delete-char 1)
	  (insert news-gred-unseen-mark)
	  (beginning-of-line))
      (message "It is no group name.") (beep))))

(defun news-gred-unsubscribe ()
  (interactive)
  (let* ((buffer-read-only nil)
	 (groupname (news-gred-get-group-name))
	 (groupsym  (intern groupname)))
    (if (news-get-first-and-last-article-number groupname)
	(let ((status (get groupsym ':news-status)))
	  (if status 
	      ;;;	  (news-update-message-read group (news-cdar news-point-pdl))
	      (progn (setcar status nil) 
		     (end-of-line)
		     (search-backward " ")
		     (backward-delete-char 1)
		     (insert news-gred-unsubscribed-mark )
		     (beginning-of-line))
	    (message "Not subscribed to group: %s" grouname)))
      (message "It is not news group.") (beep))))

(defun news-gred-read ()
  (interactive)
  (let* ((groupname (news-gred-get-group-name))
	 (groupsym  (intern groupname))
	 (status (get groupsym ':news-status)))
    (if (and status 
	     (news-get-first-and-last-article-number groupname)
	     (car status) ;;; subscribed
	     )
	(progn
	  (switch-to-buffer news-buffer)
	  (news-goto-news-group groupname)
	  (news-summary)
	  )
      (message "No readable news." ))))

(defun news-gred-next-group ()
  (interactive)
  (set-buffer news-buffer)
  (if news-current-news-group
      (news-update-message-read news-current-news-group
				(news-cdar news-point-pdl)))
  (set-buffer news-gred-buffer)
  (let ((buffer-read-only nil))
    (news-gred-update-group-status)
    (end-of-line)
    (if (eobp)
	(beginning-of-line)
      (forward-char 1)
      (news-gred-update-group-status)
      )))

(defun news-gred-previous-group ()
  (interactive)
  (set-buffer news-buffer)
  (if news-current-news-group
      (news-update-message-read news-current-news-group
				(news-cdar news-point-pdl)))
  (set-buffer news-gred-buffer)
  (let ((buffer-read-only nil))
    (news-gred-update-group-status)
    (beginning-of-line)
    (if (bobp)
	nil
      (backward-char 1)
      (news-gred-update-group-status))))

(defun news-gred-quit ()
  (interactive)
  (bury-buffer news-buffer)
  (bury-buffer news-summary-buffer)
  (pop-to-buffer (prog1 news-gred-buffer (bury-buffer (current-buffer))))
  (delete-other-windows)
  (news-exit))


;;; status : ( <flag> { (start . end) | number} ....)
(defun news-gred-status-set-flag (status flag)
  (setcar status flag))

(defun news-gred-status-add-number (status number)
  (let ((list (cdr status))(flag t))
    (if (null list)
	(setcdr status (cons number nil))
      (while (and list flag)
	(setq flag nil)
	(cond((consp (car list))
	      (cond ((< number (1-(car(car list))))
		     (setcdr list (cons (car list) (cdr list)))
		     (setcar list number))
		    ((= number (1- (car(car list))))
		     (setcar (car list) number))
		    ((and (<= (car(car list)) number)
			  (<= number (cdr(car list))))
		     nil)
		    ((= (1+ (cdr (car list))) number)
		     (cond((consp (car (cdr list)))
			   (cond ((= number (1- (car(car(cdr list)))))
				  (setcdr (car list) (cdr(car(cdr list))))
				  (setcdr list (cdr(cdr list))))
				 (t
				  (setcdr (car list) number))))
			  ((numberp (car (cdr list)))
			   (cond((= number (1- (car(cdr list))))
				 (setcdr (car list) (car(cdr list)))
				 (setcdr list (cdr(cdr list))))
				(t
				 (setcdr (car list) number))))
			  ((null (cdr list))
			   (setcdr (car list) number))))
		    ((null (cdr list))
		     (setcdr list (cons number nil)))
		    (t
		     (setq flag t
			   list (cdr list)
			   ))))
	     ((numberp (car list))
	      (cond ((< number (1- (car list)))
		     (setcdr list (cons (car list) (cdr list)))
		     (setcar list number))
		    ((= number (1- (car list)))
		     (setcar list (cons number (car list))))
		    ((= number (car list)) nil)
		    ((= (1+ (car list)) number)
		     (cond((consp (car (cdr list)))
			   (cond (( = number (1-(car (car(cdr list)))))
				  (setcar (car(cdr list)) (car list))
				  (setcar list (car(cdr list)))
				  (setcdr list (cdr(cdr list)))
				  )
				 (t 
				  (setcar list (cons (car list) number)))))
			  ((numberp (car (cdr list)))
			   (cond ((= number (1-(car (cdr list))))
				  (setcar list (cons (car list)
						     (car (cdr list))))
				  (setcdr list (cdr(cdr list))))
				 (t
				  (setcar list (cons (car list) number)))))
			  ((null (cdr list))
			   (setcar list (cons (car list) number)))))
		    ((null (cdr list))
		     (setcdr list (cons number nil)))
		    (t
		     (setq flag t
			   list (cdr list)
			   )))))))
    status))

(defun status-add-number (status number)
  (let ((list (cdr status))(flag t))
    (if (null list)
	(setcdr status (cons (cons number (1- number)) nil))
      (while (and list flag)
	(setq flag nil)
	(cond((> number (1+ (car (car list))))
	      (setcdr list (cons (car list) (cdr list)))
	      (setcar list (cons number (1- number))))
	     ((= number (1+ (car(car list))))
	      (setcar (car list) number))
	     ((and (>=  (car(car list)) number)
		   (>   number (cdr(car list))))
		     nil)
	     ((= number (cdr (car list)))
	      (cond ((null (cdr list))
		     (setcdr (car list) (1- number)))
		    ((= (1- number) (car(car(cdr list))))
		     (setcdr (car list) (cdr(car(cdr list))))
		     (setcdr list (cdr(cdr list))))
		    (t
		     (setcdr (car list) (1- number)))))
	     (t (setq flag t list (cdr list)))))))
  status)

(defun status-member (status number)
  (let ((list (cdr status)) (flag nil))
    (while (and list (not flag))
      (setq flag (and (>= (car (car list)) number)
		      (>  number (cdr (car list))))
	    list (cdr list)))
    flag))
	    
(defun status-delete-number (status number)
  (let ((list (cdr status)) (flag nil))
    (while (and list (not flag))
      (if (and (>= (car (car list)) number)
	       (>  number (cdr (car list))))
	  (progn
	    (setq flag t)
	    (cond((= (car(car list)) number)
		  (cond((= (1- (car (car list))) (cdr (car list)))
			(setcar list (car (cdr list)))
			(setcdr list (cdr(cdr list))))
		       (t
			(setcar (car list) (1- number)))))
		 ((= (1+ (cdr(car list))) number)
		  (setcdr (car list) number))
		 (t
		  (setcdr list (cons  (cons (1- number) (cdr (car list)))
				      (cdr (cdr list))))
		  (setcdr (car list) number)))
	    )
	(setq list (cdr list))))
    status))

;;; end of patch

;;; patch by S.Tomura 88-Feb-14
(defun news-get-last-article-number (gp-name)
  (let ((number (cdr (news-get-first-and-last-article-number gp-name))))
    (or number 0)))
;;; end of patch


(defmacro news-/ (a1 a2)
;; a form of / that guarantees that (/ -1 2) = 0
  (if (zerop (/ -1 2))
      (` (/ (, a1) (, a2)))
    (` (if (< (, a1) 0)
	   (- (/ (- (, a1)) (, a2)))
	 (/ (, a1) (, a2))))))

;;; patch by S.Tomura 87-06-17
;;;(defun news-find-first-or-last (pfx base dirn)
;;;  ;; first use powers of two to find a plausible ceiling
;;;  (let ((original-dir dirn))
;;;    (while (news-wins pfx (+ base dirn))
;;;      (setq dirn (* dirn 2)))
;;;    (setq dirn (news-/ dirn 2))
;;;    ;; Then use a binary search to find the high water mark
;;;    (let ((offset (news-/ dirn 2)))
;;;      (while (/= offset 0)
;;;	(if (news-wins pfx (+ base dirn offset))
;;;	    (setq dirn (+ dirn offset)))
;;;	(setq offset (news-/ offset 2))))
;;;    ;; If this high-water mark is bogus, recurse.
;;;    (let ((offset (* news-max-plausible-gap original-dir)))
;;;      (while (and (/= offset 0) (not (news-wins pfx (+ base dirn offset))))
;;;	(setq offset (- offset original-dir)))
;;;      (if (= offset 0)
;;;	  (+ base dirn)
;;;	(news-find-first-or-last pfx (+ base dirn offset) original-dir)))))
;;; end of patch

(defun rnews ()
"Read USENET news for groups for which you are a member and add or
delete groups.
You can reply to articles posted and send articles to any group.

Type \\[describe-mode] once reading news to get a list of rnews commands."
  (interactive)
  (let ((last-buffer (buffer-name)))
    ;;; patch by S. Tomura 88-Feb-8
    ;;;(make-local-variable 'rmail-last-file)
    ;;; end of patch
    (switch-to-buffer (setq news-buffer (get-buffer-create "*news*")))
    (news-mode)
    (setq news-buffer-save last-buffer)
    (setq buffer-read-only nil)
    (erase-buffer)
    (setq buffer-read-only t)
    (set-buffer-modified-p t)
    (sit-for 0)
    (message "Getting new USENET news...")
    (news-set-mode-line)
    ;;; patch by S.Tomura 88-Feb-13
    ;;;(news-get-certifications)
    ;;; end of patch
    (news-get-new-news)))

;;; pathc by S. Tomura 88-Feb-15
(defun news-read-group-article-status ()
  ;; Read the latest group article status from ~/.NEWSRC .
  (save-excursion
    (save-window-excursion
      (setq news-group-article-status
	    (car-safe
	     (condition-case var
		 (let*
		     ((file (substitute-in-file-name "~/.NEWSRC" ))
		      (buf (find-file-noselect file)))
		   (and (file-exists-p file)
			(progn
			  (switch-to-buffer buf 'norecord)
			  (unwind-protect
			      (read-from-string (buffer-string))
			    (kill-buffer buf)))))
	       (error nil))))
      (let ((l news-group-article-status))
	(while l
	  (cond((eq (car (car l)) ':toplevel)
		(setq news-user-toplevel
		      (copy-alist (cdr (car l))))
		(let ((ll news-user-toplevel))
		  (while ll
		    (if (stringp (car ll))
			(setcar ll (intern (car ll))))
		    (setq ll (cdr ll)))))
	       (t
		(put (intern (car (car l))) ':news-status (cdr (car l)))))
	  (setq l (cdr l)))))))

(defun news-write-group-article-status ()
  ;; Write a ~/.NEWSRC file.
  (save-excursion
    (if (not (null news-current-news-group))
	(news-update-message-read news-current-news-group
				  (news-cdar news-point-pdl)))
    (let ((save-buf (current-buffer))
	  (buf (get-buffer-create "*News Group Article Status*")))
      (set-buffer buf)
      (setq buffer-read-only nil)
      (erase-buffer)
      (let ((standard-output buf))
	(princ "(")
	(let ((l news-group-article-status))
	  (while l
	    (terpri)
	    (prin1 (car l))
	    (setq l (cdr l))))
	(terpri)
	(princ ")")
	(terpri))
      (let ((version-control 'never))
	(write-region (point-min) (point-max) (substitute-in-file-name "~/.NEWSRC")))
      (set-buffer save-buf)
      (kill-buffer buf))))

;;; news-group-article-status is a list of
;;; ( <group name string> <subscribe flag> { <number> | ( <number> . <number> )} ..)
;;;
(defun news-convert-group-article-status ()
  ;;; Caution:: unsubscription may be lost.
  (let ((tem news-user-group-list)
	result
	group)
    (save-excursion
      (if (not (null news-current-news-group))
	  (news-update-message-read news-current-news-group
				(news-cdar news-point-pdl)))
      (while tem
	(setq group (assoc (car tem)
			   news-group-article-assoc))
	(setq result (cons (list (car tem) t 
				 (cons (car (news-cadr group))
				       (news-cadr (news-cadr group))))
			   result))
	(setq tem (cdr tem)))
      (setq news-group-article-status (reverse result)))))
;;; end of patch

;;; patch by S.Tomura 88-Feb-13
;;;(defun news-group-certification (group)
;;;  (cdr-safe (assoc group news-current-certifications)))
;;;
;;;
;;;(defun news-set-current-certifiable ()
;;;  ;; Record the date that corresponds to the directory you are about to check
;;;  (let ((file (concat news-path
;;;		      (string-subst-char ?/ ?. news-current-news-group))))
;;;    (setq news-current-certifiable
;;;	  (nth 5 (file-attributes
;;;		  (or (file-symlink-p file) file))))))
;;;
;;;(defun news-get-certifications ()
;;;  ;; Read the certified-read file from last session
;;;  (save-excursion
;;;    (save-window-excursion
;;;      (setq news-current-certifications
;;;	    (car-safe
;;;	     (condition-case var
;;;		 (let*
;;;		     ((file (substitute-in-file-name news-certification-file))
;;;		      (buf (find-file-noselect file)))
;;;		   (and (file-exists-p file)
;;;			(progn
;;;			  (switch-to-buffer buf 'norecord)
;;;			  (unwind-protect
;;;			      (read-from-string (buffer-string))
;;;			    (kill-buffer buf)))))
;;;	       (error nil)))))))
;;;
;;;(defun news-write-certifications ()
;;;  ;; Write a certification file.
;;;  ;; This is an assoc list of group names with doubletons that represent
;;;  ;; mod times of the directory when group is read completely.
;;;  (save-excursion
;;;    (save-window-excursion
;;;      (with-output-to-temp-buffer
;;;	  "*CeRtIfIcAtIoNs*"
;;;	  (print news-current-certifications))
;;;      (let ((buf (get-buffer "*CeRtIfIcAtIoNs*")))
;;;	(switch-to-buffer buf)
;;;	(write-file (substitute-in-file-name news-certification-file))
;;;	(kill-buffer buf)))))
;;;
;;;(defun news-set-current-group-certification ()
;;;  (let ((cgc (assoc news-current-news-group news-current-certifications)))
;;;    (if cgc (setcdr cgc news-current-certifiable)
;;;      (news-push (cons news-current-news-group news-current-certifiable)
;;;	    news-current-certifications))))
;;; end of patch
(defun news-set-minor-modes ()
  "Creates a minor mode list that has group name, total articles,
and attribute for current article."
  (setq news-minor-modes (list (cons 'foo
				     (concat news-current-message-number
					     "/"
					     news-total-current-group
					     (news-get-attribute-string)))))
  ;; Detect Emacs versions 18.16 and up, which display
  ;; directly from news-minor-modes by using a list for mode-name.
  (or (boundp 'minor-mode-alist)
      (setq minor-modes news-minor-modes)))

;;; patch by S. Tomura 88-Feb-14
;;;(defun news-set-message-counters ()
;;;  "Scan through current news-groups filelist to figure out how many messages
;;;are there. Set counters for use with minor mode display."
;;;    (if (null news-list-of-files)
;;;	(setq news-current-message-number 0)))
;;; end of patch

(if news-mode-map
    nil
  (setq news-mode-map (make-keymap))
  (suppress-keymap news-mode-map)
  (define-key news-mode-map "." 'beginning-of-buffer)
  (define-key news-mode-map " " 'scroll-up)
  (define-key news-mode-map "\177" 'scroll-down)
  (define-key news-mode-map "n" 'news-next-message)
  (define-key news-mode-map "c" 'news-make-link-to-message)
  (define-key news-mode-map "p" 'news-previous-message)
  (define-key news-mode-map "j" 'news-goto-message)
;;; patch by K.Handa 87.5.1
  (define-key news-mode-map "N" 'news-goto-next-message)
  (define-key news-mode-map "n" 'news-goto-next-message)
  (define-key news-mode-map "P" 'news-goto-previous-message)
  (define-key news-mode-map "p" 'news-goto-previous-message)
;;; end of patch
;;; patch by S. Tomura 88-Feb-12
  (define-key news-mode-map "s" 'news-summary)
;;; end of patch
;;; patch by S. Tomura 88-May-19
  (define-key news-mode-map "C" 'news-cancel-news)
;;; end of patch
  (define-key news-mode-map "q" 'news-exit)
  (define-key news-mode-map "e" 'news-exit)
  (define-key news-mode-map "\ej" 'news-goto-news-group)
  (define-key news-mode-map "\en" 'news-next-group)
  (define-key news-mode-map "\ep" 'news-previous-group)
  (define-key news-mode-map "l" 'news-list-news-groups)
  (define-key news-mode-map "?" 'describe-mode)
  (define-key news-mode-map "g" 'news-get-new-news)
  (define-key news-mode-map "f" 'news-reply)
  (define-key news-mode-map "m" 'news-mail-other-window)
  (define-key news-mode-map "a" 'news-post-news)
  (define-key news-mode-map "r" 'news-mail-reply)
  (define-key news-mode-map "o" 'news-save-item-in-file)
  (define-key news-mode-map "\C-o" 'rmail-output)
  (define-key news-mode-map "t" 'news-show-all-headers)
  (define-key news-mode-map "x" 'news-force-update)
;;; patch by S.Tomura 89-08-06
  (define-key news-mode-map "X" 'news-force-update-to-end)
;;; end of patch
  (define-key news-mode-map "A" 'news-add-news-group)
  (define-key news-mode-map "u" 'news-unsubscribe-current-group)
  (define-key news-mode-map "U" 'news-unsubscribe-group)
  (define-key news-mode-map "\C-c\C-r" 'news-caesar-buffer-body))

(defun news-mode ()
  "News Mode is used by M-x rnews for reading USENET Newsgroups articles.
New readers can find additional help in newsgroup: news.announce.newusers .
All normal editing commands are turned off.
Instead, these commands are available:

.	move point to front of this news article (same as Meta-<).
Space	scroll to next screen of this news article.
Delete  scroll down previous page of this news article.
n	move to next news article, possibly next group.
p	move to previous news article, possibly previous group.
j	jump to news article specified by numeric position.
M-j     jump to news group.
M-n     goto next news group.
M-p     goto previous news group.
l       list all the news groups with current status.
?       print this help message.
C-c C-r caesar rotate all letters by 13 places in the article's body (rot13).
g       get new USENET news.
f       post a reply article to USENET.
a       post an original news article.
A       add a newsgroup. 
o	save the current article in the named file (append if file exists).
C-o	output this message to a Unix-format mail file (append it).
c       \"copy\" (actually link) current or prefix-arg msg to file.
	warning: target directory and message file must be on same device
		(UNIX magic)
t       show all the headers this news article originally had.
q	quit reading news after updating .newsrc file.
e	exit updating .newsrc file.
m	mail a news article.  Same as C-x 4 m.
x       update last message seen to be the current message.
r	mail a reply to this news article.  Like m but initializes some fields.
u       unsubscribe from current newsgroup.
U       unsubscribe from specified newsgroup."
  (interactive)
  (kill-all-local-variables)
  ;;; patch by S. Tomura 88-Feb-8
  (make-local-variable 'rmail-last-file)
  (setq rmail-last-file  (expand-file-name "~/mbox.news"))
  ;;; end of patch
  (make-local-variable 'news-read-first-time-p)
  (setq news-read-first-time-p t)
  (make-local-variable 'news-current-news-group)
;  (setq news-current-news-group "??")
  (make-local-variable 'news-current-group-begin)
  (setq news-current-group-begin 0)
  (make-local-variable 'news-current-message-number)
  (setq news-current-message-number 0)
  (make-local-variable 'news-total-current-group)
  (make-local-variable 'news-buffer-save)
  (make-local-variable 'version-control)
  (setq version-control 'never)
  (make-local-variable 'news-point-pdl)
;  This breaks it.  I don't have time to figure out why. -- RMS
;  (make-local-variable 'news-group-article-assoc)
  (setq major-mode 'news-mode)
  (if (boundp 'minor-mode-alist)
      ;; Emacs versions 18.16 and up.
      (setq mode-name '("NEWS" news-minor-modes))
    ;; Earlier versions display minor-modes via a special mechanism.
    (setq mode-name "NEWS"))
  (news-set-mode-line)
  (set-syntax-table text-mode-syntax-table)
  (use-local-map news-mode-map)
  (setq local-abbrev-table text-mode-abbrev-table)
  (run-hooks 'news-mode-hook))

(defun string-subst-char (new old string)
  (let (index)
    (setq old (regexp-quote (char-to-string old))
	  string (substring string 0))
    (while (setq index (string-match old string))
      (aset string index new)))
  string)

;;; patch by S. Tomura 88-Feb-15
;; update read message number
;;;(defmacro news-update-message-read (ngroup nno)
;;;  (list 'setcar
;;;	(list 'news-cdadr
;;;	      (list 'assoc ngroup 'news-group-article-assoc))
;;;	nno))
;;;
(defun news-update-message-read (gp-name number)
  ;;; S. Tomura 88-Jul-15
  (and gp-name
       (setcdr (news-caddr (assoc gp-name news-group-article-status))
	       number)))
;;; end of patch

(defun news-parse-range (number-string)
  "Parse string representing range of numbers of he form <a>-<b>
to a list (a . b)"
  (let ((n (string-match "-" number-string)))
    (if n
	(cons (string-to-int (substring number-string 0 n))
	      (string-to-int (substring number-string (1+ n))))
      (setq n (string-to-int number-string))
      (cons n n))))

;(defun is-in (elt lis)
;  (catch 'foo
;    (while lis
;      (if (equal (car lis) elt)
;	  (throw 'foo t)
;	(setq lis (cdr lis))))))

;;; patch by S. Tomura 88-Feb-15
(defun news-read-newsrc ()
  "Get new USENET news, if there is any for the current user."
  (interactive)
  (message "Looking up %s file..." news-startup-file)
  (setq news-group-article-status nil)
  (let ((file (substitute-in-file-name news-startup-file))
	(temp-user-groups ()))
    (save-excursion
      (let ((newsrcbuf (find-file-noselect file))
    	    start end endofline tem)
    	(set-buffer newsrcbuf)
    	(goto-char 0)
    	(while (search-forward ":" nil t)
    	  (setq endofname (- (point) 1))
    	  (skip-chars-forward " ")
    	  (setq end (point))
    	  (beginning-of-line)
    	  (setq start (point))
    	  (end-of-line)
    	  (setq endofline (point))
    	  (setq tem (buffer-substring start endofname))
    	  (let ((range (news-parse-range
    			(buffer-substring end endofline))))
    	    (if (assoc tem news-group-article-status)
    		(message "You are subscribed twice to %s; I ignore second"
    			 tem)	      
    	      (setq temp-user-groups (cons tem temp-user-groups)
    		    news-group-article-status
    		    (cons (list tem  t (cons (car range) (cdr range)))
				news-group-article-status)))))
    	(kill-buffer newsrcbuf))))
  (setq news-group-article-status (reverse news-group-article-status)))
;;; end of patch



(defun news-get-new-news ()
  "Get new USENET news, if there is any for the current user."
  (interactive)
  ;;; patch by S. Tomura 88-Feb-15
  ;;;(if (not (null news-user-group-list))
  ;;;  (news-update-newsrc-file))
  ;;;(setq news-group-article-assoc ())
  ;;;(setq news-user-group-list ())
  ;;;(message "Looking up %s file..." news-startup-file)
  (cond(news-group-article-status t)
       ((and (not (file-exists-p "~/.NEWSRC"))
	     (file-exists-p "~/.newsrc"))
	(message 
	 "~/.NEWSRC not exists. ~/.NEWSRC will be made from ~/.newsrc .")
	(sleep-for 1)
	(if (yes-or-no-p 
	     "In this convertion, some information may be lost. Is it OK?")
	    (news-read-newsrc)
	    (setq quit-flag t)))
       ((file-exists-p "~/.NEWSRC")
	(message "Looking up ~/.NEWSRC file ...")
	(news-read-group-article-status))
       (t (setq news-group-article-status nil)))
  ;;; end of patch

  (let ((file (substitute-in-file-name news-startup-file))
	(temp-user-groups ()))
    ;;; patch by S. Tomura 88-Feb-15
    ;;;(save-excursion
    ;;;      (let ((newsrcbuf (find-file-noselect file))
    ;;;	    start end endofline tem)
    ;;;	(set-buffer newsrcbuf)
    ;;;	(goto-char 0)
    ;;;	(while (search-forward ":" nil t)
    ;;;	  (setq endofname (- (point) 1))
    ;;;	  (skip-chars-forward " ")
    ;;;	  (setq end (point))
    ;;;	  (beginning-of-line)
    ;;;	  (setq start (point))
    ;;;	  (end-of-line)
    ;;;	  (setq endofline (point))
    ;;;	  (setq tem (buffer-substring start endofname))
    ;;;	  (let ((range (news-parse-range
    ;;;			(buffer-substring end endofline))))
    ;;;	    (if (assoc tem news-group-article-assoc)
    ;;;		(message "You are subscribed twice to %s; I ignore second"
    ;;;			 tem)	      
    ;;;	      (setq temp-user-groups (cons tem temp-user-groups)
    ;;;		    news-group-article-assoc
    ;;;		    (cons (list tem (list (car range)
    ;;;					  (cdr range)
    ;;;					  (cdr range)))
    ;;;			  news-group-article-assoc)))))
    ;;;	(kill-buffer newsrcbuf)))      
    ;;;(setq temp-user-groups (nreverse temp-user-groups))
    ;;; end of patch
    (message "Prefrobnicating...")
    (switch-to-buffer news-buffer)
    ;;; patch by S. Tomura 88-Feb-15
    ;;;(setq news-user-group-list temp-user-groups)
    (setq temp-user-groups news-group-article-status)
    ;;; end of patch
    (while (and temp-user-groups
		;;; patch by S. Tomura 88-Feb-15
		;;; I had better replce following codes by the invocation of 
		;;; news-find-new-news-group. But .....
		;;;(not (news-read-files-into-buffer
		;;;      (car temp-user-groups) nil)))
		(let* ((item (car temp-user-groups))
		       (first-and-last
			(news-get-first-and-last-article-number (car item))))
		  (cond((null (news-cadr item)) t)
		       ((null first-and-last)
			(message "Group: %s is bogus!!" (car item))
			(setq news-group-article-status
			      ;;; patch by S.Tomura 88-May-23
			      (delq item news-group-article-status))
			      ;;; end of patch
			(sleep-for 1)
			t)
		       ((< (cdr (nth 2 item)) (cdr first-and-last))
			(news-read-files-into-buffer (car item) nil)
			(not  news-current-new-articles-p))
		       (t t))))
	        ;;; end of patch
      (setq temp-user-groups (cdr temp-user-groups)))
    (if (null temp-user-groups)
	(message "No news is good news.")
      (message ""))))

(defun news-list-news-groups ()
  "Display all the news groups to which you belong."
  (interactive)
  (with-output-to-temp-buffer "*Newsgroups*"
    (save-excursion
      (set-buffer standard-output)
      (insert
	"News Group        Msg No.       News Group        Msg No.\n")
      (insert
	"-------------------------       -------------------------\n")
      ;;; patch by S.Tomura 88-Feb-15
      ;;;(let ((temp news-user-group-list)
      (let ((temp news-group-article-status)
      ;;; end of patch
	    (flag nil))
	(while temp
	  ;;; patch by S. Tomura 88-Feb-15
	  ;;;(let ((item (assoc (car temp) news-group-article-assoc)))
	  (let ((item (car temp)))
	  ;;; end of patch
	    (insert (car item))
	    (indent-to (if flag 52 20))
	    ;;; patch by S. Tomura 88-Feb-15
	    ;;;(insert (int-to-string (news-cadr (news-cadr item))))
	    (insert (int-to-string (cdr (nth 2 item))))
	    ;;; end of patch
	    (if flag
		(insert "\n")
	      (indent-to 33))
	    (setq temp (cdr temp) flag (not flag))))))))

;; Mode line hack
(defun news-set-mode-line ()
  "Set mode line string to something useful."
  (setq mode-line-process
	(concat " "
		(if (integerp news-current-message-number)
		    (int-to-string news-current-message-number)
		 "??")
		"/"
		(if (integerp news-current-group-end)
		    (int-to-string news-current-group-end)
		  news-current-group-end)))
  (setq mode-line-buffer-identification
	(concat "NEWS: "
		news-current-news-group
		;; Enough spaces to pad group name to 17 positions.
		(substring "                 "
			   0 (max 0 (- 17 (length news-current-news-group))))))
  (set-buffer-modified-p t)
  (sit-for 0))

(defun news-goto-news-group (gp)
  "Takes a string and goes to that news group."
  (interactive (list (completing-read "NewsGroup: "
				      ;;; patch by S.Tomura 88-Feb-15
				      ;;;news-group-article-assoc)))
				      news-group-article-status)))
                                      ;;; end of patch
  (message "Jumping to news group %s..." gp)
  (news-select-news-group gp)
  (message "Jumping to news group %s... done." gp))

(defun news-select-news-group (gp)
  ;;; patch by S. Tomura 88-Feb-15
  ;;;(let ((grp (assoc gp news-group-article-assoc)))
  (let ((grp (assoc gp news-group-article-status))
	(f-and-l (news-get-first-and-last-article-number gp)))
  ;;; end of patch
    ;;; patch by S. Tomura 88-Feb-15
    ;;;(if (null grp)
    ;;; 	(error "Group not subscribed to in file %s." news-startup-file)
    (if (not (and grp (nth 1 grp) f-and-l))
	(cond((and (null grp) (null f-and-l))
	      (error "Group: %s  not exists." gp))
	     ((and grp (null f-and-l))
	      ;;; patch by S. Tomura 88-May-23
	      (setq news-group-article-status
	      ;;; end of patch
		    (delq grp news-group-article-status))
	      (error "Group: %s is bogus!!" gp))
	     ((null grp)
	      (if (y-or-n-p (format "Group %s is not subscribed. Add it?" gp))
		  (progn
		   (setq news-group-article-status
			 (cons (list gp t (cons 0 0))
			       news-group-article-status))
		   (setq grp (assoc gp news-group-article-status))
		   (news-update-message-read news-current-news-group
					     (news-cdar news-point-pdl))
		   (news-read-files-into-buffer  (car grp) nil)
		   (news-set-mode-line))
		(setq quit-flag t)))
	     ((y-or-n-p (format "Group %s is unsubscribed. Subscribe it?" gp))
	      (setcar (cdr grp) t)
	      (news-update-message-read news-current-news-group
					(news-cdar news-point-pdl))
	      (news-read-files-into-buffer  (car grp) nil)
	      (news-set-mode-line))
	     (t (setq quit-flag t)))
	 ;;; end of patch
      (progn
	(news-update-message-read news-current-news-group
				  (news-cdar news-point-pdl))
	(news-read-files-into-buffer  (car grp) nil)
	(news-set-mode-line)))))

(defun news-goto-message (arg)
  "Goes to the article ARG in current newsgroup."
  (interactive "p")
  (if (null current-prefix-arg)
      (setq arg (read-no-blanks-input "Go to article: " "")))
  (news-select-message arg))

;;; patch by S.Tomura 87-06-25
(defun news-goto-next-message (arg)
  "Move ARG messages forward within one newsgroup.
Negative ARG moves backward.
If ARG is 1 or -1, moves to next or previous newsgroup if at end."
  (interactive "p")
  (let ((no (+ arg news-current-message-number))
	(start (car (news-get-first-and-last-article-number 
		     news-current-news-group)))
	(end   (cdr (news-get-first-and-last-article-number
		     news-current-news-group))))
    ;;; patch by S. Tomura 88-05-15
    (if (not (= news-current-group-end end))
	(progn (setq news-current-group-end end)
	       (news-set-mode-line)))
    ;;; end of patch
    (while (and (<= start no)
		(<= no end)
		(not (file-exists-p (news-get-current-message-file no))))
      (setq no (if (< arg 0) (1- no) (1+ no))))
    (cond ((and (<= start no) (<= no end))
	   (news-select-message no))
	  ((= arg 1)(news-next-group))
	  ((= arg -1)(news-previous-group))
	  ((cond ((< no start) (setq no start))
		 ((< end no)   (setq no end)))
	   (news-select-message no)))))

(defun news-goto-previous-message (arg)
  "Go to the previous message in current news group."
  (interactive "p")
  (news-goto-next-message (- arg)))
;;; end of patch

;;; patch by S.Tomura 88-Nov-30
(defun news-message-exists-p (arg)
  (if (stringp arg) (setq arg (string-to-int arg)))
  (file-exists-p
   (concat news-path
	   (string-subst-char ?/ ?. news-current-news-group)
	   "/" arg)))
;;; end of patch

(defun news-select-message (arg)
  (if (stringp arg) (setq arg (string-to-int arg)))
  (let ((file (concat news-path
		      (string-subst-char ?/ ?. news-current-news-group)
		      "/" arg)))
    (if (= arg
		 ;;; patch by S. Tomura 88-Feb-14
		 ;;;(or (news-cadr (memq (news-cdar news-point-pdl) news-list-of-files))
		 (or (news-get-next-news-no news-current-news-group
					    (news-cdar news-point-pdl)
					    nil)
                 ;;; end of patch		     
  	       0))
  	(setcdr (car news-point-pdl) arg))
    (setq news-current-message-number arg)
    (if (file-exists-p file)
  	(let ((buffer-read-only nil))
  	  (news-read-in-file file)
  	  (news-set-mode-line))
      (news-set-mode-line)
      (error "Article %d nonexistent" arg))))

;;; patch by S.Tomura 89-Sep-6
(defun news-select-message-archived (arg)
  (if (stringp arg) (setq arg (string-to-int arg)))
  (let ((file (concat news-path
		      (string-subst-char ?/ ?. news-current-news-group)
		      "/" arg)))
    (if (file-exists-p file)
	(let ((buffer-read-only ()))
	  (setq news-current-message-number arg)
	  (news-read-in-file file)
	  (news-set-mode-line))
      (error "Article %d nonexistent" arg))))
;;;end of patch

(defun news-force-update ()
  "updates the position of last article read in the current news group"
  (interactive)
  (setcdr (car news-point-pdl) news-current-message-number)
  (message "Updated to %d" news-current-message-number))

;;; patch by S.Tomura 89-08-06
(defun news-force-update-to-end ()
  "updates the position of last article read in the current news group"
  (interactive)
  (if (integerp news-current-group-end)
      (progn
	(setcdr (car news-point-pdl) news-current-group-end)
	(message "Updated to %d" news-current-group-end))
    (beep)))
;;; end of patch
;;; patch by S.Tomura 87-06-25
(defun news-get-current-message-file (no)
  (concat news-path
	  (string-subst-char ?/ ?. news-current-news-group)
	  "/" no))
;;; end of patch

(defun news-next-message (arg)
  "Move ARG messages forward within one newsgroup.
Negative ARG moves backward.
If ARG is 1 or -1, moves to next or previous newsgroup if at end."
  (interactive "p")
  (let ((no (+ arg news-current-message-number)))
;;; patch by S.Tomura 87-06-25
    (while (and (<= news-current-group-begin no)
		(<= no news-current-group-end)
		(not (file-exists-p (news-get-current-message-file no))))
      (setq no (if (< arg 0) (1- no) (1+ no))))
;;; end of patch
    (if (or (< no news-current-group-begin) 
	    (> no news-current-group-end))
	(cond ((= arg 1)
	       ;;; patch by S.Tomura 88-Feb-13
	       ;;;(news-set-current-group-certification)
	       ;;; end of patch
	       (news-next-group))
	      ((= arg -1)
	       (news-previous-group))
	      (t (error "Article out of range")))
;;; patch by S.Tomura 87-06-25
;;;      (let ((plist (news-get-motion-lists
;;;		     news-current-message-number
;;;		     news-list-of-files)))
;;;	(if (< arg 0)
;;;	    (news-select-message (nth (1- (- arg)) (car (cdr plist))))
;;;	  (news-select-message (nth (1- arg) (car plist))))))))
      (news-select-message no))))
;;; end of patch

(defun news-previous-message (arg)
  "Move ARG messages backward in current newsgroup.
With no arg or arg of 1, move one message
and move to previous newsgroup if at beginning.
A negative ARG means move forward."
  (interactive "p")
  (news-next-message (- arg)))

;;; patch by S. Tomura 88-Mar-29
;;;
(defun news-find-new-news-group (group-alist)
  "Given group-alist find next new news group and read it.
Returns t if found it, returns nil if no new news group."
  (news-update-message-read news-current-news-group
			    (news-cdar news-point-pdl))
    (while (and group-alist
		(let* ((item (car group-alist))
		       (first-and-last
			(news-get-first-and-last-article-number (car item))))
		  (cond((null (news-cadr item)) t)
		       ((null first-and-last)
			(message "Group: %s is bogus!!" (car item))
			(setq news-group-article-status
			      ;;; patch by S. Tomura 88-May-23
			      (delq item news-group-article-status))
			      ;;; end of patch
			(sleep-for 1)
			t)
		       ((< (cdr (nth 2 item)) (cdr first-and-last))
			(news-read-files-into-buffer (car item) nil)
			(not  news-current-new-articles-p))
		       (t t))))
      (setq group-alist (cdr group-alist)))
    (not (null group-alist)))
;;; end of patch

(defun news-move-to-group (arg)
  "Given arg move forward or backward to a new newsgroup."
  (let ((cg news-current-news-group))
    ;;; patch by S. Tomura 88-Feb-15
    ;;;(let ((plist (news-get-motion-lists cg news-user-group-list))
    (let ((plist (news-get-motion-lists (assoc cg news-group-article-status)
					news-group-article-status))
	  )
      (if (< arg 0)
	  (or (news-find-new-news-group (news-cadr plist))
	      (error "No previous news groups"))
	(or (news-find-new-news-group (car plist))
	    (error "No more news groups"))))))
    ;;;	  ngrp)
    ;;;  (if (< arg 0)
    ;;;	  (or (setq ngrp (nth (1- (- arg)) (news-cadr plist)))
    ;;;	      (error "No previous news groups"))
    ;;;	(or (setq ngrp (nth arg (car plist)))
    ;;;	    (error "No more news groups")))
    ;;;(news-select-news-group ngrp))))
    ;;;  (news-select-news-group (car ngrp)))))


(defun news-next-group ()
  "Moves to the next user group."
  (interactive)
;  (message "Moving to next group...")
  (news-move-to-group 0)
  ;;; patch by S. Tomura 88-Feb-14
  ;;;(while (null news-list-of-files)
  (while (not news-current-new-articles-p)
  ;;; end of patch
    (news-move-to-group 0)))
;  (message "Moving to next group... done.")

(defun news-previous-group ()
  "Moves to the previous user group."
  (interactive)
;  (message "Moving to previous group...")
  (news-move-to-group -1)
  ;;; patch by S. Tomura 88-Feb-14
  ;;;(while (null news-list-of-files)
  (while (not news-current-new-articles-p)
  ;;; end of patch
    (news-move-to-group -1)))
;  (message "Moving to previous group... done.")

(defun news-get-motion-lists (arg listy)
  "Given a msgnumber/group this will return a list of two lists;
one for moving forward and one for moving backward."
  (let ((temp listy)
	(result ()))
    (catch 'out
      (while temp
	(if (equal (car temp) arg)
	    (throw 'out (cons (cdr temp) (list result)))
	  (setq result (nconc (list (car temp)) result))
	  (setq temp (cdr temp)))))))

;; miscellaneous io routines
(defun news-read-in-file (filename)
  (erase-buffer)
  (let ((start (point)))
  (insert-file-contents filename)
  (news-convert-format)
  (goto-char start)
  (forward-line 1)
  (if (eobp)
      (message "(Empty file?)")
    (goto-char start))))

(defun news-convert-format ()
  (save-excursion
    (save-restriction
      (let* ((start (point))
	     (end (condition-case ()
		      (progn (search-forward "\n\n") (point))
		    (error nil)))
	     has-from has-date)
       (cond (end
	      (narrow-to-region start end)
	      (goto-char start)
	      (setq has-from (search-forward "\nFrom:" nil t))
	      (cond ((and (not has-from) has-date)
		     (goto-char start)
		     (search-forward "\nDate:")
		     (beginning-of-line)
		     (kill-line) (kill-line)))
	      (news-delete-headers start)
	      (goto-char start)))))))

(defun news-show-all-headers ()
  "Redisplay current news item with all original headers"
  (interactive)
  (let (news-ignored-headers
	(buffer-read-only ()))
    (erase-buffer)
    (news-set-mode-line)
    (news-read-in-file
     (concat news-path
	     (string-subst-char ?/ ?. news-current-news-group)
	     "/" (int-to-string news-current-message-number)))))

(defun news-delete-headers (pos)
  (goto-char pos)
  (and (stringp news-ignored-headers)
       (while (re-search-forward news-ignored-headers nil t)
	 (beginning-of-line)
	 (delete-region (point)
			(progn (re-search-forward "\n[^ \t]")
			       (forward-char -1)
			       (point))))))

(defun news-exit ()
  "Quit news reading session and update the .newsrc file."
  (interactive)
  (if (y-or-n-p "Do you really wanna quit reading news ? ")
      ;;; patch by S. Tomura 88-Feb-13
      ;;;(progn (message "Updating %s..." news-startup-file)
      (progn (message "Updating ~/.NEWSRC...")
      ;;; end of patch
	     ;;; patch by S. Tomura 88-Feb-13
	     ;;;(news-update-newsrc-file)
	     (news-write-group-article-status)
	     ;;; end of patch
	     ;;; patch by S.Tomura 88-Feb-13
	     ;;;(news-write-certifications)
	     ;;; end of patch
	     ;;; patch by S. Tomura 88-Feb-13
	     ;;;(message "Updating %s... done" news-startup-file)
	     (message "Updating ~/.NEWSRC... done")
	     ;;; end of patche
	     (message "Now do some real work")
	     (and (fboundp 'bury-buffer) (bury-buffer (current-buffer)))
	     (switch-to-buffer news-buffer-save)
	     ;;; patch by S. Tomura 88-Feb-15
	     ;;;(setq news-user-group-list ()))
	     ;(kill-buffer news-buffer)
	     ;(setq news-buffer nil)
	     ;(setq news-group-article-status nil)
	     )
             ;;; end of patch
    (message "")))

(defun news-update-newsrc-file ()
  "Updates the .newsrc file in the users home dir."
  (let ((newsrcbuf (find-file-noselect
		     (substitute-in-file-name news-startup-file)))
	(tem news-user-group-list)
	group)
    (save-excursion
      (if (not (null news-current-news-group))
	  (news-update-message-read news-current-news-group
				(news-cdar news-point-pdl)))
      (switch-to-buffer newsrcbuf)
      (while tem
	(setq group (assoc (car tem)
			   news-group-article-assoc))
	(if (= (news-cadr (news-cadr group)) (news-caddr (news-cadr group)))
	    nil
	  (goto-char 0)
;;; patch by S.Tomura 87-06-15
;;;	  (if (search-forward (concat (car group) ": ") nil t)
;;;	      (kill-line nil)
	  (if (search-forward (concat (car group) ":") nil t)
	      (let (from to)
		(setq from (point))
		(end-of-line)
		(setq to (point))
		(kill-region from to)
		(insert " "))
;;; end of patch
	    (insert (car group) ": \n") (backward-char 1))
	  (insert (int-to-string (car (news-cadr group))) "-"
		  (int-to-string (news-cadr (news-cadr group)))))
	(setq tem (cdr tem)))
     (while news-unsubscribe-groups
       (setq group (assoc (car news-unsubscribe-groups)
			  news-group-article-assoc))
       (goto-char 0)
;;; patch by S.Tomura 87-06-15
;;;    (if (search-forward (concat (car group) ": ") nil t)
       (if (search-forward (concat (car group) ":") nil t)
;;; end of patch
	   (progn
;;; patch by S.Tomura 87-06-15
;;;	      (backward-char 2)
;;;	      (kill-line nil)
	      (backward-char 1)
	      (let (from to)
		(setq from (point))
		(end-of-line)
		(setq to (point))
		(kill-region from to))
;;; end of patch
	      (insert "! " (int-to-string (car (news-cadr group)))
		      "-" (int-to-string (news-cadr (news-cadr group))))))
       (setq news-unsubscribe-groups (cdr news-unsubscribe-groups)))
     (save-buffer)
     (kill-buffer (current-buffer)))))


(defun news-unsubscribe-group (group)
  "Removes you from newgroup GROUP."
  (interactive (list (completing-read  "Unsubscribe from group: "
				      ;;; patch by S. Tomura 88-Feb-15
				      ;;;news-group-article-assoc)))
				      news-group-article-status)))
                                      ;;; end of patch
  (news-unsubscribe-internal group))

(defun news-unsubscribe-current-group ()
  "Removes you from the newsgroup you are now reading."
  (interactive)
  (if (y-or-n-p "Do you really want to unsubscribe from this group ? ")
      (news-unsubscribe-internal news-current-news-group)))

(defun news-unsubscribe-internal (group)
  ;;; patch by S.Tomura 88-Feb-15
  ;;;(let ((tem (assoc group news-group-article-assoc)))
  (let ((tem (assoc group news-group-article-status)))
  ;;; end of patch
    (if tem
	(progn
	  ;;; patch by S.Tomura 88-Feb-15
	  ;;;(setq news-unsubscribe-groups (cons group news-unsubscribe-groups))
	  ;;; end of patch
	  (news-update-message-read group (news-cdar news-point-pdl))
	  (setcar (cdr tem) nil)
	  (if (equal group news-current-news-group)
	      (news-next-group))
	  (message ""))
      (error "Not subscribed to group: %s" group))))

(defun news-save-item-in-file (file)
  "Save the current article that is being read by appending to a file."
  (interactive "FSave item in file: ")
  (append-to-file (point-min) (point-max) file))

;;; patch by S. Tomura 87-06-24
(defvar news-summary-buffer nil)

(defun news-summary (&optional gpname begin)
  "Display a summary of messagess, one line per message."
  (interactive)
  (news-new-summary (or gpname news-current-news-group) 
		    (or begin  
			;;; patch by S. Tomura 88-Jul-8
			news-current-message-number
			;;; end of patch
			news-current-group-begin)))

;; Rnews Summary mode is suitalbe only for specially formatted data.
(put 'news-summary-mode 'mode-class 'special)
(defvar news-summary-mode-map nil)
(if news-summary-mode-map
    nil
  (setq news-summary-mode-map (make-keymap))
  (suppress-keymap news-summary-mode-map)

  ;;;(define-key news-summary-mode-map "A" 'news-add-news-group)
  ;;;(define-key news-mode-map "c" 'news-make-link-to-message)
  ;;;(define-key news-summary-mode-map "l" 'news-summary-list-news-groups)
  ;;;(define-key news-summary-mode-map "u" 'news-summary-unsubscribe-current-group)
  ;;;(define-key news-summary-mode-map "U" 'news-summary-unsubscribe-group)
  ;;;(define-key news-summary-mode-map "\ej" 'news-summary-goto-news-group)
  ;;;(define-key news-summary-mode-map "\en" 'news-summary-next-group)
  ;;;(define-key news-summary-mode-map "\ep" 'news-summary-previous-group)

  (define-key news-summary-mode-map "."    'news-summary-beginning-of-buffer)
  (define-key news-summary-mode-map "a"    'news-post-news)
  (define-key news-summary-mode-map "C"    'news-summary-cancel-news)
  (define-key news-summary-mode-map "e"    'news-summary-exit)
  (define-key news-summary-mode-map "j"    'news-summary-goto-msg)
;;(define-key news-summary-mode-map "g"    'news-summary-get-new-news)
  (define-key news-summary-mode-map "f"    'news-summary-reply)
  (define-key news-summary-mode-map "m"    'news-summary-mail-other-window)
  (define-key news-summary-mode-map "n"    'news-summary-next-msg)
  (define-key news-summary-mode-map "o"    'news-summary-save-item-in-file)
  (define-key news-summary-mode-map "\C-o" 'news-summary-rmail-output)
  (define-key news-summary-mode-map "p"    'news-summary-previous-msg)
  (define-key news-summary-mode-map "q"    'news-summary-exit)
  (define-key news-summary-mode-map "r"    'news-summary-mail-reply)
  (define-key news-summary-mode-map "t"    'news-summary-show-all-headers)
  (define-key news-summary-mode-map "x"    'news-summary-force-update)
  (define-key news-summary-mode-map "X"    'news-summary-force-update-to-end)
  (define-key news-summary-mode-map " "    'news-summary-scroll-msg-up)
  (define-key news-summary-mode-map "\177" 'news-summary-scroll-msg-down)
  (define-key news-summary-mode-map "\C-@" 'news-summary-scroll-msg-down)
  (define-key news-summary-mode-map "?"    'describe-mode)
  (define-key news-summary-mode-map "\es"  'news-summary-isearch-forward)
  (define-key news-summary-mode-map "\ep"  'news-summary-print-buffer)
  (define-key news-summary-mode-map "\er"  'news-summary-isearch-backward)
  )

(defun news-summary-print-buffer ()
  (interactive)
  (unwind-protect
      (progn 
	(pop-to-buffer news-buffer)
	(print-buffer))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-isearch-forward ()
  (interactive)
  (unwind-protect
      (progn 
	(pop-to-buffer news-buffer)
	(isearch-forward))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-cancel-news ()
  (interactive)
  (unwind-protect
      (progn
	(pop-to-buffer news-buffer)
	(news-cancel-news))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-beginning-of-buffer ()
  (interactive)
  (unwind-protect
      (progn
	(pop-to-buffer news-buffer)
	(beginning-of-buffer))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-force-update ()
  (interactive)
  (news-summary-goto-msg-internal)
  (unwind-protect
      (progn
	(pop-to-buffer news-buffer)
	(news-force-update))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-force-update-to-end ()
  (interactive)
  ;;;(news-summary-goto-msg-internal)
  (unwind-protect
      (progn
	(pop-to-buffer news-buffer)
	(news-force-update-to-end))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-show-all-headers ()
  (interactive)
  (news-summary-goto-msg-internal)
  (pop-to-buffer news-buffer)
  (news-show-all-headers)
  (pop-to-buffer news-summary-buffer))

(defun news-summary-reply ()
  (interactive)
  (news-summary-goto-msg-internal)
  (pop-to-buffer news-buffer)
  (news-reply))

(defun news-summary-mail-reply ()
  (interactive)
  (news-summary-goto-msg-internal)
  (pop-to-buffer news-buffer)
  (news-mail-reply))

(defun news-summary-rmail-output (filename)
  (interactive
   (list
    (progn
      (rmail-output-default-file 'rmail-last-file)
      (read-file-name
       (concat "Output message to Unix mail file"
	       (if rmail-last-file
		   (concat " (default "
			   (file-name-nondirectory rmail-last-file)
			   "): " )
		 ": "))			
       (and rmail-last-file (file-name-directory rmail-last-file))
       rmail-last-file)))
   )
  (unwind-protect
      (progn
	(news-summary-goto-msg-internal)
	(pop-to-buffer news-buffer)
	(rmail-output filename))
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-save-item-in-file (file)
  (interactive "FSave item in file: ")
  (unwind-protect
      (progn
	(news-summary-goto-msg-internal)
	(pop-to-buffer news-buffer)
	(append-to-file (point-min) (point-max) file)
	)
    (pop-to-buffer news-summary-buffer)))

(defun news-summary-mail-other-window ()
  (interactive)
  (news-summary-goto-msg-internal)
  (pop-to-buffer news-buffer)
  (news-mail-other-window))

(defun news-summary-reply  ()
  (interactive)
  (news-summary-goto-msg-internal)
  (pop-to-buffer news-buffer)
  (news-reply))

(defun news-summary-next-msg (&optional n)
  (interactive "p")
  (if (save-excursion (end-of-line)(eobp))
      (error "No next message")
    (forward-line n)
    (news-summary-goto-msg-internal)))

(defun news-summary-previous-msg (&optional n)
  (interactive "p")
  (if (save-excursion (beginning-of-line 1)(bobp))
      (error "No previous message")
    (forward-line (-(or n 1)))
    (news-summary-goto-msg-internal)))


(defun news-summary-goto-msg (arg)
  "Goes to the article ARG in current newsgroup."
  (interactive "p")
  (if (null current-prefix-arg)
      (news-summary-goto-msg-internal)
    (let ((point (point)))
      (goto-char (point-min))
      (if (re-search-forward (concat "^ +" (int-to-string arg)) nil t)
	  (progn
	    (beginning-of-line)
	    (sit-for 0)
	    (news-summary-goto-msg-internal))
	(goto-char point)
	(message (format "Article %d does not found." arg))
	(beep)
	))))

(defun news-summary-goto-msg-internal ()
  (let (msgno)
    (beginning-of-line)
    (setq msgno (string-to-int
		 (buffer-substring (point) (save-excursion
					     (re-search-forward "[^ 0-9]")
					     (point)))))
    (set-buffer news-buffer)
    (cond((< msgno 
	     (car (news-get-first-and-last-article-number
		   news-current-news-group)))
	  (set-buffer news-summary-buffer)
	  (let ((buffer-read-only nil))
	    (re-search-forward "[^ 0-9]")
	    (delete-char -1) (insert "A"))
	  (beginning-of-line)
	  (message "The article has been archived.")
	  (set-buffer news-buffer)
	  (if archived-news-path
	      (let ((news-path archived-news-path))
		(if (news-message-exists-p msgno)
		    (progn
		      (pop-to-buffer news-buffer)
		      (news-select-message-archived msgno)
		      (pop-to-buffer news-summary-buffer)
		      ;;;(message "The article has been got from the archived directory.")
		      )
		  (beep)))
	    (beep)))

	 ((news-message-exists-p msgno)
	  (pop-to-buffer news-buffer)
	  (news-select-message msgno)
	  (pop-to-buffer news-summary-buffer))
	 (t (set-buffer news-summary-buffer)
	    (let ((buffer-read-only nil))
	      (re-search-forward "[^ 0-9]")
	      (delete-char -1) (insert "C"))
	    (beginning-of-line)
	    (message "The article has been canceled.")
	    (beep)))))

(defun news-summary-scroll-msg-up (&optional dist)
  "Scroll message in top window forward"
  (interactive "P")
  (scroll-other-window (if (null dist) nil
			 (prefix-numeric-value dist))))
	
(defun news-summary-scroll-msg-down (&optional dist)
  "Scroll message in top window backward"
  (interactive "P")
  (other-window 1)
  (scroll-down (if (null dist) nil
		 (prefix-numeric-value dist)))
  (other-window 1))

(defun news-summary-quit ()
  "Quit out of rnews and rnews summary"
  (interactive)
  (news-summary-exit)
  (news-exit))

(defun news-summary-exit ()
  "Exit news summary, remaining within rnews."
  (interactive)
  ;; Switch to the rnews buffer after burying this one.
  ;; Tricky since variable rmail-buffer is local.
  (pop-to-buffer (prog1 news-buffer (bury-buffer (current-buffer))))
  (delete-other-windows)
  (if news-gred-buffer
      (switch-to-buffer news-gred-buffer)))

(defun news-summary-mode ()
  "Major mode in effect in Rmail summary buffer.
A subset of the Rnews mode commands are supported in this mode.
As commands are issued in the summary buffer the corresponding
news message is displayed in the rnews buffer.

n	Move to next message, or arg messages.
j	Jump to the message at cursor location.
p	Move to previous message, or arg messages.
C-n	Move to next, or forward arg messages.
C-p	Move to previous, or backward arg messages.
q	Quit Rnews.
x	Exit and kill the summary window.
space	Scroll message in other window forward.
delete	Scroll message in other window backward.

Entering this mode calls value of hook variable news-summary-mode-hook."
  (interactive)
  (kill-all-local-variables)
  ;;(make-local-variable 'news-summary-total-messages)
  (setq major-mode 'news-summary-mode)
  (setq mode-name '( "Rnews Summary" news-summary-minor-modes))
  (use-local-map news-summary-mode-map)
  (setq truncate-lines t)
  (setq buffer-read-only t)
  (set-syntax-table text-mode-syntax-table)
  (run-hooks 'news-summary-mode-hook))

(defvar news-summary-minor-modes nil)

(defun previous-news-new-summary (gpname &optional begin)
  (interactive "sNews Group Name:")
  (setq news-summary-buffer
	(get-buffer-create "*News Summary*"))
  (setq news-summary-minor-modes (list ": " gpname))
  (pop-to-buffer news-summary-buffer)
  (news-summary-mode)
  (message "Creating News Summary .....")
  (setq buffer-read-only nil)
  (erase-buffer)
  (goto-char 0)
  (let* ((first-and-last (news-get-first-and-last-article-number gpname))
	 (first-no (car first-and-last))
	 (last-no  (cdr first-and-last))
	 (no    (or begin first-no))
	 point )
    (while (<= no last-no)
      (let ((file (concat news-path
			  (string-subst-char ?/ ?. gpname)
			  "/" no)))
	(if (file-exists-p file)
	    (let (subject from)
	      (setq point (point))
	      (insert-file-contents file)
	      (narrow-to-region point (point-max))
	      (goto-char (point-min))
	      (search-forward "\n\n")
	      (delete-region (point) (point-max))
	      (setq subject (or (mail-fetch-field "Subject") "")
		    from    (or (mail-fetch-field "From"   ) ""))
	      (delete-region point (point-max))
	      (widen)
	      (if (< 65 (length subject))
		  (setq subject (substring subject 0 65)))
	      (if (< 10 (length from))
		  (setq from (substring from 0 10)))
	      (goto-char point)
	      (insert (format "%3d %10s %s\n" no from subject))
	      (goto-char (point-max)))))
	  (setq no (1+ no))))
  (goto-char (point-max)) (backward-char 1) (delete-char 1)
  (goto-char 0)
  (message "Creating... done")
  (setq buffer-read-only t))

(defvar news-header-summary-directory "/usr/local/rnews-summary/"  "Directory name under which header summary files exist.")

(defun news-make-all-header-summary ()
  (interactive)
  (find-file-read-only news-active-file)
  (goto-char (point-min))
  (while (not (eobp))
    (if (looking-at "[^ ]* ")
	(progn
	  (message  (buffer-substring (match-beginning 0)(1- (match-end 0))))
	  (kill-buffer 
	   (news-make-header-summary
	    (buffer-substring (match-beginning 0)
			      (1- (match-end 0))))))
      (error "???"))
    (beginning-of-line)
    (forward-line 1))
  (kill-buffer (current-buffer)))

(require 'nntp)

(if (and (fboundp 'nntp-server-active-p)
	 (not (fboundp 'nntp-server-opened)))
    (fset 'nntp-server-opened (symbol-function 'nntp-server-active-p)))

(defun news-make-header-summary (gpname)
  (let* ((header-file (concat news-header-summary-directory
			      gpname))
	 (news-directory  (concat news-path (string-subst-char ?/  ?. gpname) "/"))
	 (first-and-last (news-get-first-and-last-article-number gpname))
	 (first (car first-and-last))
	 (last  (cdr first-and-last))
	 modified
	 (header-last )
	 (buff (find-file-noselect header-file))
	 (lastbuff (current-buffer))
	 point
	 (newslastmod 
	  (nth 5 (file-attributes news-directory)))
	 (headlastmod
	  (nth 5 (file-attributes header-file)))
	 (require-final-newline nil))
    (message "Creating News Summary .....")
    (set-buffer buff)
    (setq buffer-read-only nil)
    (goto-char (point-min))
    (if (search-forward "\n\n" nil t)
	(delete-region (match-beginning 0) (point-max)))
    (goto-char (point-max))
    (if (= (preceding-char) ?\n)
	(delete-char -1))
    (setq modified (buffer-modified-p))
    (setq point (point-max))
    (if (= first last) nil
      (if (bobp)
	  nil
	(beginning-of-line)
	(skip-chars-forward " ")
	(looking-at "[0-9]*[^0-9]")
	(setq header-last 
	      (string-to-int (buffer-substring (match-beginning 0)
					       (1- (match-end 0))))))
      (if (and 
	   (and header-last (= last header-last))
	   (and 
	    headlastmod
	    (or
	     (< (car newslastmod) (car headlastmod))
	     (and (= (car newslastmod) (car headlastmod))
		  (< (car (cdr newslastmod)) (car (cdr headlastmod)))))))
	  nil
	(narrow-to-region (point-max) (point-max))
	(message (format "Creating News Summary .....[%s] about %d articles"
			 gpname
			 (- last (or header-last first))))
	(let ((from (if header-last (1+ header-last) first))
	      (to   last))
	  (if (nntp-server-opened)
	      nil
	    (nntp-open-server 
	     (or (and (boundp 'nntp-server-host) nntp-server-host)
		 (setq nntp-server-host (read-string "nntp server host name: ")))))
	  (nntp-request-group gpname)
	  (while (<= from to)
	    (nntp-request-head from)
	    (set-buffer nntp-server-buffer)
	    (goto-char (point-min))
	    (cond((re-search-forward "^From:.*$" nil t)
		  (set-buffer buff)
		  (insert (int-to-string from) ":")
		  (insert-buffer-substring nntp-server-buffer (match-beginning 0)
					   (match-end 0))
		  (insert ?\n)))
	    (set-buffer nntp-server-buffer)
	    (goto-char (point-min))
	    (cond((re-search-forward "^Subject:.*$" nil t)
		  (set-buffer buff)
		  (insert (int-to-string from) ":")
		  (insert-buffer-substring nntp-server-buffer (match-beginning 0)
					   (match-end 0))
		  (insert ?\n)))
	    (setq from (1+ from))))
	(set-buffer buff)
	(goto-char (point-min))
	(insert ?\n)
	(while (not (eobp))
	  (let ( point1 point2 number)
	    (cond((looking-at "\\(.*:\\)From: .*\n\\1Subject: .*\n")
		  (setq number (buffer-substring (match-beginning 1) (match-end 1)))
		  (goto-char (match-end 1))
		  (let ((col (current-column)))
		    (beginning-of-line)
		    (insert (make-string (max 0 (- 4 col)) ? )))
		  (search-forward ":")
		  (if (looking-at "From:") nil
		    (error "no From: exists"))
		  (delete-region (match-beginning 0) (match-end 0))
		  (end-of-line) 
		  (insert (make-string (max 0 (- (+ 4 1 10) (current-column))) ?  ))
		  (move-to-column (+ 4 1 10 ))
		  (kill-line 1)
		  (insert "  ")
		;;; subject
		  (setq point1 (point))
		  (search-forward "Subject: ")
		  (delete-region point1 (point))
		  (move-to-column (+ 4 1 10 2 65))
		  (or (eolp) (kill-line))
		  (beginning-of-line)
		  (forward-line 1)
		;;; delete errorneous headers
		  (while (looking-at number)
		    (kill-line 1))
		  )
		 ((looking-at ".*:Subject: ")
		  (search-forward ":") 
		  (backward-char 1)
		  (let ((col (current-column)))
		    (beginning-of-line)
		    (insert (make-string (- 4 col) ? )))
		  (search-forward ":")
		  (setq point1 (point))
		  (search-forward "Subject:") (setq point2 (point))
		  (delete-region point1 point2)
		;;;(move-to-column (+ 4 1 10))
		  (insert "            ")
		  (beginning-of-line)
		  (next-line 1))
		 ((looking-at ".*:From: ")
		  (search-forward ":") 
		  (backward-char 1)
		  (let ((col (current-column)))
		    (beginning-of-line)
		    (insert (make-string (max 0 (- 4 col))  ? )))
		  (search-forward ":")
		  (setq point1 (point))
		  (search-forward "From:") (setq point2 (point))
		  (delete-region point1 point2)
		  (move-to-column (+ 4 1 10))
		  (or (eolp) (kill-line 1))
		  (beginning-of-line)
		  (next-line 1))
		 (t(next-line 1)))))
	(goto-char (point-min)) 
	(or (eobp) (delete-char 1))
	(goto-char (point-max)) 
	(or (bobp) (delete-backward-char 1))
	(widen)
	(goto-char point)
	(cond((and (not modified) (= point (point-max))) ;;; nothing added
	      nil)
	     ((= point (point-min)) ;;; original is empty
	      (if (verify-visited-file-modtime buff)
		  (let ((version-control 'never))
		    (save-buffer)
		    (set-file-modes header-file 438))))
	     (t
	      (goto-char point) (insert ?\n)
	      (if (verify-visited-file-modtime buff)
		  (let ((version-control 'never))
		    (if modified (save-buffer)
		      (progn 
			(message "Adding new headers...")
			(append-to-file point (point-max) buffer-file-name)
		        (message "Adding new headers... done")
			)
		      )
		   ))))))
    (setq buffer-file-name nil)
    (set-buffer lastbuff)
    (message "Creating... done")
    buff))

(defun t-news-make-header-summary (gpname)
  (let* ((header-file (concat news-header-summary-directory
		      gpname))
	 (news-directory  (concat news-path (string-subst-char ?/  ?. gpname) "/"))
	 (first-and-last (news-get-first-and-last-article-number gpname))
	 (first (car first-and-last))
	 (last  (cdr first-and-last))
	 (header-last )
	 (buff (find-file-noselect header-file))
	 (lastbuff (current-buffer))
	 point
	 (newslastmod 
	  (nth 5 (file-attributes news-directory)))
	 (headlastmod
	  (nth 5 (file-attributes header-file))))
    (message "Creating News Summary .....")
    (set-buffer buff)
    (setq buffer-read-only nil)
    (goto-char (point-max))
    (setq point (point-max))
    (if (= first last) nil
      (if (bobp)
	  nil
	(beginning-of-line)
	(skip-chars-forward " ")
	(looking-at "[0-9]*[^0-9]")
	(setq header-last 
	      (string-to-int (buffer-substring (match-beginning 0)
					       (1- (match-end 0))))))
      (if (and headlastmod
	       (or
		(< (car newslastmod) (car headlastmod))
		(and (= (car newslastmod) (car headlastmod))
		     (< (car (cdr newslastmod)) (car (cdr headlastmod))))
		(and header-last (= last header-last))))
	  nil
	(narrow-to-region (point-max) (point-max))
	(message (format "Creating News Summary .....[%s] about %d articles"
			 gpname
			 (- last (or header-last first))))
      (insert "cd " news-directory ";")
      (let ((from (if header-last (1+ header-last) (1+ first)))
	    (to   last))
	(insert "egrep '(^From: )|(^Subject: )' ")
	(insert " '#.#'")
	(insert-shell-regexp-range from (min last (+ from 1000)))
	(setq from (+ from 1001))
	(while (<= from last)
	  (insert ";egrep '(^From: )|(^Subject: )' ")
	  (insert " '#.#'")
	  (insert-shell-regexp-range from (min last (+ from 1000)))
	  (setq from (+ from 1001))))
      (let ((cmd (buffer-substring (point-min) (point-max))))
	(delete-region (point-min) (point-max))
	(shell-command-on-region (point-min) (point-min) cmd t))
      (goto-char (point-min))
      (insert ?\n)
      (while (not (eobp))
	(let ( point1 point2 number)
	  (cond((looking-at "egrep:") (kill-line) (kill-line))
	       ((looking-at "\\(.*:\\)From: .*\n\\1Subject: .*\n")
		(setq number (buffer-substring (match-beginning 1) (match-end 1)))
		(goto-char (match-end 1))
		(let ((col (current-column)))
		  (beginning-of-line)
		  (insert (make-string (max 0 (- 4 col)) ? )))
		(search-forward ":")
		(if (looking-at "From:") nil
		  (error "no From: exists"))
		(delete-region (match-beginning 0) (match-end 0))
		(end-of-line) 
		(insert (make-string (max 0 (- (+ 4 1 10) (current-column))) ?  ))
		(move-to-column (+ 4 1 10 ))
		(kill-line 1)
		(insert "  ")
		;;; subject
		(setq point1 (point))
		(search-forward "Subject: ")
		(delete-region point1 (point))
		(move-to-column (+ 4 1 10 2 65))
		(or (eolp) (kill-line))
		(beginning-of-line)
		(forward-line 1)
		;;; delete errorneous headers
		(while (looking-at number)
		  (kill-line 1))
		)
	       ((looking-at 
		 "\\(.*\\):Subject: .*\n\\1:From: ")
		(next-line 1) (transpose-lines 1) (forward-line -2))
	       ((looking-at ".*:Subject: ")
		(search-forward ":") 
		(backward-char 1)
		(let ((col (current-column)))
		  (beginning-of-line)
		  (insert (make-string (- 4 col) ? )))
		(search-forward ":")
		(setq point1 (point))
		(search-forward "Subject:") (setq point2 (point))
		(delete-region point1 point2)
		;;;(move-to-column (+ 4 1 10))
		(insert "            ")
		(beginning-of-line)
		(next-line 1))
	       ((looking-at ".*:From: ")
		(search-forward ":") 
		(backward-char 1)
		(let ((col (current-column)))
		  (beginning-of-line)
		  (insert (make-string (max 0 (- 4 col))  ? )))
		(search-forward ":")
		(setq point1 (point))
		(search-forward "From:") (setq point2 (point))
		(delete-region point1 point2)
		(move-to-column (+ 4 1 10))
		(or (eolp) (kill-line 1))
		(beginning-of-line)
		(next-line 1))
	       ((looking-at "[nN]o [mM]atch")
		(delete-region (point-min) (point-max)))
	       ((looking-at "Arguments too long.")
		(error "CSH: arguments too long."))
	       (t(next-line 1)))))
      (goto-char (point-min)) 
      (or (eobp) (delete-char 1))
      (goto-char (point-max)) 
      (or (bobp) (delete-backward-char 1))
      (widen)
      (goto-char point)
      (cond((= point (point-max))	;;; nothing added
	    nil)
	   (t (or (= point (point-min)) 
		  (progn (goto-char point) (insert ?\n)))
	      (if (verify-visited-file-modtime buff)
		  (let ((version-control 'never))
		    (save-buffer)
		    (set-file-modes header-file 438)))))))
    (setq buffer-file-name nil)
    (set-buffer lastbuff)
    (message "Creating... done")
    buff))

(defun previous-news-new-summary (gpname &optional begin)
  (interactive "sNews Group Name:")
  (setq news-summary-buffer  (get-buffer-create "*News Summary*"))
  (setq news-summary-minor-modes (list ": " gpname))
  (pop-to-buffer news-summary-buffer)
  (news-summary-mode)
  (message "Creating News Summary .....")
  (setq buffer-read-only nil)
  (erase-buffer)
  (goto-char 0)
  (insert "cd " news-path (string-subst-char ?/  ?. gpname) "/;")
  (insert "egrep '(^From: )|(^Subject: )' ")
  (let* ((first-and-last (news-get-first-and-last-article-number gpname))
	 (first-no (car first-and-last))
	 (last-no  (cdr first-and-last))
	 (no    (or begin first-no)))
    (insert " '#.#'")
    (insert-shell-regexp-range no last-no)
    (let ((cmd (buffer-substring (point-min) (point-max))))
      (erase-buffer)
      (shell-command-on-region (point-min) (point-min) cmd t)))
  (goto-char (point-min))
  (while (not (eobp))
    (let ( point1 point2 )
      (cond((looking-at "egrep:") (kill-line) (kill-line))
	   ((looking-at ".*:From: ")
	    (search-forward ":") 
	    (backward-char 1)
	    (let ((col (current-column)))
	      (beginning-of-line)
	      (insert (make-string (- 4 col) ? )))
	    (search-forward ":")
	    (setq point1 (point))
	    (search-forward "From:") (setq point2 (point))
	    (delete-region point1 point2)
	    (move-to-column (+ 4 1 10))
	    (or (eolp) (kill-line))
	    (insert (make-string 2 ? ))
	    (beginning-of-line)
	    (next-line 1)
	    (if (looking-at ".*:Subject: ")
		(progn
		  (delete-backward-char 1)
		  (setq point1 (point))
		  (search-forward "Subject: ")
		  (delete-region point1 (point))
		  (move-to-column (+ 4 1 10 1 65))
		  (or (eolp) (kill-line))
		  (beginning-of-line)
		  (next-line 1))))
	   ((looking-at ".*:Subject: ") 
	    (next-line 1))
	   ((looking-at "[nN]o [mM]atch")
	    (erase-buffer))
	   (t(next-line 1)))))
  (goto-char (point-max)) (or (bobp) (delete-backward-char 1))
  (goto-char (point-min))
  (message "Creating... done")
  (setq buffer-read-only t)
  (or (eobp)  (news-summary-goto-msg-internal)))

(defun news-new-summary (gpname &optional begin)
  (interactive "sNews Group Name:")
  (and news-summary-buffer (kill-buffer news-summary-buffer))
  (setq news-summary-buffer (news-make-header-summary gpname))
  (pop-to-buffer news-summary-buffer)
  (rename-buffer "*News Summary*")
  (setq news-summary-minor-modes (list ": " gpname))
  (news-summary-mode)
  (setq buffer-read-only t)
  (goto-char (point-max))
  (if begin
      (let* ((f-and-l (news-get-first-and-last-article-number gpname))
	     (last    (cdr f-and-l))
	     (point   (point-max)))
	(while (and (<= begin last)
		    (not (re-search-backward (concat "^.*" (int-to-string begin) ":")
				       nil point)))
	  (setq begin (1+ begin)))
	))
  (or (eobp)  (news-summary-goto-msg-internal))
  (set-window-start (selected-window) (point))
  )

(defun insert-shell-regexp-range  (min max)
  (let ((base 10) (ibase 0) next digit (flag t))
    ;;(if (< min 10)
    ;;	  (progn (insert " [" (int-to-string min) "-9]")
    ;;		 (setq min 10)))
    (while flag
      (setq next (* base (1+ (/ min base)))
	    digit   (/ (% min base) (/ base 10)))
      (if (<= next max)
	  (progn
	    (insert " " (let ((x (/ min base)))
			  (if (< 0 x) (int-to-string x) ""))
		    "[" (int-to-string digit) "-9]")
	    (let ((i ibase))
	      (while (< 0 i)
		(insert "[0-9]")
		(setq i (1- i))))
	    (setq ibase (1+ ibase)
		  base  (* base 10)
		  min   next))
	(setq flag nil)))
    ;;; here we need make the pattern for min <= * <= max
    (while (<= 10 base)
      (let ((left (/ max base))
	    (from (/ (% min base) (/ base 10)))
	    (to   (/ (% max base) (/ base 10))))
	(if (not (= from to))
	    (progn 
	      (insert " " (if (< 0 left) (int-to-string left) "")
		      "[" (int-to-string from) "-" (int-to-string (1- to)) "]")
	      (let ((i ibase))
		(while (< 0 i)
		  (insert "[0-9]")
		  (setq i (1- i))))))
	(setq base (/ base 10)
	      ibase (1- ibase))
	))
    (insert " " (int-to-string max))))

;;; patch by S.Tomura 88-Feb-13
;;;(defun news-get-pruned-list-of-files (gp-list end-file-no)
;;;  "Given a news group it does an ls to give all files in the news group.
;;;The arg must be in slashified format.
;;;Using ls was found to be too slow in a previous version."
;;;  (let
;;;      ((answer
;;;	(and
;;;	 (not (and end-file-no
;;;		   (equal (news-set-current-certifiable)
;;;		     (news-group-certification gp-list))
;;;		   (setq news-list-of-files nil
;;;			 news-list-of-files-possibly-bogus t)))
;;;	 (let* ((file-directory (concat news-path
;;;					(string-subst-char ?/ ?. gp-list)))
;;;		tem
;;;		(last-winner
;;;		 (and end-file-no
;;;		      (news-wins file-directory end-file-no)
;;;		      (news-find-first-or-last file-directory end-file-no 1))))
;;;	   (setq news-list-of-files-possibly-bogus t news-list-of-files nil)
;;;	   (if last-winner
;;;	       (progn
;;;		 (setq news-list-of-files-possibly-bogus t
;;;		       news-current-group-end last-winner)
;;;		 (while (> last-winner end-file-no)
;;;		   (news-push last-winner news-list-of-files)
;;;		   (setq last-winner (1- last-winner)))
;;;		 news-list-of-files)
;;;	     (if (or (not (file-directory-p file-directory))
;;;                  (not (file-readable-p file-directory)))
;;;		 nil
;;;	       (setq news-list-of-files
;;;		     (condition-case error
;;;			 (directory-files file-directory)
;;;		       (file-error
;;;			(if (string= (nth 2 error) "permission denied")
;;;			    (message "Newsgroup %s is read-protected"
;;;				     gp-list)
;;;			  (signal 'file-error (cdr error)))
;;;			nil)))
;;;	       (setq tem news-list-of-files)
;;;	       (while tem
;;;		 (if (or (not (string-match "^[0-9]*$" (car tem)))
;;;					;; dont get confused by directories that look like numbers
;;;			 (file-directory-p
;;;			  (concat file-directory "/" (car tem)))
;;;			 (<= (string-to-int (car tem)) end-file-no))
;;;		     (setq news-list-of-files
;;;			   (delq (car tem) news-list-of-files)))
;;;		 (setq tem (cdr tem)))
;;;	       (if (null news-list-of-files)
;;;		   (progn (setq news-current-group-end 0)
;;;			  nil)
;;;		 (setq news-list-of-files
;;;		       (mapcar 'string-to-int news-list-of-files))
;;;		 (setq news-list-of-files (sort news-list-of-files '<))
;;;		 (setq news-current-group-end
;;;		       (elt news-list-of-files
;;;			    (1- (length news-list-of-files))))
;;;		 news-list-of-files)))))))
;;;    (or answer (progn (news-set-current-group-certification) nil))))
;;;

(defun news-get-next-news-no (gp-name current-no &optional reversep)
  (let* ((file-directory
	  (concat news-path (string-subst-char ?/ ?. gp-name)))
	 (first-and-last 
	  (news-get-first-and-last-article-number gp-name))
	 (first-number (car first-and-last))
	 (last-number  (cdr first-and-last)))
    (let ((i (if reversep 
		 (if (and current-no 
			  (<= first-number (1- current-no))
			  (<= (1- current-no) last-number))
		     (1- current-no)
		   last-number)
	       (if (and current-no 
			(<= first-number (1+ current-no))
			(<= (1+ current-no) last-number))
		   (1+ current-no)
		 first-number))))
      (while (and (<= first-number i)
		  (<= i last-number)
		  (let ((filename (concat file-directory "/" (int-to-string i))))
		     (not
		      (and (file-exists-p filename)
			   (not (file-directory-p filename))))))
	(setq i (if reversep (1- i) (1+ i))))
      (if (and (<= first-number i) (<= i last-number))
	  i nil))))
;;; end of patch

(defun news-read-files-into-buffer (group reversep)
  ;;; patch by S.Tomura 88-Feb-15
  ;;;(let* ((files-start-end (news-cadr (assoc group news-group-article-assoc)))
  (let* ((files-start-end (news-caddr (assoc group news-group-article-status)))
  ;;; end of patch
	 (start-file-no (car files-start-end))
	 ;;; patch by S. Tomura 88-Feb-15
	 ;;(end-file-no (news-cadr files-start-end))
	 (end-file-no (cdr files-start-end))
	 ;;; patch by S.Tomura 88-Feb-14
	 (first-and-last 
	  (news-get-first-and-last-article-number group))
	 (first-number (car first-and-last))
	 (last-number  (cdr first-and-last))
	 (next-number  (if (and end-file-no last-number
				(<= last-number end-file-no))
			   nil
			 (news-get-next-news-no group end-file-no reversep)))
	 (begin-number (if (and end-file-no last-number
				(<= last-number end-file-no))
			   nil
			 (news-get-next-news-no group end-file-no nil)))
	 ;;; end of patch
	 (buffer-read-only nil))
    (setq news-current-news-group group)
    (setq news-current-new-articles-p (numberp next-number))
    ;;; patch by S.Tomura 88-Feb-14
    ;;;(setq news-current-message-number nil)
    ;;;(setq news-current-group-end nil)
    (setq news-current-message-number next-number)
    (setq news-current-group-begin (or begin-number last-number))
    (setq news-current-group-end last-number)
    ;;; end of patch
    (news-set-mode-line)
    ;;; patch by S.Tomura 88-Feb-14
    ;;;(news-get-pruned-list-of-files group end-file-no)
    ;;;(news-set-mode-line)
    ;;; end of patch
    ;; @@ should be a lot smarter than this if we have to move
    ;; @@ around correctly.
    ;;; patch by S.Tomura 88-Feb-14
    ;;;(setq news-point-pdl (list (cons (car files-start-end)
    ;;;				     (news-cadr files-start-end))))
    (setq news-point-pdl (list (cons start-file-no end-file-no)))
    ;;; end of patch
    ;;; patch by S.Tomura 88-Feb-14
    ;;;(if (null news-list-of-files)
    (if (null next-number)
	(progn (erase-buffer)
	       ;;; patch by S. Tomura 88-Feb-14
	       ;;;(setq news-current-group-end end-file-no)
	       ;;;(setq news-current-group-begin end-file-no)
	       ;;; end of patch
	       (setq news-current-message-number end-file-no)
	       (news-set-mode-line)
;	       (message "No new articles in " group " group.")
	       nil)
      ;;; patch by S. Tomura 88-Feb-14
      ;;;(setq news-current-group-begin (car news-list-of-files))
      ;;;(if reversep
      ;;;	  (setq news-current-message-number news-current-group-end)
      ;;;	(if (> (car news-list-of-files) end-file-no)
      ;;;	    (setcdr (car news-point-pdl) (car news-list-of-files)))
      ;;;	(setq news-current-message-number news-current-group-begin))
      (if reversep
	  nil
	(setcdr (car news-point-pdl) news-current-message-number))
      ;;; end of patch
      ;;; patch by S.Tomura 88-Feb-14
      ;;;(news-set-message-counters)
      ;;; end of patch
      (news-set-mode-line)
      (news-read-in-file (concat news-path
				 (string-subst-char ?/ ?. group)
				 "/"
				 (int-to-string
				   news-current-message-number)))
      ;;; patch by S.Tomura 88-Feb-14
      ;;;(news-set-message-counters)
      ;;; end of patch
      (news-set-mode-line)
      t)))

;;; patch by S.Tomura 88-Feb-15
(defun news-add-news-group-predicate (item)
  (let ((rec (assoc (car item) news-group-article-status)))
    (or (null rec)
	(null (news-cadr rec)))))
;;; end of patch

(defun news-add-news-group (gp)
  "Resubscribe to or add a USENET news group named GROUP (a string)."
; @@ (completing-read ...)
; @@ could be based on news library file ../active (slightly facist)
; @@ or (expensive to compute) all directories under the news spool directory
;;; patch by S.Tomura 87-06-23
;;;  (interactive "sAdd news group: ")
  (interactive (list 
		(completing-read "Add news group: "
				 (news-get-all-news-group-assoc)
				 (function news-add-news-group-predicate)
				 t )))
;;; end of patch
;;; patch by S. Tomura 88-Feb-15
;;;  (let ((file-dir (concat news-path (string-subst-char ?/ ?. gp))))
;;;    (save-excursion
;;;      (if (null (assoc gp news-group-article-assoc))
;;;	  (let ((newsrcbuf (find-file-noselect
;;;			    (substitute-in-file-name news-startup-file))))
;;;	    (if t ;;; (assoc gp (news-get-all-news-group-assoc))
;;;		(progn
;;;		  (switch-to-buffer newsrcbuf)
;;;		  (goto-char 0)
;;;		  (if (search-forward (concat gp "! ") nil t)
;;;		      (progn
;;;			(message "Re-subscribing to group %s." gp)
;;;			;;@@ news-unsubscribe-groups isn't being used
;;;			;;(setq news-unsubscribe-groups
;;;			;;    (delq gp news-unsubscribe-groups))
;;;			(backward-char 2)
;;;			(delete-char 1)
;;;			(insert ":"))
;;;		    (progn
;;;		      (message
;;;		       "Added %s to your list of newsgroups." gp)
;;;		      (end-of-buffer)
;;;		      (insert gp ": 1-1\n")))
;;;		  (search-backward gp nil t)
;;;		  (let (start endofname end endofline tem)
;;;		    (search-forward ":" nil t)
;;;		    (setq endofname (- (point) 1))
;;;		    (skip-chars-forward " ")
;;;		    (setq end (point))
;;;		    (beginning-of-line)
;;;		    (setq start (point))
;;;		    (end-of-line)
;;;		    (setq endofline (point))
;;;		    (setq tem (buffer-substring start endofname))
;;;		    (let ((range (news-parse-range
;;;				  (buffer-substring end endofline))))
;;;		      (setq news-group-article-assoc
;;;			    (cons (list tem (list (car range)
;;;						  (cdr range)
;;;						  (cdr range)))
;;;				  news-group-article-assoc))))
;;;		  (save-buffer)
;;;		  (kill-buffer (current-buffer)))
;;;	      (message "Newsgroup %s doesn't exist." gp)))
;;;	(message "Already subscribed to group %s." gp)))))
  (let ((item (assoc gp news-group-article-status)))
    (if item
	(progn
	  (setcar (cdr item) t)
	  (message "Re-subscribing to group %s." gp)
	  )
      (let ((item (list t (cons 0 0))))
	;;; patch by S. Tomura 88-Jul-15
	(put (intern gp) ':news-status item)
	;;; end of patch
	(setq news-group-article-status
	    (cons (cons gp item)
		  news-group-article-status))
	(message "Added %s to your list of newgroups." gp)))))
;;; end of patch

(defun news-make-link-to-message (number newname)
	"Forges a link to an rnews message numbered number (current if no arg)
Good for hanging on to a message that might or might not be
automatically deleted."
  (interactive "P
FName to link to message: ")
  (add-name-to-file
   (concat news-path
	   (string-subst-char ?/ ?. news-current-news-group)
	   "/" (if number
		   (prefix-numeric-value number)
		 news-current-message-number))
   newname))

;;; caesar-region written by phr@prep.ai.mit.edu  Nov 86
;;; modified by tower@prep Nov 86
(defun caesar-region (&optional n)
  "Caesar rotation of region by N, default 13, for decrypting netnews."
  (interactive (if current-prefix-arg	; Was there a prefix arg?
		   (list (prefix-numeric-value current-prefix-arg))
		 (list nil)))
  (cond ((not (numberp n)) (setq n 13))
	((< n 0) (setq n (- 26 (% (- n) 26))))
	(t (setq n (% n 26))))		;canonicalize N
  (if (not (zerop n))		; no action needed for a rot of 0
      (progn
	(if (or (not (boundp 'caesar-translate-table))
		(/= (aref caesar-translate-table ?a) (+ ?a n)))
	    (let ((i 0) (lower "abcdefghijklmnopqrstuvwxyz") upper)
	      (message "Building caesar-translate-table...")
	      (setq caesar-translate-table (make-vector 256 0))
	      (while (< i 256)
		(aset caesar-translate-table i i)
		(setq i (1+ i)))
	      (setq lower (concat lower lower) upper (upcase lower) i 0)
	      (while (< i 26)
		(aset caesar-translate-table (+ ?a i) (aref lower (+ i n)))
		(aset caesar-translate-table (+ ?A i) (aref upper (+ i n)))
		(setq i (1+ i)))
	      (message "Building caesar-translate-table... done")))
	(let ((from (region-beginning))
	      (to (region-end))
	      (i 0) str len)
	  (setq str (buffer-substring from to))
	  (setq len (length str))
	  (while (< i len)
	    (aset str i (aref caesar-translate-table (aref str i)))
	    (setq i (1+ i)))
	  (goto-char from)
	  (kill-region from to)
	  (insert str)))))

;;; news-caesar-buffer-body written by paul@media-lab.mit.edu  Wed Oct 1, 1986
;;; hacked further by tower@prep.ai.mit.edu
(defun news-caesar-buffer-body (&optional rotnum)
  "Caesar rotates all letters in the current buffer by 13 places.
Used to encode/decode possibly offensive messages (commonly in net.jokes).
With prefix arg, specifies the number of places to rotate each letter forward.
Mail and USENET news headers are not rotated."
  (interactive (if current-prefix-arg	; Was there a prefix arg?
		   (list (prefix-numeric-value current-prefix-arg))
		 (list nil)))
  (save-excursion
    (let ((buffer-status buffer-read-only))
      (setq buffer-read-only nil)
      ;; setup the region
      (set-mark (if (progn (goto-char (point-min))
			    (search-forward
			     (concat "\n"
				     (if (equal major-mode 'news-mode)
					 ""
				       mail-header-separator)
				     "\n") nil t))
		     (point)
		   (point-min)))
      (goto-char (point-max))
      (caesar-region rotnum)
      (setq buffer-read-only buffer-status))))
