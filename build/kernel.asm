
build/kernel.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_start>:
    80000000:	30401073          	csrw	mie,zero
    80000004:	f14022f3          	csrr	t0,mhartid
    80000008:	02029663          	bnez	t0,80000034 <halt>
    8000000c:	00010117          	auipc	sp,0x10
    80000010:	35410113          	addi	sp,sp,852 # 80010360 <__kernel_end>
    80000014:	00000297          	auipc	t0,0x0
    80000018:	33f28293          	addi	t0,t0,831 # 80000353 <__bss_end>
    8000001c:	00000317          	auipc	t1,0x0
    80000020:	33730313          	addi	t1,t1,823 # 80000353 <__bss_end>

0000000080000024 <clear_bss>:
    80000024:	00628663          	beq	t0,t1,80000030 <bss_done>
    80000028:	0002b023          	sd	zero,0(t0)
    8000002c:	02a1                	addi	t0,t0,8
    8000002e:	bfdd                	j	80000024 <clear_bss>

0000000080000030 <bss_done>:
    80000030:	0d0000ef          	jal	80000100 <kernel_main>

0000000080000034 <halt>:
    80000034:	10500073          	wfi
    80000038:	bff5                	j	80000034 <halt>

000000008000003a <uart_putc>:
    8000003a:	10000737          	lui	a4,0x10000
    8000003e:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    80000040:	100006b7          	lui	a3,0x10000
    80000044:	00074783          	lbu	a5,0(a4)
    80000048:	0207f793          	andi	a5,a5,32
    8000004c:	dfe5                	beqz	a5,80000044 <uart_putc+0xa>
    8000004e:	00a68023          	sb	a0,0(a3) # 10000000 <_start-0x70000000>
    80000052:	8082                	ret

0000000080000054 <uart_puts>:
    80000054:	00054783          	lbu	a5,0(a0)
    80000058:	c79d                	beqz	a5,80000086 <uart_puts+0x32>
    8000005a:	10000737          	lui	a4,0x10000
    8000005e:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    80000060:	45a9                	li	a1,10
    80000062:	10000637          	lui	a2,0x10000
    80000066:	4835                	li	a6,13
    80000068:	02b78063          	beq	a5,a1,80000088 <uart_puts+0x34>
    8000006c:	00054683          	lbu	a3,0(a0)
    80000070:	0505                	addi	a0,a0,1
    80000072:	00074783          	lbu	a5,0(a4)
    80000076:	0207f793          	andi	a5,a5,32
    8000007a:	dfe5                	beqz	a5,80000072 <uart_puts+0x1e>
    8000007c:	00d60023          	sb	a3,0(a2) # 10000000 <_start-0x70000000>
    80000080:	00054783          	lbu	a5,0(a0)
    80000084:	f3f5                	bnez	a5,80000068 <uart_puts+0x14>
    80000086:	8082                	ret
    80000088:	00074783          	lbu	a5,0(a4)
    8000008c:	0207f793          	andi	a5,a5,32
    80000090:	dfe5                	beqz	a5,80000088 <uart_puts+0x34>
    80000092:	01060023          	sb	a6,0(a2)
    80000096:	bfd9                	j	8000006c <uart_puts+0x18>

0000000080000098 <uart_puthex>:
    80000098:	00000797          	auipc	a5,0x0
    8000009c:	19078793          	addi	a5,a5,400 # 80000228 <kernel_main+0x128>
    800000a0:	6394                	ld	a3,0(a5)
    800000a2:	6798                	ld	a4,8(a5)
    800000a4:	00000797          	auipc	a5,0x0
    800000a8:	1947c783          	lbu	a5,404(a5) # 80000238 <kernel_main+0x138>
    800000ac:	7179                	addi	sp,sp,-48
    800000ae:	f022                	sd	s0,32(sp)
    800000b0:	842a                	mv	s0,a0
    800000b2:	00000517          	auipc	a0,0x0
    800000b6:	16e50513          	addi	a0,a0,366 # 80000220 <kernel_main+0x120>
    800000ba:	e436                	sd	a3,8(sp)
    800000bc:	e83a                	sd	a4,16(sp)
    800000be:	f406                	sd	ra,40(sp)
    800000c0:	00f10c23          	sb	a5,24(sp)
    800000c4:	f91ff0ef          	jal	80000054 <uart_puts>
    800000c8:	10000737          	lui	a4,0x10000
    800000cc:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    800000ce:	03c00693          	li	a3,60
    800000d2:	10000537          	lui	a0,0x10000
    800000d6:	55f1                	li	a1,-4
    800000d8:	00d457b3          	srl	a5,s0,a3
    800000dc:	8bbd                	andi	a5,a5,15
    800000de:	978a                	add	a5,a5,sp
    800000e0:	0087c603          	lbu	a2,8(a5)
    800000e4:	00074783          	lbu	a5,0(a4)
    800000e8:	0207f793          	andi	a5,a5,32
    800000ec:	dfe5                	beqz	a5,800000e4 <uart_puthex+0x4c>
    800000ee:	00c50023          	sb	a2,0(a0) # 10000000 <_start-0x70000000>
    800000f2:	36f1                	addiw	a3,a3,-4
    800000f4:	feb692e3          	bne	a3,a1,800000d8 <uart_puthex+0x40>
    800000f8:	70a2                	ld	ra,40(sp)
    800000fa:	7402                	ld	s0,32(sp)
    800000fc:	6145                	addi	sp,sp,48
    800000fe:	8082                	ret

0000000080000100 <kernel_main>:
    80000100:	1141                	addi	sp,sp,-16
    80000102:	00000517          	auipc	a0,0x0
    80000106:	13e50513          	addi	a0,a0,318 # 80000240 <kernel_main+0x140>
    8000010a:	e406                	sd	ra,8(sp)
    8000010c:	f49ff0ef          	jal	80000054 <uart_puts>
    80000110:	00000517          	auipc	a0,0x0
    80000114:	13850513          	addi	a0,a0,312 # 80000248 <kernel_main+0x148>
    80000118:	f3dff0ef          	jal	80000054 <uart_puts>
    8000011c:	00000517          	auipc	a0,0x0
    80000120:	15450513          	addi	a0,a0,340 # 80000270 <kernel_main+0x170>
    80000124:	f31ff0ef          	jal	80000054 <uart_puts>
    80000128:	00000517          	auipc	a0,0x0
    8000012c:	16850513          	addi	a0,a0,360 # 80000290 <kernel_main+0x190>
    80000130:	f25ff0ef          	jal	80000054 <uart_puts>
    80000134:	00000517          	auipc	a0,0x0
    80000138:	18450513          	addi	a0,a0,388 # 800002b8 <kernel_main+0x1b8>
    8000013c:	f19ff0ef          	jal	80000054 <uart_puts>
    80000140:	00000517          	auipc	a0,0x0
    80000144:	19050513          	addi	a0,a0,400 # 800002d0 <kernel_main+0x1d0>
    80000148:	f0dff0ef          	jal	80000054 <uart_puts>
    8000014c:	f1402573          	csrr	a0,mhartid
    80000150:	f49ff0ef          	jal	80000098 <uart_puthex>
    80000154:	10000737          	lui	a4,0x10000
    80000158:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    8000015a:	100006b7          	lui	a3,0x10000
    8000015e:	00074783          	lbu	a5,0(a4)
    80000162:	0207f793          	andi	a5,a5,32
    80000166:	dfe5                	beqz	a5,8000015e <kernel_main+0x5e>
    80000168:	47a9                	li	a5,10
    8000016a:	00f68023          	sb	a5,0(a3) # 10000000 <_start-0x70000000>
    8000016e:	00000517          	auipc	a0,0x0
    80000172:	17250513          	addi	a0,a0,370 # 800002e0 <kernel_main+0x1e0>
    80000176:	edfff0ef          	jal	80000054 <uart_puts>
    8000017a:	30002573          	csrr	a0,mstatus
    8000017e:	f1bff0ef          	jal	80000098 <uart_puthex>
    80000182:	10000737          	lui	a4,0x10000
    80000186:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    80000188:	100006b7          	lui	a3,0x10000
    8000018c:	00074783          	lbu	a5,0(a4)
    80000190:	0207f793          	andi	a5,a5,32
    80000194:	dfe5                	beqz	a5,8000018c <kernel_main+0x8c>
    80000196:	47a9                	li	a5,10
    80000198:	00f68023          	sb	a5,0(a3) # 10000000 <_start-0x70000000>
    8000019c:	00000517          	auipc	a0,0x0
    800001a0:	15c50513          	addi	a0,a0,348 # 800002f8 <kernel_main+0x1f8>
    800001a4:	eb1ff0ef          	jal	80000054 <uart_puts>
    800001a8:	10000537          	lui	a0,0x10000
    800001ac:	eedff0ef          	jal	80000098 <uart_puthex>
    800001b0:	10000737          	lui	a4,0x10000
    800001b4:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    800001b6:	100006b7          	lui	a3,0x10000
    800001ba:	00074783          	lbu	a5,0(a4)
    800001be:	0207f793          	andi	a5,a5,32
    800001c2:	dfe5                	beqz	a5,800001ba <kernel_main+0xba>
    800001c4:	47a9                	li	a5,10
    800001c6:	00f68023          	sb	a5,0(a3) # 10000000 <_start-0x70000000>
    800001ca:	00000517          	auipc	a0,0x0
    800001ce:	13e50513          	addi	a0,a0,318 # 80000308 <kernel_main+0x208>
    800001d2:	e83ff0ef          	jal	80000054 <uart_puts>
    800001d6:	4505                	li	a0,1
    800001d8:	057e                	slli	a0,a0,0x1f
    800001da:	ebfff0ef          	jal	80000098 <uart_puthex>
    800001de:	10000737          	lui	a4,0x10000
    800001e2:	0715                	addi	a4,a4,5 # 10000005 <_start-0x6ffffffb>
    800001e4:	100006b7          	lui	a3,0x10000
    800001e8:	00074783          	lbu	a5,0(a4)
    800001ec:	0207f793          	andi	a5,a5,32
    800001f0:	dfe5                	beqz	a5,800001e8 <kernel_main+0xe8>
    800001f2:	47a9                	li	a5,10
    800001f4:	00000517          	auipc	a0,0x0
    800001f8:	12450513          	addi	a0,a0,292 # 80000318 <kernel_main+0x218>
    800001fc:	00f68023          	sb	a5,0(a3) # 10000000 <_start-0x70000000>
    80000200:	e55ff0ef          	jal	80000054 <uart_puts>
    80000204:	00000517          	auipc	a0,0x0
    80000208:	13450513          	addi	a0,a0,308 # 80000338 <kernel_main+0x238>
    8000020c:	e49ff0ef          	jal	80000054 <uart_puts>
    80000210:	10500073          	wfi
    80000214:	10500073          	wfi
    80000218:	bfe5                	j	80000210 <kernel_main+0x110>

Disassembly of section .rodata:

0000000080000220 <__bss_end-0x133>:
    80000220:	7830                	ld	a2,112(s0)
    80000222:	0000                	unimp
    80000224:	0000                	unimp
    80000226:	0000                	unimp
    80000228:	3130                	fld	fa2,96(a0)
    8000022a:	3332                	fld	ft6,296(sp)
    8000022c:	3534                	fld	fa3,104(a0)
    8000022e:	3736                	fld	fa4,360(sp)
    80000230:	3938                	fld	fa4,112(a0)
    80000232:	4241                	li	tp,16
    80000234:	46454443          	.insn	4, 0x46454443
	...
    80000240:	4a325b1b          	.insn	4, 0x4a325b1b
    80000244:	00485b1b          	srliw	s6,a6,0x4
    80000248:	3d3d                	addiw	s10,s10,-17
    8000024a:	3d3d                	addiw	s10,s10,-17
    8000024c:	3d3d                	addiw	s10,s10,-17
    8000024e:	3d3d                	addiw	s10,s10,-17
    80000250:	3d3d                	addiw	s10,s10,-17
    80000252:	3d3d                	addiw	s10,s10,-17
    80000254:	3d3d                	addiw	s10,s10,-17
    80000256:	3d3d                	addiw	s10,s10,-17
    80000258:	3d3d                	addiw	s10,s10,-17
    8000025a:	3d3d                	addiw	s10,s10,-17
    8000025c:	3d3d                	addiw	s10,s10,-17
    8000025e:	3d3d                	addiw	s10,s10,-17
    80000260:	3d3d                	addiw	s10,s10,-17
    80000262:	3d3d                	addiw	s10,s10,-17
    80000264:	3d3d                	addiw	s10,s10,-17
    80000266:	3d3d                	addiw	s10,s10,-17
    80000268:	3d3d                	addiw	s10,s10,-17
    8000026a:	3d3d                	addiw	s10,s10,-17
    8000026c:	000a                	c.slli	zero,0x2
    8000026e:	0000                	unimp
    80000270:	2020                	fld	fs0,64(s0)
    80000272:	696d                	lui	s2,0x1b
    80000274:	7a62                	ld	s4,56(sp)
    80000276:	2d20534f          	.insn	4, 0x2d20534f
    8000027a:	5220                	lw	s0,96(a2)
    8000027c:	5349                	li	t1,-14
    8000027e:	20562d43          	fmadd.s	fs10,fa2,ft5,ft4,rdn
    80000282:	6e72654b          	.insn	4, 0x6e72654b
    80000286:	6c65                	lui	s8,0x19
    80000288:	7620                	ld	s0,104(a2)
    8000028a:	2e30                	fld	fa2,88(a2)
    8000028c:	0a31                	addi	s4,s4,12
    8000028e:	0000                	unimp
    80000290:	3d3d                	addiw	s10,s10,-17
    80000292:	3d3d                	addiw	s10,s10,-17
    80000294:	3d3d                	addiw	s10,s10,-17
    80000296:	3d3d                	addiw	s10,s10,-17
    80000298:	3d3d                	addiw	s10,s10,-17
    8000029a:	3d3d                	addiw	s10,s10,-17
    8000029c:	3d3d                	addiw	s10,s10,-17
    8000029e:	3d3d                	addiw	s10,s10,-17
    800002a0:	3d3d                	addiw	s10,s10,-17
    800002a2:	3d3d                	addiw	s10,s10,-17
    800002a4:	3d3d                	addiw	s10,s10,-17
    800002a6:	3d3d                	addiw	s10,s10,-17
    800002a8:	3d3d                	addiw	s10,s10,-17
    800002aa:	3d3d                	addiw	s10,s10,-17
    800002ac:	3d3d                	addiw	s10,s10,-17
    800002ae:	3d3d                	addiw	s10,s10,-17
    800002b0:	3d3d                	addiw	s10,s10,-17
    800002b2:	3d3d                	addiw	s10,s10,-17
    800002b4:	0a0a                	slli	s4,s4,0x2
    800002b6:	0000                	unimp
    800002b8:	6f42                	ld	t5,16(sp)
    800002ba:	4920746f          	jal	s0,8000774c <__stack_bottom+0x73ec>
    800002be:	666e                	ld	a2,216(sp)
    800002c0:	616d726f          	jal	tp,800d78d6 <__kernel_end+0xc7576>
    800002c4:	6974                	ld	a3,208(a0)
    800002c6:	0a3a6e6f          	jal	t3,800a6b68 <__kernel_end+0x96808>
    800002ca:	0000                	unimp
    800002cc:	0000                	unimp
    800002ce:	0000                	unimp
    800002d0:	2020                	fld	fs0,64(s0)
    800002d2:	6148                	ld	a0,128(a0)
    800002d4:	7472                	ld	s0,312(sp)
    800002d6:	4920                	lw	s0,80(a0)
    800002d8:	3a44                	fld	fs1,176(a2)
    800002da:	2020                	fld	fs0,64(s0)
    800002dc:	2020                	fld	fs0,64(s0)
    800002de:	0020                	addi	s0,sp,8
    800002e0:	2020                	fld	fs0,64(s0)
    800002e2:	614d                	addi	sp,sp,176
    800002e4:	6e696863          	bltu	s2,t1,800009d4 <__stack_bottom+0x674>
    800002e8:	2065                	.insn	2, 0x2065
    800002ea:	74617453          	.insn	4, 0x74617453
    800002ee:	7375                	lui	t1,0xffffd
    800002f0:	203a                	fld	ft0,392(sp)
    800002f2:	0000                	unimp
    800002f4:	0000                	unimp
    800002f6:	0000                	unimp
    800002f8:	2020                	fld	fs0,64(s0)
    800002fa:	4155                	li	sp,21
    800002fc:	5452                	lw	s0,52(sp)
    800002fe:	4220                	lw	s0,64(a2)
    80000300:	7361                	lui	t1,0xffff8
    80000302:	3a65                	addiw	s4,s4,-7
    80000304:	2020                	fld	fs0,64(s0)
    80000306:	0020                	addi	s0,sp,8
    80000308:	2020                	fld	fs0,64(s0)
    8000030a:	4152                	lw	sp,20(sp)
    8000030c:	204d                	.insn	2, 0x204d
    8000030e:	72617453          	.insn	4, 0x72617453
    80000312:	3a74                	fld	fa3,240(a2)
    80000314:	2020                	fld	fs0,64(s0)
    80000316:	0020                	addi	s0,sp,8
    80000318:	4b0a                	lw	s6,128(sp)
    8000031a:	7265                	lui	tp,0xffff9
    8000031c:	656e                	ld	a0,216(sp)
    8000031e:	206c                	fld	fa1,192(s0)
    80000320:	2f49                	addiw	t5,t5,18
    80000322:	6574204f          	.insn	4, 0x6574204f
    80000326:	63207473          	csrrci	s0,0x632,0
    8000032a:	6c706d6f          	jal	s10,800071f0 <__stack_bottom+0x6e90>
    8000032e:	7465                	lui	s0,0xffff9
    80000330:	2165                	addiw	sp,sp,25
    80000332:	000a                	c.slli	zero,0x2
    80000334:	0000                	unimp
    80000336:	0000                	unimp
    80000338:	6e72654b          	.insn	4, 0x6e72654b
    8000033c:	6c65                	lui	s8,0x19
    8000033e:	6920                	ld	s0,80(a0)
    80000340:	6f6e2073          	csrs	0x6f6,t3
    80000344:	61682077          	.insn	4, 0x61682077
    80000348:	746c                	ld	a1,232(s0)
    8000034a:	6e69                	lui	t3,0x1a
    8000034c:	2e2e2e67          	.insn	4, 0x2e2e2e67
    80000350:	0a0a                	slli	s4,s4,0x2
	...

