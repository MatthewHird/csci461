;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Thu Mar  5 13:02:04 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	virtual_timer
	.section	.rodata
	.type	virtual_timer, @object
	.size	virtual_timer, 19
virtual_timer:
	.byte	0
	.byte	90
	.byte	10
	.byte	80
	.byte	20
	.byte	70
	.byte	30
	.byte	60
	.byte	40
	.byte	50
	.byte	50
	.byte	40
	.byte	60
	.byte	30
	.byte	70
	.byte	20
	.byte	80
	.byte	10
	.byte	90
	.globl	virtual_index
	.sect	.data
	.type	virtual_index, @object
	.size	virtual_index, 2
virtual_index:
	.word	0
	.globl	toc2_interrupt_count
	.type	toc2_interrupt_count, @object
	.size	toc2_interrupt_count, 2
toc2_interrupt_count:
	.word	0
	.globl	running_tasks
	.type	running_tasks, @object
	.size	running_tasks, 4
running_tasks:
	.byte	-1
	.zero	3
	.globl	current_task_index
	.type	current_task_index, @object
	.size	current_task_index, 1
current_task_index:
	.byte	0
	; extern	sequence_tsk_tick_func
	; extern	toggle_tsk_tick_func
	; extern	toc2_isr
	.sect	.text
	.globl	_start
	.type	_start,@function
_start:
	des
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	tsx
	clr	0,x
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks
	ldx	#100
	xgdy
	stx	0,y
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdx
	clr	1,x
	clr	0,x
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	xgdy
	ldab	#16
	stab	0,y
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdx
	clr	0,x
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	ldx	#sequence_tsk_tick_func
	xgdy
	stx	0,y
	tsy
	ldab	0,y
	incb
	stab	0,y
	ldx	#4134
	bset	0,x, #-128
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks
	ldy	#90
	xgdx
	sty	0,x
	tsx
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdy
	clr	1,y
	clr	0,y
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+4
	xgdx
	clr	0,x
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdx
	clr	0,x
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	ldx	#toggle_tsk_tick_func
	xgdy
	stx	0,y
	tsy
	ldab	0,y
	incb
	stab	0,y
	ldx	#220
	ldab	#126
	stab	0,x
	ldx	#221
	ldy	#toc2_isr
	sty	0,x
	ldx	#4130
	bset	0,x, #64
	ldx	#4131
	bset	0,x, #64
	ldx	#4110
	ldd	0,x
	addd	#20000
	ldx	#4120
	std	0,x
	ldx	#18
	stx	virtual_index
	ldd	virtual_index
	addd	#virtual_timer
	xgdy
	clra
	ldab	0,y
	std	toc2_interrupt_count
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
.L2:
	bra	.L2
	.size	_start, .-_start
	.globl	toggle_tsk_tick_func
	.type	toggle_tsk_tick_func,@function
toggle_tsk_tick_func:
	std	*_.tmp
	bne	.L9
	ldy	#128
	bra	.L6
.L9:
	ldy	#0
.L6:
	ldx	#4096
	ldab	0,x
	andb	#127
	sty	*_.tmp
	orab	*_.tmp+1
	stab	0,x
	xgdy
	rts
	.size	toggle_tsk_tick_func, .-toggle_tsk_tick_func
	.globl	sequence_tsk_tick_func
	.type	sequence_tsk_tick_func,@function
sequence_tsk_tick_func:
	xgdy
	cpy	#32
	beq	.L14
	bls	.L16
	cpy	#64
	bne	.L16
	ldy	#32
	bra	.L12
.L14:
	ldy	#16
	bra	.L12
.L16:
	ldy	#64
.L12:
	ldx	#4096
	ldab	0,x
	andb	#-113
	sty	*_.tmp
	orab	*_.tmp+1
	stab	0,x
	xgdy
	rts
	.size	sequence_tsk_tick_func, .-sequence_tsk_tick_func
	.globl	toc2_isr
	.type	toc2_isr,@function
	.interrupt	toc2_isr
toc2_isr:
	ldx	*_.tmp
	pshx
	ldx	*_.z
	pshx
	ldx	*_.xy
	pshx
	pshx
	pshx
	pshx
	des
	ldx	*_.d1
	pshx
	tsx
	clr	3,x
	ldd	virtual_index
	addd	#virtual_timer
	xgdy
	ldab	0,y
	stab	4,x
	ldab	4,x
	stab	*_.tmp+1
	ldx	*_.tmp
	xgdx
	clra
	xgdx
	ldd	toc2_interrupt_count
	stx	*_.tmp
	cpd	*_.tmp
	bhs	.L20
	ldx	toc2_interrupt_count
	inx
	stx	toc2_interrupt_count
	bra	.L21
.L20:
	ldab	#1
	tsy
	stab	3,y
	clr	toc2_interrupt_count+1
	clr	toc2_interrupt_count
	ldx	virtual_index
	inx
	stx	virtual_index
	ldd	virtual_index
	cpd	#18
	bls	.L22
	clr	virtual_index+1
	clr	virtual_index
.L22:
	ldd	virtual_index
	addd	#virtual_timer
	xgdx
	ldab	0,x
	tsy
	stab	5,y
.L21:
	ldx	#4120
	ldd	0,x
	addd	#20000
	std	0,x
	ldx	#4131
	bset	0,x, #64
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
	tsx
	ldab	3,x
	beq	.L19
	clr	2,x
	ldab	2,x
	cmpb	#1
	bhi	.L19
.L29:
	tsy
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdx
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks
	ldx	0,x
	xgdy
	ldd	0,y
	std	*_.tmp
	cpx	*_.tmp
	blo	.L28
	ldab	current_task_index
	ldx	#running_tasks
	abx
	ldab	0,x
	stab	*_.d1+1
	tsy
	ldab	2,y
	cmpb	*_.d1+1
	bhs	.L28
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	ldab	0,y
	tsx
	stab	6,x
	bne	.L28
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	ldab	2,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdy
	clr	1,y
	clr	0,y
	ldab	2,x
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	ldab	#1
	stab	0,y
	ldab	current_task_index
	incb
	stab	current_task_index
	ldab	current_task_index
	ldx	#running_tasks
	abx
	tsy
	ldab	2,y
	stab	0,x
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	std	7,y
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	xgdx
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	xgdy
	ldab	0,y
	clra
	ldx	0,x
	jsr	0,x
	tsx
	ldx	7,x
	stab	0,x
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	tsy
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	tsx
	ldab	6,x
	stab	0,y
	ldab	current_task_index
	ldx	#running_tasks
	abx
	ldab	#-1
	stab	0,x
	ldab	current_task_index
	decb
	stab	current_task_index
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
.L28:
	tsy
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdy
	tsx
	ldab	5,x
	ldx	0,y
	abx
	stx	0,y
	tsy
	ldab	2,y
	incb
	stab	2,y
	ldab	2,y
	cmpb	#1
	bls	.L29
.L19:
	pulx
	stx	*_.d1
	pulx
	pulx
	pulx
	ins
	pulx
	stx	*_.xy
	pulx
	stx	*_.z
	pulx
	stx	*_.tmp
	rti
	.size	toc2_isr, .-toc2_isr
	.comm	tasks,16,1
	.ident	"GCC: (GNU) 3.3.6-m68hc1x-20060122"
