.model HUGE
.386

.STACK 16384

.DATA
	dd 50 dup(0)
.CODE

MAIN PROC FAR
		; MOV EAX, 233
		MOV ECX, 1
		CALL far ptr fun_output
		CALL far ptr print_space
		MOV ECX, 1
		CALL far ptr fun_output
		CALL far ptr print_space
		MOV EAX, 1
		MOV DS:[0], EAX
		MOV DS:[8], EAX
		MOV EAX, 0
		MOV DS:[4], EAX
		MOV DS:[12], EAX
		MOV EAX, DS:[0]
        MOV EDX, 1
        MOV ECX, 3
	while_true:
		CMP ECX, 91 ; 两位精度（第二位权值为1e9）最大只能打到90位
		JNC done 
		PUSH ECX
		CALL far ptr fib
		POP ECX
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        ; PUSHA
        MOV ECX, DS:[4]
		CMP ECX, 0 ;不打前导零
		JZ lowwer
		CALL far ptr fun_output
	lowwer:
		MOV ECX, DS:[0]
        CALL far ptr fun_output
        CALL far ptr print_space ; 打空格
        ; POPA
        POP EDX
        POP ECX
        POP EBX
        POP EAX
        INC ECX
        JMP while_true
; 这里往下是函数区，不建议直接走
	fib: ; 生成fib(ECX)的值，存在DS:[0-4]里
		CMP ECX, 3
		JC fib1
		PUSH ECX
		SUB ECX, 2
		CALL far ptr fib
		MOV ECX, DS:[0]
		MOV DS:[8], ECX
		MOV ECX, DS:[4]
		MOV DS:[12], ECX
		POP ECX
		SUB ECX, 1
		PUSH ECX
		CALL far ptr fib
		POP ECX
		CALL far ptr sum_two_mem
		RET

		fib1:
			MOV ECX, 1
			MOV DS:[0], ECX
			MOV ECX, 0
			MOV DS:[4], ECX
			RET

	sum_two_mem:
		MOV EAX, DS:[4]; 对位相加，先加高位
		ADD EAX, DS:[12]
		XCHG EAX, DS:[4]
		MOV DS:[12], EAX
		MOV EAX, DS:[0]; 再加低位
		MOV EBX, DS:[0]
		ADD EAX, DS:[8]
		MOV DS:[8], EBX
		MOV EBX, 1000000000
		MOV EDX, 0
		DIV EBX
		MOV DS:[0], EDX
		ADD DS:[4], EAX ; 进位
		RET

	print_space:
        PUSH EDX
        PUSH EAX
		MOV EDX,20H
		MOV EAX,200H
		INT 21H	;输出空格
        POP EAX
        POP EDX
		RET
	fun_output: ;打印ECX的值，用前最好push一下各个寄存器
		CMP ECX, 10 ; 后者大，CF=1，相等则ZF=1
		JC print

		MOV EAX, ECX
		MOV EBX, 10
		MOV EDX, 0
		DIV EBX
		MOV ECX, EAX
		PUSH EDX
		CALL far ptr fun_output	
		POP ECX
	print:
		MOV EDX,ECX
		ADD EDX,30H
		MOV EAX,200H
		INT 21H
		RET
	done: 
		MOV EAX,4C00H
		INT 21H
	
MAIN ENDP
END