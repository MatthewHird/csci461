;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Wed Mar  4 18:44:02 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	virtual_timer
	.section	.rodata
	.type	virtual_timer, @object
	.size	virtual_timer, 10
virtual_timer:
	.word	30
	.word	30
	.word	30
	.word	10
	.word	20
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
	.globl	t1
	.type	t1, @object
	.size	t1, 10
t1:
	.string	"Test1\n\004"
	.zero	2
	.globl	t2
	.type	t2, @object
	.size	t2, 10
t2:
	.string	"Test2\n\004"
	.zero	2
	.globl	t3
	.type	t3, @object
	.size	t3, 10
t3:
	.string	"Test3\n\004"
	.zero	2
	.globl	t4
	.type	t4, @object
	.size	t4, 10
t4:
	.string	"Test4\n\004"
	.zero	2
	.globl	t5
	.type	t5, @object
	.size	t5, 10
t5:
	.string	"Test5\n\004"
	.zero	2
	.globl	t6
	.type	t6, @object
	.size	t6, 10
t6:
	.string	"Test6\n\004"
	.zero	2
	.globl	t7
	.type	t7, @object
	.size	t7, 10
t7:
	.string	"Test7\n\004"
	.zero	2
	.globl	t8
	.type	t8, @object
	.size	t8, 10
t8:
	.string	"Test8\n\004"
	.zero	2
	.globl	t9
	.type	t9, @object
	.size	t9, 10
t9:
	.string	"Test9\n\004"
	.zero	2
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
	ldx	#30
	xgdy
	stx	0,y
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdy
	stx	0,y
	tsx
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+4
	xgdy
	ldab	#16
	stab	0,y
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	clr	0,y
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+6
	ldy	#sequence_tsk_tick_func
	xgdx
	sty	0,x
	tsx
	ldab	0,x
	incb
	stab	0,x
	ldx	#4134
	bset	0,x, #-128
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks
	ldy	#100
	xgdx
	sty	0,x
	tsx
	ldab	0,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdx
	sty	0,x
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	xgdx
	clr	0,x
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	clr	0,y
	tsx
	ldab	0,x
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
	addd	#-5536
	ldx	#4120
	std	0,x
	ldx	#20
	stx	toc2_interrupt_count
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
	ldy	*_.tmp
	beq	.L8
	cpy	#128
	bne	.L6
	ldy	#0
	bra	.L6
.L8:
	ldy	#128
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
	bhi	.L18
	cpy	#16
	beq	.L15
	bra	.L12
.L18:
	cpy	#64
	bne	.L12
	ldy	#32
	bra	.L12
.L14:
	ldy	#16
	bra	.L12
.L15:
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
	asld
	addd	#virtual_timer
	xgdy
	ldd	0,y
	std	4,x
	ldd	toc2_interrupt_count
	cpd	#19
	bhi	.L20
	ldx	toc2_interrupt_count
	inx
	stx	toc2_interrupt_count
	bra	.L21
.L20:
	ldab	#1
	stab	3,x
	clr	toc2_interrupt_count+1
	clr	toc2_interrupt_count
	ldx	virtual_index
	inx
	stx	virtual_index
	ldd	virtual_index
	cpd	#4
	bls	.L21
	clr	virtual_index+1
	clr	virtual_index
.L21:
	ldx	#4120
	ldd	0,x
	addd	#-5536
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
	xgdx
	ldd	0,x
	addd	#20
	std	0,x
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
	.comm	rev_temp,100,1
	.ident	"GCC: (GNU) 3.3.6-m68hc1x-20060122"