Disassembly of section .riscv.attributes:

0000000000000000 <.riscv.attributes>:
   0:	7741                	lui	a4,0xffff0
   2:	0000                	unimp
   4:	7200                	ld	s0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <_start-0x7fffffec>
   c:	006d                	c.nop	27
   e:	0000                	unimp
  10:	1004                	addi	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3676                	fld	fa2,376(sp)
  16:	6934                	ld	a3,80(a0)
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	li	t5,-20
  1c:	326d                	addiw	tp,tp,-5 # fffffffffffe0ffb <__kernel_end+0xffffffff7ffd0c9b>
  1e:	3070                	fld	fa2,224(s0)
  20:	615f 7032 5f31      	.insn	6, 0x5f317032615f
  26:	3266                	fld	ft4,120(sp)
  28:	3270                	fld	fa2,224(a2)
  2a:	645f 7032 5f32      	.insn	6, 0x5f327032645f
  30:	30703263          	.insn	4, 0x30703263
  34:	7a5f 6369 7273      	.insn	6, 0x727363697a5f
  3a:	7032                	.insn	2, 0x7032
  3c:	5f30                	lw	a2,120(a4)
  3e:	697a                	ld	s2,408(sp)
  40:	6566                	ld	a0,88(sp)
  42:	636e                	ld	t1,216(sp)
  44:	6965                	lui	s2,0x19
  46:	7032                	.insn	2, 0x7032
  48:	5f30                	lw	a2,120(a4)
  4a:	6d7a                	ld	s10,408(sp)
  4c:	756d                	lui	a0,0xffffb
  4e:	316c                	fld	fa1,224(a0)
  50:	3070                	fld	fa2,224(s0)
  52:	7a5f 6161 6f6d      	.insn	6, 0x6f6d61617a5f
  58:	7031                	c.lui	zero,0xfffec
  5a:	5f30                	lw	a2,120(a4)
  5c:	617a                	ld	sp,408(sp)
  5e:	726c                	ld	a1,224(a2)
  60:	70316373          	csrrsi	t1,0x703,2
  64:	5f30                	lw	a2,120(a4)
  66:	637a                	ld	t1,408(sp)
  68:	3161                	addiw	sp,sp,-8
  6a:	3070                	fld	fa2,224(s0)
  6c:	7a5f 6463 7031      	.insn	6, 0x703164637a5f
  72:	0030                	addi	a2,sp,8
  74:	0108                	addi	a0,sp,128
  76:	0b0a                	slli	s6,s6,0x2

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	33623167          	.insn	4, 0x33623167
   a:	3630                	fld	fa2,104(a2)
   c:	3330                	fld	fa2,96(a4)
   e:	6139                	addi	sp,sp,448
  10:	2029                	.insn	2, 0x2029
  12:	3531                	addiw	a0,a0,-20 # ffffffffffffafec <__kernel_end+0xffffffff7ffeac8c>
  14:	312e                	fld	ft2,232(sp)
  16:	302e                	fld	ft0,232(sp)
	...

Disassembly of section .debug_line:

