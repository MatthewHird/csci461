;============================================-=
; File:
       .file "buff.h" 
; Behaviour: 
;      Library of Buffalo Monitor Routines
; Assumptions:
;      Routines only modify registers and the stack.
; Board:
;      CME11-E9-EVBU (with the PW link HACK)
; Author:
;      Peter Walsh
;============================================-=

;---------------------------------------------
; Behaviour:
;    wstr calls Buffalo Monitor OUTSTRGO
; Assumptions:
;    none
; Restriction:
;    subroutine may only accesses registers and the stack
; Register and Memory Usage:
;    Precondition:
;      accd contains the string pointer
;    Postcondition:
;      ascii string referenced by b output to serial line
;    Destroys:
;      none
;---------------------------------------------
.global wstr
.global xwstr

;---------------------------------------------
; Behaviour:
;    wcrlf calls Buffalo Monitor CRLF
; Assumptions:
;    none
; Restriction:
;    subroutine may only accesses registers and the stack
; Register and Memory Usage:
;    Precondition:
;      none
;    Postcondition:
;      ascii CR/LF output to serial line
;    Destroys:
;      none
;---------------------------------------------
.global wcrlf
.global xwcrlf
