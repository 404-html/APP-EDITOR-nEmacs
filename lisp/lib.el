
;; Recompiling all lisp files used for Emacs startup.
;; isearch.el and replace.el seems to be quite big ...

(setq max-lisp-eval-depth 400)




(load "bytecomp")
(load "subr")
(load "loaddefs")
(load "files")
(load "lisp")
(load "lisp-mode")
(load "os2")                            ; write .elc files in binary mode
(setq lisp-path (concat exec-directory "../lisp"))


(defun byte-compile-old-file (file)
  "Byte-compile FILE in main Emacs Lisp path, if corrrespondant
.elc file does not exist or is older than it.
If you want to compile FILE in another directory, preceed it with\"//\"."
  (if (file-newer-than-file-p
       (expand-file-name file lisp-path)
       (expand-file-name (concat file "c") lisp-path))
      (byte-compile-file (expand-file-name file lisp-path))))



(byte-compile-old-file "simple.el")
(byte-compile-old-file "help.el") 	
(byte-compile-old-file "files.el") 
(byte-compile-old-file "window.el") 	
(byte-compile-old-file "indent.el") 
(byte-compile-old-file "startup.el") 
(byte-compile-old-file "lisp.el") 	
(byte-compile-old-file "page.el") 
(byte-compile-old-file "register.el") 	
(byte-compile-old-file "paragraphs.el") 
(byte-compile-old-file "lisp-mode.el") 	
(byte-compile-old-file "text-mode.el") 
(byte-compile-old-file "fill.el") 	
(byte-compile-old-file "c-mode.el") 
(byte-compile-old-file "isearch.el") 	
(byte-compile-old-file "replace.el") 
(byte-compile-old-file "abbrev.el") 
(byte-compile-old-file "buff-menu.el") 
(byte-compile-old-file "subr.el")
(byte-compile-old-file "backquote.el")
(byte-compile-old-file "em-keys.el")
(byte-compile-old-file "os2.el")

(kill-emacs)