0000000000000000 <.debug_line>:
   0:	0092                	slli	ra,ra,0x4
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0008                	.insn	2, 0x0008
   8:	002e                	c.slli	zero,0xb
   a:	0000                	unimp
   c:	0101                	addi	sp,sp,0
   e:	fb01                	bnez	a4,ffffffffffffff1e <__kernel_end+0xffffffff7ffefbbe>
  10:	0d0e                	slli	s10,s10,0x3
  12:	0100                	addi	s0,sp,128
  14:	0101                	addi	sp,sp,0
  16:	0001                	nop
  18:	0000                	unimp
  1a:	0001                	nop
  1c:	0100                	addi	s0,sp,128
  1e:	0101                	addi	sp,sp,0
  20:	021f 0000 0000      	.insn	6, 0x021f
  26:	001e                	c.slli	zero,0x7
  28:	0000                	unimp
  2a:	0102                	c.slli64	sp
  2c:	021f 020f 0022      	.insn	6, 0x0022020f021f
  32:	0000                	unimp
  34:	2201                	sext.w	tp,tp
  36:	0000                	unimp
  38:	0100                	addi	s0,sp,128
  3a:	0900                	addi	s0,sp,144
  3c:	0002                	c.slli64	zero
  3e:	0000                	unimp
  40:	0080                	addi	s0,sp,64
  42:	0000                	unimp
  44:	0300                	addi	s0,sp,384
  46:	010c                	addi	a1,sp,128
  48:	04090603          	lb	a2,64(s2) # 19040 <_start-0x7ffe6fc0>
  4c:	0100                	addi	s0,sp,128
  4e:	04090103          	lb	sp,64(s2)
  52:	0100                	addi	s0,sp,128
  54:	04090603          	lb	a2,64(s2)
  58:	0100                	addi	s0,sp,128
  5a:	08090603          	lb	a2,128(s2)
  5e:	0100                	addi	s0,sp,128
  60:	08090103          	lb	sp,128(s2)
  64:	0100                	addi	s0,sp,128
  66:	08090203          	lb	tp,128(s2)
  6a:	0100                	addi	s0,sp,128
  6c:	04090103          	lb	sp,64(s2)
  70:	0100                	addi	s0,sp,128
  72:	04090103          	lb	sp,64(s2)
  76:	0100                	addi	s0,sp,128
  78:	02090103          	lb	sp,32(s2)
  7c:	0100                	addi	s0,sp,128
  7e:	02090703          	lb	a4,32(s2)
  82:	0100                	addi	s0,sp,128
  84:	04090403          	lb	s0,64(s2)
  88:	0100                	addi	s0,sp,128
  8a:	04090103          	lb	sp,64(s2)
  8e:	0100                	addi	s0,sp,128
  90:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
  92:	0000                	unimp
  94:	0101                	addi	sp,sp,0
  96:	0622                	slli	a2,a2,0x8
  98:	0000                	unimp
  9a:	0005                	c.nop	1
  9c:	0008                	.insn	2, 0x0008
  9e:	00000037          	lui	zero,0x0
  a2:	0101                	addi	sp,sp,0
  a4:	f601                	bnez	a2,ffffffffffffffac <__kernel_end+0xffffffff7ffefc4c>
  a6:	0df2                	slli	s11,s11,0x1c
  a8:	0100                	addi	s0,sp,128
  aa:	0101                	addi	sp,sp,0
  ac:	0001                	nop
  ae:	0000                	unimp
  b0:	0001                	nop
  b2:	0100                	addi	s0,sp,128
  b4:	0101                	addi	sp,sp,0
  b6:	031f 0000 0000      	.insn	6, 0x031f
  bc:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
  c0:	001e                	c.slli	zero,0x7
  c2:	0000                	unimp
  c4:	0102                	c.slli64	sp
  c6:	021f 030b 0029      	.insn	6, 0x0029030b021f
  cc:	0000                	unimp
  ce:	2d00                	fld	fs0,24(a0)
  d0:	0000                	unimp
  d2:	0200                	addi	s0,sp,256
  d4:	0036                	c.slli	zero,0xd
  d6:	0000                	unimp
  d8:	0001                	nop
  da:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
  dc:	003a                	c.slli	zero,0xe
  de:	8000                	.insn	2, 0x8000
  e0:	0000                	unimp
  e2:	0000                	unimp
  e4:	0549                	addi	a0,a0,18
  e6:	0918                	addi	a4,sp,144
  e8:	0000                	unimp
  ea:	051e                	slli	a0,a0,0x7
  ec:	0905                	addi	s2,s2,1
  ee:	0000                	unimp
  f0:	0306                	slli	t1,t1,0x1
  f2:	0169                	addi	sp,sp,26
  f4:	0c05                	addi	s8,s8,1 # 19001 <_start-0x7ffe6fff>
  f6:	0a09                	addi	s4,s4,2
  f8:	0600                	addi	s0,sp,768
  fa:	0530                	addi	a2,sp,648
  fc:	0905                	addi	s2,s2,1
  fe:	0000                	unimp
 100:	0200                	addi	s0,sp,256
 102:	0204                	addi	s1,sp,256
 104:	0515                	addi	a0,a0,5
 106:	092c                	addi	a1,sp,152
 108:	0000                	unimp
 10a:	0200                	addi	s0,sp,256
 10c:	0004                	.insn	2, 0x0004
 10e:	05016803          	lwu	a6,80(sp)
 112:	00000917          	auipc	s2,0x0
 116:	0518                	addi	a4,sp,640
 118:	0905                	addi	s2,s2,1 # 113 <_start-0x7ffffeed>
 11a:	0000                	unimp
 11c:	0106                	slli	sp,sp,0x1
 11e:	0c05                	addi	s8,s8,1
 120:	0409                	addi	s0,s0,2 # ffffffffffff9002 <__kernel_end+0xffffffff7ffe8ca2>
 122:	0000                	unimp
 124:	0402                	c.slli64	s0
 126:	2e02                	fld	ft8,0(sp)
 128:	2c05                	addiw	s8,s8,1
 12a:	0609                	addi	a2,a2,2
 12c:	0000                	unimp
 12e:	0402                	c.slli64	s0
 130:	0600                	addi	s0,sp,768
 132:	051c                	addi	a5,sp,640
 134:	0905                	addi	s2,s2,1
 136:	0000                	unimp
 138:	05016a03          	lwu	s4,80(sp)
 13c:	0914                	addi	a3,sp,144
 13e:	0000                	unimp
 140:	0518                	addi	a4,sp,640
 142:	0905                	addi	s2,s2,1
 144:	0000                	unimp
 146:	0106                	slli	sp,sp,0x1
 148:	1f05                	addi	t5,t5,-31
 14a:	0409                	addi	s0,s0,2
 14c:	0100                	addi	s0,sp,128
 14e:	1f05                	addi	t5,t5,-31
 150:	0009                	c.nop	2
 152:	2d00                	fld	fs0,24(a0)
 154:	0105                	addi	sp,sp,1
 156:	0900                	addi	s0,sp,144
 158:	5402                	lw	s0,32(sp)
 15a:	0000                	unimp
 15c:	0080                	addi	s0,sp,64
 15e:	0000                	unimp
 160:	0600                	addi	s0,sp,768
 162:	051c                	addi	a5,sp,640
 164:	091f 0000 0518      	.insn	6, 0x05180000091f
 16a:	0905                	addi	s2,s2,1
 16c:	0000                	unimp
 16e:	0501                	addi	a0,a0,0
 170:	090c                	addi	a1,sp,144
 172:	0006                	c.slli	zero,0x1
 174:	0306                	slli	t1,t1,0x1
 176:	015d                	addi	sp,sp,23
 178:	0c05                	addi	s8,s8,1
 17a:	0609                	addi	a2,a2,2
 17c:	3c00                	fld	fs0,56(s0)
 17e:	0c05                	addi	s8,s8,1
 180:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 182:	0300                	addi	s0,sp,384
 184:	0c05015b          	.insn	4, 0x0c05015b
 188:	0409                	addi	s0,s0,2
 18a:	1e00                	addi	s0,sp,816
 18c:	1f05                	addi	t5,t5,-31
 18e:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 190:	0100                	addi	s0,sp,128
 192:	1f05                	addi	t5,t5,-31
 194:	0009                	c.nop	2
 196:	0600                	addi	s0,sp,768
 198:	0535                	addi	a0,a0,13
 19a:	0909                	addi	s2,s2,2
 19c:	0000                	unimp
 19e:	0106                	slli	sp,sp,0x1
 1a0:	0c05                	addi	s8,s8,1
 1a2:	0409                	addi	s0,s0,2
 1a4:	0600                	addi	s0,sp,768
 1a6:	051a                	slli	a0,a0,0x6
 1a8:	0909                	addi	s2,s2,2
 1aa:	0004                	.insn	2, 0x0004
 1ac:	0106                	slli	sp,sp,0x1
 1ae:	1505                	addi	a0,a0,-31
 1b0:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 1b2:	0600                	addi	s0,sp,768
 1b4:	05016803          	lwu	a6,80(sp)
 1b8:	0906                	slli	s2,s2,0x1
 1ba:	0000                	unimp
 1bc:	051e                	slli	a0,a0,0x7
 1be:	0905                	addi	s2,s2,1
 1c0:	0000                	unimp
 1c2:	0519                	addi	a0,a0,6
 1c4:	0905                	addi	s2,s2,1
 1c6:	0000                	unimp
 1c8:	0200                	addi	s0,sp,256
 1ca:	0204                	addi	s1,sp,256
 1cc:	0515                	addi	a0,a0,5
 1ce:	092c                	addi	a1,sp,152
 1d0:	0000                	unimp
 1d2:	0200                	addi	s0,sp,256
 1d4:	0004                	.insn	2, 0x0004
 1d6:	05016803          	lwu	a6,80(sp)
 1da:	00000917          	auipc	s2,0x0
 1de:	0518                	addi	a4,sp,640
 1e0:	0905                	addi	s2,s2,1 # 1db <_start-0x7ffffe25>
 1e2:	0000                	unimp
 1e4:	0106                	slli	sp,sp,0x1
 1e6:	0c05                	addi	s8,s8,1
 1e8:	0409                	addi	s0,s0,2
 1ea:	0000                	unimp
 1ec:	0402                	c.slli64	s0
 1ee:	2e02                	fld	ft8,0(sp)
 1f0:	2c05                	addiw	s8,s8,1
 1f2:	0609                	addi	a2,a2,2
 1f4:	0000                	unimp
 1f6:	0402                	c.slli64	s0
 1f8:	0600                	addi	s0,sp,768
 1fa:	051c                	addi	a5,sp,640
 1fc:	0905                	addi	s2,s2,1
 1fe:	0000                	unimp
 200:	05016a03          	lwu	s4,80(sp)
 204:	0914                	addi	a3,sp,144
 206:	0000                	unimp
 208:	0518                	addi	a4,sp,640
 20a:	0905                	addi	s2,s2,1
 20c:	0000                	unimp
 20e:	0106                	slli	sp,sp,0x1
 210:	1f05                	addi	t5,t5,-31
 212:	0409                	addi	s0,s0,2
 214:	0100                	addi	s0,sp,128
 216:	1f05                	addi	t5,t5,-31
 218:	0009                	c.nop	2
 21a:	0600                	addi	s0,sp,768
 21c:	090c0533          	.insn	4, 0x090c0533
 220:	0006                	c.slli	zero,0x1
 222:	1e06                	slli	t3,t3,0x21
 224:	0105                	addi	sp,sp,1
 226:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 228:	0600                	addi	s0,sp,768
 22a:	05016f03          	lwu	t5,80(sp)
 22e:	0905                	addi	s2,s2,1
 230:	0000                	unimp
 232:	0200                	addi	s0,sp,256
 234:	0204                	addi	s1,sp,256
 236:	0515                	addi	a0,a0,5
 238:	092c                	addi	a1,sp,152
 23a:	0000                	unimp
 23c:	0200                	addi	s0,sp,256
 23e:	0004                	.insn	2, 0x0004
 240:	05016803          	lwu	a6,80(sp)
 244:	00000917          	auipc	s2,0x0
 248:	0518                	addi	a4,sp,640
 24a:	0905                	addi	s2,s2,1 # 245 <_start-0x7ffffdbb>
 24c:	0000                	unimp
 24e:	0106                	slli	sp,sp,0x1
 250:	0c05                	addi	s8,s8,1
 252:	0409                	addi	s0,s0,2
 254:	0000                	unimp
 256:	0402                	c.slli64	s0
 258:	2e02                	fld	ft8,0(sp)
 25a:	2c05                	addiw	s8,s8,1
 25c:	0609                	addi	a2,a2,2
 25e:	0000                	unimp
 260:	0402                	c.slli64	s0
 262:	0600                	addi	s0,sp,768
 264:	051c                	addi	a5,sp,640
 266:	0905                	addi	s2,s2,1
 268:	0000                	unimp
 26a:	05016a03          	lwu	s4,80(sp)
 26e:	0914                	addi	a3,sp,144
 270:	0000                	unimp
 272:	0518                	addi	a4,sp,640
 274:	0905                	addi	s2,s2,1
 276:	0000                	unimp
 278:	0106                	slli	sp,sp,0x1
 27a:	1f05                	addi	t5,t5,-31
 27c:	0409                	addi	s0,s0,2
 27e:	0100                	addi	s0,sp,128
 280:	1f05                	addi	t5,t5,-31
 282:	0009                	c.nop	2
 284:	2d00                	fld	fs0,24(a0)
 286:	0105                	addi	sp,sp,1
 288:	0900                	addi	s0,sp,144
 28a:	9802                	jalr	a6
 28c:	0000                	unimp
 28e:	0080                	addi	s0,sp,64
 290:	0000                	unimp
 292:	0600                	addi	s0,sp,768
 294:	0922052b          	.insn	4, 0x0922052b
 298:	0000                	unimp
 29a:	0518                	addi	a4,sp,640
 29c:	0905                	addi	s2,s2,1
 29e:	0000                	unimp
 2a0:	0106                	slli	sp,sp,0x1
 2a2:	1005                	c.nop	-31
 2a4:	1409                	addi	s0,s0,-30
 2a6:	1600                	addi	s0,sp,800
 2a8:	2205                	addiw	tp,tp,1 # 1 <_start-0x7fffffff>
 2aa:	0609                	addi	a2,a2,2
 2ac:	1900                	addi	s0,sp,176
 2ae:	0505                	addi	a0,a0,1
 2b0:	0809                	addi	a6,a6,2
 2b2:	1600                	addi	s0,sp,800
 2b4:	1005                	c.nop	-31
 2b6:	0409                	addi	s0,s0,2
 2b8:	1600                	addi	s0,sp,800
 2ba:	2205                	addiw	tp,tp,1 # 1 <_start-0x7fffffff>
 2bc:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 2be:	1800                	addi	s0,sp,48
 2c0:	1005                	c.nop	-31
 2c2:	0409                	addi	s0,s0,2
 2c4:	0600                	addi	s0,sp,768
 2c6:	0518                	addi	a4,sp,640
 2c8:	0905                	addi	s2,s2,1
 2ca:	0004                	.insn	2, 0x0004
 2cc:	051a                	slli	a0,a0,0x6
 2ce:	0905                	addi	s2,s2,1
 2d0:	0000                	unimp
 2d2:	0501                	addi	a0,a0,0
 2d4:	090a                	slli	s2,s2,0x2
 2d6:	0000                	unimp
 2d8:	0200                	addi	s0,sp,256
 2da:	0104                	addi	s1,sp,128
 2dc:	0501                	addi	a0,a0,0
 2de:	0918                	addi	a4,sp,144
 2e0:	0000                	unimp
 2e2:	0200                	addi	s0,sp,256
 2e4:	0004                	.insn	2, 0x0004
 2e6:	0306                	slli	t1,t1,0x1
 2e8:	014a                	slli	sp,sp,0x12
 2ea:	0c05                	addi	s8,s8,1
 2ec:	0609                	addi	a2,a2,2
 2ee:	4d00                	lw	s0,24(a0)
 2f0:	0e05                	addi	t3,t3,1 # 1a001 <_start-0x7ffe5fff>
 2f2:	0409                	addi	s0,s0,2
 2f4:	0300                	addi	s0,sp,384
 2f6:	014a                	slli	sp,sp,0x12
 2f8:	0c05                	addi	s8,s8,1
 2fa:	0409                	addi	s0,s0,2
 2fc:	0000                	unimp
 2fe:	0402                	c.slli64	s0
 300:	4d01                	li	s10,0
 302:	1805                	addi	a6,a6,-31
 304:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 306:	0000                	unimp
 308:	0402                	c.slli64	s0
 30a:	0600                	addi	s0,sp,768
 30c:	0518                	addi	a4,sp,640
 30e:	0909                	addi	s2,s2,2
 310:	0000                	unimp
 312:	0106                	slli	sp,sp,0x1
 314:	1e05                	addi	t3,t3,-31
 316:	0409                	addi	s0,s0,2
 318:	0100                	addi	s0,sp,128
 31a:	2405                	addiw	s0,s0,1
 31c:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 31e:	0100                	addi	s0,sp,128
 320:	1605                	addi	a2,a2,-31
 322:	0609                	addi	a2,a2,2
 324:	0600                	addi	s0,sp,768
 326:	05015903          	lhu	s2,80(sp)
 32a:	0906                	slli	s2,s2,0x1
 32c:	0000                	unimp
 32e:	051e                	slli	a0,a0,0x7
 330:	0905                	addi	s2,s2,1
 332:	0000                	unimp
 334:	0519                	addi	a0,a0,6
 336:	0905                	addi	s2,s2,1
 338:	0000                	unimp
 33a:	0200                	addi	s0,sp,256
 33c:	0204                	addi	s1,sp,256
 33e:	0515                	addi	a0,a0,5
 340:	092c                	addi	a1,sp,152
 342:	0000                	unimp
 344:	0200                	addi	s0,sp,256
 346:	0004                	.insn	2, 0x0004
 348:	05016803          	lwu	a6,80(sp)
 34c:	00000917          	auipc	s2,0x0
 350:	0518                	addi	a4,sp,640
 352:	0905                	addi	s2,s2,1 # 34d <_start-0x7ffffcb3>
 354:	0000                	unimp
 356:	0106                	slli	sp,sp,0x1
 358:	0c05                	addi	s8,s8,1
 35a:	0409                	addi	s0,s0,2
 35c:	0000                	unimp
 35e:	0402                	c.slli64	s0
 360:	2e02                	fld	ft8,0(sp)
 362:	2c05                	addiw	s8,s8,1
 364:	0609                	addi	a2,a2,2
 366:	0000                	unimp
 368:	0402                	c.slli64	s0
 36a:	0600                	addi	s0,sp,768
 36c:	051c                	addi	a5,sp,640
 36e:	0905                	addi	s2,s2,1
 370:	0000                	unimp
 372:	05016a03          	lwu	s4,80(sp)
 376:	0914                	addi	a3,sp,144
 378:	0000                	unimp
 37a:	0518                	addi	a4,sp,640
 37c:	0905                	addi	s2,s2,1
 37e:	0000                	unimp
 380:	0106                	slli	sp,sp,0x1
 382:	1f05                	addi	t5,t5,-31
 384:	0409                	addi	s0,s0,2
 386:	0100                	addi	s0,sp,128
 388:	1f05                	addi	t5,t5,-31
 38a:	0009                	c.nop	2
 38c:	0000                	unimp
 38e:	0402                	c.slli64	s0
 390:	05460603          	lb	a2,84(a2)
 394:	0920                	addi	s0,sp,152
 396:	0002                	c.slli64	zero
 398:	0200                	addi	s0,sp,256
 39a:	0104                	addi	s1,sp,128
 39c:	0501                	addi	a0,a0,0
 39e:	0918                	addi	a4,sp,144
 3a0:	0004                	.insn	2, 0x0004
 3a2:	0200                	addi	s0,sp,256
 3a4:	0004                	.insn	2, 0x0004
 3a6:	1a06                	slli	s4,s4,0x21
 3a8:	0105                	addi	sp,sp,1
 3aa:	0409                	addi	s0,s0,2
 3ac:	0100                	addi	s0,sp,128
 3ae:	0105                	addi	sp,sp,1
 3b0:	0900                	addi	s0,sp,144
 3b2:	0002                	c.slli64	zero
 3b4:	0001                	nop
 3b6:	0080                	addi	s0,sp,64
 3b8:	0000                	unimp
 3ba:	0600                	addi	s0,sp,768
 3bc:	0531                	addi	a0,a0,12
 3be:	0918                	addi	a4,sp,144
 3c0:	0000                	unimp
 3c2:	0519                	addi	a0,a0,6
 3c4:	0905                	addi	s2,s2,1
 3c6:	0000                	unimp
 3c8:	1506                	slli	a0,a0,0x21
 3ca:	1805                	addi	a6,a6,-31
 3cc:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 3ce:	1900                	addi	s0,sp,176
 3d0:	0505                	addi	a0,a0,1
 3d2:	0809                	addi	a6,a6,2
 3d4:	1500                	addi	s0,sp,672
 3d6:	1805                	addi	a6,a6,-31
 3d8:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 3da:	1900                	addi	s0,sp,176
 3dc:	0505                	addi	a0,a0,1
 3de:	0409                	addi	s0,s0,2
 3e0:	0600                	addi	s0,sp,768
 3e2:	0518                	addi	a4,sp,640
 3e4:	0905                	addi	s2,s2,1
 3e6:	000c                	.insn	2, 0x000c
 3e8:	0518                	addi	a4,sp,640
 3ea:	0905                	addi	s2,s2,1
 3ec:	000c                	.insn	2, 0x000c
 3ee:	0518                	addi	a4,sp,640
 3f0:	0905                	addi	s2,s2,1
 3f2:	000c                	.insn	2, 0x000c
 3f4:	051a                	slli	a0,a0,0x6
 3f6:	0905                	addi	s2,s2,1
 3f8:	000c                	.insn	2, 0x000c
 3fa:	0519                	addi	a0,a0,6
 3fc:	0905                	addi	s2,s2,1
 3fe:	000c                	.insn	2, 0x000c
 400:	0518                	addi	a4,sp,640
 402:	0905                	addi	s2,s2,1
 404:	0000                	unimp
 406:	05016303          	lwu	t1,80(sp)
 40a:	0918                	addi	a4,sp,144
 40c:	0000                	unimp
 40e:	0518                	addi	a4,sp,640
 410:	0905                	addi	s2,s2,1
 412:	0000                	unimp
 414:	0518                	addi	a4,sp,640
 416:	0905                	addi	s2,s2,1
 418:	0004                	.insn	2, 0x0004
 41a:	0518                	addi	a4,sp,640
 41c:	0905                	addi	s2,s2,1
 41e:	0000                	unimp
 420:	0200                	addi	s0,sp,256
 422:	0104                	addi	s1,sp,128
 424:	3106                	fld	ft2,96(sp)
 426:	0505                	addi	a0,a0,1
 428:	0409                	addi	s0,s0,2
 42a:	0000                	unimp
 42c:	0402                	c.slli64	s0
 42e:	0600                	addi	s0,sp,768
 430:	0518                	addi	a4,sp,640
 432:	0905                	addi	s2,s2,1
 434:	0000                	unimp
 436:	017fb103          	ld	sp,23(t6)
 43a:	0605                	addi	a2,a2,1
 43c:	0009                	c.nop	2
 43e:	1e00                	addi	s0,sp,816
 440:	0505                	addi	a0,a0,1
 442:	0009                	c.nop	2
 444:	0600                	addi	s0,sp,768
 446:	05016903          	lwu	s2,80(sp)
 44a:	090c                	addi	a1,sp,144
 44c:	000a                	c.slli	zero,0x2
 44e:	3006                	fld	ft0,96(sp)
 450:	0505                	addi	a0,a0,1
 452:	0009                	c.nop	2
 454:	0000                	unimp
 456:	0402                	c.slli64	s0
 458:	1502                	slli	a0,a0,0x20
 45a:	2c05                	addiw	s8,s8,1
 45c:	0009                	c.nop	2
 45e:	0000                	unimp
 460:	0402                	c.slli64	s0
 462:	0300                	addi	s0,sp,384
 464:	0168                	addi	a0,sp,140
 466:	1705                	addi	a4,a4,-31 # fffffffffffeffe1 <__kernel_end+0xffffffff7ffdfc81>
 468:	0009                	c.nop	2
 46a:	1800                	addi	s0,sp,48
 46c:	0505                	addi	a0,a0,1
 46e:	0009                	c.nop	2
 470:	0600                	addi	s0,sp,768
 472:	0501                	addi	a0,a0,0
 474:	090c                	addi	a1,sp,144
 476:	0004                	.insn	2, 0x0004
 478:	0200                	addi	s0,sp,256
 47a:	0204                	addi	s1,sp,256
 47c:	052e                	slli	a0,a0,0xb
 47e:	092c                	addi	a1,sp,152
 480:	0006                	c.slli	zero,0x1
 482:	0200                	addi	s0,sp,256
 484:	0004                	.insn	2, 0x0004
 486:	1c06                	slli	s8,s8,0x21
 488:	0505                	addi	a0,a0,1
 48a:	0009                	c.nop	2
 48c:	0300                	addi	s0,sp,384
 48e:	016a                	slli	sp,sp,0x1a
 490:	1405                	addi	s0,s0,-31
 492:	0009                	c.nop	2
 494:	1800                	addi	s0,sp,48
 496:	0505                	addi	a0,a0,1
 498:	0009                	c.nop	2
 49a:	0600                	addi	s0,sp,768
 49c:	0501                	addi	a0,a0,0
 49e:	091f 0006 0501      	.insn	6, 0x05010006091f
 4a4:	091f 0000 7106      	.insn	6, 0x71060000091f
 4aa:	0505                	addi	a0,a0,1
 4ac:	0c09                	addi	s8,s8,2
 4ae:	1800                	addi	s0,sp,48
 4b0:	0505                	addi	a0,a0,1
 4b2:	0009                	c.nop	2
 4b4:	0300                	addi	s0,sp,384
 4b6:	0165                	addi	sp,sp,25
 4b8:	1805                	addi	a6,a6,-31
 4ba:	0009                	c.nop	2
 4bc:	1800                	addi	s0,sp,48
 4be:	0505                	addi	a0,a0,1
 4c0:	0009                	c.nop	2
 4c2:	1800                	addi	s0,sp,48
 4c4:	0505                	addi	a0,a0,1
 4c6:	0409                	addi	s0,s0,2
 4c8:	1800                	addi	s0,sp,48
 4ca:	0505                	addi	a0,a0,1
 4cc:	0009                	c.nop	2
 4ce:	0000                	unimp
 4d0:	0402                	c.slli64	s0
 4d2:	0601                	addi	a2,a2,0
 4d4:	0905052f          	.insn	4, 0x0905052f
 4d8:	0004                	.insn	2, 0x0004
 4da:	0200                	addi	s0,sp,256
 4dc:	0004                	.insn	2, 0x0004
 4de:	1806                	slli	a6,a6,0x21
 4e0:	0505                	addi	a0,a0,1
 4e2:	0009                	c.nop	2
 4e4:	0300                	addi	s0,sp,384
 4e6:	7fad                	lui	t6,0xfffeb
 4e8:	0501                	addi	a0,a0,0
 4ea:	0906                	slli	s2,s2,0x1
 4ec:	0000                	unimp
 4ee:	051e                	slli	a0,a0,0x7
 4f0:	0905                	addi	s2,s2,1
 4f2:	0000                	unimp
 4f4:	0306                	slli	t1,t1,0x1
 4f6:	0169                	addi	sp,sp,26
 4f8:	0c05                	addi	s8,s8,1
 4fa:	0a09                	addi	s4,s4,2
 4fc:	0600                	addi	s0,sp,768
 4fe:	0530                	addi	a2,sp,648
 500:	0905                	addi	s2,s2,1
 502:	0000                	unimp
 504:	0200                	addi	s0,sp,256
 506:	0204                	addi	s1,sp,256
 508:	0515                	addi	a0,a0,5
 50a:	092c                	addi	a1,sp,152
 50c:	0000                	unimp
 50e:	0200                	addi	s0,sp,256
 510:	0004                	.insn	2, 0x0004
 512:	05016803          	lwu	a6,80(sp)
 516:	00000917          	auipc	s2,0x0
 51a:	0518                	addi	a4,sp,640
 51c:	0905                	addi	s2,s2,1 # 517 <_start-0x7ffffae9>
 51e:	0000                	unimp
 520:	0106                	slli	sp,sp,0x1
 522:	0c05                	addi	s8,s8,1
 524:	0409                	addi	s0,s0,2
 526:	0000                	unimp
 528:	0402                	c.slli64	s0
 52a:	2e02                	fld	ft8,0(sp)
 52c:	2c05                	addiw	s8,s8,1
 52e:	0609                	addi	a2,a2,2
 530:	0000                	unimp
 532:	0402                	c.slli64	s0
 534:	0600                	addi	s0,sp,768
 536:	051c                	addi	a5,sp,640
 538:	0905                	addi	s2,s2,1
 53a:	0000                	unimp
 53c:	05016a03          	lwu	s4,80(sp)
 540:	0914                	addi	a3,sp,144
 542:	0000                	unimp
 544:	0518                	addi	a4,sp,640
 546:	0905                	addi	s2,s2,1
 548:	0000                	unimp
 54a:	0106                	slli	sp,sp,0x1
 54c:	1f05                	addi	t5,t5,-31
 54e:	0609                	addi	a2,a2,2
 550:	0100                	addi	s0,sp,128
 552:	1f05                	addi	t5,t5,-31
 554:	0009                	c.nop	2
 556:	0600                	addi	s0,sp,768
 558:	0575                	addi	a0,a0,29
 55a:	0905                	addi	s2,s2,1
 55c:	000c                	.insn	2, 0x000c
 55e:	0518                	addi	a4,sp,640
 560:	0905                	addi	s2,s2,1
 562:	0008                	.insn	2, 0x0008
 564:	0518                	addi	a4,sp,640
 566:	0905                	addi	s2,s2,1
 568:	0000                	unimp
 56a:	017fa903          	lw	s2,23(t6) # fffffffffffeb017 <__kernel_end+0xffffffff7ffdacb7>
 56e:	0605                	addi	a2,a2,1
 570:	0009                	c.nop	2
 572:	1e00                	addi	s0,sp,816
 574:	0505                	addi	a0,a0,1
 576:	0009                	c.nop	2
 578:	0600                	addi	s0,sp,768
 57a:	05016903          	lwu	s2,80(sp)
 57e:	090c                	addi	a1,sp,144
 580:	000a                	c.slli	zero,0x2
 582:	3006                	fld	ft0,96(sp)
 584:	0505                	addi	a0,a0,1
 586:	0009                	c.nop	2
 588:	0000                	unimp
 58a:	0402                	c.slli64	s0
 58c:	1502                	slli	a0,a0,0x20
 58e:	2c05                	addiw	s8,s8,1
 590:	0009                	c.nop	2
 592:	0000                	unimp
 594:	0402                	c.slli64	s0
 596:	0300                	addi	s0,sp,384
 598:	0168                	addi	a0,sp,140
 59a:	1705                	addi	a4,a4,-31
 59c:	0009                	c.nop	2
 59e:	1800                	addi	s0,sp,48
 5a0:	0505                	addi	a0,a0,1
 5a2:	0009                	c.nop	2
 5a4:	0600                	addi	s0,sp,768
 5a6:	0501                	addi	a0,a0,0
 5a8:	090c                	addi	a1,sp,144
 5aa:	0004                	.insn	2, 0x0004
 5ac:	0200                	addi	s0,sp,256
 5ae:	0204                	addi	s1,sp,256
 5b0:	052e                	slli	a0,a0,0xb
 5b2:	092c                	addi	a1,sp,152
 5b4:	0006                	c.slli	zero,0x1
 5b6:	0200                	addi	s0,sp,256
 5b8:	0004                	.insn	2, 0x0004
 5ba:	1c06                	slli	s8,s8,0x21
 5bc:	0505                	addi	a0,a0,1
 5be:	0009                	c.nop	2
 5c0:	0300                	addi	s0,sp,384
 5c2:	016a                	slli	sp,sp,0x1a
 5c4:	1405                	addi	s0,s0,-31
 5c6:	0009                	c.nop	2
 5c8:	1800                	addi	s0,sp,48
 5ca:	0505                	addi	a0,a0,1
 5cc:	0009                	c.nop	2
 5ce:	0600                	addi	s0,sp,768
 5d0:	0501                	addi	a0,a0,0
 5d2:	091f 0006 0501      	.insn	6, 0x05010006091f
 5d8:	091f 0000 7906      	.insn	6, 0x79060000091f
 5de:	0505                	addi	a0,a0,1
 5e0:	0c09                	addi	s8,s8,2
 5e2:	1800                	addi	s0,sp,48
 5e4:	0505                	addi	a0,a0,1
 5e6:	0809                	addi	a6,a6,2
 5e8:	1800                	addi	s0,sp,48
 5ea:	0505                	addi	a0,a0,1
 5ec:	0009                	c.nop	2
 5ee:	0300                	addi	s0,sp,384
 5f0:	7fa5                	lui	t6,0xfffe9
 5f2:	0501                	addi	a0,a0,0
 5f4:	0906                	slli	s2,s2,0x1
 5f6:	0000                	unimp
 5f8:	051e                	slli	a0,a0,0x7
 5fa:	0905                	addi	s2,s2,1
 5fc:	0000                	unimp
 5fe:	0306                	slli	t1,t1,0x1
 600:	0169                	addi	sp,sp,26
 602:	0c05                	addi	s8,s8,1
 604:	0a09                	addi	s4,s4,2
 606:	0600                	addi	s0,sp,768
 608:	0530                	addi	a2,sp,648
 60a:	0905                	addi	s2,s2,1
 60c:	0000                	unimp
 60e:	0200                	addi	s0,sp,256
 610:	0204                	addi	s1,sp,256
 612:	0515                	addi	a0,a0,5
 614:	092c                	addi	a1,sp,152
 616:	0000                	unimp
 618:	0200                	addi	s0,sp,256
 61a:	0004                	.insn	2, 0x0004
 61c:	05016803          	lwu	a6,80(sp)
 620:	00000917          	auipc	s2,0x0
 624:	0518                	addi	a4,sp,640
 626:	0905                	addi	s2,s2,1 # 621 <_start-0x7ffff9df>
 628:	0000                	unimp
 62a:	0106                	slli	sp,sp,0x1
 62c:	0c05                	addi	s8,s8,1
 62e:	0409                	addi	s0,s0,2
 630:	0000                	unimp
 632:	0402                	c.slli64	s0
 634:	2e02                	fld	ft8,0(sp)
 636:	2c05                	addiw	s8,s8,1
 638:	0609                	addi	a2,a2,2
 63a:	0000                	unimp
 63c:	0402                	c.slli64	s0
 63e:	0600                	addi	s0,sp,768
 640:	051c                	addi	a5,sp,640
 642:	0905                	addi	s2,s2,1
 644:	0000                	unimp
 646:	05016a03          	lwu	s4,80(sp)
 64a:	0914                	addi	a3,sp,144
 64c:	0000                	unimp
 64e:	0518                	addi	a4,sp,640
 650:	0905                	addi	s2,s2,1
 652:	0000                	unimp
 654:	0106                	slli	sp,sp,0x1
 656:	1f05                	addi	t5,t5,-31
 658:	0209                	addi	tp,tp,2 # 2 <_start-0x7ffffffe>
 65a:	7d00                	ld	s0,56(a0)
 65c:	0505                	addi	a0,a0,1
 65e:	0809                	addi	a6,a6,2
 660:	0300                	addi	s0,sp,384
 662:	7f9a                	ld	t6,416(sp)
 664:	0501                	addi	a0,a0,0
 666:	091f 0004 0501      	.insn	6, 0x05010004091f
 66c:	091f 0000 7d06      	.insn	6, 0x7d060000091f
 672:	0505                	addi	a0,a0,1
 674:	0409                	addi	s0,s0,2
 676:	1800                	addi	s0,sp,48
 678:	0505                	addi	a0,a0,1
 67a:	0c09                	addi	s8,s8,2
 67c:	1f00                	addi	s0,sp,944
 67e:	0505                	addi	a0,a0,1
 680:	0009                	c.nop	2
 682:	0000                	unimp
 684:	0402                	c.slli64	s0
 686:	1801                	addi	a6,a6,-32
 688:	0905                	addi	s2,s2,1
 68a:	0409                	addi	s0,s0,2
 68c:	0000                	unimp
 68e:	0402                	c.slli64	s0
 690:	1600                	addi	s0,sp,800
 692:	0b05                	addi	s6,s6,1
 694:	0009                	c.nop	2
 696:	0100                	addi	s0,sp,128
 698:	0505                	addi	a0,a0,1
 69a:	0009                	c.nop	2
 69c:	0000                	unimp
 69e:	0402                	c.slli64	s0
 6a0:	1801                	addi	a6,a6,-32
 6a2:	0905                	addi	s2,s2,1
 6a4:	0409                	addi	s0,s0,2
 6a6:	0000                	unimp
 6a8:	0402                	c.slli64	s0
 6aa:	1600                	addi	s0,sp,800
 6ac:	0b05                	addi	s6,s6,1
 6ae:	0900                	addi	s0,sp,144
 6b0:	1a02                	slli	s4,s4,0x20
 6b2:	0002                	c.slli64	zero
 6b4:	0080                	addi	s0,sp,64
 6b6:	0000                	unimp
 6b8:	0000                	unimp
 6ba:	0101                	addi	sp,sp,0

