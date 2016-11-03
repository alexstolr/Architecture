global SCHEDULER


section .data
msg: db 'Hello',10,0
len: equ $-msg

debug3: DB "****************", 10, 0	; Format string
debug4: DB "Generation: %d", 10, 0	; Format string
debug5: DB "length=%d",10,"width=%d",10,"number of generations=%d",10,"print frequency=%d",10,0	; Format string



gen2: dd 0
printfreq2: dd 0
helper3: dd 0
debug: DB "debug", 10, 0	; Format string
helper: dd 0
helper2: dd 0


printer_num: dd 0


section .text
  extern CORS
  extern numco
  extern resume
  extern printf
  extern CURR
  extern SPT
  extern SPMAIN
  extern print_number
  extern debug_flag
  extern print_array
  extern table_wid_original
  extern GW
  extern GL



SCHEDULER: ;gets gen and printfreq

        push	ebp
	mov	ebp, esp
	pushad	
	
	pushad
	pushfd
	
	
	
	cmp dword [debug_flag],1
	jne reg56
	mov eax, dword [ebp+12]
	mov dword [printfreq2], eax
	
	push dword [printfreq2] 
	
	
	mov eax, dword [ebp+8]
	mov dword [gen2], eax
	
	push dword [gen2] 
	
	
	
	push dword [GW] 
	push dword [GL] 
	push	debug5		; and pointer to format string.
	call	printf
	add 	esp, 20		; Clean up stack after call
	
	call print_array
	
	
	popfd
	popad
reg56:	
	
	
	
	
	
	
	mov eax, dword [ebp+8]
	mov dword [gen2], eax
	mov dword [helper3],0
	
	
	mov eax, dword [ebp+12]
	mov dword [printfreq2], eax
	
	
	mov dword [helper2],0
	
	
	
	
	

	
loopMASTER:

	;STAGE 1
	mov eax, dword [numco]
	dec eax
	mov dword [printer_num],eax
	
	
	mov eax, dword [numco]
	dec eax
	dec eax
	
	
	
	mov dword [helper],eax
	
	mov eax, dword [CORS]
	
	mov ecx, 0

	
	
	
loop3:
      ;eax num of threads
      ;ebx put
      ;ecx 
      mov ebx,[eax+ecx*4]
      call resume
      
      inc dword [helper2]
      pushad
      pushfd
      mov eax, dword [printfreq2]
      cmp dword [helper2], eax
      jne didi
      
	mov ecx, dword [printer_num]
	mov eax, dword [CORS]
	mov ebx,[eax+ecx*4]
	call resume
	
      ;call debug_print3
      ;call debug_print4
      ;call debug_print3
      mov dword [helper2],0
      
      
      
 didi:
    popfd
    popad
    
      
      inc ecx
      cmp ecx,dword [helper]
      jl loop3
      
      
      
      
      
      
 ;STAGE 2
	mov eax, dword [numco]
	dec eax
	mov dword [printer_num],eax
	
	
	mov eax, dword [numco]
	dec eax
	dec eax
	
	
	
	mov dword [helper],eax
	
	mov eax, dword [CORS]
	
	mov ecx, 0
	
loop4:
      
      mov ebx,[eax+ecx*4]
      call resume
      
      

       inc dword [helper2]
      pushad
      pushfd
      mov eax, dword [printfreq2]
      cmp dword [helper2], eax
      jne didi2
      
	mov ecx, dword [printer_num]
	mov eax, dword [CORS]
	
	mov ebx,[eax+ecx*4]
	call resume
      
         call debug_print3
      call debug_print4
      call debug_print3
      mov dword [helper2],0
      
 didi2:
    popfd
    popad    

      
      
      
      
      
      
      
      
      
      
      
      inc ecx
      cmp ecx,dword [helper]
      jl loop4
	
	
	
	
	
      inc dword [helper3]
      dec dword [gen2]
      cmp dword [gen2],0
      jg loopMASTER


	

	mov esp,dword [SPMAIN]
	popad				
	pop	ebp
	ret 

debug_print3:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	
	;push ecx		
	;push	debug3		; and pointer to format string.
	;call	printf
	;add 	esp, 8		; Clean up stack after call
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret
	
	
debug_print4:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	
	cmp dword [debug_flag],1
	jne reg
	;push dword [printfreq2] 		
	;push dword [helper3] 
	;push dword [table_wid_original] 
	;push dword [table_wid_original] 
	;push	debug5		; and pointer to format string.
	;call	printf
	;add 	esp, 20		; Clean up stack after call
	
	
	
	jmp endlala
reg:	
	;**************************************************
	;pushad
	;pushfd
	;push dword [helper3] 		
	;push	debug4		; and pointer to format string.
	;call	printf
	;add 	esp, 8		; Clean up stack after call
	;popfd
	;popad
	;**************************************************
endlala:	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret	
	
	
debug_print:
  
  	push	ebp
	mov	ebp, esp	
	pushad		
	
	push ecx		
	push	debug		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call
	
	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret


    
    
