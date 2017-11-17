; B	value
; color	color
; currw	current window
DrawByte

 ldu #string
 andb #$7f ; DEBUG
 pshs b

* hundreds digit
 lda #'0'
 sta ,u
loop@
 ldb ,s
 subb #100
 bmi xloop@
 stb ,s
 inc ,u
 bra loop@
xloop@

* tens digit
 lda #'0'
 sta 1,u
loop@
 ldb ,s
 subb #10
 bmi xloop@
 stb ,s
 inc 1,u
 bra loop@
xloop@

* ones digit
 puls b
 addb #'0'
 stb 2,u

* string terminator
 clr 3,u

; U string
; color color
 ldu #string
 lbsr DrawString

 rts