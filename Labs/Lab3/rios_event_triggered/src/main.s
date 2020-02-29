;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Fri Feb 28 17:46:09 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	virtual_timer
	.section	.rodata
	.type	virtual_timer, @object
	.size	virtual_timer, 24
virtual_timer:
	.word	400
	.word	400
	.word	100
	.word	300
	.word	400
	.word	200
	.word	200
	.word	400
	.word	300
	.word	100
	.word	400
	.word	400
	.globl	virtual_index
	.sect	.data
	.type	virtual_index, @object
	.size	virtual_index, 2
virtual_index:
	.word	0
	.globl	is_tick
	.type	is_tick, @object
	.size	is_tick, 1
is_tick:
	.byte	0
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
	; extern	disable_interrupts
	; extern	init_tasks
	; extern	init_toc2
	; extern	start_task
	; extern	end_task
	; extern	enable_interrupts
	.sect	.text
	.globl	_start
	.type	_start,@function
_start:
	pshx
	pshx
	pshx
	des
	ldx	*_.d1
	pshx
	bsr	disable_interrupts
	bsr	init_tasks
	bsr	init_toc2
	tsx
	clr	2,x
	ldab	2,x
	cmpb	#1
	bhi	.L22
.L6:
	tsy
	ldab	2,y
	pshb
	des
	tsx
	ldab	4,x
	clra
	asld
	asld
	asld
	addd	#tasks
	xgdy
	ldx	6,y
	pshx
	ldx	4,y
	pshx
	ldx	2,y
	pshx
	ldx	0,y
	pshx
	bsr	start_task
	tsy
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	std	15,y
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	xgdx
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	std	*_.z
	stx	*_.xy
	ldx	*_.z
	ldab	0,x
	ldx	*_.xy
	clra
	ldx	0,x
	jsr	0,x
	tsx
	ldx	15,x
	stab	0,x
	tsy
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks
	xgdy
	ldx	6,y
	pshx
	ldx	4,y
	pshx
	ldx	2,y
	pshx
	ldx	0,y
	pshx
	bsr	end_task
	tsx
	ldab	#18
	abx
	txs
	tsx
	ldab	2,x
	incb
	stab	2,x
	ldab	2,x
	cmpb	#1
	bls	.L6
.L22:
	bsr	enable_interrupts
.L25:
	clr	is_tick
.L10:
	ldab	is_tick
	beq	.L10
	ldd	virtual_index
	asld
	addd	#virtual_timer
	xgdx
	ldd	0,x
	tsy
	std	3,y
	ldx	virtual_index
	inx
	stx	virtual_index
	ldd	virtual_index
	cpd	#11
	bls	.L13
	clr	virtual_index+1
	clr	virtual_index
.L13:
	bsr	enable_interrupts
	stx	*_.xy
	tsx
	clr	2,x
	ldab	2,x
	ldx	*_.xy
	cmpb	#1
	bhi	.L25
.L19:
	tsx
	ldab	2,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdx
	tsy
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks
	ldx	0,x
	std	*_.z
	stx	*_.xy
	ldx	*_.z
	ldd	0,x
	ldx	*_.xy
	std	*_.tmp
	cpx	*_.tmp
	blo	.L18
	ldab	current_task_index
	ldx	#running_tasks
	abx
	ldab	0,x
	stab	*_.d1+1
	ldab	2,y
	cmpb	*_.d1+1
	bhs	.L18
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	ldab	0,y
	bne	.L18
	tsx
	ldab	2,x
	pshb
	des
	tsx
	ldab	4,x
	clra
	asld
	asld
	asld
	addd	#tasks
	xgdy
	ldx	6,y
	pshx
	ldx	4,y
	pshx
	ldx	2,y
	pshx
	ldx	0,y
	pshx
	bsr	start_task
	tsy
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	std	17,y
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	xgdx
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks+4
	std	*_.z
	stx	*_.xy
	ldx	*_.z
	ldab	0,x
	ldx	*_.xy
	clra
	ldx	0,x
	jsr	0,x
	tsx
	ldx	17,x
	stab	0,x
	tsy
	ldab	12,y
	clra
	asld
	asld
	asld
	addd	#tasks
	xgdy
	ldx	6,y
	pshx
	ldx	4,y
	pshx
	ldx	2,y
	pshx
	ldx	0,y
	pshx
	bsr	end_task
	tsx
	xgdx
	addd	#18
	xgdx
	txs
