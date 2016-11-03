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
msg: DB	"%d", 0	; Format string
debug: DB "debug", 10, 0	; Format string
debug2: DB "debug2", 10, 0	; Format string
debug3: DB "****************", 10, 0	; Format string
debug4: DB "Generation: %d", 10, 0	; Format string

space: DB " ", 0	; Format string
newline: DB 10, 0	; Format string

test: DB "test", 10, 0	; Format string
test_len: equ $-test


section .data
	align 16
	filename: dd 0
	table_len: dd 0
	table_wid_original: dd 0
	table_wid: dd 0
	table_wid_m: dd 0
	n_minus_1: dd 0
	gen: dd 0
	sum: dd 0
	ANS: dd 0
	n_minus_1_len: dd 0
	n_minus_1_wid: dd 0
	
	left: dd 0
	right: dd 0
	up: dd 0
	down: dd 0
	Tdown: dd 0
	Tup: dd 0
	debug_flag: dd 0;
	
	GL: dd 0
	GW: dd 0 
	
	prinfreq: dd 0
	numco: dd 0
	handle: dd 0
	ezer: dd 0
	WorldWidth: dd 0
	WorldLength: dd 0

	i: dd 0
	j: dd 0
	buffer: db 0
	;FREE FROM HERE
	CORS: dd 0 ; POUNTER TO POINTERS
	p_STKS: dd 0 ; POINTER TO STACKS
	p_STRUCTS: dd 0 ;POUNTER TO ALL STURCTS
	
	;the sched is one before the last one printer is the last one
	p_SCHED: dd 0
	p_PRINTER: dd 0
	
	

section .bss
	align 16
CURR:	resd	1 	; its reserve Double
SPT:	resd	1	 ; temporary stack pointer variable
SPMAIN:	resd	1	 ; stack pointer of main




section .text
	align 16
	global start
	global resume
	global CORS
	global numco
	global CURR
	global SPT
	global SPMAIN
	global debug_print
	global debug_print3
	global print_number
	global WorldLength
	global WorldWidth
	global p_SCHED
	global table_wid
	global print_revah_ahuz_di
	global print_ahuz_di_revah
	global print_newline
	global debug_flag
	global table_wid_original
	global GL
	global GW
	global print_array


	
	extern printf
	extern malloc
	extern free
	extern SCHEDULER
	extern PRINTER
	

	

start:
	push	ebp
	mov	ebp, esp	
	pushad
	
	;**************************************************************
	; INITZILIZE
	mov ecx, dword [ebp+24] ; get arguments
	mov dword [prinfreq], ecx
	mov ecx, dword [ebp+20] ; get arguments
	mov dword [gen], ecx
	mov ecx, dword [ebp+16] ; get arguments
	mov dword [table_len], ecx
	mov dword [GL], ecx
	mov dword [table_wid_original], ecx
	mov ecx, dword [ebp+12] ; get arguments
	mov dword [table_wid], ecx
	mov dword [GW], ecx
	mov ecx, dword [ebp+8] ; get arguments
	mov dword [filename], ecx
	
	
	
	
	
	
	dec eax
	mov dword [table_wid_m], eax
	
	
	;CHECK INITZILIZE
	;push dword [prinfreq]
	;push dword [gen]
	;push dword [table_wid]
	;push dword [table_len]
	;push dword [filename]
	;push check_argv
	;call printf
	;add esp, 24
	;**************************************************************
	
	;**************************************************************
	;Inizitilize NUMCO with len*wid
	; mul is put in a, pput in d, mul with d, ans in a
	mov eax, dword [GL]
	mov edx, dword [GW]
	mul edx
	;IMPORTANT WE ADD 2 THREADS ONE FOR SCHED AND ONE FOR PRINTER
	inc eax
	inc eax
	mov dword [numco], eax

;**************************************************************
	;malloc STACKS each stack is stksz size
	mov eax, dword [numco]
	mov edx, STKSZ
	mul edx
	
	push eax
	call malloc ;malloc brings back the acctual address of the new allocate and not a pointer to that address like in c, actualy even in c its the address but going back to a pointer
	add esp,4
	
	mov dword [p_STKS],eax
