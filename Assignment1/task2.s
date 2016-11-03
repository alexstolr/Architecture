section	.rodata



LC0: db "%llx",10,0


section	.rodata


section	.data

left: db 0
right: db 0
temp_byte: db 0;

temp_eax: dd 0

value: db 0




array_y: times 16 db 0

longlong_x: dd 0

ans: times 8 db 0
bool_print: db 0
numofrounds: dd 0









section .text
	global calc_func
	extern compare
	extern printf

calc_func:
	


	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	sub esp,4		; make room for answer
	pushad			; Save registers
	
	
	
	mov ecx, dword [ebp+12]
	mov dword [numofrounds], ecx
	mov ecx, dword [ebp+8]
	mov dword [longlong_x], ecx


	
	

	
	
loop:

      



      jmp zeros
back:

     mov ecx,0
looliloop2: ; put in the MONE!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
      
      mov edx,0
      mov eax,0
      mov eax, dword [longlong_x]
      mov dl,byte [eax+ecx]
      shr dl,4
      mov ebx,0
      mov bl,dl
      inc byte [array_y + ebx]
      mov edx,0
      mov dl,byte [eax+ecx]
      shl dl,4
      shr dl,4
      mov ebx, 0
      mov bl,dl
      inc byte [array_y + ebx]
      
      
      
      
      inc ecx
      
      cmp ecx,8
      jl looliloop2


 
      
      mov ecx,0
      mov ebx,0
      mov eax,0

      
looliloop3: ; trasform array_y to unsigned long long [hex] ANS
     
      

      mov eax,0
      mov al,byte [array_y+ecx]



      shl al,4
      
      inc ecx

      
      OR al,byte [array_y+ecx]
      


      mov byte [ans +ebx],al

      inc ecx
      inc ebx
      cmp ebx,8
      jl looliloop3
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
      mov ecx,0
      mov ebx,0
      

     
      
 reverse:
      mov ebx,0
      mov edx,0
      mov eax,0
      mov bl,byte [ans+ecx]
      mov byte [temp_byte],bl
      mov eax,ans+7
      sub eax,ecx
      mov dl,byte [eax]
      mov byte [ans+ecx],dl
      mov eax,0
      mov eax,ans+7
      sub eax,ecx
      mov byte [eax],bl
      

      
      
      inc ecx
      cmp ecx,4
      jl reverse
      
      

    
     

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
     
    
     mov ecx,0



      
      
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
     
     

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
      
      pushad
      push dword [longlong_x]  
      
 
      
      push ans

      call compare
      mov dword [temp_eax],eax
      popad
      mov eax, dword [temp_eax]
      cmp eax,1    
      je true
   
      jmp false
back3:

     

      dec dword [numofrounds]
      

      cmp dword [numofrounds], 0
      jg loop
      
finish:

	cmp byte [bool_print],1
	je finish2
	

	
    pushad
    push dword [ans+4]
    push dword [ans]
    push LC0
    call printf
    jmp finish3
    
    

	
finish2:	

	
	 mov dword [ebp-4],eax ; move ans
	 
	  popad
	pop eax

	pop ebp

	
finish3:	
	mov eax,1
	mov ebx,0
	int 0x80


zeros:
      push edx
      mov edx,0
loopiloop:
      shr byte [array_y+edx],8
      inc edx
      cmp edx,16
      jl loopiloop
      pop edx
      jmp back

true:

    
    mov byte [bool_print],1 
    pushad
    push dword [ans+4]
    push dword [ans]   
    push LC0
    call printf
    jmp finish3
    popad  
false:



      mov eax,0
      mov eax,dword [longlong_x]
      mov ebx,0
      mov ebx,dword [ans]
      mov dword [eax], ebx

         mov eax,0
      mov eax,dword [longlong_x]
      add eax,4
      mov ebx,0
      mov ebx,dword [ans+4]
      mov dword [eax], ebx



      
      
      
      
      
      
 
      
      
      
      


      jmp back3
      

	
