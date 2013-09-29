;; Basic Roma-to-Kana Translation Table for Egg
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

;;; 90.3.2   modified for Nemacs Ver.3.3.1
;;;	by jiro@math.keio.ac.jp (TANAKA Jiro)
;;;     proposal of keybinding for JIS symbols

(define-egg-mode "roma-kana" t)

(defvar aa '("k" "s" "t" "h" "y" "r" "w" "g" "z" "d" "b"
		 "p" "c" "f" "j" "v"))
(defrule  '(aa aa) "¤Ã" '(aa))

(defrule "tch"  "¤Ã" "ch")

(defvar q1 '("b" "m" "p"))

(defrule '("m" q1) "¤ó" '(q1))

(defrule "n" "¤ó")
(defrule "N" "¤ó")

(defvar enable-double-n-syntax nil "*Enable ""nn"" input for ""¤ó"" ")

(if enable-double-n-syntax 
    (defrule "nn" "¤ó"))

(defrule "n'" "¤ó")

(defvar small '("x") )

(defrule '(small "a") "¤¡")
(defrule '(small "i") "¤£")
(defrule '(small "u") "¤¥")
(defrule '(small "e") "¤§")
(defrule '(small "o") "¤©")
(defrule '(small "ya") "¤ã")
(defrule '(small "yu") "¤å")
(defrule '(small "yo") "¤ç")
(defrule '(small "tu") "¤Ã")
(defrule '(small "tsu") "¤Ã")
(defrule '(small "wa") "¤î")


(defrule   "a"    "¤¢")
(defrule   "i"    "¤¤")
(defrule   "u"    "¤¦")
(defrule   "e"    "¤¨")
(defrule   "o"    "¤ª")
(defrule   "ka"   "¤«")
(defrule   "ki"   "¤­")
(defrule   "ku"   "¤¯")
(defrule   "ke"   "¤±")
(defrule   "ko"   "¤³")
(defrule   "kya"  "¤­¤ã")
(defrule   "kyu"  "¤­¤å")
(defrule   "kye"  "¤­¤§")
(defrule   "kyo"  "¤­¤ç")
(defrule   "sa"   "¤µ")
(defrule   "si"   "¤·")
(defrule   "su"   "¤¹")
(defrule   "se"   "¤»")
(defrule   "so"   "¤½")
(defrule   "sya"  "¤·¤ã")
(defrule   "syu"  "¤·¤å")
(defrule   "sye"  "¤·¤§")
(defrule   "syo"  "¤·¤ç")
(defrule   "sha"  "¤·¤ã")
(defrule   "shi"  "¤·")
(defrule   "shu"  "¤·¤å")
(defrule   "she"  "¤·¤§")
(defrule   "sho"  "¤·¤ç")
(defrule   "ta"   "¤¿")
(defrule   "ti"   "¤Á")
(defrule   "tu"   "¤Ä")
(defrule   "te"   "¤Æ")
(defrule   "to"   "¤È")
(defrule   "tya"  "¤Á¤ã")
(defrule   "tyi"  "¤Æ¤£")
(defrule   "tyu"  "¤Á¤å")
(defrule   "tye"  "¤Á¤§")
(defrule   "tyo"  "¤Á¤ç")
(defrule   "tsu"  "¤Ä")
(defrule   "cha"  "¤Á¤ã")
(defrule   "chi"  "¤Á")
(defrule   "chu"  "¤Á¤å")
(defrule   "che"  "¤Á¤§")
(defrule   "cho"  "¤Á¤ç")
(defrule   "na"   "¤Ê")
(defrule   "ni"   "¤Ë")
(defrule   "nu"   "¤Ì")
(defrule   "ne"   "¤Í")
(defrule   "no"   "¤Î")
(defrule   "nya"  "¤Ë¤ã")
(defrule   "nyu"  "¤Ë¤å")
(defrule   "nye"  "¤Ë¤§")
(defrule   "nyo"  "¤Ë¤ç")
(defrule   "ha"   "¤Ï")
(defrule   "hi"   "¤Ò")
(defrule   "hu"   "¤Õ")
(defrule   "he"   "¤Ø")
(defrule   "ho"   "¤Û")
(defrule   "hya"  "¤Ò¤ã")
(defrule   "hyu"  "¤Ò¤å")
(defrule   "hye"  "¤Ò¤§")
(defrule   "hyo"  "¤Ò¤ç")
(defrule   "fa"   "¤Õ¤¡")
(defrule   "fi"   "¤Õ¤£")
(defrule   "fu"   "¤Õ")
(defrule   "fe"   "¤Õ¤§")
(defrule   "fo"   "¤Õ¤©")
(defrule   "ma"   "¤Þ")
(defrule   "mi"   "¤ß")
(defrule   "mu"   "¤à")
(defrule   "me"   "¤á")
(defrule   "mo"   "¤â")
(defrule   "mya"  "¤ß¤ã")
(defrule   "myu"  "¤ß¤å")
(defrule   "mye"  "¤ß¤§")
(defrule   "myo"  "¤ß¤ç")
(defrule   "ya"   "¤ä")
(defrule   "yi"   "¤¤")
(defrule   "yu"   "¤æ")
(defrule   "ye"   "¤¤¤§")
(defrule   "yo"   "¤è")
(defrule   "ra"   "¤é")
(defrule   "ri"   "¤ê")
(defrule   "ru"   "¤ë")
(defrule   "re"   "¤ì")
(defrule   "ro"   "¤í")
(defrule   "la"   "¤é")
(defrule   "li"   "¤ê")
(defrule   "lu"   "¤ë")
(defrule   "le"   "¤ì")
(defrule   "lo"   "¤í")
(defrule   "rya"  "¤ê¤ã")
(defrule   "ryu"  "¤ê¤å")
(defrule   "rye"  "¤ê¤§")
(defrule   "ryo"  "¤ê¤ç")
(defrule   "lya"  "¤ê¤ã")
(defrule   "lyu"  "¤ê¤å")
(defrule   "lye"  "¤ê¤§")
(defrule   "lyo"  "¤ê¤ç")
(defrule   "wa"   "¤ï")
(defrule   "wi"   "¤ð")
(defrule   "wu"   "¤¦")
(defrule   "we"   "¤ñ")
(defrule   "wo"   "¤ò")
(defrule   "ga"   "¤¬")
(defrule   "gi"   "¤®")
(defrule   "gu"   "¤°")
(defrule   "ge"   "¤²")
(defrule   "go"   "¤´")
(defrule   "gya"  "¤®¤ã")
(defrule   "gyu"  "¤®¤å")
(defrule   "gye"  "¤®¤§")
(defrule   "gyo"  "¤®¤ç")
(defrule   "za"   "¤¶")
(defrule   "zi"   "¤¸")
(defrule   "zu"   "¤º")
(defrule   "ze"   "¤¼")
(defrule   "zo"   "¤¾")
(defrule   "zya"  "¤¸¤ã")
(defrule   "zyu"  "¤¸¤å")
(defrule   "zye"  "¤¸¤§")
(defrule   "zyo"  "¤¸¤ç")
(defrule   "ja"   "¤¸¤ã")
(defrule   "ji"   "¤¸")
(defrule   "ju"   "¤¸¤å")
(defrule   "je"   "¤¸¤§")
(defrule   "jo"   "¤¸¤ç")
(defrule   "da"   "¤À")
(defrule   "di"   "¤Â")
(defrule   "du"   "¤Å")
(defrule   "de"   "¤Ç")
(defrule   "do"   "¤É")
(defrule   "dya"  "¤Â¤ã")
(defrule   "dyi"  "¤Ç¤£")
(defrule   "dyu"  "¤Â¤å")
(defrule   "dye"  "¤Â¤§")
(defrule   "dyo"  "¤Â¤ç")
(defrule   "ba"   "¤Ð")
(defrule   "bi"   "¤Ó")
(defrule   "bu"   "¤Ö")
(defrule   "be"   "¤Ù")
(defrule   "bo"   "¤Ü")
(defrule   "va"   "¥ô¤¡")
(defrule   "vi"   "¥ô¤£")
(defrule   "vu"   "¥ô")
(defrule   "ve"   "¥ô¤§")
(defrule   "vo"   "¥ô¤©")
(defrule   "bya"  "¤Ó¤ã")
(defrule   "byu"  "¤Ó¤å")
(defrule   "bye"  "¤Ó¤§")
(defrule   "byo"  "¤Ó¤ç")
(defrule   "pa"   "¤Ñ")
(defrule   "pi"   "¤Ô")
(defrule   "pu"   "¤×")
(defrule   "pe"   "¤Ú")
(defrule   "po"   "¤Ý")
(defrule   "pya"  "¤Ô¤ã")
(defrule   "pyu"  "¤Ô¤å")
(defrule   "pye"  "¤Ô¤§")
(defrule   "pyo"  "¤Ô¤ç")
(defrule   "kwa"  "¤¯¤î")
(defrule   "kwi"  "¤¯¤£")
(defrule   "kwu"  "¤¯")
(defrule   "kwe"  "¤¯¤§")
(defrule   "kwo"  "¤¯¤©")
(defrule   "gwa"  "¤°¤î")
(defrule   "gwi"  "¤°¤£")
(defrule   "gwu"  "¤°")
(defrule   "gwe"  "¤°¤§")
(defrule   "gwo"  "¤°¤©")
(defrule   "tsa"  "¤Ä¤¡")
(defrule   "tsi"  "¤Ä¤£")
(defrule   "tse"  "¤Ä¤§")
(defrule   "tso"  "¤Ä¤©")
(defrule   "xka"  "¥õ")
(defrule   "xke"  "¥ö")
(defrule   "xti"  "¤Æ¤£")
(defrule   "xdi"  "¤Ç¤£")
(defrule   "xdu"  "¤É¤¥")
(defrule   "xde"  "¤Ç¤§")
(defrule   "xdo"  "¤É¤©")
(defrule   "xwa"  "¤î")
(defrule   "xwi"  "¤¦¤£")
(defrule   "xwe"  "¤¦¤§")
(defrule   "xwo"  "¤¦¤©")

;;; Zenkaku Symbols

(defrule   "1"   "£±")
(defrule   "2"   "£²")
(defrule   "3"   "£³")
(defrule   "4"   "£´")
(defrule   "5"   "£µ")
(defrule   "6"   "£¶")
(defrule   "7"   "£·")
(defrule   "8"   "£¸")
(defrule   "9"   "£¹")
(defrule   "0"   "£°")

(defrule   " "   "¡¡")
(defrule   "!"   "¡ª")
(defrule   "@"   "¡÷")
(defrule   "#"   "¡ô")
(defrule   "$"   "¡ð")
(defrule   "%"   "¡ó")
(defrule   "^"   "¡°")
(defrule   "&"   "¡õ")
(defrule   "*"   "¡ö")
(defrule   "("   "¡Ê")
(defrule   ")"   "¡Ë")
(defrule   "-"   "¡¼") ;;; JIS 213c  ;;;(defrule   "-"   "¡Ý")
(defrule   "="   "¡á")
(defrule   "`"   "¡®")
(defrule   "\\"  "¡ï")
(defrule   "|"   "¡Ã")
(defrule   "_"   "¡²")
(defrule   "+"   "¡Ü")
(defrule   "~"   "¡±")
(defrule   "["    "¡Ö")  ;;(defrule   "["   "¡Î")
(defrule   "]"    "¡×")  ;;(defrule   "]"   "¡Ï")
(defrule   "{"   "¡Ð")
(defrule   "}"   "¡Ñ")
(defrule   ":"   "¡§")
(defrule   ";"   "¡¨")
(defrule   "\""  "¡É")
(defrule   "'"   "¡Ç")
(defrule   "<"   "¡ã")
(defrule   ">"   "¡ä")
(defrule   "?"   "¡©")
(defrule   "/"   "¡¿")
(defrule   ","   "¡¢")  ;;(defrule   ","   "¡¤")
(defrule   "."   "¡£")  ;;(defrule   "."   "¡¥")


;;; Escape character to Zenkaku inputs

(defvar zenkaku-escape "Z")

;;; Escape character to Hankaku inputs

(defvar hankaku-escape "~")
;;;
;;; Zenkaku inputs
;;;

(defrule '(zenkaku-escape "0") "£°")
(defrule '(zenkaku-escape "1") "£±")
(defrule '(zenkaku-escape "2") "£²")
(defrule '(zenkaku-escape "3") "£³")
(defrule '(zenkaku-escape "4") "£´")
(defrule '(zenkaku-escape "5") "£µ")
(defrule '(zenkaku-escape "6") "£¶")
(defrule '(zenkaku-escape "7") "£·")
(defrule '(zenkaku-escape "8") "£¸")
(defrule '(zenkaku-escape "9") "£¹")

(defrule '(zenkaku-escape "A") "£Á")
(defrule '(zenkaku-escape "B") "£Â")
(defrule '(zenkaku-escape "C") "£Ã")
(defrule '(zenkaku-escape "D") "£Ä")
(defrule '(zenkaku-escape "E") "£Å")
(defrule '(zenkaku-escape "F") "£Æ")
(defrule '(zenkaku-escape "G") "£Ç")
(defrule '(zenkaku-escape "H") "£È")
(defrule '(zenkaku-escape "I") "£É")
(defrule '(zenkaku-escape "J") "£Ê")
(defrule '(zenkaku-escape "K") "£Ë")
(defrule '(zenkaku-escape "L") "£Ì")
(defrule '(zenkaku-escape "M") "£Í")
(defrule '(zenkaku-escape "N") "£Î")
(defrule '(zenkaku-escape "O") "£Ï")
(defrule '(zenkaku-escape "P") "£Ð")
(defrule '(zenkaku-escape "Q") "£Ñ")
(defrule '(zenkaku-escape "R") "£Ò")
(defrule '(zenkaku-escape "S") "£Ó")
(defrule '(zenkaku-escape "T") "£Ô")
(defrule '(zenkaku-escape "U") "£Õ")
(defrule '(zenkaku-escape "V") "£Ö")
(defrule '(zenkaku-escape "W") "£×")
(defrule '(zenkaku-escape "X") "£Ø")
(defrule '(zenkaku-escape "Y") "£Ù")
(defrule '(zenkaku-escape "Z") "£Ú")

(defrule '(zenkaku-escape "a") "£á")
(defrule '(zenkaku-escape "b") "£â")
(defrule '(zenkaku-escape "c") "£ã")
(defrule '(zenkaku-escape "d") "£ä")
(defrule '(zenkaku-escape "e") "£å")
(defrule '(zenkaku-escape "f") "£æ")
(defrule '(zenkaku-escape "g") "£ç")
(defrule '(zenkaku-escape "h") "£è")
(defrule '(zenkaku-escape "i") "£é")
(defrule '(zenkaku-escape "j") "£ê")
(defrule '(zenkaku-escape "k") "£ë")
(defrule '(zenkaku-escape "l") "£ì")
(defrule '(zenkaku-escape "m") "£í")
(defrule '(zenkaku-escape "n") "£î")
(defrule '(zenkaku-escape "o") "£ï")
(defrule '(zenkaku-escape "p") "£ð")
(defrule '(zenkaku-escape "q") "£ñ")
(defrule '(zenkaku-escape "r") "£ò")
(defrule '(zenkaku-escape "s") "£ó")
(defrule '(zenkaku-escape "t") "£ô")
(defrule '(zenkaku-escape "u") "£õ")
(defrule '(zenkaku-escape "v") "£ö")
(defrule '(zenkaku-escape "w") "£÷")
(defrule '(zenkaku-escape "x") "£ø")
(defrule '(zenkaku-escape "y") "£ù")
(defrule '(zenkaku-escape "z") "£ú")

(defrule '(zenkaku-escape " ")  "¡¡")
(defrule '(zenkaku-escape "!")  "¡ª")
(defrule '(zenkaku-escape "@")  "¡÷")
(defrule '(zenkaku-escape "#")  "¡ô")
(defrule '(zenkaku-escape "$")  "¡ð")
(defrule '(zenkaku-escape "%")  "¡ó")
(defrule '(zenkaku-escape "^")  "¡°")
(defrule '(zenkaku-escape "&")  "¡õ")
(defrule '(zenkaku-escape "*")  "¡ö")
(defrule '(zenkaku-escape "(")  "¡Ê")
(defrule '(zenkaku-escape ")")  "¡Ë")
(defrule '(zenkaku-escape "-")  "¡Ý")
(defrule '(zenkaku-escape "=")  "¡á")
(defrule '(zenkaku-escape "`")  "¡®")
(defrule '(zenkaku-escape "\\") "¡ï")
(defrule '(zenkaku-escape "|")  "¡Ã")
(defrule '(zenkaku-escape "_")  "¡²")
(defrule '(zenkaku-escape "+")  "¡Ü")
(defrule '(zenkaku-escape "~")  "¡±")
(defrule '(zenkaku-escape "[")  "¡Î")
(defrule '(zenkaku-escape "]")  "¡Ï")
(defrule '(zenkaku-escape "{")  "¡Ð")
(defrule '(zenkaku-escape "}")  "¡Ñ")
(defrule '(zenkaku-escape ":")  "¡§")
(defrule '(zenkaku-escape ";")  "¡¨")
(defrule '(zenkaku-escape "\"") "¡É")
(defrule '(zenkaku-escape "'")  "¡Ç")
(defrule '(zenkaku-escape "<")  "¡ã")
(defrule '(zenkaku-escape ">")  "¡ä")
(defrule '(zenkaku-escape "?")  "¡©")
(defrule '(zenkaku-escape "/")  "¡¿")
(defrule '(zenkaku-escape ",")  "¡¤")
(defrule '(zenkaku-escape ".")  "¡¥")

;;;
;;; Hankaku inputs
;;;

;;(defvar escd '("-" "," "." "/" ";" ":" "[" "\\" "]" "^" "~"))
;;(defrule '("x" escd)  '(escd))


(defvar digit-characters 
   '( "1"  "2"  "3"  "4" "5"  "6"  "7"  "8"  "9"  "0" ))

(defvar symbol-characters 
   '( " "  "!"  "@"  "#"  "$"  "%"  "^"  "&"  "*"  "("  ")"
      "-"  "="  "`"  "\\" "|"  "_"  "+"  "~" "["  "]"  "{"  "}"
      ":"  ";"  "\"" "'"  "<"  ">"  "?"  "/"  ","  "." ))

(defvar downcase-alphabets 
   '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
     "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar upcase-alphabets
   '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"
     "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

(defrule '(hankaku-escape digit-characters)   '(digit-characters))
(defrule '(hankaku-escape symbol-characters)  '(symbol-characters))
(defrule '(hankaku-escape downcase-alphabets) '(downcase-alphabets))
(defrule '(hankaku-escape upcase-alphabets)   '(upcase-alphabets))

;;(defvar upcase-escape   "X")

;;(defrule '(upcase-escape digit-characters)     '(digit-characters))
;;(defrule '(upcase-escape symbol-characters)    '(symbol-characters))
;;(defrule '(upcase-escape upcase-alphabets)     '(upcase-alphabets))

;;; Note: We cannot define
;;; (defrule '(upcase-escape downcase-alphabets) '(upcase-alphabets))
;;; We need association between them.

;;;; Proposal:
;;;; (defvar down-up-assoc '(("a" "A") ("b" "B")....))
;;;; (defrule '((upcase-escape) (downcase-alpha))
;;;;          '(downcase-alpha down-up-assoc))
;;;;

;;; proposal key bindings for JIS symbols
;;; 90.3.2  by jiro@math.keio.ac.jp (TANAKA Jiro)

(defrule   "z1"   "¡û")	(defrule   "z!"   "¡ü")
(defrule   "z2"   "¢¦")	(defrule   "z@"   "¢§")
(defrule   "z3"   "¢¤")	(defrule   "z#"   "¢¥")
(defrule   "z4"   "¢¢")	(defrule   "z$"   "¢£")
(defrule   "z5"   "¡þ")	(defrule   "z%"   "¢¡")
(defrule   "z6"   "¡ù")	(defrule   "z^"   "¡ú")
(defrule   "z7"   "¡ý")	(defrule   "z&"   "¡ò")
(defrule   "z8"   "¡ñ")	(defrule   "z*"   "¡ß")
(defrule   "z9"   "¡é")	(defrule   "z("   "¡Ú")
(defrule   "z0"   "¡ê")	(defrule   "z)"   "¡Û")
(defrule   "z-"   "¡Á")	(defrule   "z_"   "¡è")	; z-
(defrule   "z="   "¡â")	(defrule   "z+"   "¡Þ")
(defrule   "z\\"  "¡À")	(defrule   "z|"   "¡Â")
(defrule   "z`"   "¡­")	(defrule   "z~"   "¡¯")

(defrule   "zq"   "¡Ô")	(defrule   "zQ"   "¡Ò")
(defrule   "zw"   "¡Õ")	(defrule   "zW"   "¡Ó")
; e
(defrule   "zr"   "¡¹")	(defrule   "zR"   "¡¸")	; zr
(defrule   "zt"   "¡º")	(defrule   "zT"   "¡ø")
; y u i o
(defrule   "zp"   "¢©")	(defrule   "zP"   "¢¬")	; zp
(defrule   "z["   "¡Ø")	(defrule   "z{"   "¡Ì")	; z[
(defrule   "z]"   "¡Ù")	(defrule   "z}"   "¡Í")	; z]

; a
(defrule   "zs"   "¡³")	(defrule   "zS"   "¡´")
(defrule   "zd"   "¡µ")	(defrule   "zD"   "¡¶")
(defrule   "zf"   "¡·")	(defrule   "zF"   "¢ª")
(defrule   "zg"   "¡¾")	(defrule   "zG"   "¡½")
(defrule   "zh"   "¢«")
(defrule   "zj"   "¢­")
(defrule   "zk"   "¢¬")
(defrule   "zl"   "¢ª")
(defrule   "z;"   "¡«")	(defrule   "z:"   "¡¬")
(defrule   "z\'"  "¡Æ")	(defrule   "z\""  "¡È")

; z
(defrule   "zx"   ":-")	(defrule   "zX"   ":-)")
(defrule   "zc"   "¡»")	(defrule   "zC"   "¡î")	; zc
(defrule   "zv"   "¢¨")	(defrule   "zV"   "¡à")
(defrule   "zb"   "¡ë")	(defrule   "zB"   "¢«")
(defrule   "zn"   "¡ì")	(defrule   "zN"   "¢­")
(defrule   "zm"   "¡í")	(defrule   "zM"   "¢®")
(defrule   "z,"   "¡Å")	(defrule   "z<"   "¡å")
(defrule   "z."   "¡Ä")	(defrule   "z>"   "¡æ")	; z.
(defrule   "z/"   "¡¦")	(defrule   "z?"   "¡ç")	; z/

;;; Commented out by K.Handa.  Already defined in a different way.
;(defrule   "va"   "¥ô¥¡")
;(defrule   "vi"   "¥ô¥£")
;(defrule   "vu"   "¥ô")
;(defrule   "ve"   "¥ô¥§")
;(defrule   "vo"   "¥ô¥©")
