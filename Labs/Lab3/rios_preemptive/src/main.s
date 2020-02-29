;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Fri Feb 28 17:25:29 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	toc2_interrupt_count
	.sect	.data
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
	.globl	is_tick
	.type	is_tick, @object
	.size	is_tick, 1
is_tick:
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
	; extern	enable_interrupts
	; extern	start_task
	; extern	end_task
	.sect	.text
	.globl	_start
	.type	_start,@function
_start:
	pshx
	des
	ldx	*_.d1
	pshx
	bsr	disable_interrupts
	bsr	init_tasks
	bsr	init_toc2
	bsr	enable_interrupts
.L18:
	clr	is_tick
	tsx
	clr	2,x
.L5:
	ldab	is_tick
	beq	.L5
	ldab	is_tick
	beq	.L18
	tsy
	clr	2,y
	ldab	2,y
	cmpb	#1
	bhi	.L18
.L14:
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
	xgdy
	ldd	0,y
	std	*_.tmp
	cpx	*_.tmp
	blo	.L13
	ldab	current_task_index
	ldx	#running_tasks
	abx
	ldab	0,x
	stab	*_.d1+1
	tsy
	ldab	2,y
	cmpb	*_.d1+1
	bhs	.L13
	ldab	2,y
	clra
	asld
	asld
	asld
	addd	#tasks+5
	xgdx
	ldab	0,x
	bne	.L13
	ldab	2,y
	pshb
	des
	tsy
	ldab	4,y
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
	std	13,y
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
	xgdy
	ldab	0,y
	clra
	ldx	0,x
	jsr	0,x
	tsx
	ldx	13,x
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
.L13:
	tsx
	ldab	2,x
	clra
	asld
	asld
	asld
	addd	#tasks+2
	xgdx
	ldd	0,x
	addd	#200
	std	0,x
	tsy
	ldab	2,y
	incb
	stab	2,y
	ldab	2,y
	cmpb	#1
	bls	.L14
	bra	.L18
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
	ldy	#200
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
	ldy	#1000
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
	bne	.L24
	ldy	#128
	bra	.L21
.L24:
	ldy	#0
.L21:
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
	beq	.L29
	bls	.L31
	cpy	#64
	bne	.L31
	ldy	#32
	bra	.L27
.L29:
	ldy	#16
	bra	.L27
.L31:
	ldy	#64
.L27:
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
	bsr	enable_interrupts
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
	bsr	enable_interrupts
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
	ldd	toc2_interrupt_count
	cpd	#5
	bhi	.L43
	ldx	toc2_interrupt_count
	inx
	stx	toc2_interrupt_count
	bra	.L44
.L43:
	ldab	#1
	stab	is_tick
	clr	toc2_interrupt_count+1
	clr	toc2_interrupt_count
.L44:
	bsr	update_toc2
	bsr	enable_interrupts
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
