;;; Rmail sort the messages by date
;;;
;;;  Copyright 1988 Satoru Tomura
;;;

;;; Babyl format:
;;; <Header> ^_ { ^L <Text> ^_ }...

(defun rmail-sort-by-date ()
  (interactive)
  (message "Sorting messages by date ...")
  (let ((buffer-read-only nil))
    (widen)
    (mark-timestamp)
    (goto-char (point-min))
    (search-forward "\^_")
    (sort-regexp-fields nil "\^L\nSORTTIME:[^\^L\^_]*\^_" "^SORTTIME: [0-9]*$" (point) (point-max))
    (unmark-timestamp)
    (message "Sorting messages by date ... done")
    (rmail-set-message-counters)
    (rmail-show-message)
    )
  )

(defun mark-timestamp ()
  (widen)
  (goto-char (point-min))
  (search-forward "\^_")
  (while (not (eobp))
    (let ((start (point)))
      (search-forward "\^_")
      (narrow-to-region start (point))
      (let ((time (get-timestamp)))
	(goto-char (point-min))
	(forward-char)
	(insert "\nSORTTIME: " time ?\n))
      (goto-char (point-max)))
    (widen)))
	     
(defun unmark-timestamp ()
  (widen)
  (goto-char (point-min))
  (while (re-search-forward "\nSORTTIME: .*\n" nil t)
    (replace-match ""))
  )

(defun find-no-message-id ()
  (goto-char (point-min))
  (while (re-search-forward "\^L[^\^L\^_]*\^_" (point-max) t)
    (let ((start (match-beginning 0)) (end (match-end 0)))
      (goto-char start)
      (if (re-search-forward "^Message-Id: .*$" end t)
	  nil
	(message "NO Message-Id:")
      (read-char))
    (goto-char end))))

(defun month-value (str)
  (cond ((or (equal str "Jan") (equal str "jan")) "01")
	((or (equal str "Feb") (equal str "feb")) "02")
	((or (equal str "Mar") (equal str "mar")) "03")
	((or (equal str "Apr") (equal str "apr")) "04")
	((or (equal str "May") (equal str "may")) "05")
	((or (equal str "Jun") (equal str "jun")) "06")
	((or (equal str "Jul") (equal str "jul")) "07")
	((or (equal str "Aug") (equal str "aug")) "08")
	((or (equal str "Sep") (equal str "sep")) "09")
	((or (equal str "Oct") (equal str "oct")) "10")
	((or (equal str "Nov") (equal str "nov")) "11")
	((or (equal str "Dec") (equal str "dec")) "12")
	(t "??")))

(defun day-value (int)
  (if (<= int 9) (format "0%d" int)
    (format "%d" int)))

(defun get-timestamp ()
  (goto-char (point-min))
  (cond	((re-search-forward "^Date:" nil t)
	 (let ((year "YY") (month "MM") (day "DD") (hour "HH") (minutes "MM")
	       (end (save-excursion (end-of-line) (point))))
	   (cond((re-search-forward
		  "\\([^0-9]\\)\\([0-3]?[0-9]\\) *\\([a-z]*\\) *\\([0-9][0-9]\\) *\\([0-9]?[0-9]\\):\\([0-9]?[0-9]\\):\\([0-9]?[0-9]\\)"
		  end t)
		 (setq day (day-value (string-to-int (buffer-substring (match-beginning 2) (match-end 2)))))
		 (setq month (month-value (buffer-substring (match-beginning 3) (match-end 3))))
		 (setq year (buffer-substring (match-beginning 4) (match-end 4)))
		 (setq hour (buffer-substring (match-beginning 5) (match-end 5)))
		 (setq minutes (buffer-substring (match-beginning 6) (match-end 6))))
		((re-search-forward 
		  "\\([^0-9:]\\)\\([0-3]?[0-9]\\)\\([- \t_]+\\)\\([adfjmnos][aceopu][bcglnprtvy]\\)\\([0-9][0-9]\\)"
		  end t)
		 (setq year (buffer-substring (match-beginning 5) (match-end 5)))
		 (setq date (string-to-int (buffer-substring (match-beginning 2) (match-end 2))))
		 (setq month (month-value (buffer-substring  (match-beginning 4) (match-end 4))))
		 )
		((re-search-forward 
		  "\\([^a-z]\\)\\([adfjmnos][acepou][bcglnprtvy]\\)\\([-a-z \t_]*\\)\\([0-9][0-9]?\\)"
		  end t)
		 (setq date (string-to-int (buffer-substring (match-beginning 4)(match-end 4))))
		 (setq month (month-value (buffer-substring (match-beginning 2) (match-end 2))))))
	   (concat year month day hour minutes)))
	((re-search-forward "^Message-Id:" nil t)
	 (re-search-forward "[0-9]+" nil nil)
	 (buffer-substring (match-beginning 0) (match-end 0)))))


