
input:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 82 2f 00 00    	push   QWORD PTR [rip+0x2f82]        # 3fa8 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 83 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f83]        # 3fb0 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nop    DWORD PTR [rax]
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	push   0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    103f:	90                   	nop
    1040:	f3 0f 1e fa          	endbr64 
    1044:	68 01 00 00 00       	push   0x1
    1049:	f2 e9 d1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    104f:	90                   	nop
    1050:	f3 0f 1e fa          	endbr64 
    1054:	68 02 00 00 00       	push   0x2
    1059:	f2 e9 c1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    105f:	90                   	nop
    1060:	f3 0f 1e fa          	endbr64 
    1064:	68 03 00 00 00       	push   0x3
    1069:	f2 e9 b1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    106f:	90                   	nop

Disassembly of section .plt.got:

0000000000001070 <__cxa_finalize@plt>:
    1070:	f3 0f 1e fa          	endbr64 
    1074:	f2 ff 25 7d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f7d]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    107b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

0000000000001080 <strcpy@plt>:
    1080:	f3 0f 1e fa          	endbr64 
    1084:	f2 ff 25 2d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f2d]        # 3fb8 <strcpy@GLIBC_2.2.5>
    108b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000001090 <__stack_chk_fail@plt>:
    1090:	f3 0f 1e fa          	endbr64 
    1094:	f2 ff 25 25 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f25]        # 3fc0 <__stack_chk_fail@GLIBC_2.4>
    109b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010a0 <printf@plt>:
    10a0:	f3 0f 1e fa          	endbr64 
    10a4:	f2 ff 25 1d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f1d]        # 3fc8 <printf@GLIBC_2.2.5>
    10ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000010b0 <fgets@plt>:
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	f2 ff 25 15 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f15]        # 3fd0 <fgets@GLIBC_2.2.5>
    10bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

00000000000010c0 <_start>:
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	31 ed                	xor    ebp,ebp
    10c6:	49 89 d1             	mov    r9,rdx
    10c9:	5e                   	pop    rsi
    10ca:	48 89 e2             	mov    rdx,rsp
    10cd:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    10d1:	50                   	push   rax
    10d2:	54                   	push   rsp
    10d3:	45 31 c0             	xor    r8d,r8d
    10d6:	31 c9                	xor    ecx,ecx
    10d8:	48 8d 3d ca 00 00 00 	lea    rdi,[rip+0xca]        # 11a9 <main>
    10df:	ff 15 f3 2e 00 00    	call   QWORD PTR [rip+0x2ef3]        # 3fd8 <__libc_start_main@GLIBC_2.34>
    10e5:	f4                   	hlt    
    10e6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    10ed:	00 00 00 

00000000000010f0 <deregister_tm_clones>:
    10f0:	48 8d 3d 21 2f 00 00 	lea    rdi,[rip+0x2f21]        # 4018 <__TMC_END__>
    10f7:	48 8d 05 1a 2f 00 00 	lea    rax,[rip+0x2f1a]        # 4018 <__TMC_END__>
    10fe:	48 39 f8             	cmp    rax,rdi
    1101:	74 15                	je     1118 <deregister_tm_clones+0x28>
    1103:	48 8b 05 d6 2e 00 00 	mov    rax,QWORD PTR [rip+0x2ed6]        # 3fe0 <_ITM_deregisterTMCloneTable@Base>
    110a:	48 85 c0             	test   rax,rax
    110d:	74 09                	je     1118 <deregister_tm_clones+0x28>
    110f:	ff e0                	jmp    rax
    1111:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1118:	c3                   	ret    
    1119:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001120 <register_tm_clones>:
    1120:	48 8d 3d f1 2e 00 00 	lea    rdi,[rip+0x2ef1]        # 4018 <__TMC_END__>
    1127:	48 8d 35 ea 2e 00 00 	lea    rsi,[rip+0x2eea]        # 4018 <__TMC_END__>
    112e:	48 29 fe             	sub    rsi,rdi
    1131:	48 89 f0             	mov    rax,rsi
    1134:	48 c1 ee 3f          	shr    rsi,0x3f
    1138:	48 c1 f8 03          	sar    rax,0x3
    113c:	48 01 c6             	add    rsi,rax
    113f:	48 d1 fe             	sar    rsi,1
    1142:	74 14                	je     1158 <register_tm_clones+0x38>
    1144:	48 8b 05 a5 2e 00 00 	mov    rax,QWORD PTR [rip+0x2ea5]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    114b:	48 85 c0             	test   rax,rax
    114e:	74 08                	je     1158 <register_tm_clones+0x38>
    1150:	ff e0                	jmp    rax
    1152:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1158:	c3                   	ret    
    1159:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001160 <__do_global_dtors_aux>:
    1160:	f3 0f 1e fa          	endbr64 
    1164:	80 3d bd 2e 00 00 00 	cmp    BYTE PTR [rip+0x2ebd],0x0        # 4028 <completed.0>
    116b:	75 2b                	jne    1198 <__do_global_dtors_aux+0x38>
    116d:	55                   	push   rbp
    116e:	48 83 3d 82 2e 00 00 	cmp    QWORD PTR [rip+0x2e82],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1175:	00 
    1176:	48 89 e5             	mov    rbp,rsp
    1179:	74 0c                	je     1187 <__do_global_dtors_aux+0x27>
    117b:	48 8b 3d 86 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2e86]        # 4008 <__dso_handle>
    1182:	e8 e9 fe ff ff       	call   1070 <__cxa_finalize@plt>
    1187:	e8 64 ff ff ff       	call   10f0 <deregister_tm_clones>
    118c:	c6 05 95 2e 00 00 01 	mov    BYTE PTR [rip+0x2e95],0x1        # 4028 <completed.0>
    1193:	5d                   	pop    rbp
    1194:	c3                   	ret    
    1195:	0f 1f 00             	nop    DWORD PTR [rax]
    1198:	c3                   	ret    
    1199:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000011a0 <frame_dummy>:
    11a0:	f3 0f 1e fa          	endbr64 
    11a4:	e9 77 ff ff ff       	jmp    1120 <register_tm_clones>

