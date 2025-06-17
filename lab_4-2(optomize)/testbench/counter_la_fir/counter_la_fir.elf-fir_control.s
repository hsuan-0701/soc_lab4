	.file	"fir_control.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir" "fir_control.c"
	.section	.mprjram,"ax",@progbits
	.align	2
	.globl	config_set
	.type	config_set, @function
config_set:
.LFB316:
	.file 1 "fir_control.c"
	.loc 1 6 77
	.cfi_startproc
.LVL0:
	.loc 1 8 2
	.loc 1 8 38 is_stmt 0
	li	a5,805306368
	li	a4,11
	sw	a4,20(a5)
	.loc 1 9 2 is_stmt 1
	.loc 1 9 38 is_stmt 0
	sw	a0,16(a5)
	.loc 1 10 1
	ret
	.cfi_endproc
.LFE316:
	.size	config_set, .-config_set
	.align	2
	.globl	tap_write
	.type	tap_write, @function
tap_write:
.LFB317:
	.loc 1 12 66 is_stmt 1
	.cfi_startproc
	.loc 1 13 2
	.loc 1 15 2
.LBB2:
	.loc 1 15 6
.LVL1:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a5,805306368
	li	a4,-6
	sw	a4,128(a5)
	.loc 1 15 23 is_stmt 1
.LVL2:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a3,1
	sw	a3,132(a5)
	.loc 1 15 23 is_stmt 1
.LVL3:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a3,-7
	sw	a3,136(a5)
	.loc 1 15 23 is_stmt 1
.LVL4:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a3,7
	sw	a3,140(a5)
	.loc 1 15 23 is_stmt 1
.LVL5:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a2,-1
	sw	a2,144(a5)
	.loc 1 15 23 is_stmt 1
.LVL6:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a2,-8
	sw	a2,148(a5)
	.loc 1 15 23 is_stmt 1
.LVL7:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a2,3
	sw	a2,152(a5)
	.loc 1 15 23 is_stmt 1
.LVL8:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	sw	a3,156(a5)
	.loc 1 15 23 is_stmt 1
.LVL9:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a3,-10
	sw	a3,160(a5)
	.loc 1 15 23 is_stmt 1
.LVL10:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	sw	a4,164(a5)
	.loc 1 15 23 is_stmt 1
.LVL11:
	.loc 1 15 17
	.loc 1 16 3
	.loc 1 16 47 is_stmt 0
	li	a4,8
	sw	a4,168(a5)
	.loc 1 15 23 is_stmt 1
.LVL12:
	.loc 1 15 17
.LBE2:
	.loc 1 18 1 is_stmt 0
	ret
	.cfi_endproc
.LFE317:
	.size	tap_write, .-tap_write
	.align	2
	.globl	fir_work
	.type	fir_work, @function
fir_work:
.LFB318:
	.loc 1 20 73 is_stmt 1
	.cfi_startproc
.LVL13:
	.loc 1 21 2
	.loc 1 23 2
	.loc 1 54 2
	.loc 1 54 6 is_stmt 0
	li	a5,805306368
	lw	a3,0(a5)
	.loc 1 54 4
	li	a4,4
	beq	a3,a4,.L10
	.loc 1 55 7 is_stmt 1
	.loc 1 55 41 is_stmt 0
	li	a5,637534208
	li	a4,-1409351680
	sw	a4,12(a5)
.L6:
	.loc 1 56 5 is_stmt 1
	.loc 1 56 39 is_stmt 0
	li	a5,805306368
	sw	zero,64(a5)
	.loc 1 57 5 is_stmt 1
	.loc 1 57 39 is_stmt 0
	li	a4,1
	sw	a4,64(a5)
	.loc 1 58 5 is_stmt 1
	.loc 1 58 39 is_stmt 0
	li	a4,2
	sw	a4,64(a5)
	.loc 1 59 3 is_stmt 1
	.loc 1 59 37 is_stmt 0
	li	a5,637534208
	li	a4,-1421672448
	sw	a4,12(a5)
	.loc 1 60 2 is_stmt 1
.LBB3:
	.loc 1 60 6
.LVL14:
	.loc 1 60 18
	li	a5,3
	ble	a0,a5,.L7
	.loc 1 61 41 is_stmt 0
	li	a4,805306368
	.loc 1 61 38
	li	a2,637534208
.LVL15:
.L8:
	.loc 1 61 4 is_stmt 1 discriminator 3
	.loc 1 61 41 is_stmt 0 discriminator 3
	lw	a3,68(a4)
	.loc 1 61 38 discriminator 3
	sw	a3,12(a2)
	.loc 1 63 4 is_stmt 1 discriminator 3
	.loc 1 63 38 is_stmt 0 discriminator 3
	sw	a5,64(a4)
	.loc 1 60 32 is_stmt 1 discriminator 3
	addi	a5,a5,1
.LVL16:
	.loc 1 60 18 discriminator 3
	bne	a0,a5,.L8
.LVL17:
.L7:
.LBE3:
	.loc 1 65 4
	.loc 1 65 38 is_stmt 0
	li	a5,637534208
	li	a4,-1421410304
	sw	a4,12(a5)
	.loc 1 66 1
	ret
.L10:
	.loc 1 54 47 is_stmt 1 discriminator 1
	.loc 1 54 83 is_stmt 0 discriminator 1
	li	a4,1
	sw	a4,0(a5)
	j	.L6
	.cfi_endproc
