	.file	"counter_la_fir.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir" "counter_la_fir.c"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
.LFB316:
	.file 1 "counter_la_fir.c"
	.loc 1 37 1
	.cfi_startproc
	.loc 1 38 2
	.loc 1 65 9
	.loc 1 37 1 is_stmt 0
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	.loc 1 65 43
	li	a4,8192
	li	a5,637534208
	.loc 1 37 1
	sw	s0,8(sp)
	sw	ra,12(sp)
	.cfi_offset 8, -8
	.cfi_offset 1, -4
	.loc 1 65 43
	addi	a3,a4,-2039
	sw	a3,160(a5)
	.loc 1 66 9 is_stmt 1
	.loc 1 66 43 is_stmt 0
	sw	a3,156(a5)
	.loc 1 67 9 is_stmt 1
	.loc 1 67 43 is_stmt 0
	sw	a3,152(a5)
	.loc 1 68 9 is_stmt 1
	.loc 1 68 43 is_stmt 0
	sw	a3,148(a5)
	.loc 1 69 9 is_stmt 1
	.loc 1 69 43 is_stmt 0
	sw	a3,144(a5)
	.loc 1 70 9 is_stmt 1
	.loc 1 70 43 is_stmt 0
	sw	a3,140(a5)
	.loc 1 71 9 is_stmt 1
	.loc 1 71 43 is_stmt 0
	sw	a3,136(a5)
	.loc 1 72 9 is_stmt 1
	.loc 1 72 43 is_stmt 0
	sw	a3,132(a5)
	.loc 1 73 9 is_stmt 1
	.loc 1 73 43 is_stmt 0
	sw	a3,128(a5)
	.loc 1 74 9 is_stmt 1
	.loc 1 74 43 is_stmt 0
	sw	a3,124(a5)
	.loc 1 75 9 is_stmt 1
	.loc 1 75 43 is_stmt 0
	sw	a3,120(a5)
	.loc 1 76 9 is_stmt 1
	.loc 1 76 43 is_stmt 0
	sw	a3,116(a5)
	.loc 1 77 9 is_stmt 1
	.loc 1 77 43 is_stmt 0
	sw	a3,112(a5)
	.loc 1 78 9 is_stmt 1
	.loc 1 78 43 is_stmt 0
	sw	a3,108(a5)
	.loc 1 79 9 is_stmt 1
	.loc 1 79 43 is_stmt 0
	sw	a3,104(a5)
	.loc 1 80 9 is_stmt 1
	.loc 1 80 43 is_stmt 0
	sw	a3,100(a5)
	.loc 1 82 9 is_stmt 1
	.loc 1 82 43 is_stmt 0
	addi	a4,a4,-2040
	sw	a4,96(a5)
	.loc 1 83 9 is_stmt 1
	.loc 1 83 43 is_stmt 0
	sw	a4,92(a5)
	.loc 1 84 9 is_stmt 1
	.loc 1 84 43 is_stmt 0
	sw	a4,88(a5)
	.loc 1 85 9 is_stmt 1
	.loc 1 85 43 is_stmt 0
	sw	a4,84(a5)
	.loc 1 86 9 is_stmt 1
	.loc 1 86 43 is_stmt 0
	sw	a4,80(a5)
	.loc 1 87 9 is_stmt 1
	.loc 1 87 43 is_stmt 0
	sw	a4,76(a5)
	.loc 1 88 9 is_stmt 1
	.loc 1 88 43 is_stmt 0
	sw	a4,72(a5)
	.loc 1 89 9 is_stmt 1
	.loc 1 89 43 is_stmt 0
	sw	a4,68(a5)
	.loc 1 90 9 is_stmt 1
	.loc 1 90 43 is_stmt 0
	sw	a4,64(a5)
	.loc 1 91 9 is_stmt 1
	.loc 1 91 43 is_stmt 0
	sw	a4,56(a5)
	.loc 1 92 9 is_stmt 1
	.loc 1 92 43 is_stmt 0
	sw	a4,52(a5)
	.loc 1 93 9 is_stmt 1
	.loc 1 93 43 is_stmt 0
	sw	a4,48(a5)
	.loc 1 94 9 is_stmt 1
	.loc 1 94 43 is_stmt 0
	sw	a4,44(a5)
	.loc 1 95 9 is_stmt 1
	.loc 1 95 43 is_stmt 0
	sw	a4,40(a5)
	.loc 1 96 9 is_stmt 1
	.loc 1 96 43 is_stmt 0
	sw	a4,36(a5)
	.loc 1 98 9 is_stmt 1
	.loc 1 98 43 is_stmt 0
	sw	a3,60(a5)
	.loc 1 102 2 is_stmt 1
	.loc 1 102 50 is_stmt 0
	li	a4,1
	li	a3,-268410880
	sw	a4,0(a3)
	.loc 1 105 2 is_stmt 1
	.loc 1 106 10 is_stmt 0
	li	s0,637534208
	.loc 1 105 36
	sw	a4,0(a5)
	.loc 1 106 2 is_stmt 1