(defun make-timestamp ()
  (goto-char (point-min))
  (cond	((re-search-forward "^Date:" nil t)
	 (let ((end (save-excursion (end-of-line) (point))))
	   (cond((re-search-forward
		  ;;; 2: day 3: month 4: year 5: hour 6: minutes
		  "\\([^0-9]\\)\\([0-3]?[0-9]\\) *\\([a-z]*\\) *\\([0-9][0-9]\\) *\\([0-9]?[0-9]\\):\\([0-9]?[0-9]\\):\\([0-9]?[0-9]\\)"
		  end t)
		 (goto-char end)
		 (insert "\nSORTTIME: ")
		 ;;; year
		 (insert-buffer-substring (current-buffer) (match-beginning 4) (match-end 4))
		 ;;; month
		 (insert (month-value (buffer-substring (match-beginning 3) (match-end 3))))
		 ;;; day
		 (if (= (1+ (match-beginning 2)) (match-end 2)) (insert "0"))
		 (insert-buffer-substring (current-buffer) (match-beginning 2) (match-end 2))
		 ;;; hour
		 (insert-buffer-substring (current-buffer) (match-beginning 5) (match-end 5))
		 ;;; min.
		 (insert-buffer-substring (current-buffer) (match-beginning 6) (match-end 6))
		 (insert ?\n))
		((re-search-forward 
		  "\\([^0-9:]\\)\\([0-3]?[0-9]\\)\\([- \t_]+\\)\\([adfjmnos][aceopu][bcglnprtvy]\\)\\([0-9][0-9]\\)"
		  end t)
		 (goto-char end)
		 (insert "\nSORTTIME: ")
		 ;;; year
		 (insert-buffer-substring (current-buffer) (match-beginning 5) (match-end 5))
		 ;;; month
		 (insert (month-value (buffer-substrgin (match-beginning 4) (match-end 4))))
		 ;;; day
		 (if (= (1+ (match-beginning 2)) (match-end 2)) (insert "0"))
		 (buffer-substring (match-beginning 2) (match-end 2))
		 (insert ?\n))
		((re-search-forward 
		  "\\([^a-z]\\)\\([adfjmnos][acepou][bcglnprtvy]\\)\\([-a-z \t_]*\\)\\([0-9][0-9]?\\)"
		  end t)
		 (goto-char end)
		 (insert "\nSORTTIME: ")
		 ;;; year
		 (insert "YY")
		 ;;; month
		 (insert (month-value (buffer-substring (match-beginning 2) (match-end 2))))
		 ;;; day
		 (if (= (1+ (match-beginning 4)) (match-end 4)) (insert "0"))
		 (insert-buffer-substring (current-buffer) (match-beginning 4) (match-end 4))
		 (insert ?\n)))))
	((re-search-forward "^Message-Id:" nil t)
	 (re-search-forward "[0-9]+" nil nil)
	 (end-of-line)
	 (insert "\nSORTTIME: ")
	 (insert-buffer-substring (current-buffer) (match-beginning 0) (match-end 0))
	 (insert ?\n))
	(t
	 (goto-char (point-min)) (forward-char))
	 (insert "\nSORTTIME: \n" )))











