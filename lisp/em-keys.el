;
; em-keys.el
;
; Written by Eberhard Mattes
;
(provide 'em-keys)

(defvar ext-map nil
  "Keymap used for extended scan codes.")
(setq ext-map (make-keymap))

(defvar em-map nil
  "Keymap used for em's key definitions which are prefixed by F9.")
(setq em-map (make-sparse-keymap))

(define-key ext-map "\040" 'em-dup-line)	    ; A-d
(define-key ext-map "\041" 'find-file)		    ; A-f
(define-key ext-map "\042" 'goto-line)	            ; A-g
(define-key ext-map "\056" 'em-copy-region)         ; A-c
(define-key ext-map "\046" 'em-copy-line-as-kill)   ; A-l
(define-key ext-map "\062" 'em-match-paren)         ; A-m
(define-key ext-map "\030" 'open-rectangle)	    ; A-o
(define-key ext-map "\021" 'em-kill-word)	    ; A-w
(define-key ext-map "\016" 'undo)		    ; A-BS
(define-key ext-map "<" 'em-other-buffer)	    ; F2
(define-key ext-map "=" 'em-search-forward)	    ; F3
(define-key ext-map ">" 'em-search-backward)	    ; F4
(define-key ext-map "?" 'em-fill-paragraph)         ; F5
(define-key ext-map "@" 'other-window)		    ; F6
(define-key ext-map "A" 'undefined)		    ; F7
(define-key ext-map "B" 'undefined)		    ; F8
(define-key ext-map "C" em-map)			    ; F9
(define-key ext-map "D" 'undefined)		    ; F10
(define-key ext-map "E" 'undefined)		    ;
(define-key ext-map "F" 'undefined)		    ;
(define-key ext-map "G" 'beginning-of-line)	    ; HOME
(define-key ext-map "H" 'previous-line)		    ; UP
(define-key ext-map "I" 'scroll-down)		    ; PAGEUP
(define-key ext-map "J" 'undefined)		    ;
(define-key ext-map "K" 'backward-char)		    ; LEFT
(define-key ext-map "L" 'goto-line)		    ; CENTER
(define-key ext-map "M" 'forward-char)		    ; RIGHT
(define-key ext-map "N" 'undefined)		    ;
(define-key ext-map "O" 'end-of-line)		    ; END
(define-key ext-map "P" 'next-line)		    ; DOWN
(define-key ext-map "Q" 'scroll-up)		    ; PAGEDOWN
(define-key ext-map "R" 'overwrite-mode)	    ; INSERT
(define-key ext-map "S" 'delete-char)		    ; DELETE
(define-key ext-map "T" 'describe-key)		    ; S-F1
(define-key ext-map "U" 'em-buffer-list)	    ; S-F2
(define-key ext-map "V" 'next-error)		    ; S-F3
(define-key ext-map "W" 'undefined)		    ; S-F4
(define-key ext-map "X" 'undefined)		    ; S-F5
(define-key ext-map "Y" 'undefined)		    ; S-F6
(define-key ext-map "Z" 'undefined)		    ; S-F7
(define-key ext-map "s" 'em-backward-to-word)	    ; C-LEFT
(define-key ext-map "t" 'em-forward-to-word)	    ; C-RIGHT
(define-key ext-map "u" 'kill-line)		    ; C-END
(define-key ext-map "v" 'em-end-of-buffer)	    ; C-PAGEDOWN
(define-key ext-map "w" 'em-kill-left-line)	    ; C-HOME
(define-key ext-map "\200" 'undefined)              ; A-9
(define-key ext-map "\204" 'em-beginning-of-buffer) ; C-PAGEUP
(define-key ext-map "\205" 'call-last-kbd-macro)    ; F11
(define-key ext-map "\206" 'set-mark-command)	    ; F12
(define-key ext-map "\207" 'expand-abbrev)          ; S-F11
(define-key ext-map "\215" 'em-scroll-line-down)    ; C-UP
(define-key ext-map "\216" 'undefined)              ; C-NUM-
(define-key ext-map "\217" 'undefined)              ; C-CENTER
(define-key ext-map "\220" 'undefined)              ; C-NUM+
(define-key ext-map "\221" 'em-scroll-line-up)	    ; C-DOWN
(define-key ext-map "\222" 'undefined)              ; C-INSERT
(define-key ext-map "\231" 'undefined)              ; A-PAGEUP
(define-key ext-map "\233" 'scroll-right)	    ; A-LEFT
(define-key ext-map "\235" 'scroll-left)	    ; A-RIGHT
(define-key ext-map "\241" 'scroll-other-window)    ; A-PAGEDOWN
(define-key ext-map "\245" 'undefined)              ; A-TAB

(define-key em-map "c" 'compile)	            ; F9 c
(define-key em-map "i" 'em-reinitialize)	    ; F9 i

(global-set-key "\e " 'set-mark-command)
(global-set-key "\0" ext-map)

;
; The following definitions avoid the insertion of unexpected
; characters into the buffer if the scan code prefix (C-@) is not a
; valid key. Otherwise, "C-X RIGHT", for instance, would be
; interpreted as C-X C-@, which is undefined, followed by "M" which
; would be inserted into the buffer.
;
(define-key ctl-x-map "\0" (make-sparse-keymap))
(define-key ctl-x-4-map "\0" (make-sparse-keymap))
(define-key esc-map "\0" (make-sparse-keymap))
(define-key mode-specific-map "\0" (make-sparse-keymap))
(define-key help-map "\0" (make-sparse-keymap))
(define-key em-map "\0" (make-sparse-keymap))

(defun em-forward-to-word (arg)
  "Move forward until encountering the beginning of a word.
With argument, do this that many times."
  (interactive "p")
  (or (re-search-forward "\\W\\b" nil t arg)
      (goto-char (point-max))))

(defun em-backward-to-word (arg)
  "Move backward until encountering the beginning of a word.
With argument, do this that many times."
  (interactive "p")
  (backward-char)
  (if (re-search-backward "\\W\\b" nil t arg) (goto-char (match-end 0))
      (goto-char (point-min))))

(defun em-kill-left-line nil
  "Kill from the beginning of the line to point."
  (interactive "*")
  (kill-line 0))

(defun em-end-of-buffer nil
  "Move to end of the buffer without setting mark."
  (interactive)
  (goto-char (point-max)))

(defun em-beginning-of-buffer nil
  "Move to the beginning of the buffer without setting mark."
  (interactive)
  (goto-char (point-min)))

(defun em-reinitialize nil
  "Load \"~/.emacs, em-keys.el and em-misc.el\".
This is used to load new versions of these files while debugging."
  (interactive)
  (load "~/.emacs")
  (load "em-keys")
  (load "em-misc"))

(defun em-scroll-line-up (arg)
  "Scroll up by one line.
With argument, do this that many times."
  (interactive "p")
  (scroll-up arg))

(defun em-scroll-line-down (arg)
  "Scroll down by one line.
With argument, do this that many times."
  (interactive "p")
  (scroll-down arg))

(defun em-copy-line-as-kill (arg)
  "Copy line as kill.
With argument, copy that many lines."
  (interactive "p")
  (let ((s (point)))
    (beginning-of-line)
    (let ((b (point)))
      (forward-line arg)
      (copy-region-as-kill b (point)))
    (goto-char s)))

(defun em-dup-line (arg)
  "Duplicate current line.
Set mark to the beginning of the new line.
With argument, do this that many times."
  (interactive "*p")
  (setq last-command 'identity) ; Don't append to kill ring
  (let ((s (point)))
    (beginning-of-line)
    (let ((b (point)))
      (forward-line)
      (if (not (eq (preceding-char) ?\n)) (insert ?\n))
      (copy-region-as-kill b (point))
    (while (> arg 0)
      (yank)
      (setq arg (1- arg)))
    (goto-char s))))

(defun em-kill-word (arg)
  "Delete characters until encountering the beginning of a word.
With argument, do this that many times."
  (interactive "*p")
  (let ((b (point)))
     (em-forward-to-word arg)
     (kill-region b (point))))

(defvar em-search-string nil
  "Search string for em-search-forward and em-search-backward.")

(defvar em-search-re nil
  "Non-nil means use regular expression for em-search-forward and -backward.")

(defun em-search-forward (&optional arg)
  "Search forward for a string.
If prefixed by \\[universal-argument], ask for search string.
If prefixed by \\[universal-argument] \\[universal-argument], use regular expression."
  (interactive "P")
  (em-search-fb arg 'search-forward 're-search-forward))

(defun em-search-backward (&optional arg)
  "Search backward for a string.
If prefixed by \\[universal-argument], ask for search string.
If prefixed by \\[universal-argument] \\[universal-argument], use
regular expression."
  (interactive "P")
  (em-search-fb arg 'search-backward 're-search-backward))

(defun em-search-fb (arg fun re-fun)
  "Search forward or backward for a string.
If the first argument is nil, ask for the string.
The second argument is search-forward or search-backward.
The third argument is re-search-forward or re-search-backward."
  (if (or arg (not em-search-string))
     (progn
       (setq em-search-re 
	     (and (listp arg) (numberp (car arg)) (>= (car arg) 16)))
       (setq em-search-string
          (read-from-minibuffer
             (if em-search-re "Re-Search forward: " "Search forward: ")
             em-search-string))))
  (funcall (if em-search-re re-fun fun) em-search-string))

(defun em-other-buffer nil
  "Select another buffer without asking."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun em-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis.
This function uses the syntax table."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

(defun em-buffer-list ()
  "Display a list of names of existing buffers.
Inserts it in buffer *Buffer List* and selects that.
Note that buffers with names starting with spaces are omitted."
  (interactive)
  (list-buffers)
  (select-window (get-buffer-window "*Buffer List*"))
  (list-buffers))                                   ; update for *Buffer List*

(defun em-copy-region ()
  "Copy region to point."
  (interactive)
  (copy-region-as-kill (point) (mark))
  (yank))


(defun em-fill-paragraph (arg)
  "Fill paragraph at or before point using em's notion of a paragraph.
Prefix arg means justify as well.
Paragraphs are separated by blank lines. The indentation of the first line
is used for indenting the entire paragraph. If there are two consecutive
blanks in the first line of the paragraphs, everything to the left of these
blanks is left as-is and the paragraph is indented to the first non-blank
character after the first two consecutive blanks of the first line."
  (interactive "P")
  (save-excursion
    (let (fill-prefix start end join column)
      (while (looking-at "^$")
          (forward-line -1))
      (re-search-backward "^$" (point-min) 0)
      (if (looking-at "^$")
          (forward-char))
      (setq start (point))
      (re-search-forward "^$" (point-max) 0)
      (or (bolp) (newline 1))
      (setq end (point-marker))
      (goto-char start)
      (if (looking-at "^ *[^ \n]*  ")
          (progn (re-search-forward "^ *[^ \n]*   *")
                 (setq column (current-column))
                 (split-line)
                 (setq join (point))
                 (forward-line 1)
                 (setq start (point))
                 (forward-char column)
                 (setq fill-prefix
                       (if (zerop column) nil
                         (make-string column ? )))
                 (while (and (zerop (forward-line 1))
                             (< (point) (marker-position end)))
                   (backward-to-indentation 0)
                   (cond ((> (current-column) column)
                          (delete-region (+ (point) column
                                            (- (current-column))) (point)))
                         ((< (current-column) column)
                          (insert-char ?  (- column (current-column))))))
                 (fill-region-as-paragraph start
                                           (marker-position end) arg)
                 (delete-region join (+ start column)))
        (fill-region-as-paragraph (point) (marker-position end) arg)))))

; Local Variables:
; comment-column: 52
; End:
