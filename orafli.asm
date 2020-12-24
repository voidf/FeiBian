.MODEL HUGE  			;100000以内的素数
.STACK 16384

.CODE


MAIN PROC FAR
		.386
		MOV EAX,1
	while_true:
		INC EAX
		MOV EBX, 2
		CMP EAX, 1000000
		JNC done
		while_true_2:
			CMP EBX, EAX ;<
			JNC got_prime
			CMP EBX,1001
			JNC got_prime
		div_try:
			PUSH EAX
			MOV EDX,0
			DIV EBX
			POP EAX
			CMP EDX,0
			JZ  while_true
			INC EBX
			JMP while_true_2
		got_prime:
			MOV ECX, EAX
			PUSH EAX
			CALL far ptr fun_output
		back1:
			CALL far ptr print_space
		back2:
			POP EAX
			JMP while_true
	print_space:
		MOV EDX,20H
		MOV EAX,200H
		INT 21H			;输出空格
		RET
	fun_output: ; ECX是待打印
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