;;;-----------------------------------------
;;; Start MC68HC11 gcc assembly output
;;; gcc compiler 3.3.6-m68hc1x-20060122
;;; Command:	/usr/lib/gcc-lib/m68hc11/3.3.6-m68hc1x-20060122/cc1 -quiet -D__GNUC__=3 -D__GNUC_MINOR__=3 -D__GNUC_PATCHLEVEL__=6 -Dmc68hc1x -D__mc68hc1x__ -D__mc68hc1x -D__HAVE_SHORT_INT__ -D__INT__=16 -Dmc6811 -DMC6811 -Dmc68hc11 main.c -quiet -dumpbase main.c -mshort -auxbase main -Os -fomit-frame-pointer -o main.s
;;; Compiled:	Wed Jan 29 12:17:40 2020
;;; (META)compiled by GNU C version 6.3.0 20170221.
;;;-----------------------------------------
	.file	"main.c"
	.mode mshort
	.globl	sto_count
	.sect	.data
	.type	sto_count, @object
	.size	sto_count, 2
sto_count:
	.word	0
	.globl	lto_count
	.type	lto_count, @object
	.size	lto_count, 2
lto_count:
	.word	0
	.globl	state
	.type	state, @object
	.size	state, 1
state:
	.byte	0
	.globl	is_car
	.type	is_car, @object
	.size	is_car, 1
is_car:
	.byte	0
	.globl	is_wait
	.type	is_wait, @object
	.size	is_wait, 1
is_wait:
	.byte	1
	.globl	sto_flag
	.type	sto_flag, @object
	.size	sto_flag, 1
sto_flag:
	.byte	0
	.globl	lto_flag
	.type	lto_flag, @object
	.size	lto_flag, 1
lto_flag:
	.byte	0
	.globl	isr_str
	.type	isr_str, @object
	.size	isr_str, 100
isr_str:
	.string	"ISR Happened!\n\004"
	.zero	84
	.globl	here_str
	.type	here_str, @object
	.size	here_str, 100
here_str:
	.string	"I'm here!!\n\004"
	.zero	87
	.globl	a_str
	.type	a_str, @object
	.size	a_str, 100
a_str:
	.string	"a\004"
	.zero	97
	.globl	b_str
	.type	b_str, @object
	.size	b_str, 100
b_str:
	.string	"b\004"
	.zero	97
	.globl	c_str
	.type	c_str, @object
	.size	c_str, 100
c_str:
	.string	"c\004"
	.zero	97
	.globl	d_str
	.type	d_str, @object
	.size	d_str, 100
d_str:
	.string	"d\004"
	.zero	97
	.globl	e_str
	.type	e_str, @object
	.size	e_str, 100
e_str:
	.string	"e\004"
	.zero	97
	.globl	f_str
	.type	f_str, @object
	.size	f_str, 100
f_str:
	.string	"f\004"
	.zero	97
	.globl	g_str
	.type	g_str, @object
	.size	g_str, 100
g_str:
	.string	"g\004"
	.zero	97
	; extern	frame_sync_isr
	; extern	set_light_out
	; extern	read_car_in
	; extern	update_sto
	; extern	update_lto
	; extern	update_state
	.sect	.text
	.globl	_start
	.type	_start,@function
_start:
; Begin inline assembler code
#APP
	sei
; End of inline assembler code
#NO_APP
	ldx	#220
	ldab	#126
	stab	0,x
	ldx	#221
	ldd	#frame_sync_isr
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
	bsr	set_light_out
	ldab	#1
	stab	is_wait
.L5:
	ldab	is_wait
	cmpb	#1
	beq	.L5
	bsr	read_car_in
	bsr	update_sto
	bsr	update_lto
	bsr	update_state
	bra	.L9
	.size	_start, .-_start
	.globl	frame_sync_isr
	.type	frame_sync_isr,@function
	.interrupt	frame_sync_isr
frame_sync_isr:
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
	clr	is_wait
	pulx
	stx	*_.xy
	pulx
	stx	*_.z
	pulx
	stx	*_.tmp
	rti
	.size	frame_sync_isr, .-frame_sync_isr
	.globl	read_car_in
	.type	read_car_in,@function
read_car_in:
	ldx	#4096
	ldab	0,x
	lsrd
	anda	#0
	andb	#1
	stab	is_car
	rts
	.size	read_car_in, .-read_car_in
	.globl	update_sto
	.type	update_sto,@function
update_sto:
	des
	ldd	sto_count
	cpd	#299
	bhi	.L13
	ldx	sto_count
	inx
	stx	sto_count
.L13:
	tsx
	clr	0,x
	ldd	sto_count
	cpd	#300
	bne	.L14
	ldab	#1
	stab	0,x
.L14:
	tsx
	ldab	0,x
	stab	sto_flag
	ins
	rts
	.size	update_sto, .-update_sto
	.globl	update_lto
	.type	update_lto,@function
update_lto:
	des
	ldd	lto_count
	cpd	#999
	bhi	.L16
	ldx	lto_count
	inx
	stx	lto_count
.L16:
	tsx
	clr	0,x
	ldd	lto_count
	cpd	#1000
	bne	.L17
	ldab	#1
	stab	0,x
.L17:
	tsx
	ldab	0,x
	stab	lto_flag
	ins
	rts
	.size	update_lto, .-update_lto
	.globl	update_state
	.type	update_state,@function
update_state:
	ldab	state
	stab	*_.tmp+1
	ldx	*_.tmp
	xgdx
	clra
	xgdx
	cpx	#64
	beq	.L30
	bgt	.L34
	cpx	#0
	beq	.L20
	cpx	#32
	beq	.L23
	rts
.L34:
	cpx	#96
	beq	.L26
	rts
.L20:
	ldab	is_car
	cmpb	#1
	bne	.L21
	ldab	lto_flag
	cmpb	#1
	bne	.L21
	ldab	#32
	stab	state
	stx	sto_count
	stx	lto_count
	rts
.L21:
	clr	state
	rts
.L23:
	ldab	sto_flag
	cmpb	#1
	bne	.L24
	ldab	#96
	bra	.L35
.L24:
	ldab	#32
	stab	state
	rts
.L26:
	ldab	is_car
	bne	.L29
	ldab	sto_flag
	cmpb	#1
	beq	.L28
.L29:
	ldab	lto_flag
	cmpb	#1
	bne	.L18
.L28:
	ldab	#64
.L35:
	stab	state
	clr	sto_count+1
	clr	sto_count
	clr	lto_count+1
	clr	lto_count
	rts
.L30:
	ldab	sto_flag
	cmpb	#1
	bne	.L18
	clr	state
	clr	sto_count+1
	clr	sto_count
	clr	lto_count+1
	clr	lto_count
.L18:
	rts
	.size	update_state, .-update_state
	.globl	set_light_out
	.type	set_light_out,@function
set_light_out:
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
	.size	set_light_out, .-set_light_out
	.ident	"GCC: (GNU) 3.3.6-m68hc1x-20060122"