;**************************************************************
	;malloc STRUCT each struct is 12 bytes
	mov eax, dword [numco]
	mov edx, 24
	mul edx
	push eax
	call malloc
	add esp,4
	mov dword [p_STRUCTS],eax
;**************************************************************
	;malloc pointers to CORR (ARRAY OF POINTERS)
	mov eax, dword [numco]
	mov edx, 4
	mul edx
	push eax
	call malloc
	add esp,4
	mov dword [CORS],eax
	

;**********************************************************
;**********************************************************
;**********************************************************
;**********************************************************

	;INIZTILIZE CORRS POINTERS
	mov eax, dword [numco]
	mov ebx, dword [p_STRUCTS]

	mov ecx,0
	mov edx, dword [CORS]

	
	
	
INI_CORRS:
	;add 4 across the array and add 24 each time
	mov dword [edx+4*ecx],ebx

	dec eax
	inc ecx
	add ebx,24
	cmp eax,0
	jg INI_CORRS
	

;**********************************************************
	
	;INIZTILIZE FLAGS POINTERS
	mov eax, dword [numco]
	mov ebx, dword [p_STRUCTS]

	add ebx,4

	
INI_FLAGS:
	mov dword [ebx],1

	dec eax

	add ebx,24
	cmp eax,0
	jg INI_FLAGS
;**********************************************************
	
	;INIZTILIZE SP POINTERS
	mov eax, dword [numco]
	mov ebx, dword [p_STRUCTS]

	
	add ebx,8
	
	mov edx, dword [p_STKS]
	

	
	add edx,STKSZ
	
	
	
INI_SP:
	
	mov dword [ebx], edx

	dec eax
	
	add ebx,24
	add edx,STKSZ
	cmp eax,0	
	jg INI_SP
;**********************************************************
	;INIZTILIZE FUNCTION FUCNTIONS
	mov eax, dword [numco]
	mov ebx, dword [p_STRUCTS]

	
INI_FUNC:
	mov dword [ebx],Function1

	dec eax

	add ebx,24
	cmp eax,0	
	jg INI_FUNC
;**********************************************************
;**********************************************************
; put pointer to PRINTER and to SCHED

  mov eax, dword [CORS]
  mov ecx, dword [numco]
again:
      add eax,4
      dec ecx
      cmp ecx,2
      jg again
      
      
      mov eax, dword [eax]
      mov dword [p_SCHED],eax
      add eax, 24
      mov dword [p_PRINTER],eax
      
      
 ;**********************************************************
;**********************************************************
	
		call open_file
		
		mov dword [i],0
		mov eax,0
		mov ebx,0
		mov ecx,0
loop1:
;line running on eax
;col running on ebx

  
  mov eax, dword [i]
  


  push eax
  call check_zoogi
  cmp eax,0
  je zoogi
  

e_zoogi:

      cmp dword [i],0
      jne d45
      pushad
      call read_char
      popad
      
d45:    
      
          mov ebx,0
      loop2_e:
	    
	  mov eax, dword [i]
	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]
	  
	  mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	  
	  
	  add edx, POS_I
	  mov eax, dword [i]
	  mov dword [edx],eax
	  
	  
	  

	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]
	  
	  mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	  
	  add edx, POS_J
	  mov dword [edx],ebx
	  
	  
	  
	  
	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]
	  
	  mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	  
	  add edx, INFO
	  
	  ;STAM get read of space or \n
	  pushad
	  call read_char
	  popad
	  
	  pushad
	  call read_char
	  mov dword [edx],eax
	  
	  
	  
	  popad
	  
	  mov eax, dword [i]
	  
	  
	  

	  inc ecx
	  inc ebx
	  cmp ebx,dword [table_wid]
	  jl loop2_e
	  jmp con1

zoogi:
      cmp dword [i],0
      je d44
      pushad
      call read_char
      popad
      