00000000000011a9 <main>:
    11a9:	f3 0f 1e fa          	endbr64 
    11ad:	55                   	push   rbp
    11ae:	48 89 e5             	mov    rbp,rsp
    11b1:	48 81 ec e0 00 00 00 	sub    rsp,0xe0
    11b8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    11bf:	00 00 
    11c1:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    11c5:	31 c0                	xor    eax,eax
    11c7:	48 8d 05 36 0e 00 00 	lea    rax,[rip+0xe36]        # 2004 <_IO_stdin_used+0x4>
    11ce:	48 89 c7             	mov    rdi,rax
    11d1:	b8 00 00 00 00       	mov    eax,0x0
    11d6:	e8 c5 fe ff ff       	call   10a0 <printf@plt>
    11db:	48 8b 15 3e 2e 00 00 	mov    rdx,QWORD PTR [rip+0x2e3e]        # 4020 <stdin@GLIBC_2.2.5>
    11e2:	48 8d 85 20 ff ff ff 	lea    rax,[rbp-0xe0]
    11e9:	be 64 00 00 00       	mov    esi,0x64
    11ee:	48 89 c7             	mov    rdi,rax
    11f1:	e8 ba fe ff ff       	call   10b0 <fgets@plt>
    11f6:	48 8d 95 20 ff ff ff 	lea    rdx,[rbp-0xe0]
    11fd:	48 8d 45 90          	lea    rax,[rbp-0x70]
    1201:	48 89 d6             	mov    rsi,rdx
    1204:	48 89 c7             	mov    rdi,rax
    1207:	e8 74 fe ff ff       	call   1080 <strcpy@plt>
    120c:	48 8d 45 90          	lea    rax,[rbp-0x70]
    1210:	48 89 c6             	mov    rsi,rax
    1213:	48 8d 05 f9 0d 00 00 	lea    rax,[rip+0xdf9]        # 2013 <_IO_stdin_used+0x13>
    121a:	48 89 c7             	mov    rdi,rax
    121d:	b8 00 00 00 00       	mov    eax,0x0
    1222:	e8 79 fe ff ff       	call   10a0 <printf@plt>
    1227:	b8 00 00 00 00       	mov    eax,0x0
    122c:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
    1230:	64 48 2b 14 25 28 00 	sub    rdx,QWORD PTR fs:0x28
    1237:	00 00 
    1239:	74 05                	je     1240 <main+0x97>
    123b:	e8 50 fe ff ff       	call   1090 <__stack_chk_fail@plt>
    1240:	c9                   	leave  
    1241:	c3                   	ret    

Disassembly of section .fini:

0000000000001244 <_fini>:
    1244:	f3 0f 1e fa          	endbr64 
    1248:	48 83 ec 08          	sub    rsp,0x8
    124c:	48 83 c4 08          	add    rsp,0x8
    1250:	c3                   	ret    