.L18:
	stx	*_.xy
	tsx
	ldab	2,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdy
	ldd	0,y
	stx	*_.z
	ldx	3,x
	stx	*_.tmp
	addd	*_.tmp
	std	0,y
	ldx	*_.z
	ldab	2,x
	incb
	stab	2,x
	ldab	2,x
	cmpb	#1
	bls	.L19
	bra	.L25
	.size	_start, .-_start
	; extern	sequence_tsk_tick_func
	; extern	toggle_tsk_tick_func
	.globl	init_tasks
	.type	init_tasks,@function
init_tasks:
	des
	clrb
	tsy
	stab	0,y
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks
	ldy	#400
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
	xgdy
	clrb
	stab	0,y
	tsy
	ldab	0,y
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
	ldy	#900
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
	xgdy
	clrb
	stab	0,y
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdy
	clrb
	stab	0,y
	tsy
	ldab	0,y
	clra
	asld
	asld
	asld
	addd	#tasks+6
	ldy	#toggle_tsk_tick_func
	xgdx
	sty	0,x
	ins
	rts
	.size	init_tasks, .-init_tasks
	.globl	toggle_tsk_tick_func
	.type	toggle_tsk_tick_func,@function
toggle_tsk_tick_func:
	std	*_.tmp
	bne	.L31
	ldy	#128
	bra	.L28
.L31:
	ldy	#0
.L28:
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
	beq	.L36
	bls	.L38
	cpy	#64
	bne	.L38
	ldy	#32
	bra	.L34
.L36:
	ldy	#16
	bra	.L34
.L38:
	ldy	#64
.L34:
	ldx	#4096
	ldab	0,x
	andb	#-113
	sty	*_.tmp
	orab	*_.tmp+1
	stab	0,x
	xgdy
	rts
	.size	sequence_tsk_tick_func, .-sequence_tsk_tick_func
	.globl	enable_interrupts
	.type	enable_interrupts,@function
enable_interrupts:
; Begin inline assembler code
#APP
	cli
; End of inline assembler code
#NO_APP
	rts
	.size	enable_interrupts, .-enable_interrupts
	.globl	disable_interrupts
	.type	disable_interrupts,@function
disable_interrupts:
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	rts
	.size	disable_interrupts, .-disable_interrupts
	.globl	enable_toc2
	.type	enable_toc2,@function
enable_toc2:
	ldx	#4130
	bset	0,x, #64
	rts
	.size	enable_toc2, .-enable_toc2
	.globl	disable_toc2
	.type	disable_toc2,@function
disable_toc2:
	ldx	#4130
	ldab	0,x
	stab	0,x
	rts
	.size	disable_toc2, .-disable_toc2
	; extern	toc2_isr
	.globl	init_toc2
	.type	init_toc2,@function
init_toc2:
	ldx	#220
	ldab	#126
	stab	0,x
	ldx	#221
	ldd	#toc2_isr
	std	0,x
	bsr	enable_toc2
	ldx	#4131
	bset	0,x, #64
	ldx	#4110
	ldd	0,x
	addd	#-5536
	ldx	#4120
	std	0,x
	rts
	.size	init_toc2, .-init_toc2
	.globl	update_toc2
	.type	update_toc2,@function
update_toc2:
	ldx	#4120
	ldd	0,x
	addd	#-5536
	std	0,x
	ldx	#4131
	bset	0,x, #64
	rts
	.size	update_toc2, .-update_toc2
	.globl	start_task
	.type	start_task,@function
start_task:
	bsr	disable_interrupts
	ldab	current_task_index
	incb
	stab	current_task_index
	ldab	current_task_index
	ldx	#running_tasks
	abx
	tsy
	ldab	11,y
	stab	0,x
	rts
	.size	start_task, .-start_task
	.globl	end_task
	.type	end_task,@function
end_task:
	bsr	disable_interrupts
	ldab	current_task_index
	ldx	#running_tasks
	abx
	ldab	#-1
	stab	0,x
	ldab	current_task_index
	decb
	stab	current_task_index
	rts
	.size	end_task, .-end_task
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
	ldd	virtual_index
	asld
	addd	#virtual_timer
	xgdx
	ldd	0,x
	ldx	#30
	idiv
	xgdx
	ldx	toc2_interrupt_count
	std	*_.tmp
	cpx	*_.tmp
	bhs	.L50
	ldx	toc2_interrupt_count
	inx
	stx	toc2_interrupt_count
	bra	.L51
.L50:
	ldab	#1
	stab	is_tick
	clr	toc2_interrupt_count+1
	clr	toc2_interrupt_count
.L51:
	bsr	update_toc2
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
