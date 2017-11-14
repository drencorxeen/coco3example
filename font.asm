
; currw current window
; U string
; color color
DrawString

loop@
 ldb ,u+
 beq xDrawString
 lbsr DrawChar
 bra loop@

xDrawString
 rts

; B character
; color color
; currw window
DrawChar
 pshs d,x,y,u

 pshs b

* Get current window
 ldu currw

* Carriage return
 cmpb #13
 bne no@
 clr 4,u ; XCURSOR
 inc 5,u ; YCURSOR
* Need scrolling?
 ;lda 5,u ; YCURSOR
 ;cmpa 3,u ; YHEIGHT
 ;blo xDrawRow
* Scroll window
 ;dec 5,u ; YCURSOR
 bra xDrawRow
no@

* Clip to window width
 lda 4,u ; XCURSOR
 cmpa 2,u ; XWIDTH
 bhs xDrawRow

* convert row/column to pixel offsets
 ldb 4,u ; XCURSOR
 addb ,u ; XSTART
 lda #6
 mul
 std x1

 ldb 5,u ; YCURSOR
 addb 1,u ; YSTART
 lda #7
 mul
 std y1

 puls b

* point X to font data
 leau charset,pcr
 leax font-5,pcr
loop@
 leax 5,x
 cmpb ,u+
 bne loop@

* for each row
 ldd y1
 std ypos
 lda #5
 pshs a
DrawRow
 dec ,s
 bmi xDrawRow

* for each pixel in row
 ldb ,x+
 rolb
 stb rowdata
 ldd x1
 std xpos
 lda #5
 pshs a

DrawPixel
 dec ,s
 bmi xDrawPixel

* draw pixel
 ldb color
 rol rowdata
 bcs no@
 clrb
no@
 pshs x
 ldx xpos
 ldy ypos
 lbsr pset
 puls x

* next pixel
 ldd xpos
 addd #1
 std xpos
 bra DrawPixel
xDrawPixel
 leas 1,s

* next row
 ldd ypos
 addd #1
 std ypos
 bra DrawRow
xDrawRow
 ;leas 1,s
 puls b
 cmpb #32
 blo no@
 ldu currw
 inc 4,u
no@

 puls d,x,y,u,pc

charset
 fcc " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:,.!#"

font
 fcb 0x00,0x00,0x00,0x00,0x00 ;  (space)
 fcb 0x38,0x44,0x7c,0x44,0x44 ;  A
 fcb 0x78,0x44,0x78,0x44,0x78 ;  B
 fcb 0x3C,0x40,0x40,0x40,0x3C ;  C
 fcb 0x78,0x44,0x44,0x44,0x78 ;  D
 fcb 0x7c,0x40,0x78,0x40,0x7c ;  E
 fcb 0x7c,0x40,0x70,0x40,0x40 ;  F
 fcb 0x3c,0x40,0x4c,0x44,0x38 ;  G
 fcb 0x44,0x44,0x7c,0x44,0x44 ;  H
 fcb 0x38,0x10,0x10,0x10,0x38 ;  I
 fcb 0x04,0x04,0x04,0x44,0x38 ;  J
 fcb 0x44,0x48,0x70,0x48,0x44 ;  K
 fcb 0x40,0x40,0x40,0x40,0x7c ;  L
 fcb 0x44,0x6c,0x54,0x44,0x44 ;  M
 fcb 0x44,0x64,0x54,0x4c,0x44 ;  N
 fcb 0x38,0x44,0x44,0x44,0x38 ;  O
 fcb 0x78,0x44,0x78,0x40,0x40 ;  P
 fcb 0x7c,0x44,0x44,0x7c,0x10 ;  Q
 fcb 0x78,0x44,0x78,0x44,0x44 ;  R
 fcb 0x3c,0x40,0x38,0x04,0x78 ;  S
 fcb 0x7c,0x10,0x10,0x10,0x10 ;  T
 fcb 0x44,0x44,0x44,0x44,0x38 ;  U
 fcb 0x44,0x44,0x28,0x28,0x10 ;  V
 fcb 0x44,0x44,0x54,0x54,0x28 ;  W
 fcb 0x44,0x28,0x10,0x28,0x44 ;  X
 fcb 0x44,0x44,0x28,0x10,0x10 ;  Y
 fcb 0x7c,0x08,0x10,0x20,0x7c ;  Z
 fcb 0x38,0x44,0x44,0x44,0x38 ;  0
 fcb 0x10,0x30,0x10,0x10,0x38 ;  1
 fcb 0x78,0x04,0x38,0x40,0x7c ;  2
 fcb 0x78,0x04,0x38,0x04,0x78 ;  3
 fcb 0x18,0x28,0x48,0x7c,0x08 ;  4
 fcb 0x7c,0x40,0x78,0x04,0x78 ;  5
 fcb 0x38,0x40,0x78,0x44,0x38 ;  6
 fcb 0x7c,0x04,0x08,0x10,0x10 ;  7
 fcb 0x38,0x44,0x38,0x44,0x38 ;  8
 fcb 0x38,0x44,0x3C,0x04,0x38 ;  9
 fcb 0x00,0x10,0x00,0x10,0x00 ;  :
 fcb 0x00,0x00,0x00,0x20,0x40 ;  ,
 fcb 0x00,0x00,0x00,0x00,0x10 ;  .
 fcb 0x10,0x10,0x10,0x00,0x10 ;  !
 fcb 0x28,0x7c,0x28,0x7c,0x28 ;  #
