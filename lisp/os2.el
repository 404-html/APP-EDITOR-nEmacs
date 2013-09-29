;;
;; os2.el -- Patches for OS/2
;;
(provide 'os2)

(defun replace-char-in-string (str c1 c2)
  "Replace character C1 in string STR with character C2 and return STR.
This function does *not* copy the string."
  (let ((indx 0) (len (length str)) chr)
    (while (< indx len)
      (setq chr (aref str indx))
      (if (eq chr c1)
          (aset str indx c2))
      (setq indx (1+ indx)))
    str))

(defun make-legal-file-name (fn)
  "Turn FN into a legal file name and return the modified copy of the string.
The characters * and ? will be replaced with _."
  (setq fn (copy-sequence fn))
  (replace-char-in-string fn ?* ?_)
  (replace-char-in-string fn ?? ?_))

;;
;; Changes:
;; - replace * and ? with _
;; - on FAT file system, append # to extension
;;
(defun make-auto-save-file-name ()
  "Return file name to use for auto-saves of current buffer.
Does not consider auto-save-visited-file-name; that is checked
before calling this function.
This has been redefined for customization.
See also auto-save-file-name-p."
  (let ((tem
	 (if buffer-file-name
	     (concat (file-name-directory buffer-file-name)
		     "#"
		     (file-name-nondirectory buffer-file-name)
		     "#")
	   (expand-file-name (concat "#%" (make-legal-file-name 
					   (buffer-name)) "#")))))
    (cond ((valid-file-name-p tem) tem)
	  (buffer-file-name
	   (add-to-fat-file-name "#" buffer-file-name "#"))
	  (t (expand-file-name (add-to-fat-file-name "#%"
				(make-legal-file-name (buffer-name)) "#"))))))


;;
;; Requires patched Emacs: valid-file-name-p
;;
(defun make-backup-file-name (file)
  "Create the non-numeric backup file name for FILE.
This is a separate function so you can redefine it for customization."
  (let (backup)
    (or
     (progn (setq backup (concat file "~")) (valid-file-name-p backup))
     (setq backup (add-to-fat-file-name nil file "~")))
    backup))

(defun split-file-name (name)
  "Split NAME into directory part, base name part and extension.
Return a list containing three elements. If a part is empty, the list element
is nil."
  (let* ((dir (file-name-directory name))
	 (file (file-name-nondirectory name))
	 (pos (string-match "\\.[^.]*$" file))
	 (base (if pos (substring file 0 pos) file))
	 (ext (if pos (substring file pos) nil)))
    (list dir base ext)))

(defun add-to-fat-file-name (prefix file suffix)
  "Concatenate PREFIX, FILE and SUFFIX, then make it FAT compatible.
It is assumed that FILE is already compatible with the FAT file system."
  (let* ((split (split-file-name file))
	 (base (concat prefix (nth 1 split)))
	 (ext (nth 2 split))
	 (ext-len (length ext))
	 (suffix-len (length suffix)))
    (if (> (length base) 8)
	(setq base (substring base 0 8)))
    (while (and (> suffix-len 0) (eq (elt suffix 0) ?.))
      (setq suffix-len (1- suffix-len))
      (setq suffix (substring suffix 1)))
    (if (> suffix-len 3) (progn (setq suffix-len 3) (setq suffix (substring suffix 0 3))))
    (if (zerop suffix-len)
	file
      (cond ((null ext) (setq ext (concat "." suffix)))
	    ((<= (+ ext-len suffix-len) 4)
	     (setq ext (concat ext suffix)))
	    (t (setq ext (concat "." (substring ext 1
						(- 4 suffix-len)) suffix))))
      (concat (car split) base ext))))

(setq completion-ignored-extensions
      (append completion-ignored-extensions
	      (list ".com" ".exe" ".dll" ".obj" ".bak" ".zip" ".arj" ".lzh"
		    ".ico")))

(setq meta-flag t)
(setq default-ctl-arrow 1)

;
; Display names of special keys -- requires patched GNU Emacs
;
(defun key-description (keys)
  "Return a pretty description of key-sequence KEYS.
Control characters turn into \"C-foo\" sequences, meta into \"M-foo\"
the names of PC function keys are inserted,
spaces are put between sequence elements, etc."
  (let ((result "") (add "") (index 0) (len (length keys)) char new)
    (while (< index len)
      (setq char (elt keys index))
      (setq index (1+ index))
      (cond
       ;;--------required for Emacs without 8-bit keymaps---------
       ;; ((and (zerop char) (< (1+ index) len)
       ;; (= (elt keys index) 27)
       ;;	  (setq new (aref pc-function-keys
       ;;			  (+ (elt keys (1+ index)) 128))))
       ;;   (setq index (+ index 2)))
       ((and (zerop char) (< index len)
             (setq new (aref pc-function-keys (elt keys index))))
        (setq index (1+ index)))
       (t (setq new (single-key-description char))))
      (setq result (concat result add new))
      (setq add " "))
    result))

(defvar pc-function-keys (make-vector 256 nil)
  "Array containing descriptions of the PC function keys.")

(aset pc-function-keys	 1 "A-ESC")
(aset pc-function-keys   3 "C-2")
(aset pc-function-keys	14 "A-BS")
(aset pc-function-keys	15 "BTAB")
(aset pc-function-keys	16 "A-q")
(aset pc-function-keys	17 "A-w")
(aset pc-function-keys	18 "A-e")
(aset pc-function-keys	19 "A-r")
(aset pc-function-keys	20 "A-t")
(aset pc-function-keys	21 "A-y")
(aset pc-function-keys	22 "A-u")
(aset pc-function-keys	23 "A-i")
(aset pc-function-keys	24 "A-o")
(aset pc-function-keys	25 "A-p")
(aset pc-function-keys	27 "A-[")
(aset pc-function-keys	28 "A-]")
(aset pc-function-keys	29 "A-RET")
(aset pc-function-keys	30 "A-a")
(aset pc-function-keys	31 "A-s")
(aset pc-function-keys	32 "A-d")
(aset pc-function-keys	33 "A-f")
(aset pc-function-keys	34 "A-g")
(aset pc-function-keys	35 "A-h")
(aset pc-function-keys	36 "A-j")
(aset pc-function-keys	37 "A-k")
(aset pc-function-keys	38 "A-l")
(aset pc-function-keys	39 "A-;")
(aset pc-function-keys	40 "A-`")
(aset pc-function-keys	43 "A-\\")
(aset pc-function-keys	44 "A-z")
(aset pc-function-keys	45 "A-x")
(aset pc-function-keys	46 "A-c")
(aset pc-function-keys	47 "A-v")
(aset pc-function-keys	48 "A-b")
(aset pc-function-keys	49 "A-n")
(aset pc-function-keys	50 "A-m")
(aset pc-function-keys	51 "A-,")
(aset pc-function-keys	52 "A-.")
(aset pc-function-keys	53 "A-/")
(aset pc-function-keys	55 "A-NUM*")
(aset pc-function-keys	59 "F1")
(aset pc-function-keys	60 "F2")
(aset pc-function-keys	61 "F3")
(aset pc-function-keys	62 "F4")
(aset pc-function-keys	63 "F5")
(aset pc-function-keys	64 "F6")
(aset pc-function-keys	65 "F7")
(aset pc-function-keys	66 "F8")
(aset pc-function-keys	67 "F9")
(aset pc-function-keys	68 "F10")
(aset pc-function-keys	71 "HOME")
(aset pc-function-keys	72 "UP")
(aset pc-function-keys	73 "PAGEUP")
(aset pc-function-keys	74 "A-NUM-")
(aset pc-function-keys	75 "LEFT")
(aset pc-function-keys	76 "CENTER")
(aset pc-function-keys	77 "RIGHT")
(aset pc-function-keys	78 "A-NUM+")
(aset pc-function-keys	79 "END")
(aset pc-function-keys	80 "DOWN")
(aset pc-function-keys	81 "PAGEDOWN")
(aset pc-function-keys	82 "INSERT")
(aset pc-function-keys	83 "DELETE")
(aset pc-function-keys	84 "S-F1")
(aset pc-function-keys	85 "S-F2")
(aset pc-function-keys	86 "S-F3")
(aset pc-function-keys	87 "S-F4")
(aset pc-function-keys	88 "S-F5")
(aset pc-function-keys	89 "S-F6")
(aset pc-function-keys	90 "S-F7")
(aset pc-function-keys	91 "S-F8")
(aset pc-function-keys	92 "S-F9")
(aset pc-function-keys	93 "S-F10")
(aset pc-function-keys	94 "C-F1")
(aset pc-function-keys	95 "C-F2")
(aset pc-function-keys	96 "C-F3")
(aset pc-function-keys	97 "C-F4")
(aset pc-function-keys	98 "C-F5")
(aset pc-function-keys	99 "C-F6")
(aset pc-function-keys 100 "C-F7")
(aset pc-function-keys 101 "C-F8")
(aset pc-function-keys 102 "C-F9")
(aset pc-function-keys 103 "C-F10")
(aset pc-function-keys 104 "A-F1")
(aset pc-function-keys 105 "A-F2")
(aset pc-function-keys 106 "A-F3")
(aset pc-function-keys 107 "A-F4")
(aset pc-function-keys 108 "A-F5")
(aset pc-function-keys 109 "A-F6")
(aset pc-function-keys 110 "A-F7")
(aset pc-function-keys 111 "A-F8")
(aset pc-function-keys 112 "A-F9")
(aset pc-function-keys 113 "A-F10")
(aset pc-function-keys 114 "C-PRTSC")
(aset pc-function-keys 115 "C-LEFT")
(aset pc-function-keys 116 "C-RIGHT")
(aset pc-function-keys 117 "C-END")
(aset pc-function-keys 118 "C-PAGEDOWN")
(aset pc-function-keys 119 "C-HOME")
(aset pc-function-keys 120 "A-1")
(aset pc-function-keys 121 "A-2")
(aset pc-function-keys 122 "A-3")
(aset pc-function-keys 123 "A-4")
(aset pc-function-keys 124 "A-5")
(aset pc-function-keys 125 "A-6")
(aset pc-function-keys 126 "A-7")
(aset pc-function-keys 127 "A-8")
(aset pc-function-keys 128 "A-9")
(aset pc-function-keys 132 "C-PAGEUP")
(aset pc-function-keys 133 "F11")
(aset pc-function-keys 134 "F12")
(aset pc-function-keys 135 "S-F11")
(aset pc-function-keys 136 "S-F12")
(aset pc-function-keys 137 "C-F11")
(aset pc-function-keys 138 "C-F12")
(aset pc-function-keys 139 "A-F11")
(aset pc-function-keys 140 "A-F12")
(aset pc-function-keys 141 "C-UP")
(aset pc-function-keys 142 "C-NUM-")
(aset pc-function-keys 143 "C-CENTER")
(aset pc-function-keys 144 "C-NUM+")
(aset pc-function-keys 145 "C-DOWN")
(aset pc-function-keys 146 "C-INSERT")
(aset pc-function-keys 147 "C-DELETE")
(aset pc-function-keys 148 "C-TAB")
(aset pc-function-keys 149 "C-NUM/")
(aset pc-function-keys 150 "C-NUM*")
(aset pc-function-keys 151 "A-HOME")
(aset pc-function-keys 152 "A-UP")
(aset pc-function-keys 153 "A-PAGEUP")
(aset pc-function-keys 155 "A-LEFT")
(aset pc-function-keys 157 "A-RIGHT")
(aset pc-function-keys 159 "A-END")
(aset pc-function-keys 160 "A-DOWN")
(aset pc-function-keys 161 "A-PAGEDOWN")
(aset pc-function-keys 162 "A-INSERT")
(aset pc-function-keys 163 "A-DELETE")
(aset pc-function-keys 164 "A-NUM/")
(aset pc-function-keys 165 "A-TAB")
(aset pc-function-keys 166 "A-ENTER")
;;

(defvar file-type-alist nil "\
Alist of filename patterns vs corresponding file types.
Each element looks like (REGEXP . TYPE).")

(setq file-type-alist (mapcar 'purecopy
			      '(("\\.elc$" . "b"))))

(defun file-type-from-file-name (filename)
  "Return the file type depending on FILENAME.
A return value of \"b\" denotes a binary file: no CR/LF conversion
will be done. A return value of \"t\" denotes a text file: CR/LF pairs
will be converted to LF on reading, a final C-Z -- if present -- will be
discarded on reading. On writing, LF is converted to CR/LF.

This function uses file-type-alist. If this fails, default-file-type is
used."
  (let ((alist file-type-alist) type)
    (while (and (not type) alist)
      (if (string-match (car (car alist)) filename)
          (setq type (cdr (car alist))))
      (setq alist (cdr alist)))
    (or type default-file-type "t")))

(setq shell-prompt-pattern "^\\[.*\\] *")
(setq shell-file-name "cmd")

(defun os2-cd-command (dir)
  "Return a string containing the OS/2 command(s) for changing to DIR.
That string can be used directly with send-string. It contains one
or two line feed characters."
  (setq dir (replace-char-in-string (copy-sequence dir) ?/ ?\\))
  (if (string-match "[^:]\\\\$" dir)
      (setq dir (substring dir 0 -1)))
  (concat
   (and (string-match "[A-Za-z]:" dir)
        (prog1 (concat (substring dir 0 2) "\n")
          (setq dir (substring dir 2))))
   (if (> (length dir) 0)
       (concat "cd " dir "\n"))))