Disassembly of section .debug_line_str:

0000000000000000 <.debug_line_str>:
   0:	6573552f          	.insn	4, 0x6573552f
   4:	7372                	ld	t1,312(sp)
   6:	62696d2f          	.insn	4, 0x62696d2f
   a:	2f7a                	fld	ft10,408(sp)
   c:	6b726f77          	.insn	4, 0x6b726f77
  10:	7065722f          	.insn	4, 0x7065722f
  14:	6d2f736f          	jal	t1,f76e6 <_start-0x7ff0891a>
  18:	6269                	lui	tp,0x1a
  1a:	6f7a                	ld	t5,408(sp)
  1c:	72730073          	.insn	4, 0x72730073
  20:	6f620063          	beq	tp,s6,700 <_start-0x7ffff900>
  24:	532e746f          	jal	s0,e7556 <_start-0x7ff18aaa>
  28:	7300                	ld	s0,32(a4)
  2a:	6372                	ld	t1,280(sp)
  2c:	72656b2f          	.insn	4, 0x72656b2f
  30:	656e                	ld	a0,216(sp)
  32:	2e6c                	fld	fa1,216(a2)
  34:	74730063          	beq	t1,t2,774 <_start-0x7ffff88c>
  38:	6964                	ld	s1,208(a0)
  3a:	746e                	ld	s0,248(sp)
  3c:	672d                	lui	a4,0xb
  3e:	682e6363          	bltu	t3,sp,6c4 <_start-0x7ffff93c>
  42:	2f00                	fld	fs0,24(a4)
  44:	2f74706f          	j	47b3a <_start-0x7ffb84c6>
  48:	6f68                	ld	a0,216(a4)
  4a:	656d                	lui	a0,0x1b
  4c:	7262                	ld	tp,56(sp)
  4e:	7765                	lui	a4,0xffff9
  50:	6c65432f          	.insn	4, 0x6c65432f
  54:	616c                	ld	a1,192(a0)
  56:	2f72                	fld	ft10,280(sp)
  58:	6972                	ld	s2,280(sp)
  5a:	2d766373          	csrrsi	t1,0x2d7,12
  5e:	2d756e67          	.insn	4, 0x2d756e67
  62:	6f74                	ld	a3,216(a4)
  64:	68636c6f          	jal	s8,366ea <_start-0x7ffc9916>
  68:	6961                	lui	s2,0x18
  6a:	2f6e                	fld	ft10,216(sp)
  6c:	616d                	addi	sp,sp,240
  6e:	6e69                	lui	t3,0x1a
  70:	62696c2f          	.insn	4, 0x62696c2f
  74:	6363672f          	.insn	4, 0x6363672f
  78:	7369722f          	.insn	4, 0x7369722f
  7c:	34367663          	bgeu	a2,gp,3c8 <_start-0x7ffffc38>
  80:	752d                	lui	a0,0xfffeb
  82:	6b6e                	ld	s6,216(sp)
  84:	6f6e                	ld	t5,216(sp)
  86:	652d6e77          	.insn	4, 0x652d6e77
  8a:	666c                	ld	a1,200(a2)
  8c:	2e35312f          	.insn	4, 0x2e35312f
  90:	2e31                	addiw	t3,t3,12 # 1a00c <_start-0x7ffe5ff4>
  92:	2f30                	fld	fa2,88(a4)
  94:	6e69                	lui	t3,0x1a
  96:	64756c63          	bltu	a0,t2,6ee <_start-0x7ffff912>
  9a:	0065                	c.nop	25

Disassembly of section .debug_info:

0000000000000000 <.debug_info>:
   0:	0024                	addi	s1,sp,8
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0801                	addi	a6,a6,0
   8:	0000                	unimp
   a:	0000                	unimp
   c:	0001                	nop
   e:	0000                	unimp
  10:	0000                	unimp
  12:	0000                	unimp
  14:	0080                	addi	s0,sp,64
  16:	0000                	unimp
  18:	3e00                	fld	fs0,56(a2)
  1a:	0000                	unimp
  1c:	0000                	unimp
  1e:	0000000b          	.insn	4, 0x000b
  22:	0029                	c.nop	10
  24:	0000                	unimp
  26:	8001                	c.srli64	s0
  28:	0828                	addi	a0,sp,24
  2a:	0000                	unimp
  2c:	0005                	c.nop	1
  2e:	0801                	addi	a6,a6,0
  30:	0014                	.insn	2, 0x0014
  32:	0000                	unimp
  34:	a211                	j	138 <_start-0x7ffffec8>
  36:	0000                	unimp
  38:	1d00                	addi	s0,sp,688
  3a:	03164703          	lbu	a4,49(a2)
  3e:	2900                	fld	fs0,16(a0)
  40:	0000                	unimp
  42:	0000                	unimp
  44:	0000                	unimp
  46:	3a00                	fld	fs0,48(a2)
  48:	0000                	unimp
  4a:	0080                	addi	s0,sp,64
  4c:	0000                	unimp
  4e:	e000                	sd	s0,0(s0)
  50:	0001                	nop
  52:	0000                	unimp
  54:	0000                	unimp
  56:	9600                	.insn	2, 0x9600
  58:	0000                	unimp
  5a:	0400                	addi	s0,sp,512
  5c:	0601                	addi	a2,a2,0
  5e:	0064                	addi	s1,sp,12
  60:	0000                	unimp
  62:	0204                	addi	s1,sp,256
  64:	4e05                	li	t3,1
  66:	0001                	nop
  68:	1200                	addi	s0,sp,288
  6a:	0504                	addi	s1,sp,640
  6c:	6e69                	lui	t3,0x1a
  6e:	0074                	addi	a3,sp,12
  70:	0804                	addi	s1,sp,16
  72:	6205                	lui	tp,0x1
  74:	0001                	nop
  76:	0c00                	addi	s0,sp,528
  78:	00000133          	add	sp,zero,zero
  7c:	182e                	slli	a6,a6,0x2b
  7e:	005a                	c.slli	zero,0x16
  80:	0000                	unimp
  82:	0104                	addi	s1,sp,128
  84:	6208                	ld	a0,0(a2)
  86:	0000                	unimp
  88:	0400                	addi	s0,sp,512
  8a:	0702                	c.slli64	a4
  8c:	0082                	c.slli64	ra
  8e:	0000                	unimp
  90:	0404                	addi	s1,sp,512
  92:	00007507          	.insn	4, 0x7507
  96:	0c00                	addi	s0,sp,528
  98:	0048                	addi	a0,sp,4
  9a:	0000                	unimp
  9c:	007a1937          	lui	s2,0x7a1
  a0:	0000                	unimp
  a2:	0804                	addi	s1,sp,16
  a4:	00007007          	.insn	4, 0x7007
  a8:	0800                	addi	s0,sp,16
  aa:	0000016b          	.insn	4, 0x016b
  ae:	0076                	c.slli	zero,0x1d
  b0:	0001                	nop
  b2:	0080                	addi	s0,sp,64
  b4:	0000                	unimp
  b6:	1a00                	addi	s0,sp,304
  b8:	0001                	nop
  ba:	0000                	unimp
  bc:	0000                	unimp
  be:	0100                	addi	s0,sp,128
  c0:	c39c                	sw	a5,0(a5)
  c2:	0004                	.insn	2, 0x0004
  c4:	0700                	addi	s0,sp,896
  c6:	04dd                	addi	s1,s1,23
  c8:	0000                	unimp
  ca:	014c                	addi	a1,sp,132
  cc:	8000                	.insn	2, 0x8000
  ce:	0000                	unimp
  d0:	0000                	unimp
  d2:	4c0c                	lw	a1,24(s0)
  d4:	0001                	nop
  d6:	0080                	addi	s0,sp,64
  d8:	0000                	unimp
  da:	0400                	addi	s0,sp,512
  dc:	0000                	unimp
  de:	0000                	unimp
  e0:	0000                	unimp
  e2:	8100                	.insn	2, 0x8100
  e4:	c705                	beqz	a4,10c <_start-0x7ffffef4>
  e6:	0000                	unimp
  e8:	0d00                	addi	s0,sp,656
  ea:	04ec                	addi	a1,sp,588
  ec:	0000                	unimp
  ee:	0700                	addi	s0,sp,896
  f0:	0754                	addi	a3,sp,900
  f2:	0000                	unimp
  f4:	0154                	addi	a3,sp,132
  f6:	8000                	.insn	2, 0x8000
  f8:	0000                	unimp
  fa:	0000                	unimp
  fc:	5412                	lw	s0,36(sp)
  fe:	0001                	nop
 100:	0080                	addi	s0,sp,64
 102:	0000                	unimp
 104:	1a00                	addi	s0,sp,304
 106:	0000                	unimp
 108:	0000                	unimp
 10a:	0000                	unimp
 10c:	8200                	.insn	2, 0x8200
 10e:	5a05                	li	s4,-31
 110:	0001                	nop
 112:	0100                	addi	s0,sp,128
 114:	0761                	addi	a4,a4,24 # ffffffffffff9018 <__kernel_end+0xffffffff7ffe8cb8>
 116:	0000                	unimp
 118:	000e                	c.slli	zero,0x3
 11a:	0000                	unimp
 11c:	000c                	.insn	2, 0x000c
 11e:	0000                	unimp
 120:	9005                	srli	s0,s0,0x21
 122:	5e000007          	.insn	4, 0x5e000007
 126:	0001                	nop
 128:	0080                	addi	s0,sp,64
 12a:	0000                	unimp
 12c:	1700                	addi	s0,sp,928
 12e:	004e                	c.slli	zero,0x13
 130:	0000                	unimp
 132:	0d3a                	slli	s10,s10,0xe
 134:	011e                	slli	sp,sp,0x7
 136:	0000                	unimp
 138:	9f01                	subw	a4,a4,s0
 13a:	19000007          	.insn	4, 0x19000007
 13e:	0000                	unimp
 140:	1700                	addi	s0,sp,928
 142:	0000                	unimp
 144:	0000                	unimp
 146:	6c06                	ld	s8,64(sp)
 148:	68000007          	.insn	4, 0x68000007
 14c:	0001                	nop
 14e:	0080                	addi	s0,sp,64
 150:	0000                	unimp
 152:	1c00                	addi	s0,sp,560
 154:	0168                	addi	a0,sp,140
 156:	8000                	.insn	2, 0x8000
 158:	0000                	unimp
 15a:	0000                	unimp
 15c:	0006                	c.slli	zero,0x1
 15e:	0000                	unimp
 160:	0000                	unimp
 162:	0000                	unimp
 164:	7901053f 28000007 	.insn	8, 0x280000077901053f
 16c:	0000                	unimp
 16e:	2600                	fld	fs0,8(a2)
 170:	0000                	unimp
 172:	0100                	addi	s0,sp,128
 174:	0784                	addi	s1,sp,960
 176:	0000                	unimp
 178:	0035                	c.nop	13
 17a:	0000                	unimp
 17c:	00000033          	add	zero,zero,zero
 180:	0000                	unimp
 182:	0004c307          	.insn	4, 0x0004c307
 186:	7a00                	ld	s0,48(a2)
 188:	0001                	nop
 18a:	0080                	addi	s0,sp,64
 18c:	0000                	unimp
 18e:	2200                	fld	fs0,0(a2)
 190:	017a                	slli	sp,sp,0x1e
 192:	8000                	.insn	2, 0x8000
 194:	0000                	unimp
 196:	0000                	unimp
 198:	0004                	.insn	2, 0x0004
 19a:	0000                	unimp
 19c:	0000                	unimp
 19e:	0000                	unimp
 1a0:	0585                	addi	a1,a1,1
 1a2:	0184                	addi	s1,sp,192
 1a4:	0000                	unimp
 1a6:	d20d                	beqz	a2,c8 <_start-0x7fffff38>
 1a8:	0004                	.insn	2, 0x0004
 1aa:	0000                	unimp
 1ac:	00075407          	.insn	4, 0x00075407
 1b0:	8200                	.insn	2, 0x8200
 1b2:	0001                	nop
 1b4:	0080                	addi	s0,sp,64
 1b6:	0000                	unimp
 1b8:	2800                	fld	fs0,16(s0)
 1ba:	0182                	c.slli64	gp
 1bc:	8000                	.insn	2, 0x8000
 1be:	0000                	unimp
 1c0:	0000                	unimp
 1c2:	001a                	c.slli	zero,0x6
 1c4:	0000                	unimp
 1c6:	0000                	unimp
 1c8:	0000                	unimp
 1ca:	0586                	slli	a1,a1,0x1
 1cc:	00000217          	auipc	tp,0x0
 1d0:	6101                	addi	sp,sp,0
 1d2:	40000007          	.insn	4, 0x40000007
 1d6:	0000                	unimp
 1d8:	3e00                	fld	fs0,56(a2)
 1da:	0000                	unimp
 1dc:	0500                	addi	s0,sp,640
 1de:	0790                	addi	a2,sp,960
 1e0:	0000                	unimp
 1e2:	018c                	addi	a1,sp,192
 1e4:	8000                	.insn	2, 0x8000
 1e6:	0000                	unimp
 1e8:	0000                	unimp
 1ea:	592d                	li	s2,-21
 1ec:	0000                	unimp
 1ee:	3a00                	fld	fs0,48(a2)
 1f0:	db0d                	beqz	a4,122 <_start-0x7ffffede>
 1f2:	0001                	nop
 1f4:	0100                	addi	s0,sp,128
 1f6:	079f 0000 004b      	.insn	6, 0x004b0000079f
 1fc:	0000                	unimp
 1fe:	0049                	c.nop	18
 200:	0000                	unimp
 202:	0600                	addi	s0,sp,768
 204:	076c                	addi	a1,sp,908
 206:	0000                	unimp
 208:	0196                	slli	gp,gp,0x5
 20a:	8000                	.insn	2, 0x8000
 20c:	0000                	unimp
 20e:	0000                	unimp
 210:	9632                	add	a2,a2,a2
 212:	0001                	nop
 214:	0080                	addi	s0,sp,64
 216:	0000                	unimp
 218:	0600                	addi	s0,sp,768
 21a:	0000                	unimp
 21c:	0000                	unimp
 21e:	0000                	unimp
 220:	3f00                	fld	fs0,56(a4)
 222:	0105                	addi	sp,sp,1
 224:	0779                	addi	a4,a4,30
 226:	0000                	unimp
 228:	005a                	c.slli	zero,0x16
 22a:	0000                	unimp
 22c:	0058                	addi	a4,sp,4
 22e:	0000                	unimp
 230:	8401                	c.srai64	s0
 232:	67000007          	.insn	4, 0x67000007
 236:	0000                	unimp
 238:	6500                	ld	s0,8(a0)
 23a:	0000                	unimp
 23c:	0000                	unimp
 23e:	0700                	addi	s0,sp,896
 240:	0754                	addi	a3,sp,900
 242:	0000                	unimp
 244:	01b0                	addi	a2,sp,200
 246:	8000                	.insn	2, 0x8000
 248:	0000                	unimp
 24a:	0000                	unimp
 24c:	b039                	j	fffffffffffffa5a <__kernel_end+0xffffffff7ffef6fa>
 24e:	0001                	nop
 250:	0080                	addi	s0,sp,64
 252:	0000                	unimp
 254:	1a00                	addi	s0,sp,304
 256:	0000                	unimp
 258:	0000                	unimp
 25a:	0000                	unimp
 25c:	8a00                	.insn	2, 0x8a00
 25e:	aa05                	j	38e <_start-0x7ffffc72>
 260:	0002                	c.slli64	zero
 262:	0100                	addi	s0,sp,128
 264:	0761                	addi	a4,a4,24
 266:	0000                	unimp
 268:	0072                	c.slli	zero,0x1c
 26a:	0000                	unimp
 26c:	0070                	addi	a2,sp,12
 26e:	0000                	unimp
 270:	9005                	srli	s0,s0,0x21
 272:	ba000007          	.insn	4, 0xba000007
 276:	0001                	nop
 278:	0080                	addi	s0,sp,64
 27a:	0000                	unimp
 27c:	3e00                	fld	fs0,56(a2)
 27e:	0064                	addi	s1,sp,12
 280:	0000                	unimp
 282:	0d3a                	slli	s10,s10,0xe
 284:	026e                	slli	tp,tp,0x1b
 286:	0000                	unimp
 288:	9f01                	subw	a4,a4,s0
 28a:	7d000007          	.insn	4, 0x7d000007
 28e:	0000                	unimp
 290:	7b00                	ld	s0,48(a4)
 292:	0000                	unimp
 294:	0000                	unimp
 296:	6c06                	ld	s8,64(sp)
 298:	c4000007          	.insn	4, 0xc4000007
 29c:	0001                	nop
 29e:	0080                	addi	s0,sp,64
 2a0:	0000                	unimp
 2a2:	4300                	lw	s0,0(a4)
 2a4:	01c4                	addi	s1,sp,196
 2a6:	8000                	.insn	2, 0x8000
 2a8:	0000                	unimp
 2aa:	0000                	unimp
 2ac:	0006                	c.slli	zero,0x1
 2ae:	0000                	unimp
 2b0:	0000                	unimp
 2b2:	0000                	unimp
 2b4:	7901053f 8c000007 	.insn	8, 0x8c0000077901053f
 2bc:	0000                	unimp
 2be:	8a00                	.insn	2, 0x8a00
 2c0:	0000                	unimp
 2c2:	0100                	addi	s0,sp,128
 2c4:	0784                	addi	s1,sp,960
 2c6:	0000                	unimp
 2c8:	0099                	addi	ra,ra,6
 2ca:	0000                	unimp
 2cc:	00000097          	auipc	ra,0x0
 2d0:	0000                	unimp
 2d2:	5405                	li	s0,-31
 2d4:	de000007          	.insn	4, 0xde000007
 2d8:	0001                	nop
 2da:	0080                	addi	s0,sp,64
 2dc:	0000                	unimp
 2de:	4a00                	lw	s0,16(a2)
 2e0:	0000006f          	j	2e0 <_start-0x7ffffd20>
 2e4:	058e                	slli	a1,a1,0x3
 2e6:	0325                	addi	t1,t1,9 # ffffffffffffa009 <__kernel_end+0xffffffff7ffe9ca9>
 2e8:	0000                	unimp
 2ea:	6101                	addi	sp,sp,0
 2ec:	a4000007          	.insn	4, 0xa4000007
 2f0:	0000                	unimp
 2f2:	a200                	fsd	fs0,0(a2)
 2f4:	0000                	unimp
 2f6:	0500                	addi	s0,sp,640
 2f8:	0790                	addi	a2,sp,960
 2fa:	0000                	unimp
 2fc:	01e8                	addi	a0,sp,204
 2fe:	8000                	.insn	2, 0x8000
 300:	0000                	unimp
 302:	0000                	unimp
 304:	00007a4f          	fnmadd.s	fs4,ft0,ft0,ft0
 308:	3a00                	fld	fs0,48(a2)
 30a:	f50d                	bnez	a0,234 <_start-0x7ffffdcc>
 30c:	0002                	c.slli64	zero
 30e:	0100                	addi	s0,sp,128
 310:	079f 0000 00af      	.insn	6, 0x00af0000079f
 316:	0000                	unimp
 318:	00ad                	addi	ra,ra,11 # 2d7 <_start-0x7ffffd29>
 31a:	0000                	unimp
 31c:	0900                	addi	s0,sp,144
 31e:	076c                	addi	a1,sp,908
 320:	0000                	unimp
 322:	01f2                	slli	gp,gp,0x1c
 324:	8000                	.insn	2, 0x8000
 326:	0000                	unimp
 328:	0000                	unimp
 32a:	8554                	.insn	2, 0x8554
 32c:	0000                	unimp
 32e:	3f00                	fld	fs0,56(a4)
 330:	0105                	addi	sp,sp,1
 332:	0779                	addi	a4,a4,30
 334:	0000                	unimp
 336:	00be                	slli	ra,ra,0xf
 338:	0000                	unimp
 33a:	00bc                	addi	a5,sp,72
 33c:	0000                	unimp
 33e:	8401                	c.srai64	s0
 340:	cb000007          	.insn	4, 0xcb000007
 344:	0000                	unimp
 346:	c900                	sw	s0,16(a0)
 348:	0000                	unimp
 34a:	0000                	unimp
 34c:	0300                	addi	s0,sp,384
 34e:	0110                	addi	a2,sp,128
 350:	8000                	.insn	2, 0x8000
 352:	0000                	unimp
 354:	0000                	unimp
 356:	0619                	addi	a2,a2,6
 358:	0000                	unimp
 35a:	0344                	addi	s1,sp,388
 35c:	0000                	unimp
 35e:	0102                	c.slli64	sp
 360:	095a                	slli	s2,s2,0x16
 362:	00024003          	lbu	zero,0(tp) # 1cc <_start-0x7ffffe34>
 366:	0080                	addi	s0,sp,64
 368:	0000                	unimp
 36a:	0000                	unimp
 36c:	00011c03          	lh	s8,0(sp)
 370:	0080                	addi	s0,sp,64
 372:	0000                	unimp
 374:	1900                	addi	s0,sp,176
 376:	0006                	c.slli	zero,0x1
 378:	6300                	ld	s0,0(a4)
 37a:	02000003          	lb	zero,32(zero) # 20 <_start-0x7fffffe0>
 37e:	5a01                	li	s4,-32
 380:	0309                	addi	t1,t1,2
 382:	0248                	addi	a0,sp,260
 384:	8000                	.insn	2, 0x8000
 386:	0000                	unimp
 388:	0000                	unimp
 38a:	0300                	addi	s0,sp,384
 38c:	0128                	addi	a0,sp,136
 38e:	8000                	.insn	2, 0x8000
 390:	0000                	unimp
 392:	0000                	unimp
 394:	0619                	addi	a2,a2,6
 396:	0000                	unimp
 398:	0382                	c.slli64	t2
 39a:	0000                	unimp
 39c:	0102                	c.slli64	sp
 39e:	095a                	slli	s2,s2,0x16
 3a0:	00027003          	.insn	4, 0x00027003
 3a4:	0080                	addi	s0,sp,64
 3a6:	0000                	unimp
 3a8:	0000                	unimp
 3aa:	00013403          	ld	s0,0(sp)
 3ae:	0080                	addi	s0,sp,64
 3b0:	0000                	unimp
 3b2:	1900                	addi	s0,sp,176
 3b4:	0006                	c.slli	zero,0x1
 3b6:	a100                	fsd	fs0,0(a0)
 3b8:	02000003          	lb	zero,32(zero) # 20 <_start-0x7fffffe0>
 3bc:	5a01                	li	s4,-32
 3be:	0309                	addi	t1,t1,2
 3c0:	0290                	addi	a2,sp,320
 3c2:	8000                	.insn	2, 0x8000
 3c4:	0000                	unimp
 3c6:	0000                	unimp
 3c8:	0300                	addi	s0,sp,384
 3ca:	0140                	addi	s0,sp,132
 3cc:	8000                	.insn	2, 0x8000
 3ce:	0000                	unimp
 3d0:	0000                	unimp
 3d2:	0619                	addi	a2,a2,6
 3d4:	0000                	unimp
 3d6:	03c0                	addi	s0,sp,452
 3d8:	0000                	unimp
 3da:	0102                	c.slli64	sp
 3dc:	095a                	slli	s2,s2,0x16
 3de:	0002b803          	ld	a6,0(t0)
 3e2:	0080                	addi	s0,sp,64
 3e4:	0000                	unimp
 3e6:	0000                	unimp
 3e8:	00014c03          	lbu	s8,0(sp)
 3ec:	0080                	addi	s0,sp,64
 3ee:	0000                	unimp
 3f0:	1900                	addi	s0,sp,176
 3f2:	0006                	c.slli	zero,0x1
 3f4:	df00                	sw	s0,56(a4)
 3f6:	02000003          	lb	zero,32(zero) # 20 <_start-0x7fffffe0>
 3fa:	5a01                	li	s4,-32
 3fc:	0309                	addi	t1,t1,2
 3fe:	02d0                	addi	a2,sp,324
 400:	8000                	.insn	2, 0x8000
 402:	0000                	unimp
 404:	0000                	unimp
 406:	0e00                	addi	s0,sp,784
 408:	0154                	addi	a3,sp,132
 40a:	8000                	.insn	2, 0x8000
 40c:	0000                	unimp
 40e:	0000                	unimp
 410:	000004f7          	.insn	4, 0x04f7
 414:	00017a03          	.insn	4, 0x00017a03
 418:	0080                	addi	s0,sp,64
 41a:	0000                	unimp
 41c:	1900                	addi	s0,sp,176
 41e:	0006                	c.slli	zero,0x1
 420:	0b00                	addi	s0,sp,400
 422:	0004                	.insn	2, 0x0004
 424:	0200                	addi	s0,sp,256
 426:	5a01                	li	s4,-32
 428:	0309                	addi	t1,t1,2
 42a:	02e0                	addi	s0,sp,332
 42c:	8000                	.insn	2, 0x8000
 42e:	0000                	unimp
 430:	0000                	unimp
 432:	0e00                	addi	s0,sp,784
 434:	0182                	c.slli64	gp
 436:	8000                	.insn	2, 0x8000
 438:	0000                	unimp
 43a:	0000                	unimp
 43c:	000004f7          	.insn	4, 0x04f7
 440:	0001a803          	lw	a6,0(gp)
 444:	0080                	addi	s0,sp,64
 446:	0000                	unimp
 448:	1900                	addi	s0,sp,176
 44a:	0006                	c.slli	zero,0x1
 44c:	3700                	fld	fs0,40(a4)
 44e:	0004                	.insn	2, 0x0004
 450:	0200                	addi	s0,sp,256
 452:	5a01                	li	s4,-32
 454:	0309                	addi	t1,t1,2
 456:	02f8                	addi	a4,sp,332
 458:	8000                	.insn	2, 0x8000
 45a:	0000                	unimp
 45c:	0000                	unimp
 45e:	0300                	addi	s0,sp,384
 460:	01b0                	addi	a2,sp,200
 462:	8000                	.insn	2, 0x8000
 464:	0000                	unimp
 466:	0000                	unimp
 468:	000004f7          	.insn	4, 0x04f7
 46c:	0450                	addi	a2,sp,516
 46e:	0000                	unimp
 470:	0102                	c.slli64	sp
 472:	035a                	slli	t1,t1,0x16
 474:	4840                	lw	s0,20(s0)
 476:	0024                	addi	s1,sp,8
 478:	0001d603          	lhu	a2,0(gp)
 47c:	0080                	addi	s0,sp,64
 47e:	0000                	unimp
 480:	1900                	addi	s0,sp,176
 482:	0006                	c.slli	zero,0x1
 484:	6f00                	ld	s0,24(a4)
 486:	0004                	.insn	2, 0x0004
 488:	0200                	addi	s0,sp,256
 48a:	5a01                	li	s4,-32
 48c:	0309                	addi	t1,t1,2
 48e:	0308                	addi	a0,sp,384
 490:	8000                	.insn	2, 0x8000
 492:	0000                	unimp
 494:	0000                	unimp
 496:	0300                	addi	s0,sp,384
 498:	01de                	slli	gp,gp,0x17
 49a:	8000                	.insn	2, 0x8000
 49c:	0000                	unimp
 49e:	0000                	unimp
 4a0:	000004f7          	.insn	4, 0x04f7
 4a4:	0488                	addi	a0,sp,576
 4a6:	0000                	unimp
 4a8:	0102                	c.slli64	sp
 4aa:	035a                	slli	t1,t1,0x16
 4ac:	4b40                	lw	s0,20(a4)
 4ae:	0024                	addi	s1,sp,8
 4b0:	00020403          	lb	s0,0(tp) # 0 <_start-0x80000000>
 4b4:	0080                	addi	s0,sp,64
 4b6:	0000                	unimp
 4b8:	1900                	addi	s0,sp,176
 4ba:	0006                	c.slli	zero,0x1
 4bc:	a700                	fsd	fs0,8(a4)
 4be:	0004                	.insn	2, 0x0004
 4c0:	0200                	addi	s0,sp,256
 4c2:	5a01                	li	s4,-32
 4c4:	0309                	addi	t1,t1,2
 4c6:	0318                	addi	a4,sp,384
 4c8:	8000                	.insn	2, 0x8000
 4ca:	0000                	unimp
 4cc:	0000                	unimp
 4ce:	0f00                	addi	s0,sp,912
 4d0:	0210                	addi	a2,sp,256
 4d2:	8000                	.insn	2, 0x8000
 4d4:	0000                	unimp
 4d6:	0000                	unimp
 4d8:	0619                	addi	a2,a2,6
 4da:	0000                	unimp
 4dc:	0102                	c.slli64	sp
 4de:	095a                	slli	s2,s2,0x16
 4e0:	00033803          	ld	a6,0(t1)
 4e4:	0080                	addi	s0,sp,64
 4e6:	0000                	unimp
 4e8:	0000                	unimp
 4ea:	0a00                	addi	s0,sp,272
 4ec:	0095                	addi	ra,ra,5
 4ee:	0000                	unimp
 4f0:	186a                	slli	a6,a6,0x3a
 4f2:	0000006f          	j	4f2 <_start-0x7ffffb0e>
 4f6:	04dd                	addi	s1,s1,23
 4f8:	0000                	unimp
 4fa:	9a10                	.insn	2, 0x9a10
 4fc:	0000                	unimp
 4fe:	6b00                	ld	s0,16(a4)
 500:	0000006f          	j	500 <_start-0x7ffffb00>
 504:	0a00                	addi	s0,sp,272
 506:	0035                	c.nop	13
 508:	0000                	unimp
 50a:	1864                	addi	s1,sp,60
 50c:	0000006f          	j	50c <_start-0x7ffffaf4>
 510:	000004f7          	.insn	4, 0x04f7
 514:	3b10                	fld	fa2,48(a4)
 516:	0000                	unimp
 518:	6500                	ld	s0,8(a0)
 51a:	0000006f          	j	51a <_start-0x7ffffae6>
 51e:	0800                	addi	s0,sp,16
 520:	0051                	c.nop	20
 522:	0000                	unimp
 524:	9854                	.insn	2, 0x9854
 526:	0000                	unimp
 528:	0080                	addi	s0,sp,64
 52a:	0000                	unimp
 52c:	6800                	ld	s0,16(s0)
 52e:	0000                	unimp
 530:	0000                	unimp
 532:	0000                	unimp
 534:	0100                	addi	s0,sp,128
 536:	fd9c                	sd	a5,56(a1)
 538:	0005                	c.nop	1
 53a:	1300                	addi	s0,sp,416
 53c:	0042                	c.slli	zero,0x10
 53e:	0000                	unimp
 540:	5401                	li	s0,-32
 542:	00006f1b          	.insn	4, 0x6f1b
 546:	da00                	sw	s0,48(a2)
 548:	0000                	unimp
 54a:	d400                	sw	s0,40(s0)
 54c:	0000                	unimp
 54e:	1400                	addi	s0,sp,544
 550:	6568                	ld	a0,200(a0)
 552:	0078                	addi	a4,sp,12
 554:	5501                	li	a0,-32
 556:	fd10                	sd	a2,56(a0)
 558:	0005                	c.nop	1
 55a:	0200                	addi	s0,sp,256
 55c:	5891                	li	a7,-28
 55e:	c815                	beqz	s0,592 <_start-0x7ffffa6e>
 560:	0000                	unimp
 562:	0080                	addi	s0,sp,64
 564:	0000                	unimp
 566:	3000                	fld	fs0,32(s0)
 568:	0000                	unimp
 56a:	0000                	unimp
 56c:	0000                	unimp
 56e:	e100                	sd	s0,0(a0)
 570:	0005                	c.nop	1
 572:	1600                	addi	s0,sp,800
 574:	0069                	c.nop	26
 576:	5901                	li	s2,-32
 578:	410e                	lw	sp,192(sp)
 57a:	0000                	unimp
 57c:	f600                	sd	s0,40(a2)
 57e:	0000                	unimp
 580:	f200                	sd	s0,32(a2)
 582:	0000                	unimp
 584:	0900                	addi	s0,sp,144
 586:	0754                	addi	a3,sp,900
 588:	0000                	unimp
 58a:	00e4                	addi	s1,sp,76
 58c:	8000                	.insn	2, 0x8000
 58e:	0000                	unimp
 590:	0000                	unimp
 592:	2e14                	fld	fa3,24(a2)
 594:	0000                	unimp
 596:	5a00                	lw	s0,48(a2)
 598:	0109                	addi	sp,sp,2
 59a:	0761                	addi	a4,a4,24
 59c:	0000                	unimp
 59e:	0109                	addi	sp,sp,2
 5a0:	0000                	unimp
 5a2:	00000107          	.insn	4, 0x0107
 5a6:	9005                	srli	s0,s0,0x21
 5a8:	e4000007          	.insn	4, 0xe4000007
 5ac:	0000                	unimp
 5ae:	0080                	addi	s0,sp,64
 5b0:	0000                	unimp
 5b2:	1800                	addi	s0,sp,48
 5b4:	003e                	c.slli	zero,0xf
 5b6:	0000                	unimp
 5b8:	0d3a                	slli	s10,s10,0xe
 5ba:	05a4                	addi	s1,sp,712
 5bc:	0000                	unimp
 5be:	9f01                	subw	a4,a4,s0
 5c0:	13000007          	.insn	4, 0x13000007
 5c4:	0001                	nop
 5c6:	1100                	addi	s0,sp,160
 5c8:	0001                	nop
 5ca:	0000                	unimp
 5cc:	6c06                	ld	s8,64(sp)
 5ce:	ee000007          	.insn	4, 0xee000007
 5d2:	0000                	unimp
 5d4:	0080                	addi	s0,sp,64
 5d6:	0000                	unimp
 5d8:	1d00                	addi	s0,sp,688
 5da:	00ee                	slli	ra,ra,0x1b
 5dc:	8000                	.insn	2, 0x8000
 5de:	0000                	unimp
 5e0:	0000                	unimp
 5e2:	0004                	.insn	2, 0x0004
 5e4:	0000                	unimp
 5e6:	0000                	unimp
 5e8:	0000                	unimp
 5ea:	7901053f 22000007 	.insn	8, 0x220000077901053f
 5f2:	0001                	nop
 5f4:	2000                	fld	fs0,0(s0)
 5f6:	0001                	nop
 5f8:	0100                	addi	s0,sp,128
 5fa:	0784                	addi	s1,sp,960
 5fc:	0000                	unimp
 5fe:	0000012f          	.insn	4, 0x012f
 602:	012d                	addi	sp,sp,11
 604:	0000                	unimp
 606:	0000                	unimp
 608:	0f00                	addi	s0,sp,912
 60a:	00c8                	addi	a0,sp,68
 60c:	8000                	.insn	2, 0x8000
 60e:	0000                	unimp
 610:	0000                	unimp
 612:	0619                	addi	a2,a2,6
 614:	0000                	unimp
 616:	0102                	c.slli64	sp
 618:	095a                	slli	s2,s2,0x16
 61a:	00022003          	lw	zero,0(tp) # 0 <_start-0x80000000>
 61e:	0080                	addi	s0,sp,64
 620:	0000                	unimp
 622:	0000                	unimp
 624:	1700                	addi	s0,sp,928
 626:	0614                	addi	a3,sp,768
 628:	0000                	unimp
 62a:	060d                	addi	a2,a2,3
 62c:	0000                	unimp
 62e:	7a18                	ld	a4,48(a2)
 630:	0000                	unimp
 632:	1000                	addi	s0,sp,32
 634:	0400                	addi	s0,sp,512
 636:	0801                	addi	a6,a6,0
 638:	0000006b          	.insn	4, 0x006b
 63c:	0d19                	addi	s10,s10,6
 63e:	0006                	c.slli	zero,0x1
 640:	0800                	addi	s0,sp,16
 642:	00000177          	.insn	4, 0x0177
 646:	5445                	li	s0,-15
 648:	0000                	unimp
 64a:	0080                	addi	s0,sp,64
 64c:	0000                	unimp
 64e:	4400                	lw	s0,8(s0)
 650:	0000                	unimp
 652:	0000                	unimp
 654:	0000                	unimp
 656:	0100                	addi	s0,sp,128
 658:	4e9c                	lw	a5,24(a3)
 65a:	1a000007          	.insn	4, 0x1a000007
 65e:	45010073          	.insn	4, 0x45010073
 662:	4e1c                	lw	a5,24(a2)
 664:	3b000007          	.insn	4, 0x3b000007
 668:	0001                	nop
 66a:	3700                	fld	fs0,40(a4)
 66c:	0001                	nop
 66e:	1b00                	addi	s0,sp,432
 670:	0754                	addi	a3,sp,900
 672:	0000                	unimp
 674:	00000013          	nop
 678:	4901                	li	s2,0
 67a:	b20d                	j	ffffffffffffff9c <__kernel_end+0xffffffff7ffefc3c>
 67c:	0006                	c.slli	zero,0x1
 67e:	1c00                	addi	s0,sp,560
 680:	0761                	addi	a4,a4,24
 682:	0000                	unimp
 684:	9005                	srli	s0,s0,0x21
 686:	88000007          	.insn	4, 0x88000007
 68a:	0000                	unimp
 68c:	0080                	addi	s0,sp,64
 68e:	0000                	unimp
 690:	1d00                	addi	s0,sp,688
 692:	001d                	c.nop	7
 694:	0000                	unimp
 696:	0d3a                	slli	s10,s10,0xe
 698:	0682                	c.slli64	a3
 69a:	0000                	unimp
 69c:	9f01                	subw	a4,a4,s0
 69e:	48000007          	.insn	4, 0x48000007
 6a2:	0001                	nop
 6a4:	4600                	lw	s0,8(a2)
 6a6:	0001                	nop
 6a8:	0000                	unimp
 6aa:	6c09                	lui	s8,0x2
 6ac:	92000007          	.insn	4, 0x92000007
 6b0:	0000                	unimp
 6b2:	0080                	addi	s0,sp,64
 6b4:	0000                	unimp
 6b6:	2200                	fld	fs0,0(a2)
 6b8:	00000027          	.insn	4, 0x0027
 6bc:	7901053f 55000007 	.insn	8, 0x550000077901053f
 6c4:	0001                	nop
 6c6:	5300                	lw	s0,32(a4)
 6c8:	0001                	nop
 6ca:	0100                	addi	s0,sp,128
 6cc:	0784                	addi	s1,sp,960
 6ce:	0000                	unimp
 6d0:	0160                	addi	s0,sp,140
 6d2:	0000                	unimp
 6d4:	015e                	slli	sp,sp,0x17
 6d6:	0000                	unimp
 6d8:	0000                	unimp
 6da:	5406                	lw	s0,96(sp)
 6dc:	72000007          	.insn	4, 0x72000007
 6e0:	0000                	unimp
 6e2:	0080                	addi	s0,sp,64
 6e4:	0000                	unimp
 6e6:	0c00                	addi	s0,sp,528
 6e8:	0072                	c.slli	zero,0x1c
 6ea:	8000                	.insn	2, 0x8000
 6ec:	0000                	unimp
 6ee:	0000                	unimp
 6f0:	000e                	c.slli	zero,0x3
 6f2:	0000                	unimp
 6f4:	0000                	unimp
 6f6:	0000                	unimp
 6f8:	6101094b          	fnmsub.s	fs2,ft2,fa6,fa2,rne
 6fc:	69000007          	.insn	4, 0x69000007
 700:	0001                	nop
 702:	6700                	ld	s0,8(a4)
 704:	0001                	nop
 706:	0700                	addi	s0,sp,896
 708:	0790                	addi	a2,sp,960
 70a:	0000                	unimp
 70c:	0072                	c.slli	zero,0x1c
 70e:	8000                	.insn	2, 0x8000
 710:	0000                	unimp
 712:	0000                	unimp
 714:	7210                	ld	a2,32(a2)
 716:	0000                	unimp
 718:	0080                	addi	s0,sp,64
 71a:	0000                	unimp
 71c:	0400                	addi	s0,sp,512
 71e:	0000                	unimp
 720:	0000                	unimp
 722:	0000                	unimp
 724:	3a00                	fld	fs0,48(a2)
 726:	110d                	addi	sp,sp,-29
 728:	01000007          	.insn	4, 0x01000007
 72c:	079f 0000 0171      	.insn	6, 0x01710000079f
 732:	0000                	unimp
 734:	0000016f          	jal	sp,734 <_start-0x7ffff8cc>
 738:	0600                	addi	s0,sp,768
 73a:	076c                	addi	a1,sp,908
 73c:	0000                	unimp
 73e:	007c                	addi	a5,sp,12
 740:	8000                	.insn	2, 0x8000
 742:	0000                	unimp
 744:	0000                	unimp
 746:	7c15                	lui	s8,0xfffe5
 748:	0000                	unimp
 74a:	0080                	addi	s0,sp,64
 74c:	0000                	unimp
 74e:	0400                	addi	s0,sp,512
 750:	0000                	unimp
 752:	0000                	unimp
 754:	0000                	unimp
 756:	3f00                	fld	fs0,56(a4)
 758:	0105                	addi	sp,sp,1
 75a:	0779                	addi	a4,a4,30
 75c:	0000                	unimp
 75e:	017e                	slli	sp,sp,0x1f
 760:	0000                	unimp
 762:	017c                	addi	a5,sp,140
 764:	0000                	unimp
 766:	8401                	c.srai64	s0
 768:	89000007          	.insn	4, 0x89000007
 76c:	0001                	nop
 76e:	8700                	.insn	2, 0x8700
 770:	0001                	nop
 772:	0000                	unimp
 774:	0000                	unimp
 776:	081d                	addi	a6,a6,7
 778:	0614                	addi	a3,sp,768
 77a:	0000                	unimp
 77c:	581e                	lw	a6,228(sp)
 77e:	0001                	nop
 780:	0100                	addi	s0,sp,128
 782:	6c010633          	.insn	4, 0x6c010633
 786:	1f000007          	.insn	4, 0x1f000007
 78a:	33010063          	beq	sp,a6,aaa <_start-0x7ffff556>
 78e:	0d15                	addi	s10,s10,5
 790:	0006                	c.slli	zero,0x1
 792:	0000                	unimp
 794:	3b20                	fld	fs0,112(a4)
 796:	0001                	nop
 798:	0100                	addi	s0,sp,128
 79a:	1429                	addi	s0,s0,-22
 79c:	00079003          	lh	zero,0(a5)
 7a0:	0b00                	addi	s0,sp,400
 7a2:	005d                	c.nop	23
 7a4:	0000                	unimp
 7a6:	2729                	addiw	a4,a4,10
 7a8:	0000006f          	j	7a8 <_start-0x7ffff858>
 7ac:	0000420b          	.insn	4, 0x420b
 7b0:	2900                	fld	fs0,16(a0)
 7b2:	4f35                	li	t5,13
 7b4:	0000                	unimp
 7b6:	0000                	unimp
 7b8:	450a                	lw	a0,128(sp)
 7ba:	0001                	nop
 7bc:	2200                	fld	fs0,0(a2)
 7be:	00004f17          	auipc	t5,0x4
 7c2:	ab00                	fsd	fs0,16(a4)
 7c4:	0b000007          	.insn	4, 0x0b000007
 7c8:	005d                	c.nop	23
 7ca:	0000                	unimp
 7cc:	2922                	fld	fs2,8(sp)
 7ce:	0000006f          	j	7ce <_start-0x7ffff832>
 7d2:	2100                	fld	fs0,0(a0)
 7d4:	0754                	addi	a3,sp,900
 7d6:	0000                	unimp
 7d8:	003a                	c.slli	zero,0xe
 7da:	8000                	.insn	2, 0x8000
 7dc:	0000                	unimp
 7de:	0000                	unimp
 7e0:	001a                	c.slli	zero,0x6
 7e2:	0000                	unimp
 7e4:	0000                	unimp
 7e6:	0000                	unimp
 7e8:	9c01                	subw	s0,s0,s0
 7ea:	6122                	ld	sp,8(sp)
 7ec:	01000007          	.insn	4, 0x01000007
 7f0:	055a                	slli	a0,a0,0x16
 7f2:	0790                	addi	a2,sp,960
 7f4:	0000                	unimp
 7f6:	0044                	addi	s1,sp,4
 7f8:	8000                	.insn	2, 0x8000
 7fa:	0000                	unimp
 7fc:	0000                	unimp
 7fe:	0c05                	addi	s8,s8,1 # fffffffffffe5001 <__kernel_end+0xffffffff7ffd4ca1>
 800:	0000                	unimp
 802:	3a00                	fld	fs0,48(a2)
 804:	ef0d                	bnez	a4,83e <_start-0x7ffff7c2>
 806:	01000007          	.insn	4, 0x01000007
 80a:	079f 0000 0191      	.insn	6, 0x01910000079f
 810:	0000                	unimp
 812:	0000018f          	.insn	4, 0x018f
 816:	0600                	addi	s0,sp,768
 818:	076c                	addi	a1,sp,908
 81a:	0000                	unimp
 81c:	004e                	c.slli	zero,0x13
 81e:	8000                	.insn	2, 0x8000
 820:	0000                	unimp
 822:	0000                	unimp
 824:	4e0a                	lw	t3,128(sp)
 826:	0000                	unimp
 828:	0080                	addi	s0,sp,64
 82a:	0000                	unimp
 82c:	0400                	addi	s0,sp,512
 82e:	0000                	unimp
 830:	0000                	unimp
 832:	0000                	unimp
 834:	3f00                	fld	fs0,56(a4)
 836:	0105                	addi	sp,sp,1
 838:	0779                	addi	a4,a4,30
 83a:	0000                	unimp
 83c:	019e                	slli	gp,gp,0x7
 83e:	0000                	unimp
 840:	019c                	addi	a5,sp,192
 842:	0000                	unimp
 844:	8401                	c.srai64	s0
 846:	a9000007          	.insn	4, 0xa9000007
 84a:	0001                	nop
 84c:	a700                	fsd	fs0,8(a4)
 84e:	0001                	nop
 850:	0000                	unimp
	...

Disassembly of section .debug_abbrev:

0000000000000000 <.debug_abbrev>:
   0:	1101                	addi	sp,sp,-32
   2:	1000                	addi	s0,sp,32
   4:	12011117          	auipc	sp,0x12011
   8:	1b0e030f          	.insn	4, 0x1b0e030f
   c:	250e                	fld	fa0,192(sp)
   e:	130e                	slli	t1,t1,0x23
  10:	0005                	c.nop	1
  12:	0000                	unimp
  14:	0501                	addi	a0,a0,0 # fffffffffffeb000 <__kernel_end+0xffffffff7ffdaca0>
  16:	3100                	fld	fs0,32(a0)
  18:	b7170213          	addi	tp,a4,-1167
  1c:	1742                	slli	a4,a4,0x30
  1e:	0000                	unimp
  20:	4902                	lw	s2,0(sp)
  22:	0200                	addi	s0,sp,256
  24:	7e18                	ld	a4,56(a2)
  26:	0018                	.insn	2, 0x0018
  28:	0300                	addi	s0,sp,384
  2a:	0148                	addi	a0,sp,132
  2c:	017d                	addi	sp,sp,31 # 12011023 <_start-0x6dfeefdd>
  2e:	1301137f 24040000 	.insn	12, 0x3e0b0b00240400001301137f
  36:	3e0b0b00 
  3a:	000e030b          	.insn	4, 0x000e030b
  3e:	0500                	addi	s0,sp,640
  40:	011d                	addi	sp,sp,7
  42:	1331                	addi	t1,t1,-20
  44:	0152                	slli	sp,sp,0x14
  46:	42b8                	lw	a4,64(a3)
  48:	5817550b          	.insn	4, 0x5817550b
  4c:	0121                	addi	sp,sp,8
  4e:	0b59                	addi	s6,s6,22
  50:	13010b57          	.insn	4, 0x13010b57
  54:	0000                	unimp
  56:	1d06                	slli	s10,s10,0x21
  58:	3101                	addiw	sp,sp,-32
  5a:	b8015213          	.insn	4, 0xb8015213
  5e:	0b42                	slli	s6,s6,0x10
  60:	0111                	addi	sp,sp,4
  62:	0712                	slli	a4,a4,0x4
  64:	2158                	fld	fa4,128(a0)
  66:	5901                	li	s2,-32
  68:	000b570b          	.insn	4, 0x000b570b
  6c:	0700                	addi	s0,sp,896
  6e:	011d                	addi	sp,sp,7
  70:	1331                	addi	t1,t1,-20
  72:	0152                	slli	sp,sp,0x14
  74:	42b8                	lw	a4,64(a3)
  76:	1201110b          	.insn	4, 0x1201110b
  7a:	01215807          	.insn	4, 0x01215807
  7e:	0b59                	addi	s6,s6,22
  80:	13010b57          	.insn	4, 0x13010b57
  84:	0000                	unimp
  86:	2e08                	fld	fa0,24(a2)
  88:	3f01                	addiw	t5,t5,-32 # 479e <_start-0x7fffb862>
  8a:	0319                	addi	t1,t1,6
  8c:	3a0e                	fld	fs4,224(sp)
  8e:	0121                	addi	sp,sp,8
  90:	21390b3b          	.insn	4, 0x21390b3b
  94:	2706                	fld	fa4,64(sp)
  96:	1119                	addi	sp,sp,-26
  98:	1201                	addi	tp,tp,-32 # ffffffffffffffe0 <__kernel_end+0xffffffff7ffefc80>
  9a:	7a184007          	.insn	4, 0x7a184007
  9e:	0119                	addi	sp,sp,6
  a0:	09000013          	li	zero,144
  a4:	011d                	addi	sp,sp,7
  a6:	1331                	addi	t1,t1,-20
  a8:	0152                	slli	sp,sp,0x14
  aa:	42b8                	lw	a4,64(a3)
  ac:	5817550b          	.insn	4, 0x5817550b
  b0:	0121                	addi	sp,sp,8
  b2:	0b59                	addi	s6,s6,22
  b4:	00000b57          	.insn	4, 0x0b57
  b8:	2e0a                	fld	ft8,128(sp)
  ba:	0301                	addi	t1,t1,0
  bc:	3a0e                	fld	fs4,224(sp)
  be:	0121                	addi	sp,sp,8
  c0:	0b390b3b          	.insn	4, 0x0b390b3b
  c4:	13491927          	.insn	4, 0x13491927
  c8:	2120                	fld	fs0,64(a0)
  ca:	00130103          	lb	sp,1(t1)
  ce:	0b00                	addi	s0,sp,400
  d0:	0005                	c.nop	1
  d2:	213a0e03          	lb	t3,531(s4)
  d6:	3b01                	addiw	s6,s6,-32
  d8:	490b390b          	.insn	4, 0x490b390b
  dc:	0c000013          	li	zero,192
  e0:	0016                	c.slli	zero,0x5
  e2:	213a0e03          	lb	t3,531(s4)
  e6:	3b02                	fld	fs6,32(sp)
  e8:	490b390b          	.insn	4, 0x490b390b
  ec:	0d000013          	li	zero,208
  f0:	0034                	addi	a3,sp,8
  f2:	1331                	addi	t1,t1,-20
  f4:	0000                	unimp
  f6:	480e                	lw	a6,192(sp)
  f8:	7d00                	ld	s0,56(a0)
  fa:	7f01                	lui	t5,0xfffe0
  fc:	0f000013          	li	zero,240
 100:	0148                	addi	a0,sp,132
 102:	017d                	addi	sp,sp,31
 104:	0000137f 03003410 	.insn	12, 0x01213a0e030034100000137f
 10c:	01213a0e 
 110:	21390b3b          	.insn	4, 0x21390b3b
 114:	490e                	lw	s2,192(sp)
 116:	11000013          	li	zero,272
 11a:	0111                	addi	sp,sp,4
 11c:	0e25                	addi	t3,t3,9 # 1a009 <_start-0x7ffe5ff7>
 11e:	01900b13          	li	s6,25
 122:	0601910b          	.insn	4, 0x0601910b
 126:	1f1b1f03          	lh	t5,497(s6)
 12a:	0111                	addi	sp,sp,4
 12c:	0712                	slli	a4,a4,0x4
 12e:	1710                	addi	a2,sp,928
 130:	0000                	unimp
 132:	2412                	fld	fs0,256(sp)
 134:	0b00                	addi	s0,sp,400
 136:	030b3e0b          	.insn	4, 0x030b3e0b
 13a:	0008                	.insn	2, 0x0008
 13c:	1300                	addi	s0,sp,416
 13e:	0005                	c.nop	1
 140:	0b3a0e03          	lb	t3,179(s4)
 144:	0b390b3b          	.insn	4, 0x0b390b3b
 148:	1349                	addi	t1,t1,-14
 14a:	1702                	slli	a4,a4,0x20
 14c:	001742b7          	lui	t0,0x174
 150:	1400                	addi	s0,sp,544
 152:	0034                	addi	a3,sp,8
 154:	0b3a0803          	lb	a6,179(s4)
 158:	0b390b3b          	.insn	4, 0x0b390b3b
 15c:	1349                	addi	t1,t1,-14
 15e:	1802                	slli	a6,a6,0x20
 160:	0000                	unimp
 162:	0b15                	addi	s6,s6,5
 164:	1101                	addi	sp,sp,-32
 166:	1201                	addi	tp,tp,-32 # ffffffffffffffe0 <__kernel_end+0xffffffff7ffefc80>
 168:	00130107          	.insn	4, 0x00130107
 16c:	1600                	addi	s0,sp,800
 16e:	0034                	addi	a3,sp,8
 170:	0b3a0803          	lb	a6,179(s4)
 174:	0b390b3b          	.insn	4, 0x0b390b3b
 178:	1349                	addi	t1,t1,-14
 17a:	1702                	slli	a4,a4,0x20
 17c:	001742b7          	lui	t0,0x174
 180:	1700                	addi	s0,sp,928
 182:	0101                	addi	sp,sp,0
 184:	1349                	addi	t1,t1,-14
 186:	1301                	addi	t1,t1,-32
 188:	0000                	unimp
 18a:	2118                	fld	fa4,0(a0)
 18c:	4900                	lw	s0,16(a0)
 18e:	000b2f13          	slti	t5,s6,0
 192:	1900                	addi	s0,sp,176
 194:	0026                	c.slli	zero,0x9
 196:	1349                	addi	t1,t1,-14
 198:	0000                	unimp
 19a:	051a                	slli	a0,a0,0x6
 19c:	0300                	addi	s0,sp,384
 19e:	3a08                	fld	fa0,48(a2)
 1a0:	390b3b0b          	.insn	4, 0x390b3b0b
 1a4:	0213490b          	.insn	4, 0x0213490b
 1a8:	1742b717          	auipc	a4,0x1742b
 1ac:	0000                	unimp
 1ae:	31011d1b          	.insn	4, 0x31011d1b
 1b2:	58175513          	.insn	4, 0x58175513
 1b6:	570b590b          	.insn	4, 0x570b590b
 1ba:	0013010b          	.insn	4, 0x0013010b
 1be:	1c00                	addi	s0,sp,560
 1c0:	0005                	c.nop	1
 1c2:	1331                	addi	t1,t1,-20
 1c4:	0000                	unimp
 1c6:	0f1d                	addi	t5,t5,7 # fffffffffffe0007 <__kernel_end+0xffffffff7ffcfca7>
 1c8:	0b00                	addi	s0,sp,400
 1ca:	0013490b          	.insn	4, 0x0013490b
 1ce:	1e00                	addi	s0,sp,816
 1d0:	012e                	slli	sp,sp,0xb
 1d2:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 1da:	0b39                	addi	s6,s6,14
 1dc:	0b201927          	.insn	4, 0x0b201927
 1e0:	1301                	addi	t1,t1,-32
 1e2:	0000                	unimp
 1e4:	051f 0300 3a08      	.insn	6, 0x3a080300051f
 1ea:	390b3b0b          	.insn	4, 0x390b3b0b
 1ee:	0013490b          	.insn	4, 0x0013490b
 1f2:	2000                	fld	fs0,0(s0)
 1f4:	012e                	slli	sp,sp,0xb
 1f6:	0b3a0e03          	lb	t3,179(s4)
 1fa:	0b390b3b          	.insn	4, 0x0b390b3b
 1fe:	0b201927          	.insn	4, 0x0b201927
 202:	1301                	addi	t1,t1,-32
 204:	0000                	unimp
 206:	2e21                	addiw	t3,t3,8
 208:	3101                	addiw	sp,sp,-32
 20a:	12011113          	.insn	4, 0x12011113
 20e:	7a184007          	.insn	4, 0x7a184007
 212:	0019                	c.nop	6
 214:	2200                	fld	fs0,0(a2)
 216:	0005                	c.nop	1
 218:	1331                	addi	t1,t1,-20
 21a:	1802                	slli	a6,a6,0x20
 21c:	0000                	unimp
	...

