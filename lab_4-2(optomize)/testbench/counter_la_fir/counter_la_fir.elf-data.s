	.file	"data.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir" "data.c"
	.globl	data
	.data
	.align	2
	.type	data, @object
	.size	data, 120
data:
	.word	66280
	.word	-21168
	.word	82307
	.word	-65322
	.word	-62691
	.word	-48793
	.word	3228
	.word	94958
	.word	-63698
	.word	-42053
	.word	32885
	.word	86613
	.word	-95825
	.word	84933
	.word	89576
	.word	35702
	.word	75598
	.word	-949
	.word	-60181
	.word	-89142
	.word	-73195
	.word	83703
	.word	-86019
	.word	-37533
	.word	-45145
	.word	94371
	.word	24754
	.word	-1096
	.word	-90377
	.word	-28889
	.text
.Letext0:
	.file 1 "data.h"
	.file 2 "data.c"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x53
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x1
	.4byte	.LASF3
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.Ldebug_line0
	.byte	0x2
	.4byte	0x35
	.4byte	0x2e
	.byte	0x3
	.4byte	0x2e
	.byte	0x1d
	.byte	0
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.4byte	.LASF2
	.byte	0x5
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x6
	.4byte	.LASF4
	.byte	0x1
	.byte	0x7
	.byte	0xc
	.4byte	0x1e
	.byte	0x7
	.4byte	0x3c
	.byte	0x2
	.byte	0x2
	.byte	0x5
	.byte	0x5
	.byte	0x3
	.4byte	data
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.byte	0x1
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
	.byte	0x10
	.byte	0x17
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
	.byte	0x5
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
	.byte	0x6
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
	.byte	0x3f
	.byte	0x19
	.byte	0x3c
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x34
	.byte	0
	.byte	0x47
	.byte	0x13
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x14
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF3:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -O3 -ffreestanding"
.LASF2:
	.string	"unsigned int"
.LASF4:
	.string	"data"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/ubuntu/caravel-soc_fpga-lab/lab-caravel_fir/testbench/counter_la_fir"
.LASF0:
	.string	"data.c"
	.ident	"GCC: (g1ea978e3066) 12.1.0"