d44:     
      mov ebx,0
      loop2:
	  
	  mov eax, dword [i]
	  
	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]
	  
	  mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	  
	  add edx, POS_I
	  

	  mov eax, dword [i]
	  mov dword [edx],eax
	  
	  
	  
	  
	  
	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]

	  mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	  
	  add edx, POS_J
	  mov dword [edx],ebx
	  
	  
	  
	  
	  
	  
	  
	  mov dword [j], ecx
	  pushad
	  push ecx
	  call mul24
	  mov dword [ezer],ecx
	  popad
	  mov ecx, dword [ezer]
	 
	 mov edx, dword [p_STRUCTS]
	  add edx,ecx
	  mov ecx, dword [j]
	 
	  
	  add edx, INFO
	  pushad
	  call read_char
	  mov dword [edx],eax
	 
	 
	 
	  popad
	  mov eax, dword [i]
	  
	  
	  
	  
	  
	  ;STAM get read of space or \n
	  pushad
	  call read_char
	  popad
	  
	  mov eax, dword [i]
	  
	  

	  
	  
	  inc ecx
	  inc ebx
	  cmp ebx,dword [table_wid_m]
	  jle loop2
	  
con1:	

	
	
	mov eax, dword [i]
	inc eax
	mov dword [i], eax


	cmp eax,dword [table_len]
	jl loop1
	
	
	call close_file
	
	
	
	;******************************************
	
	mov eax, dword [p_PRINTER]
	mov dword [eax],PRINTER
	
	
	mov eax, dword [p_SCHED]
	mov dword [eax],SCHEDULER
	
	
	
	
	
	;*******************************************
	;INIT CO FROM C LIKE IN THE PPT
	
	mov eax, dword [numco]
	dec eax
	dec eax
	mov dword [i], eax
	mov ecx,dword [CORS]
	mov ecx, dword [ecx]
	
loop337:
	
	mov [SPT],esp
	mov esp,[ecx+SPP]
	mov ebp,esp
	push Function1
	pushfd
	pushad
	mov [ecx+SPP],esp
	mov esp,[SPT]

	
	
	add ecx,24
	dec dword [i]
	cmp dword [i],0
	jg loop337
	
	
	mov [SPT],esp
	mov esp,[ecx+SPP]
	mov ebp,esp
	
	;NEED TO CHANGE TODO
	push dword [prinfreq]
	push dword [gen]
	push SCHEDULER
	push SCHEDULER
	
	
	pushfd
	pushad
	mov [ecx+SPP],esp
	mov esp,[SPT]
	
	add ecx,24
	
	
	mov [SPT],esp
	mov esp,[ecx+SPP]
	mov ebp,esp
	push PRINTER
	pushfd
	pushad
	mov [ecx+SPP],esp
	mov esp,[SPT]
	
	
	
	
	
	
	
	
	mov eax, dword [table_wid]
	mov dword [WorldWidth], eax
	mov eax, dword [table_len]
	mov dword [WorldLength], eax
	
	
	
	mov ecx, dword [GW]
	dec ecx
	mov dword [n_minus_1], ecx
	mov dword [n_minus_1_wid],ecx
	
	mov ecx, dword [GL]
	dec ecx
	mov dword [n_minus_1_len],ecx
	; CODE START HERE
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	jmp start_co_from_c
	

	
	; CODE FINISH HERE

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
;**********************************************************
;**********************************************************


	;free all malloc automatic ALL !
	;push dword [p_STKS]
	;call free
	;add esp,4
	;
	
	;push dword [CORS]
	;call free
	;add esp,4
	;	
	
	;push dword [p_STRUCTS]
	;call free
	;add esp,4
	;
	
	;********************************************
	
	popad			; Restore registers

	mov	esp, ebp	; Function exit code
	
	pop	ebp
	
	ret 
	
	
	
	

	
print_revah_ahuz_di:
  
  	push	ebp
	mov	ebp, esp	
	mov ecx, dword [ebp+8] ; get arguments
	pushad		
	
	push 	ecx		
	push	revah_ahuz_di		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 4

