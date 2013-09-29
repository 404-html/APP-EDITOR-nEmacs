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
(defrule  '(aa aa) "��" '(aa))

(defrule "tch"  "��" "ch")

(defvar q1 '("b" "m" "p"))

(defrule '("m" q1) "��" '(q1))

(defrule "n" "��")
(defrule "N" "��")

(defvar enable-double-n-syntax nil "*Enable ""nn"" input for ""��"" ")

(if enable-double-n-syntax 
    (defrule "nn" "��"))

(defrule "n'" "��")

(defvar small '("x") )

(defrule '(small "a") "��")
(defrule '(small "i") "��")
(defrule '(small "u") "��")
(defrule '(small "e") "��")
(defrule '(small "o") "��")
(defrule '(small "ya") "��")
(defrule '(small "yu") "��")
(defrule '(small "yo") "��")
(defrule '(small "tu") "��")
(defrule '(small "tsu") "��")
(defrule '(small "wa") "��")


(defrule   "a"    "��")
(defrule   "i"    "��")
(defrule   "u"    "��")
(defrule   "e"    "��")
(defrule   "o"    "��")
(defrule   "ka"   "��")
(defrule   "ki"   "��")
(defrule   "ku"   "��")
(defrule   "ke"   "��")
(defrule   "ko"   "��")
(defrule   "kya"  "����")
(defrule   "kyu"  "����")
(defrule   "kye"  "����")
(defrule   "kyo"  "����")
(defrule   "sa"   "��")
(defrule   "si"   "��")
(defrule   "su"   "��")
(defrule   "se"   "��")
(defrule   "so"   "��")
(defrule   "sya"  "����")
(defrule   "syu"  "����")
(defrule   "sye"  "����")
(defrule   "syo"  "����")
(defrule   "sha"  "����")
(defrule   "shi"  "��")
(defrule   "shu"  "����")
(defrule   "she"  "����")
(defrule   "sho"  "����")
(defrule   "ta"   "��")
(defrule   "ti"   "��")
(defrule   "tu"   "��")
(defrule   "te"   "��")
(defrule   "to"   "��")
(defrule   "tya"  "����")
(defrule   "tyi"  "�Ƥ�")
(defrule   "tyu"  "����")
(defrule   "tye"  "����")
(defrule   "tyo"  "����")
(defrule   "tsu"  "��")
(defrule   "cha"  "����")
(defrule   "chi"  "��")
(defrule   "chu"  "����")
(defrule   "che"  "����")
(defrule   "cho"  "����")
(defrule   "na"   "��")
(defrule   "ni"   "��")
(defrule   "nu"   "��")
(defrule   "ne"   "��")
(defrule   "no"   "��")
(defrule   "nya"  "�ˤ�")
(defrule   "nyu"  "�ˤ�")
(defrule   "nye"  "�ˤ�")
(defrule   "nyo"  "�ˤ�")
(defrule   "ha"   "��")
(defrule   "hi"   "��")
(defrule   "hu"   "��")
(defrule   "he"   "��")
(defrule   "ho"   "��")
(defrule   "hya"  "�Ҥ�")
(defrule   "hyu"  "�Ҥ�")
(defrule   "hye"  "�Ҥ�")
(defrule   "hyo"  "�Ҥ�")
(defrule   "fa"   "�դ�")
(defrule   "fi"   "�դ�")
(defrule   "fu"   "��")
(defrule   "fe"   "�դ�")
(defrule   "fo"   "�դ�")
(defrule   "ma"   "��")
(defrule   "mi"   "��")
(defrule   "mu"   "��")
(defrule   "me"   "��")
(defrule   "mo"   "��")
(defrule   "mya"  "�ߤ�")
(defrule   "myu"  "�ߤ�")
(defrule   "mye"  "�ߤ�")
(defrule   "myo"  "�ߤ�")
(defrule   "ya"   "��")
(defrule   "yi"   "��")
(defrule   "yu"   "��")
(defrule   "ye"   "����")
(defrule   "yo"   "��")
(defrule   "ra"   "��")
(defrule   "ri"   "��")
(defrule   "ru"   "��")
(defrule   "re"   "��")
(defrule   "ro"   "��")
(defrule   "la"   "��")
(defrule   "li"   "��")
(defrule   "lu"   "��")
(defrule   "le"   "��")
(defrule   "lo"   "��")
(defrule   "rya"  "���")
(defrule   "ryu"  "���")
(defrule   "rye"  "�ꤧ")
(defrule   "ryo"  "���")
(defrule   "lya"  "���")
(defrule   "lyu"  "���")
(defrule   "lye"  "�ꤧ")
(defrule   "lyo"  "���")
(defrule   "wa"   "��")
(defrule   "wi"   "��")
(defrule   "wu"   "��")
(defrule   "we"   "��")
(defrule   "wo"   "��")
(defrule   "ga"   "��")
(defrule   "gi"   "��")
(defrule   "gu"   "��")
(defrule   "ge"   "��")
(defrule   "go"   "��")
(defrule   "gya"  "����")
(defrule   "gyu"  "����")
(defrule   "gye"  "����")
(defrule   "gyo"  "����")
(defrule   "za"   "��")
(defrule   "zi"   "��")
(defrule   "zu"   "��")
(defrule   "ze"   "��")
(defrule   "zo"   "��")
(defrule   "zya"  "����")
(defrule   "zyu"  "����")
(defrule   "zye"  "����")
(defrule   "zyo"  "����")
(defrule   "ja"   "����")
(defrule   "ji"   "��")
(defrule   "ju"   "����")
(defrule   "je"   "����")
(defrule   "jo"   "����")
(defrule   "da"   "��")
(defrule   "di"   "��")
(defrule   "du"   "��")
(defrule   "de"   "��")
(defrule   "do"   "��")
(defrule   "dya"  "�¤�")
(defrule   "dyi"  "�Ǥ�")
(defrule   "dyu"  "�¤�")
(defrule   "dye"  "�¤�")
(defrule   "dyo"  "�¤�")
(defrule   "ba"   "��")
(defrule   "bi"   "��")
(defrule   "bu"   "��")
(defrule   "be"   "��")
(defrule   "bo"   "��")
(defrule   "va"   "����")
(defrule   "vi"   "����")
(defrule   "vu"   "��")
(defrule   "ve"   "����")
(defrule   "vo"   "����")
(defrule   "bya"  "�Ӥ�")
(defrule   "byu"  "�Ӥ�")
(defrule   "bye"  "�Ӥ�")
(defrule   "byo"  "�Ӥ�")
(defrule   "pa"   "��")
(defrule   "pi"   "��")
(defrule   "pu"   "��")
(defrule   "pe"   "��")
(defrule   "po"   "��")
(defrule   "pya"  "�Ԥ�")
(defrule   "pyu"  "�Ԥ�")
(defrule   "pye"  "�Ԥ�")
(defrule   "pyo"  "�Ԥ�")
(defrule   "kwa"  "����")
(defrule   "kwi"  "����")
(defrule   "kwu"  "��")
(defrule   "kwe"  "����")
(defrule   "kwo"  "����")
(defrule   "gwa"  "����")
(defrule   "gwi"  "����")
(defrule   "gwu"  "��")
(defrule   "gwe"  "����")
(defrule   "gwo"  "����")
(defrule   "tsa"  "�Ĥ�")
(defrule   "tsi"  "�Ĥ�")
(defrule   "tse"  "�Ĥ�")
(defrule   "tso"  "�Ĥ�")
(defrule   "xka"  "��")
(defrule   "xke"  "��")
(defrule   "xti"  "�Ƥ�")
(defrule   "xdi"  "�Ǥ�")
(defrule   "xdu"  "�ɤ�")
(defrule   "xde"  "�Ǥ�")
(defrule   "xdo"  "�ɤ�")
(defrule   "xwa"  "��")
(defrule   "xwi"  "����")
(defrule   "xwe"  "����")
(defrule   "xwo"  "����")

;;; Zenkaku Symbols

(defrule   "1"   "��")
(defrule   "2"   "��")
(defrule   "3"   "��")
(defrule   "4"   "��")
(defrule   "5"   "��")
(defrule   "6"   "��")
(defrule   "7"   "��")
(defrule   "8"   "��")
(defrule   "9"   "��")
(defrule   "0"   "��")

(defrule   " "   "��")
(defrule   "!"   "��")
(defrule   "@"   "��")
(defrule   "#"   "��")
(defrule   "$"   "��")
(defrule   "%"   "��")
(defrule   "^"   "��")
(defrule   "&"   "��")
(defrule   "*"   "��")
(defrule   "("   "��")
(defrule   ")"   "��")
(defrule   "-"   "��") ;;; JIS 213c  ;;;(defrule   "-"   "��")
(defrule   "="   "��")
(defrule   "`"   "��")
(defrule   "\\"  "��")
(defrule   "|"   "��")
(defrule   "_"   "��")
(defrule   "+"   "��")
(defrule   "~"   "��")
(defrule   "["    "��")  ;;(defrule   "["   "��")
(defrule   "]"    "��")  ;;(defrule   "]"   "��")
(defrule   "{"   "��")
(defrule   "}"   "��")
(defrule   ":"   "��")
(defrule   ";"   "��")
(defrule   "\""  "��")
(defrule   "'"   "��")
(defrule   "<"   "��")
(defrule   ">"   "��")
(defrule   "?"   "��")
(defrule   "/"   "��")
(defrule   ","   "��")  ;;(defrule   ","   "��")
(defrule   "."   "��")  ;;(defrule   "."   "��")


;;; Escape character to Zenkaku inputs

(defvar zenkaku-escape "Z")

;;; Escape character to Hankaku inputs

(defvar hankaku-escape "~")
;;;
;;; Zenkaku inputs
;;;

(defrule '(zenkaku-escape "0") "��")
(defrule '(zenkaku-escape "1") "��")
(defrule '(zenkaku-escape "2") "��")
(defrule '(zenkaku-escape "3") "��")
(defrule '(zenkaku-escape "4") "��")
(defrule '(zenkaku-escape "5") "��")
(defrule '(zenkaku-escape "6") "��")
(defrule '(zenkaku-escape "7") "��")
(defrule '(zenkaku-escape "8") "��")
(defrule '(zenkaku-escape "9") "��")

(defrule '(zenkaku-escape "A") "��")
(defrule '(zenkaku-escape "B") "��")
(defrule '(zenkaku-escape "C") "��")
(defrule '(zenkaku-escape "D") "��")
(defrule '(zenkaku-escape "E") "��")
(defrule '(zenkaku-escape "F") "��")
(defrule '(zenkaku-escape "G") "��")
(defrule '(zenkaku-escape "H") "��")
(defrule '(zenkaku-escape "I") "��")
(defrule '(zenkaku-escape "J") "��")
(defrule '(zenkaku-escape "K") "��")
(defrule '(zenkaku-escape "L") "��")
(defrule '(zenkaku-escape "M") "��")
(defrule '(zenkaku-escape "N") "��")
(defrule '(zenkaku-escape "O") "��")
(defrule '(zenkaku-escape "P") "��")
(defrule '(zenkaku-escape "Q") "��")
(defrule '(zenkaku-escape "R") "��")
(defrule '(zenkaku-escape "S") "��")
(defrule '(zenkaku-escape "T") "��")
(defrule '(zenkaku-escape "U") "��")
(defrule '(zenkaku-escape "V") "��")
(defrule '(zenkaku-escape "W") "��")
(defrule '(zenkaku-escape "X") "��")
(defrule '(zenkaku-escape "Y") "��")
(defrule '(zenkaku-escape "Z") "��")

(defrule '(zenkaku-escape "a") "��")
(defrule '(zenkaku-escape "b") "��")
(defrule '(zenkaku-escape "c") "��")
(defrule '(zenkaku-escape "d") "��")
(defrule '(zenkaku-escape "e") "��")
(defrule '(zenkaku-escape "f") "��")
(defrule '(zenkaku-escape "g") "��")
(defrule '(zenkaku-escape "h") "��")
(defrule '(zenkaku-escape "i") "��")
(defrule '(zenkaku-escape "j") "��")
(defrule '(zenkaku-escape "k") "��")
(defrule '(zenkaku-escape "l") "��")
(defrule '(zenkaku-escape "m") "��")
(defrule '(zenkaku-escape "n") "��")
(defrule '(zenkaku-escape "o") "��")
(defrule '(zenkaku-escape "p") "��")
(defrule '(zenkaku-escape "q") "��")
(defrule '(zenkaku-escape "r") "��")
(defrule '(zenkaku-escape "s") "��")
(defrule '(zenkaku-escape "t") "��")
(defrule '(zenkaku-escape "u") "��")
(defrule '(zenkaku-escape "v") "��")
(defrule '(zenkaku-escape "w") "��")
(defrule '(zenkaku-escape "x") "��")
(defrule '(zenkaku-escape "y") "��")
(defrule '(zenkaku-escape "z") "��")

(defrule '(zenkaku-escape " ")  "��")
(defrule '(zenkaku-escape "!")  "��")
(defrule '(zenkaku-escape "@")  "��")
(defrule '(zenkaku-escape "#")  "��")
(defrule '(zenkaku-escape "$")  "��")
(defrule '(zenkaku-escape "%")  "��")
(defrule '(zenkaku-escape "^")  "��")
(defrule '(zenkaku-escape "&")  "��")
(defrule '(zenkaku-escape "*")  "��")
(defrule '(zenkaku-escape "(")  "��")
(defrule '(zenkaku-escape ")")  "��")
(defrule '(zenkaku-escape "-")  "��")
(defrule '(zenkaku-escape "=")  "��")
(defrule '(zenkaku-escape "`")  "��")
(defrule '(zenkaku-escape "\\") "��")
(defrule '(zenkaku-escape "|")  "��")
(defrule '(zenkaku-escape "_")  "��")
(defrule '(zenkaku-escape "+")  "��")
(defrule '(zenkaku-escape "~")  "��")
(defrule '(zenkaku-escape "[")  "��")
(defrule '(zenkaku-escape "]")  "��")
(defrule '(zenkaku-escape "{")  "��")
(defrule '(zenkaku-escape "}")  "��")
(defrule '(zenkaku-escape ":")  "��")
(defrule '(zenkaku-escape ";")  "��")
(defrule '(zenkaku-escape "\"") "��")
(defrule '(zenkaku-escape "'")  "��")
(defrule '(zenkaku-escape "<")  "��")
(defrule '(zenkaku-escape ">")  "��")
(defrule '(zenkaku-escape "?")  "��")
(defrule '(zenkaku-escape "/")  "��")
(defrule '(zenkaku-escape ",")  "��")
(defrule '(zenkaku-escape ".")  "��")

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

(defrule   "z1"   "��")	(defrule   "z!"   "��")
(defrule   "z2"   "��")	(defrule   "z@"   "��")
(defrule   "z3"   "��")	(defrule   "z#"   "��")
(defrule   "z4"   "��")	(defrule   "z$"   "��")
(defrule   "z5"   "��")	(defrule   "z%"   "��")
(defrule   "z6"   "��")	(defrule   "z^"   "��")
(defrule   "z7"   "��")	(defrule   "z&"   "��")
(defrule   "z8"   "��")	(defrule   "z*"   "��")
(defrule   "z9"   "��")	(defrule   "z("   "��")
(defrule   "z0"   "��")	(defrule   "z)"   "��")
(defrule   "z-"   "��")	(defrule   "z_"   "��")	; z-
(defrule   "z="   "��")	(defrule   "z+"   "��")
(defrule   "z\\"  "��")	(defrule   "z|"   "��")
(defrule   "z`"   "��")	(defrule   "z~"   "��")

(defrule   "zq"   "��")	(defrule   "zQ"   "��")
(defrule   "zw"   "��")	(defrule   "zW"   "��")
; e
(defrule   "zr"   "��")	(defrule   "zR"   "��")	; zr
(defrule   "zt"   "��")	(defrule   "zT"   "��")
; y u i o
(defrule   "zp"   "��")	(defrule   "zP"   "��")	; zp
(defrule   "z["   "��")	(defrule   "z{"   "��")	; z[
(defrule   "z]"   "��")	(defrule   "z}"   "��")	; z]

; a
(defrule   "zs"   "��")	(defrule   "zS"   "��")
(defrule   "zd"   "��")	(defrule   "zD"   "��")
(defrule   "zf"   "��")	(defrule   "zF"   "��")
(defrule   "zg"   "��")	(defrule   "zG"   "��")
(defrule   "zh"   "��")
(defrule   "zj"   "��")
(defrule   "zk"   "��")
(defrule   "zl"   "��")
(defrule   "z;"   "��")	(defrule   "z:"   "��")
(defrule   "z\'"  "��")	(defrule   "z\""  "��")

; z
(defrule   "zx"   ":-")	(defrule   "zX"   ":-)")
(defrule   "zc"   "��")	(defrule   "zC"   "��")	; zc
(defrule   "zv"   "��")	(defrule   "zV"   "��")
(defrule   "zb"   "��")	(defrule   "zB"   "��")
(defrule   "zn"   "��")	(defrule   "zN"   "��")
(defrule   "zm"   "��")	(defrule   "zM"   "��")
(defrule   "z,"   "��")	(defrule   "z<"   "��")
(defrule   "z."   "��")	(defrule   "z>"   "��")	; z.
(defrule   "z/"   "��")	(defrule   "z?"   "��")	; z/

;;; Commented out by K.Handa.  Already defined in a different way.
;(defrule   "va"   "����")
;(defrule   "vi"   "����")
;(defrule   "vu"   "��")
;(defrule   "ve"   "����")
;(defrule   "vo"   "����")
