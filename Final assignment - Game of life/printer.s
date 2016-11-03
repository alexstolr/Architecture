STKSZ	equ	16*1024	; co-routine stack size
CODEP	equ	0	; offset of pointer to co-routine function in co-routine structure 
FLAGSP	equ	4	; offset of pointer to flags co-routine structure 
SPP	equ	8	; offset of pointer to co-routine stack in co-routine structure 
POS_I equ 12
POS_J equ 16
INFO equ 20


 section	.rodata
check_argv: DB	"filename: %s * table_len: %d * table_wid: %d  * gen: %d * prinfreq: %d", 10, 0	
ahuz_di_revah: DB	"%d ", 0	; Format string
revah_ahuz_di: DB	" %d", 0	; Format string
msg: DB	"PRINTF: %d", 10, 0	; Format string
debug: DB "debug", 10, 0	; Format string

debug2: DB "debug2", 10, 0	; Format string
space: DB " ", 0	; Format string
newline: DB 10, 0	; Format string

test: DB "test", 10, 0	; Format string
test_len: equ $-test


section .data
	align 16
	
		i: dd 0
		ezer: dd 0
section .bss
	align 16





section .text
	align 16	
	global PRINTER



	

	extern SCHEDULER
	extern start
	extern resume
	extern CORS
	extern numco
	extern CURR
	extern SPT
	extern SPMAIN
	extern debug_print
	extern debug_print3

	extern print_number
	extern print_newline
	extern WorldLength
	extern WorldWidth
	extern p_SCHED
	extern table_wid
	extern print_revah_ahuz_di
	extern print_ahuz_di_revah
	
 
 

PRINTER:
  
	;**************************************
	
	mov ebx, dword [numco]
	dec ebx
	dec ebx

	
	mov eax, dword [CORS]
	sub eax,4
	mov ecx,0
	
	mov dword [ezer],1
	mov dword [i],0
	

loop4:
	
	
	
	add eax,4
	
	
		mov ecx, dword [eax]
	
	add ecx, INFO
	
	
	cmp dword [i],0
	jne bla

	push dword [ecx]
	call print_ahuz_di_revah
	jmp bla2
	
bla:	
	push dword [ecx]
	call print_revah_ahuz_di
	
bla2:
	 
	pushad
	mov eax, dword [ezer]
	cmp eax,dword [table_wid]
	jne a123
	mov dword [ezer],0
	
	cmp dword [i],0
	je here
	mov dword [i],0
	jmp here2
	
here:
	mov dword [i],1
here2:
	call print_newline
a123:	
	popad
	;************
	
	inc dword [ezer]
	
	dec ebx
	cmp ebx,0
	jg loop4
	
	
	;******************
	;if we want each generation we need len*wid*2 for the argv[5]
	;pushad
	;pushfd
	;call print_newline
	;popfd
	;popad
	;******************
	
	
	
	
	  mov ebx,dword [p_SCHED]
	  call resume
	  
	  jmp PRINTER
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