print_ahuz_di_revah:
  
  	push	ebp
	mov	ebp, esp
	mov ecx, dword [ebp+8] ; get arguments
	pushad		
	
	push 	ecx		
	push	ahuz_di_revah		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 4


	
	
debug_print:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	pushfd
	push ecx		
	push	debug		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popfd
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

debug_print2:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	
	push ecx		
	push	debug2		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret


	

	


print_newline:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	pushfd
	push ecx		
	push	newline		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popfd
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret
	
print_space:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	pushfd
	
	push ecx		
	push	space		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popfd
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret
    
;*************************************************************
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
Function1:

  ;STAGE1
    ;code here
    
  
  
  
  mov ecx, dword [CURR]
  add ecx, POS_I
  mov ebx, dword [ecx]
  mov dword [i],ebx
  
 
  
   mov ecx, dword [CURR]
  add ecx, POS_J
  mov ebx, dword [ecx]
  mov dword [j],ebx
  
  
  
  
  
  mov ecx, dword [CURR]
  add ecx, FLAGSP
  
  cmp dword [i],0
  je ahla1
  mov ecx, dword [n_minus_1_len]
  cmp dword [i], ecx
  je ahla2
  mov ecx, dword [i]
  AND ecx,1
  cmp ecx,0
  jne ahla3
  jmp ahla4
  
  
ahla1: ; i=0
    cmp dword [j],0
    jne bahla12
    bahla11: ; j=0
    
    jmp c1
    
    bahla12: ; 0<j<n-1
    mov eax, dword [n_minus_1_wid]
    cmp dword [j], eax
    je bahla13
    

    jmp c2
    bahla13: ;j = n-1
    
    
    jmp c3
    
    
    
ahla2: ; i=n-1
    cmp dword [j],0
    jne bahla22
    bahla21: ; j=0
    
    jmp c10
    
    bahla22: ; 0<j<n-1
    mov eax, dword [n_minus_1_wid]
    cmp dword [j], eax
    je bahla23
    

    jmp c11
    bahla23: ;j = n-1
    
    
    jmp c12
    
    
ahla3: ; 0<i<n-1 and i e-zoogi
    cmp dword [j],0
    jne bahla32
    bahla31: ; j=0
    
    jmp c4
    
    bahla32: ; 0<j<n-1
    mov eax, dword [n_minus_1_wid]
    cmp dword [j], eax
    je bahla33
    

    jmp c5
    bahla33: ;j = n-1
    
    
    jmp c6
    
    
ahla4: ; 0<i<n-1 and i zoogi
    cmp dword [j],0
    jne bahla42
    bahla41: ; j=0
    
    jmp c7
    
    bahla42: ; 0<j<n-1
    mov eax, dword [n_minus_1_wid]
    cmp dword [j], eax
    je bahla43
    

    jmp c8
    bahla43: ;j = n-1
    
    
    jmp c9
    






c1:


mov eax, dword [i]
mov ebx, dword [j]
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [left], eax



mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax


mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax



mov eax, dword [i]
mov ebx, dword [j]
add eax,dword [n_minus_1_len]
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax



mov eax, dword [i]
mov ebx, dword [j]
add eax, dword [n_minus_1_len]
add ebx, dword [n_minus_1_wid]

push ebx
push eax
call GET_INFO

mov dword [Tup],eax



jmp finish


c2:

mov eax, dword [i]
mov ebx, dword [j]

dec ebx


push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]

inc ebx

push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]

inc eax

push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]

add eax, dword [n_minus_1_len]


push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]

inc eax
dec ebx

push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]

add eax, dword [n_minus_1_len]
dec ebx

push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish

c3:

mov eax, dword [i]
mov ebx, dword [j]

dec ebx

push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]

sub ebx, dword [n_minus_1_wid]

push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]

inc eax

push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]

add eax, dword [n_minus_1_len]

push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
add eax, dword [n_minus_1_len]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish

c4:

mov eax, dword [i]
mov ebx, dword [j]
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
inc ebx

push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
inc ebx

push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish

