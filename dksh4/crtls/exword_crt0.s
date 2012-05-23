.global _start
.extern _main, ___libc_init, ___libc_cleanup

_start:
	mov.l	_exit_pr, r1
	mov.l	_exit_sp, r2
	sts	pr, r0
	mov.l	r0, @r1
	mov.l	r15, @r2
	mov.l	r14, @-r15
	mov.l	r13, @-r15
	sts.l	pr, @-r15
	mov	r4, r14
	mov.l	__copy_data_addr, r1
	jsr	@r1
	nop
	mov.l	__libc_init_addr, r1
	tst	r1, r1
	bt	.L5
	mov	r4, r14
	jsr	@r1
	nop
.L5:
	mov.l 	_main_addr, r0
	mov	r14, r4
	jsr 	@r0
	nop
	mov	r0, r13
	mov.l   __libc_cleanup_addr, r1
	tst	r1, r1
	bt	.L6
	mov	r14, r4
	jsr	@r1
	nop
.L6:
	mov	r13, r0
	lds.l	@r15+, pr
	mov.l	@r15+, r13
	rts
	mov.l	@r15+, r14

.align 2
_exit_pr:
.long 0x74000024
_exit_sp:
.long 0x74000028
__copy_data_addr:
.long __copy_data
_main_addr:
.long _main
__libc_init_addr:
.long ___libc_init
__libc_cleanup_addr:
.long ___libc_cleanup
.weak ___libc_init
.weak ___libc_cleanup


__copy_data:
	mov.l	.L0, r2       // sbss
	mov.l	.L0 + 4, r5   // ebss
	mov	#0, r6
	bra	.L2
	nop
.L1:
	mov.l	r6, @r2
	add	#4, r2
.L2:
	cmp/hs  r5, r2           //sbss>=ebss
	bf      .L1
	mov.l   .L0 + 8, r6      // sdata
	mov.l   .L0 + 16, r2     // edata
	mov.l   .L0 + 12, r5     // etext
	bra     .L4
	nop
.L3:
	mov.l   @r5+, r4
	mov.l   r4, @r6
	add     #4, r6
.L4:
	cmp/hs  r2, r6          //sdata >= edata
	bf      .L3
	rts
	nop
.align 2
.L0:
.long _sbss
.long _ebss
.long _sdata
.long _etext
.long _edata
