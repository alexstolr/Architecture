section	.rodata
LC0:
	DB	"%s", 10, 0	; Format string

section .bss
LC1:
	RESB	32
LC2:
	RESB	32

section .text
	align 16
	global my_func
	extern printf

my_func:
	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	mov ecx, dword [ebp+8]	; Get argument (pointer to string)

	pushad			; Save registers
	
	mov edx,0
	mov eax,0		; length of input string
	mov ebx,0
counter:
	cmp byte [ecx],0
	je taalih2
	cmp byte [ecx],13
	je taalih2
	cmp byte [ecx],10
	je taalih2
	inc eax
	inc ecx
	jmp counter
taalih2:
      
      mov ecx,dword [ebp+8]
     
      add ecx,eax
	
taalih:
      
      mov ebx,0
      dec ecx
      mov bl, byte [ecx]
      sub bl,byte '0'

      dec ecx
      mov bh, byte [ecx]
      sub bh,'0'
      shl bh,2
      add bl,bh


      add bl,byte '0'
      cmp bl,'9'
      jle con1
      add bl,7
      jmp con1
      

con1:
	cmp bl,97
	jge tikon
con2:
	mov byte [LC1+edx],bl
	inc edx
	dec eax
	cmp eax,0
	je finish
	dec eax
	cmp eax,0
	je finish
	jmp taalih

finish:
    mov eax,0 ; holds the LC1 counter
    mov ecx,LC1
counter2:
	cmp byte [ecx],0
	je con3
	cmp byte [ecx],13
	je con3
	cmp byte [ecx],10
	je con3
	inc eax
	inc ecx
	jmp counter2
con3:
      mov ebx,0
      dec eax
      mov edx,0
loop1:
	mov bh, byte [LC1+eax]
	mov [LC2+edx],bh
	inc edx
	dec eax
	cmp eax,-1
	jne loop1

;       Your code should be here...
	
	push	LC2		; Call printf with 2 arguments: pointer to str
	push	LC0		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call

	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

tikon:
      sub bl,71
      jmp con2