c5:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish

c6:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
sub ebx,dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
sub ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
sub ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish

c7:

mov eax, dword [i]
mov ebx, dword [j]
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish



c8:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish



c9:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
sub ebx,dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
inc eax
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
inc eax
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
dec ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish


c10:

mov eax, dword [i]
mov ebx, dword [j]
add ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
sub eax, dword [n_minus_1_len]
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
sub eax, dword [n_minus_1_len]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish



c11:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
sub eax,dword [n_minus_1_len]
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
sub eax,dword [n_minus_1_len]
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
inc ebx
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish


c12:

mov eax, dword [i]
mov ebx, dword [j]
dec ebx
push ebx
push eax
call GET_INFO
mov dword [left], eax

mov eax, dword [i]
mov ebx, dword [j]
sub ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [right], eax

mov eax, dword [i]
mov ebx, dword [j]
sub eax, dword [n_minus_1_len]
push ebx
push eax
call GET_INFO

mov dword [down], eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
push ebx
push eax
call GET_INFO
mov dword [up],eax



mov eax, dword [i]
mov ebx, dword [j]
sub eax, dword [n_minus_1_len]
sub ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tdown],eax

mov eax, dword [i]
mov ebx, dword [j]
dec eax
sub ebx, dword [n_minus_1_wid]
push ebx
push eax
call GET_INFO
mov dword [Tup],eax
jmp finish


finish:
 
 mov ecx, dword [CURR]
 add ecx, INFO
 mov ecx, dword [ecx]
 
 cmp ecx,0
 je dead
 
 
 
alive:

mov dword [sum],0
  mov eax, dword [down]
  add dword [sum],eax
    mov eax, dword [up]
  add dword [sum],eax
    mov eax, dword [left]
  add dword [sum],eax
    mov eax, dword [right]
  add dword [sum],eax
    mov eax, dword [Tdown]
  add dword [sum],eax
    mov eax, dword [Tup]
  add dword [sum],eax
  
  cmp dword [sum],3
  je switch_to_alive
   cmp dword [sum],4
  je switch_to_alive
  
  jmp switch_to_dead







    



    jmp finito
dead:
 
  mov dword [sum],0
  mov eax, dword [down]
  add dword [sum],eax
    mov eax, dword [up]
  add dword [sum],eax
    mov eax, dword [left]
  add dword [sum],eax
    mov eax, dword [right]
  add dword [sum],eax
    mov eax, dword [Tdown]
  add dword [sum],eax
    mov eax, dword [Tup]
  add dword [sum],eax
  
  cmp dword [sum],2
  jne switch_to_dead
  jmp switch_to_alive

switch_to_dead:
  mov dword [ANS],0
  jmp finito
switch_to_alive:
  mov dword [ANS],1
  
finito:

 mov ecx, dword [CURR]
 add ecx, FLAGSP
 mov ebx, dword [ANS]
 mov dword [ecx], ebx
  

  
  ;end of code
end_stage1:
  
  mov ebx,dword [p_SCHED]
  call resume
  ;STAGE2
  

  
  
  ;code here
  
 mov ebx, dword [CURR]
 add ebx, INFO
  
 mov ecx, dword [CURR]
 add ecx, FLAGSP
 mov ecx, dword [ecx]
 mov dword [ebx],ecx


  
  ;endof code
  
  
  mov ebx,dword [p_SCHED]
  call resume
  
  jmp Function1


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ;*************************************************************

open_file:

  	push	ebp
	mov	ebp, esp	
	pushad		
	
	mov eax,5
	mov ecx, 0
	mov ebx, dword [filename]
	int 0x80
	mov dword [handle],eax
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 

close_file:

  	push	ebp
	mov	ebp, esp	
	pushad		
	
      mov ebx,dword [handle]
      mov eax,6
      int 0x80
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret
	