.L2:
	.loc 1 106 43 discriminator 1
	.loc 1 106 10 is_stmt 0 discriminator 1
	lw	a5,0(s0)
	.loc 1 106 43 discriminator 1
	beq	a5,a4,.L2
	.loc 1 110 2 is_stmt 1
	.loc 1 110 114 is_stmt 0
	li	a5,-268423168
	sw	zero,12(a5)
	.loc 1 110 57
	sw	zero,28(a5)
	.loc 1 111 2 is_stmt 1
	.loc 1 111 112 is_stmt 0
	li	a4,-1
	sw	a4,8(a5)
	.loc 1 111 56
	sw	a4,24(a5)
	.loc 1 112 2 is_stmt 1
	.loc 1 112 112 is_stmt 0
	sw	zero,4(a5)
	.loc 1 112 56
	sw	zero,20(a5)
	.loc 1 113 2 is_stmt 1
	.loc 1 113 100 is_stmt 0
	sw	zero,0(a5)
	.loc 1 113 50
	sw	zero,16(a5)
	.loc 1 116 2 is_stmt 1
	.loc 1 116 36 is_stmt 0
	li	a4,-1421869056
	sw	a4,12(s0)
	.loc 1 119 2 is_stmt 1
	.loc 1 119 56 is_stmt 0
	sw	zero,56(a5)
	.loc 1 122 2 is_stmt 1
	.loc 1 122 112 is_stmt 0
	sw	zero,8(a5)
	.loc 1 122 56
	sw	zero,24(a5)
	.loc 1 143 2 is_stmt 1
	.loc 1 143 36 is_stmt 0
	li	a5,-1421803520
	sw	a5,12(s0)
	.loc 1 144 2 is_stmt 1
	li	a0,30
	call	config_set
.LVL0:
	.loc 1 145 2
	call	tap_write
.LVL1:
	.loc 1 146 2
	.loc 1 146 36 is_stmt 0
	li	a5,-1421737984
	sw	a5,12(s0)
	.loc 1 147 2 is_stmt 1
	li	a0,30
	call	fir_work
.LVL2:
	.loc 1 168 2
	.loc 1 168 36 is_stmt 0
	li	a5,-1420754944
	.loc 1 169 1
	lw	ra,12(sp)
	.cfi_restore 1
	.loc 1 168 36
	sw	a5,12(s0)
	.loc 1 169 1
	lw	s0,8(sp)
	.cfi_restore 8
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE316:
	.size	main, .-main
	.text
.Letext0:
	.file 2 "fir_control.h"
	.file 3 "/opt/riscv/lib/gcc/riscv32-unknown-elf/12.1.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0xe5
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x5
	.4byte	.LASF13
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL0
	.4byte	0
	.4byte	.Ldebug_line0
	.byte	0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF2
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF3
	.byte	0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.byte	0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF5
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF6
	.byte	0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF7
	.byte	0x6
	.4byte	.LASF14
	.byte	0x3
	.byte	0x34
	.byte	0x1b
	.4byte	0x5c
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF8
	.byte	0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF9
	.byte	0x7
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.byte	0x2
	.4byte	.LASF11
	.byte	0x6
	.4byte	0x88
	.byte	0x3
	.4byte	0x6a
	.byte	0
	.byte	0x8
	.4byte	.LASF15
	.byte	0x2
	.byte	0x5
	.byte	0x6
	.byte	0x2
	.4byte	.LASF12
	.byte	0x4
	.4byte	0xa0
	.byte	0x3
	.4byte	0x6a
	.byte	0
	.byte	0x9
	.4byte	.LASF16
	.byte	0x1
	.byte	0x24
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.byte	0x1
	.byte	0x9c
	.byte	0xa
	.string	"j"
	.byte	0x1
	.byte	0x26
	.byte	0x6
	.4byte	0x6a
	.byte	0xb
	.4byte	.LVL0
	.4byte	0x90
	.4byte	0xcf
	.byte	0x4
	.byte	0x1
	.byte	0x5a
	.byte	0x1
	.byte	0x4e
	.byte	0
	.byte	0xc
	.4byte	.LVL1
	.4byte	0x88
	.byte	0xd
	.4byte	.LVL2
	.4byte	0x78
	.byte	0x4
	.byte	0x1
	.byte	0x5a
	.byte	0x1
	.byte	0x4e
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.byte	0x1
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0xe
	.byte	0
	.byte	0
	.byte	0x2
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x2
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x6
	.byte	0x27
	.byte	0x19
	.byte	0x3c
	.byte	0x19
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x3
	.byte	0x5
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x4
	.byte	0x49
	.byte	0
	.byte	0x2
	.byte	0x18
	.byte	0x7e
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x5
	.byte	0x11
	.byte	0x1
	.byte	0x25
	.byte	0xe
	.byte	0x13
	.byte	0xb
	.byte	0x3
	.byte	0x1f
	.byte	0x1b
	.byte	0x1f
	.byte	0x55
	.byte	0x17
	.byte	0x11
	.byte	0x1
	.byte	0x10
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x6
	.byte	0x16
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0
	.byte	0
	.byte	0x8
	.byte	0x2e
	.byte	0
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x27
	.byte	0x19
	.byte	0x3c
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0x9
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0xa
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xb
	.byte	0x48
	.byte	0x1
	.byte	0x7d
	.byte	0x1
	.byte	0x7f
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xc
	.byte	0x48
	.byte	0
	.byte	0x7d
	.byte	0x1
	.byte	0x7f
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xd
	.byte	0x48
	.byte	0x1
	.byte	0x7d
	.byte	0x1
	.byte	0x7f
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.4byte	0
	.4byte	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL0:
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF6:
	.string	"unsigned char"
.LASF8:
	.string	"long unsigned int"
.LASF7:
	.string	"short unsigned int"
.LASF11:
	.string	"fir_work"
.LASF12:
	.string	"config_set"
.LASF16:
	.string	"main"
.LASF10:
	.string	"unsigned int"
.LASF13:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -O3 -ffreestanding"
.LASF9:
	.string	"long long unsigned int"
.LASF5:
	.string	"long long int"
.LASF3:
	.string	"short int"
.LASF15:
	.string	"tap_write"
.LASF14:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF2:
	.string	"signed char"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir"
.LASF0:
	.string	"counter_la_fir.c"
	.ident	"GCC: (g1ea978e3066) 12.1.0"
