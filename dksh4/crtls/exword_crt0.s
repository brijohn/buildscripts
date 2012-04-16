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
	mov.l	__libc_init_addr, r1
	tst	r1, r1
	bt	.L1
	jsr	@r1
	nop
.L1:
	mov.l 	_main_addr, r0
	mov	r14, r4
	jsr 	@r0
	nop
	mov	r0, r13
	mov.l   __libc_cleanup_addr, r1
	tst	r1, r1
	bt	.L2
	mov	r14, r4
	jsr	@r1
	nop
.L2:
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
_main_addr:
.long _main
__libc_init_addr:
.long ___libc_init
__libc_cleanup_addr:
.long ___libc_cleanup
.weak ___libc_init
.weak ___libc_cleanup
