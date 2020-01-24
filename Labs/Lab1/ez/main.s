;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Thu Jan 23 11:02:22 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	STOMAX
	.section	.rodata
	.type	STOMAX, @object
	.size	STOMAX, 2
STOMAX:
	.word	300
	.globl	LTOMAX
	.type	LTOMAX, @object
	.size	LTOMAX, 2
LTOMAX:
	.word	1000
	.globl	stoCount
	.sect	.data
	.type	stoCount, @object
	.size	stoCount, 2
stoCount:
	.word	0
	.globl	ltoCount
	.type	ltoCount, @object
	.size	ltoCount, 2
ltoCount:
	.word	0
	.globl	carOn
	.type	carOn, @object
	.size	carOn, 1
carOn:
	.byte	0
	.globl	state
	.type	state, @object
	.size	state, 1
state:
	.byte	0
	.globl	checkStatus
	.type	checkStatus, @object
	.size	checkStatus, 1
checkStatus:
	.byte	0
	.globl	stoFlag
	.type	stoFlag, @object
	.size	stoFlag, 1
stoFlag:
	.byte	0
	.globl	ltoFlag
	.type	ltoFlag, @object
	.size	ltoFlag, 1
ltoFlag:
	.byte	0
	; extern	interruptFunc
	; extern	setLights
	; extern	getCar
	; extern	shortTimer
	; extern	longTimer
	; extern	fsm
	.sect	.text
	.globl	_start
	.type	_start,@function
_start:
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	ldx	#4316
	ldab	#126
	stab	0,x
	ldx	#4317
	ldd	#interruptFunc
	std	0,x
	ldx	#4130
	bset	0,x, #64
	ldx	#4131
	bset	0,x, #64
	ldx	#4110
	ldd	0,x
	addd	#20000
	ldx	#4120
	std	0,x
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
.L9:
	bsr	setLights
	clr	checkStatus
.L5:
	ldab	checkStatus
	beq	.L5
	bsr	getCar
	bsr	shortTimer
	bsr	longTimer
	bsr	fsm
	bra	.L9
	.size	_start, .-_start
	.globl	interruptFunc
	.type	interruptFunc,@function
	.interrupt	interruptFunc
interruptFunc:
	ldx	*_.tmp
	pshx
	ldx	*_.z
	pshx
	ldx	*_.xy
	pshx
	ldx	#4131
	bset	0,x, #64
	ldx	#4120
	ldd	0,x
	addd	#20000
	std	0,x
	ldab	#1
	stab	checkStatus
	pulx
	stx	*_.xy
	pulx
	stx	*_.z
	pulx
	stx	*_.tmp
	rti
	.size	interruptFunc, .-interruptFunc
	.globl	getCar
	.type	getCar,@function
getCar:
	ldx	#4096
	ldab	0,x
	anda	#0
	andb	#2
	std	*_.tmp
	beq	.L12
	ldab	#1
.L12:
	stab	carOn
	rts
	.size	getCar, .-getCar
	.globl	shortTimer
	.type	shortTimer,@function
shortTimer:
	ldd	stoCount
	cpd	#299
	bhi	.L15
	ldx	stoCount
	inx
	stx	stoCount
.L15:
	ldd	stoCount
	cpd	#300
	bne	.L16
	ldab	#1
	stab	stoFlag
	rts
.L16:
	clr	stoFlag
	rts
	.size	shortTimer, .-shortTimer
	.globl	longTimer
	.type	longTimer,@function
longTimer:
	ldd	ltoCount
	cpd	#999
	bhi	.L19
	ldx	ltoCount
	inx
	stx	ltoCount
.L19:
	ldd	ltoCount
	cpd	#1000
	bne	.L20
	ldab	#1
	stab	ltoFlag
	rts
.L20:
	clr	ltoFlag
	rts
	.size	longTimer, .-longTimer
	.globl	fsm
	.type	fsm,@function
fsm:
	ldab	state
	stab	*_.tmp+1
	ldx	*_.tmp
	xgdx
	clra
	xgdx
	cpx	#64
	beq	.L34
	bgt	.L38
	cpx	#0
	beq	.L24
	cpx	#32
	beq	.L27
	rts
.L38:
	cpx	#96
	beq	.L30
	rts
.L24:
	ldab	carOn
	cmpb	#1
	bne	.L25
	ldab	ltoFlag
	cmpb	#1
	bne	.L25
	ldab	#32
	stab	state
	stx	stoCount
	stx	ltoCount
	rts
.L25:
	clr	state
	rts
.L27:
	ldab	stoFlag
	cmpb	#1
	bne	.L28
	ldab	#96
	bra	.L39
.L28:
	ldab	#32
	stab	state
	rts
.L30:
	ldab	carOn
	bne	.L33
	ldab	stoFlag
	cmpb	#1
	beq	.L32
.L33:
	ldab	ltoFlag
	cmpb	#1
	bne	.L22
.L32:
	ldab	#64
.L39:
	stab	state
	clr	stoCount+1
	clr	stoCount
	clr	ltoCount+1
	clr	ltoCount
	rts
.L34:
	ldab	stoFlag
	cmpb	#1
	bne	.L22
	clr	state
	clr	stoCount+1
	clr	stoCount
	clr	ltoCount+1
	clr	ltoCount
.L22:
	rts
	.size	fsm, .-fsm
	.globl	setLights
	.type	setLights,@function
setLights:
	pshx
	ldx	#4096
	ldab	0,x
	andb	#-97
	tsy
	stab	0,y
	ldab	state
	orab	0,y
	stab	1,y
	stab	0,x
	pulx
	rts
	.size	setLights, .-setLights
	.ident	"GCC: (GNU) 3.3.6-m68hc1x-20060122"