read_char: ;RETURNS AN INT
      
        push	ebp
	mov	ebp, esp
	sub esp,4
	pushad		
	
	mov eax,3
	mov ebx,dword [handle]
	mov ecx,buffer
	mov edx,1
	int 0x80
	
	
	mov eax,0
	mov al, byte [buffer]
	sub eax,48
	
	mov dword [ebp-4],eax
	
	
	popad			; Restore registers
	mov eax, dword [ebp-4]
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 
	
check_zoogi: ;GETS NUM return 0 zoogi else e_zoogi

        push	ebp
	mov	ebp, esp
	sub esp,4
	pushad		
	
	mov eax, dword [ebp+8]

	
	AND eax,1
	cmp eax,0
	jne notzoogi
	mov dword [ebp-4],0
	jmp don5

notzoogi:
      mov dword [ebp-4],1
	
	
	
don5:	
	popad			; Restore registers
	mov eax, dword [ebp-4]
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 4
	
	
mul24: ;GETS NUM return num

        push	ebp
	mov	ebp, esp
	sub esp,4
	pushad		
	
	mov eax, dword [ebp+8]
	mov edx,24
	mul edx
	mov dword [ebp-4],eax

	popad			; Restore registers
	mov ecx, dword [ebp-4]
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 4
	

	


    
resume:
  
  pushfd
  pushad
  mov edx, [CURR]
  mov [EDX+SPP],esp
do_resume:

  mov esp,[ebx+SPP]
  mov [CURR],ebx  
  popad
  popfd
  ret
  
  
 
  
start_co_from_c:


  
  mov [SPMAIN],esp

  mov ebx, dword [p_SCHED]


  mov esp,[ebx+SPP]
  
  mov [CURR],ebx
  popad
  popfd
  ret

GET_INFO: ;gets i and jm returns INFO
	
        push	ebp
	mov	ebp, esp
	sub esp,4
	pushad	

	
	mov edx, dword [GW]
	mov eax,4
	MUL edx
	mov edx, eax
	mov eax, dword [ebp+8] ; eax = i
	mov ebx, dword [ebp+12] ; eax = j
	mov ecx, dword [CORS]
	
	mov dword [ezer],0
	
loop65:

      cmp ebx,0
      je loop66
      dec ebx
      add ecx,4
      jmp loop65
      
      
loop66:  
    cmp eax,0
    je zeo
    dec eax
    add ecx,edx
    jmp loop66
	
zeo:

    mov ecx, dword [ecx]
    add ecx,INFO
    mov ecx, dword [ecx]
    mov dword [ebp-4], ecx
    
    
   
	
	
	popad			; Restore registers
	mov eax, dword [ebp-4]
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 8
  
print_array:

        push	ebp
	mov	ebp, esp
      pushad
      pushfd
      	mov eax, dword [CORS]
	mov ebx, dword [numco]
	mov ecx,0
	dec ebx
	dec ebx
    pushad
    mov eax, dword [GW]
    mov dword [i], eax
    popad
    mov dword [j],0


loop8765:
    cmp dword[j],0
    je lalala765
    mov dword[j], 1
    ;call print_space
    
 lalala765:   
    mov edx, dword [eax+ecx*4]
    inc ecx

    add edx,INFO
    
    mov edx, dword [edx]
    pushad
    pushfd
    push edx
    call print_number
    
    popfd
    popad
    
    dec dword [i]
    cmp dword [i],0
    jne print_revah
    call print_newline
    
    pushad
    mov eax, dword [GW]
    mov dword [i], eax
    popad
    
    
    cmp dword[j],0
    je fdsfsd
    
    mov dword[j],0
    jmp fdsfsd2
 fdsfsd:
    call print_space
    mov dword[j],1
  fdsfsd2:
    jmp con567
print_revah:
      call print_space
con567:
	dec ebx
	
	cmp ebx,0
	jg loop8765
  
  popfd
  popad
  mov esp,ebp
  pop ebp
  ret
  
print_number: ;need to wrap with pushad outside
  	push	ebp
	mov	ebp, esp	
	
	pushad
	pushfd
	
	mov ecx, dword [ebp+8] ; get arguments
			
	
	push 	ecx		
	push	msg		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popfd
	popad
				; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret 4