.LFE318:
	.size	fir_work, .-fir_work
	.text
.Letext0:
	.file 2 "/opt/riscv/lib/gcc/riscv32-unknown-elf/12.1.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x139
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x8
	.4byte	.LASF15
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL2
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
	.byte	0x9
	.4byte	.LASF16
	.byte	0x2
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
	.byte	0xa
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.byte	0x2
	.4byte	0x6a
	.4byte	0x88
	.byte	0x3
	.4byte	0x71
	.byte	0x1d
	.byte	0
	.byte	0x4
	.4byte	.LASF11
	.byte	0x14
	.4byte	.LFB318
	.4byte	.LFE318-.LFB318
	.byte	0x1
	.byte	0x9c
	.4byte	0xd5
	.byte	0x5
	.4byte	.LASF14
	.byte	0x14
	.byte	0x40
	.4byte	0x6a
	.byte	0x1
	.byte	0x5a
	.byte	0xb
	.string	"a"
	.byte	0x1
	.byte	0x15
	.byte	0x6
	.4byte	0x6a
	.byte	0
	.byte	0xc
	.string	"x"
	.byte	0x1
	.byte	0x17
	.byte	0x6
	.4byte	0x78
	.byte	0x6
	.4byte	.LBB3
	.4byte	.LBE3-.LBB3
	.byte	0x7
	.string	"i"
	.byte	0x3c
	.4byte	0x6a
	.4byte	.LLST1
	.byte	0
	.byte	0
	.byte	0x4
	.4byte	.LASF12
	.byte	0xc
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.byte	0x1
	.byte	0x9c
	.4byte	0x10c
	.byte	0xd
	.4byte	.LASF13
	.byte	0x1
	.byte	0xd
	.byte	0x6
	.4byte	0x10c
	.byte	0x6
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.byte	0x7
	.string	"i"
	.byte	0xf
	.4byte	0x6a
	.4byte	.LLST0
	.byte	0
	.byte	0
	.byte	0x2
	.4byte	0x6a
	.4byte	0x11c
	.byte	0x3
	.4byte	0x71
	.byte	0xa
	.byte	0
	.byte	0xe
	.4byte	.LASF17
	.byte	0x1
	.byte	0x6
	.byte	0x33
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.byte	0x1
	.byte	0x9c
	.byte	0x5
	.4byte	.LASF14
	.byte	0x6
	.byte	0x42
	.4byte	0x6a
	.byte	0x1
	.byte	0x5a
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
	.byte	0x1
	.byte	0x1
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x3
	.byte	0x21
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0xb
	.byte	0
	.byte	0
	.byte	0x4
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x33
	.byte	0x27
	.byte	0x19
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x5
	.byte	0x5
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x6
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0xa
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x8
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
	.byte	0x9
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
	.byte	0xa
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
	.byte	0xb
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
	.byte	0x1c
	.byte	0xb
	.byte	0
	.byte	0
	.byte	0xc
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
	.byte	0xd
	.byte	0x34
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
	.byte	0xe
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
	.byte	0x27
	.byte	0x19
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
	.byte	0
	.section	.debug_loclists,"",@progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LLST1:
	.byte	0x7
	.4byte	.LVL14
	.4byte	.LVL15
	.byte	0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL15
	.4byte	.LVL17
	.byte	0x1
	.byte	0x5f
	.byte	0
.LLST0:
	.byte	0x7
	.4byte	.LVL1
	.4byte	.LVL2
	.byte	0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL2
	.4byte	.LVL3
	.byte	0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL3
	.4byte	.LVL4
	.byte	0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL4
	.4byte	.LVL5
	.byte	0x2
	.byte	0x33
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL5
	.4byte	.LVL6
	.byte	0x2
	.byte	0x34
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL6
	.4byte	.LVL7
	.byte	0x2
	.byte	0x35
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL7
	.4byte	.LVL8
	.byte	0x2
	.byte	0x36
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL8
	.4byte	.LVL9
	.byte	0x2
	.byte	0x37
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL9
	.4byte	.LVL10
	.byte	0x2
	.byte	0x38
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL10
	.4byte	.LVL11
	.byte	0x2
	.byte	0x39
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL11
	.4byte	.LVL12
	.byte	0x2
	.byte	0x3a
	.byte	0x9f
	.byte	0x7
	.4byte	.LVL12
	.4byte	.LFE317
	.byte	0x2
	.byte	0x3b
	.byte	0x9f
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.4byte	.LFB318
	.4byte	.LFE318-.LFB318
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
.LLRL2:
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316
	.byte	0x6
	.4byte	.LFB317
	.4byte	.LFE317
	.byte	0x6
	.4byte	.LFB318
	.4byte	.LFE318
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF14:
	.string	"data_len"
.LASF6:
	.string	"unsigned char"
.LASF8:
	.string	"long unsigned int"
.LASF7:
	.string	"short unsigned int"
.LASF11:
	.string	"fir_work"
.LASF17:
	.string	"config_set"
.LASF10:
	.string	"unsigned int"
.LASF15:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -O3 -ffreestanding"
.LASF9:
	.string	"long long unsigned int"
.LASF5:
	.string	"long long int"
.LASF13:
	.string	"taps"
.LASF3:
	.string	"short int"
.LASF12:
	.string	"tap_write"
.LASF16:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF2:
	.string	"signed char"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir"
.LASF0:
	.string	"fir_control.c"
	.ident	"GCC: (g1ea978e3066) 12.1.0"