Disassembly of section .debug_aranges:

0000000000000000 <.debug_aranges>:
   0:	002c                	addi	a1,sp,8
   2:	0000                	unimp
   4:	0002                	c.slli64	zero
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0008                	.insn	2, 0x0008
   c:	0000                	unimp
   e:	0000                	unimp
  10:	0000                	unimp
  12:	8000                	.insn	2, 0x8000
  14:	0000                	unimp
  16:	0000                	unimp
  18:	003a                	c.slli	zero,0xe
	...
  2e:	0000                	unimp
  30:	002c                	addi	a1,sp,8
  32:	0000                	unimp
  34:	0002                	c.slli64	zero
  36:	0028                	addi	a0,sp,8
  38:	0000                	unimp
  3a:	0008                	.insn	2, 0x0008
  3c:	0000                	unimp
  3e:	0000                	unimp
  40:	003a                	c.slli	zero,0xe
  42:	8000                	.insn	2, 0x8000
  44:	0000                	unimp
  46:	0000                	unimp
  48:	01e0                	addi	s0,sp,204
	...

Disassembly of section .debug_str:

0000000000000000 <.debug_str>:
   0:	2f637273          	csrrci	tp,0x2f6,6
   4:	6f62                	ld	t5,24(sp)
   6:	532e746f          	jal	s0,e7538 <_start-0x7ff18ac8>
   a:	2f00                	fld	fs0,24(a4)
   c:	7355                	lui	t1,0xffff5
   e:	7265                	lui	tp,0xffff9
  10:	696d2f73          	csrrs	t5,0x696,s10
  14:	7a62                	ld	s4,56(sp)
  16:	726f772f          	.insn	4, 0x726f772f
  1a:	65722f6b          	.insn	4, 0x65722f6b
  1e:	6f70                	ld	a2,216(a4)
  20:	696d2f73          	csrrs	t5,0x696,s10
  24:	7a62                	ld	s4,56(sp)
  26:	4700736f          	jal	t1,7496 <_start-0x7fff8b6a>
  2a:	554e                	lw	a0,240(sp)
  2c:	4120                	lw	s0,64(a0)
  2e:	2e322053          	.insn	4, 0x2e322053
  32:	3534                	fld	fa3,104(a0)
  34:	7200                	ld	s0,32(a2)
  36:	6165                	addi	sp,sp,112
  38:	5f64                	lw	s1,124(a4)
  3a:	686d                	lui	a6,0x1b
  3c:	7261                	lui	tp,0xffff8
  3e:	6974                	ld	a3,208(a0)
  40:	0064                	addi	s1,sp,12
  42:	6176                	ld	sp,344(sp)
  44:	756c                	ld	a1,232(a0)
  46:	0065                	c.nop	25
  48:	6975                	lui	s2,0x1d
  4a:	746e                	ld	s0,248(sp)
  4c:	3436                	fld	fs0,360(sp)
  4e:	745f 7500 7261      	.insn	6, 0x72617500745f
  54:	5f74                	lw	a3,124(a4)
  56:	7570                	ld	a2,232(a0)
  58:	6874                	ld	a3,208(s0)
  5a:	7865                	lui	a6,0xffff9
  5c:	6100                	ld	s0,0(a0)
  5e:	6464                	ld	s1,200(s0)
  60:	0072                	c.slli	zero,0x1c
  62:	6e75                	lui	t3,0x1d
  64:	6e676973          	csrrsi	s2,0x6e6,14
  68:	6465                	lui	s0,0x19
  6a:	6320                	ld	s0,64(a4)
  6c:	6168                	ld	a0,192(a0)
  6e:	0072                	c.slli	zero,0x1c
  70:	6f6c                	ld	a1,216(a4)
  72:	676e                	ld	a4,216(sp)
  74:	7520                	ld	s0,104(a0)
  76:	736e                	ld	t1,248(sp)
  78:	6769                	lui	a4,0x1a
  7a:	656e                	ld	a0,216(sp)
  7c:	2064                	fld	fs1,192(s0)
  7e:	6e69                	lui	t3,0x1a
  80:	0074                	addi	a3,sp,12
  82:	726f6873          	csrrsi	a6,mhpmevent6h,30
  86:	2074                	fld	fa3,192(s0)
  88:	6e75                	lui	t3,0x1d
  8a:	6e676973          	csrrsi	s2,0x6e6,14
  8e:	6465                	lui	s0,0x19
  90:	6920                	ld	s0,80(a0)
  92:	746e                	ld	s0,248(sp)
  94:	7200                	ld	s0,32(a2)
  96:	6165                	addi	sp,sp,112
  98:	5f64                	lw	s1,124(a4)
  9a:	736d                	lui	t1,0xffffb
  9c:	6174                	ld	a3,192(a0)
  9e:	7574                	ld	a3,232(a0)
  a0:	4e470073          	.insn	4, 0x4e470073
  a4:	2055                	.insn	2, 0x2055
  a6:	20333243          	fmadd.s	ft4,ft6,ft3,ft4,rup
  aa:	3531                	addiw	a0,a0,-20
  ac:	312e                	fld	ft2,232(sp)
  ae:	302e                	fld	ft0,232(sp)
  b0:	2d20                	fld	fs0,88(a0)
  b2:	616d                	addi	sp,sp,240
  b4:	6962                	ld	s2,24(sp)
  b6:	6c3d                	lui	s8,0xf
  b8:	3670                	fld	fa2,232(a2)
  ba:	6434                	ld	a3,72(s0)
  bc:	2d20                	fld	fs0,88(a0)
  be:	636d                	lui	t1,0x1b
  c0:	6f6d                	lui	t5,0x1b
  c2:	6564                	ld	s1,200(a0)
  c4:	3d6c                	fld	fa1,248(a0)
  c6:	656d                	lui	a0,0x1b
  c8:	6164                	ld	s1,192(a0)
  ca:	796e                	ld	s2,248(sp)
  cc:	2d20                	fld	fs0,88(a0)
  ce:	696d                	lui	s2,0x1b
  d0:	732d6173          	csrrsi	sp,mhpmevent18h,26
  d4:	6570                	ld	a2,200(a0)
  d6:	30323d63          	.insn	4, 0x30323d63
  da:	3931                	addiw	s2,s2,-20 # 1afec <_start-0x7ffe5014>
  dc:	3231                	addiw	tp,tp,-20 # ffffffffffff7fec <__kernel_end+0xffffffff7ffe7c8c>
  de:	3331                	addiw	t1,t1,-20 # 1afec <_start-0x7ffe5014>
  e0:	2d20                	fld	fs0,88(a0)
  e2:	616d                	addi	sp,sp,240
  e4:	6372                	ld	t1,280(sp)
  e6:	3d68                	fld	fa0,248(a0)
  e8:	7672                	ld	a2,312(sp)
  ea:	3436                	fld	fs0,360(sp)
  ec:	6d69                	lui	s10,0x1a
  ee:	6661                	lui	a2,0x18
  f0:	6364                	ld	s1,192(a4)
  f2:	7a5f 6369 7273      	.insn	6, 0x727363697a5f
  f8:	7a5f 6669 6e65      	.insn	6, 0x6e6566697a5f
  fe:	5f696563          	bltu	s2,s6,6e8 <_start-0x7ffff918>
 102:	6d7a                	ld	s10,408(sp)
 104:	756d                	lui	a0,0xffffb
 106:	5f6c                	lw	a1,124(a4)
 108:	617a                	ld	sp,408(sp)
 10a:	6d61                	lui	s10,0x18
 10c:	617a5f6f          	jal	t5,a5f22 <_start-0x7ff5a0de>
 110:	726c                	ld	a1,224(a2)
 112:	7a5f6373          	csrrsi	t1,tcontrol,30
 116:	7a5f6163          	bltu	t5,t0,8b8 <_start-0x7ffff748>
 11a:	2d206463          	bltu	zero,s2,3e2 <_start-0x7ffffc1e>
 11e:	4f2d2067          	.insn	4, 0x4f2d2067
 122:	2032                	fld	ft0,264(sp)
 124:	662d                	lui	a2,0xb
 126:	7266                	ld	tp,120(sp)
 128:	6565                	lui	a0,0x19
 12a:	6e617473          	csrrci	s0,0x6e6,2
 12e:	6964                	ld	s1,208(a0)
 130:	676e                	ld	a4,216(sp)
 132:	7500                	ld	s0,40(a0)
 134:	6e69                	lui	t3,0x1a
 136:	3874                	fld	fa3,240(s0)
 138:	745f 7700 6972      	.insn	6, 0x69727700745f
 13e:	6574                	ld	a3,200(a0)
 140:	725f 6765 7200      	.insn	6, 0x72006765725f
 146:	6165                	addi	sp,sp,112
 148:	5f64                	lw	s1,124(a4)
 14a:	6572                	ld	a0,280(sp)
 14c:	68730067          	jr	1671(t1)
 150:	2074726f          	jal	tp,47b56 <_start-0x7ffb84aa>
 154:	6e69                	lui	t3,0x1a
 156:	0074                	addi	a3,sp,12
 158:	6175                	addi	sp,sp,368
 15a:	7472                	ld	s0,312(sp)
 15c:	705f 7475 0063      	.insn	6, 0x00637475705f
 162:	6f6c                	ld	a1,216(a4)
 164:	676e                	ld	a4,216(sp)
 166:	6920                	ld	s0,80(a0)
 168:	746e                	ld	s0,248(sp)
 16a:	6b00                	ld	s0,16(a4)
 16c:	7265                	lui	tp,0xffff9
 16e:	656e                	ld	a0,216(sp)
 170:	5f6c                	lw	a1,124(a4)
 172:	616d                	addi	sp,sp,240
 174:	6e69                	lui	t3,0x1a
 176:	7500                	ld	s0,40(a0)
 178:	7261                	lui	tp,0xffff8
 17a:	5f74                	lw	a3,124(a4)
 17c:	7570                	ld	a2,232(a0)
 17e:	7374                	ld	a3,224(a4)
	...

Disassembly of section .debug_loclists:

0000000000000000 <.debug_loclists>:
   0:	000001ab          	.insn	4, 0x01ab
   4:	0005                	c.nop	1
   6:	0008                	.insn	2, 0x0008
   8:	0000                	unimp
   a:	0000                	unimp
   c:	1f12                	slli	t5,t5,0x24
   e:	9a04                	.insn	2, 0x9a04
  10:	b402                	fsd	ft0,40(sp)
  12:	0202                	c.slli64	tp
  14:	9f3a                	add	t5,t5,a4
  16:	1700                	addi	s0,sp,928
  18:	0419                	addi	s0,s0,6 # 19006 <_start-0x7ffe6ffa>
  1a:	02a4                	addi	s1,sp,328
  1c:	02a4                	addi	s1,sp,328
  1e:	0c06                	slli	s8,s8,0x1
  20:	0005                	c.nop	1
  22:	1000                	addi	s0,sp,32
  24:	009f 1f1c ae04      	.insn	6, 0xae041f1c009f
  2a:	b402                	fsd	ft0,40(sp)
  2c:	0402                	c.slli64	s0
  2e:	4840                	lw	s0,20(s0)
  30:	9f24                	.insn	2, 0x9f24
  32:	1c00                	addi	s0,sp,560
  34:	041f 02ae 02b4      	.insn	6, 0x02b402ae041f
  3a:	3a02                	fld	fs4,32(sp)
  3c:	009f 3528 c804      	.insn	6, 0xc8043528009f
  42:	e202                	sd	zero,256(sp)
  44:	0202                	c.slli64	tp
  46:	9f3a                	add	t5,t5,a4
  48:	2d00                	fld	fs0,24(a0)
  4a:	02d2042f          	.insn	4, 0x02d2042f
  4e:	02d2                	slli	t0,t0,0x14
  50:	0c06                	slli	s8,s8,0x1
  52:	0005                	c.nop	1
  54:	1000                	addi	s0,sp,32
  56:	009f 3532 dc04      	.insn	6, 0xdc043532009f
  5c:	e202                	sd	zero,256(sp)
  5e:	0402                	c.slli64	s0
  60:	4840                	lw	s0,20(s0)
  62:	9f24                	.insn	2, 0x9f24
  64:	3200                	fld	fs0,32(a2)
  66:	0435                	addi	s0,s0,13
  68:	02dc                	addi	a5,sp,324
  6a:	02e2                	slli	t0,t0,0x18
  6c:	3a02                	fld	fs4,32(sp)
  6e:	009f 4639 f604      	.insn	6, 0xf6044639009f
  74:	9002                	ebreak
  76:	9f3a0203          	lb	tp,-1549(s4)
  7a:	3e00                	fld	fs0,56(a2)
  7c:	0440                	addi	s0,sp,516
  7e:	0380                	addi	s0,sp,448
  80:	0380                	addi	s0,sp,448
  82:	0c06                	slli	s8,s8,0x1
  84:	0005                	c.nop	1
  86:	1000                	addi	s0,sp,32
  88:	009f 4643 8a04      	.insn	6, 0x8a044643009f
  8e:	04039003          	lh	zero,64(t2)
  92:	4840                	lw	s0,20(s0)
  94:	9f24                	.insn	2, 0x9f24
  96:	4300                	lw	s0,0(a4)
  98:	0446                	slli	s0,s0,0x11
  9a:	038a                	slli	t2,t2,0x2
  9c:	0390                	addi	a2,sp,448
  9e:	3a02                	fld	fs4,32(sp)
  a0:	009f 594a a404      	.insn	6, 0xa404594a009f
  a6:	0203c603          	lbu	a2,32(t2)
  aa:	9f3a                	add	t5,t5,a4
  ac:	4f00                	lw	s0,24(a4)
  ae:	0451                	addi	s0,s0,20
  b0:	03ae                	slli	t2,t2,0xb
  b2:	03ae                	slli	t2,t2,0xb
  b4:	0c06                	slli	s8,s8,0x1
  b6:	0005                	c.nop	1
  b8:	1000                	addi	s0,sp,32
  ba:	009f 5954 b804      	.insn	6, 0xb8045954009f
  c0:	0403c603          	lbu	a2,64(t2)
  c4:	4840                	lw	s0,20(s0)
  c6:	9f24                	.insn	2, 0x9f24
  c8:	5400                	lw	s0,40(s0)
  ca:	0459                	addi	s0,s0,22
  cc:	03b8                	addi	a4,sp,456
  ce:	03c6                	slli	t2,t2,0x11
  d0:	3a02                	fld	fs4,32(sp)
  d2:	009f 0500 2405      	.insn	6, 0x24050500009f
  d8:	0024                	addi	s1,sp,8
  da:	5e04                	lw	s1,56(a2)
  dc:	0180                	addi	s0,sp,192
  de:	5a01                	li	s4,-32
  e0:	8004                	.insn	2, 0x8004
  e2:	c201                	beqz	a2,e2 <_start-0x7fffff1e>
  e4:	0101                	addi	sp,sp,0
  e6:	0458                	addi	a4,sp,516
  e8:	01c2                	slli	gp,gp,0x10
  ea:	01c6                	slli	gp,gp,0x11
  ec:	a304                	fsd	fs1,0(a4)
  ee:	5a01                	li	s4,-32
  f0:	009f 100b 0010      	.insn	6, 0x0010100b009f
  f6:	8e04                	.insn	2, 0x8e04
  f8:	9e01                	subw	a2,a2,s0
  fa:	0301                	addi	t1,t1,0
  fc:	3c08                	fld	fa0,56(s0)
  fe:	049f 019e 01c6      	.insn	6, 0x01c6019e049f
 104:	5d01                	li	s10,-32
 106:	1400                	addi	s0,sp,544
 108:	0420                	addi	s0,sp,520
 10a:	01aa                	slli	gp,gp,0xa
 10c:	01b8                	addi	a4,sp,200
 10e:	5c01                	li	s8,-32
 110:	1800                	addi	s0,sp,48
 112:	041a                	slli	s0,s0,0x6
 114:	01aa                	slli	gp,gp,0xa
 116:	01aa                	slli	gp,gp,0xa
 118:	0c06                	slli	s8,s8,0x1
 11a:	0005                	c.nop	1
 11c:	1000                	addi	s0,sp,32
 11e:	009f 201d b404      	.insn	6, 0xb404201d009f
 124:	b801                	j	fffffffffffff934 <__kernel_end+0xffffffff7ffef5d4>
 126:	0401                	addi	s0,s0,0
 128:	4840                	lw	s0,20(s0)
 12a:	9f24                	.insn	2, 0x9f24
 12c:	1d00                	addi	s0,sp,688
 12e:	0420                	addi	s0,sp,520
 130:	01b4                	addi	a3,sp,200
 132:	01b8                	addi	a4,sp,200
 134:	5c01                	li	s8,-32
 136:	0000                	unimp
 138:	0c0c                	addi	a1,sp,528
 13a:	0400                	addi	s0,sp,512
 13c:	381a                	fld	fa6,416(sp)
 13e:	5a01                	li	s4,-32
 140:	3804                	fld	fs1,48(s0)
 142:	015e                	slli	sp,sp,0x17
 144:	005a                	c.slli	zero,0x16
 146:	1f1d                	addi	t5,t5,-25 # 1afe7 <_start-0x7ffe5019>
 148:	4e04                	lw	s1,24(a2)
 14a:	064e                	slli	a2,a2,0x13
 14c:	050c                	addi	a1,sp,640
 14e:	0000                	unimp
 150:	9f10                	.insn	2, 0x9f10
 152:	2200                	fld	fs0,0(a2)
 154:	0425                	addi	s0,s0,9
 156:	5c58                	lw	a4,60(s0)
 158:	4004                	lw	s1,0(s0)
 15a:	2448                	fld	fa0,136(s0)
 15c:	009f 2522 5804      	.insn	6, 0x58042522009f
 162:	025c                	addi	a5,sp,260
 164:	9f3d                	addw	a4,a4,a5
 166:	0c00                	addi	s0,sp,528
 168:	0418                	addi	a4,sp,512
 16a:	4638                	lw	a4,72(a2)
 16c:	5d01                	li	s10,-32
 16e:	1000                	addi	s0,sp,32
 170:	0412                	slli	s0,s0,0x4
 172:	3838                	fld	fa4,112(s0)
 174:	0c06                	slli	s8,s8,0x1
 176:	0005                	c.nop	1
 178:	1000                	addi	s0,sp,32
 17a:	009f 1815 4204      	.insn	6, 0x42041815009f
 180:	0446                	slli	s0,s0,0x11
 182:	4840                	lw	s0,20(s0)
 184:	9f24                	.insn	2, 0x9f24
 186:	1500                	addi	s0,sp,672
 188:	0418                	addi	a4,sp,512
 18a:	4642                	lw	a2,16(sp)
 18c:	5d01                	li	s10,-32
 18e:	0500                	addi	s0,sp,640
 190:	0a0a0407          	.insn	4, 0x0a0a0407
 194:	0c06                	slli	s8,s8,0x1
 196:	0005                	c.nop	1
 198:	1000                	addi	s0,sp,32
 19a:	009f 0d0a 1404      	.insn	6, 0x14040d0a009f
 1a0:	0418                	addi	a4,sp,512
 1a2:	4840                	lw	s0,20(s0)
 1a4:	9f24                	.insn	2, 0x9f24
 1a6:	0a00                	addi	s0,sp,272
 1a8:	040d                	addi	s0,s0,3
 1aa:	1814                	addi	a3,sp,48
 1ac:	5a01                	li	s4,-32
	...

Disassembly of section .debug_rnglists:

0000000000000000 <.debug_rnglists>:
   0:	008c                	addi	a1,sp,64
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0008                	.insn	2, 0x0008
   8:	0000                	unimp
   a:	0000                	unimp
   c:	0004                	.insn	2, 0x0004
   e:	040a                	slli	s0,s0,0x2
  10:	0e0a                	slli	t3,t3,0x2
  12:	0400                	addi	s0,sp,512
  14:	2620                	fld	fs0,72(a2)
  16:	2804                	fld	fs1,16(s0)
  18:	042e                	slli	s0,s0,0xb
  1a:	5e4e                	lw	t3,240(sp)
  1c:	0400                	addi	s0,sp,512
  1e:	2620                	fld	fs0,72(a2)
  20:	2804                	fld	fs1,16(s0)
  22:	042c                	addi	a1,sp,520
  24:	524e                	lw	tp,240(sp)
  26:	0400                	addi	s0,sp,512
  28:	2e2c                	fld	fa1,88(a2)
  2a:	5804                	lw	s1,48(s0)
  2c:	005c                	addi	a5,sp,4
  2e:	8e04                	.insn	2, 0x8e04
  30:	9401                	srai	s0,s0,0x20
  32:	0401                	addi	s0,s0,0
  34:	0198                	addi	a4,sp,192
  36:	019c                	addi	a5,sp,192
  38:	aa04                	fsd	fs1,16(a2)
  3a:	b801                	j	fffffffffffff84a <__kernel_end+0xffffffff7ffef4ea>
  3c:	0001                	nop
  3e:	8e04                	.insn	2, 0x8e04
  40:	9401                	srai	s0,s0,0x20
  42:	0401                	addi	s0,s0,0
  44:	0198                	addi	a4,sp,192
  46:	019c                	addi	a5,sp,192
  48:	aa04                	fsd	fs1,16(a2)
  4a:	ae01                	j	35a <_start-0x7ffffca6>
  4c:	0001                	nop
  4e:	9a04                	.insn	2, 0x9a04
  50:	a402                	fsd	ft0,8(sp)
  52:	0402                	c.slli64	s0
  54:	02a4                	addi	s1,sp,328
  56:	02a8                	addi	a0,sp,328
  58:	0400                	addi	s0,sp,512
  5a:	02c8                	addi	a0,sp,324
  5c:	02d2                	slli	t0,t0,0x14
  5e:	d204                	sw	s1,32(a2)
  60:	d602                	sw	zero,44(sp)
  62:	0002                	c.slli64	zero
  64:	f604                	sd	s1,40(a2)
  66:	8002                	.insn	2, 0x8002
  68:	03800403          	lb	s0,56(zero) # 38 <_start-0x7fffffc8>
  6c:	0384                	addi	s1,sp,448
  6e:	0400                	addi	s0,sp,512
  70:	03a4                	addi	s1,sp,456
  72:	03ba                	slli	t2,t2,0xe
  74:	c204                	sw	s1,0(a2)
  76:	0003c603          	lbu	a2,0(t2)
  7a:	a404                	fsd	fs1,8(s0)
  7c:	0403ae03          	lw	t3,64(t2)
  80:	03ae                	slli	t2,t2,0xb
  82:	03b2                	slli	t2,t2,0xc
  84:	0400                	addi	s0,sp,512
  86:	03b8                	addi	a4,sp,456
  88:	03ba                	slli	t2,t2,0xe
  8a:	c204                	sw	s1,0(a2)
  8c:	0003c603          	lbu	a2,0(t2)

Disassembly of section .debug_frame:

0000000000000000 <.debug_frame>:
   0:	000c                	.insn	2, 0x000c
   2:	0000                	unimp
   4:	ffff                	.insn	2, 0xffff
   6:	ffff                	.insn	2, 0xffff
   8:	7c010003          	lb	zero,1984(sp)
   c:	0c01                	addi	s8,s8,0 # f000 <_start-0x7fff1000>
   e:	0002                	c.slli64	zero
  10:	0014                	.insn	2, 0x0014
  12:	0000                	unimp
  14:	0000                	unimp
  16:	0000                	unimp
  18:	003a                	c.slli	zero,0xe
  1a:	8000                	.insn	2, 0x8000
  1c:	0000                	unimp
  1e:	0000                	unimp
  20:	001a                	c.slli	zero,0x6
  22:	0000                	unimp
  24:	0000                	unimp
  26:	0000                	unimp
  28:	0014                	.insn	2, 0x0014
  2a:	0000                	unimp
  2c:	0000                	unimp
  2e:	0000                	unimp
  30:	0054                	addi	a3,sp,4
  32:	8000                	.insn	2, 0x8000
  34:	0000                	unimp
  36:	0000                	unimp
  38:	0044                	addi	s1,sp,4
  3a:	0000                	unimp
  3c:	0000                	unimp
  3e:	0000                	unimp
  40:	0024                	addi	s1,sp,8
  42:	0000                	unimp
  44:	0000                	unimp
  46:	0000                	unimp
  48:	0098                	addi	a4,sp,64
  4a:	8000                	.insn	2, 0x8000
  4c:	0000                	unimp
  4e:	0000                	unimp
  50:	0068                	addi	a0,sp,12
  52:	0000                	unimp
  54:	0000                	unimp
  56:	0000                	unimp
  58:	0e56                	slli	t3,t3,0x15
  5a:	4230                	lw	a2,64(a2)
  5c:	0488                	addi	a0,sp,576
  5e:	8150                	.insn	2, 0x8150
  60:	7a02                	ld	s4,32(sp)
  62:	42c1                	li	t0,16
  64:	42c8                	lw	a0,4(a3)
  66:	000e                	c.slli	zero,0x3
  68:	001c                	.insn	2, 0x001c
  6a:	0000                	unimp
  6c:	0000                	unimp
  6e:	0000                	unimp
  70:	0100                	addi	s0,sp,128
  72:	8000                	.insn	2, 0x8000
  74:	0000                	unimp
  76:	0000                	unimp
  78:	011a                	slli	sp,sp,0x6
  7a:	0000                	unimp
  7c:	0000                	unimp
  7e:	0000                	unimp
  80:	0e42                	slli	t3,t3,0x10
  82:	4a10                	lw	a2,16(a2)
  84:	0281                	addi	t0,t0,0 # 174000 <_start-0x7fe8c000>
	...
