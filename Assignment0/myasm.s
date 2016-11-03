section .data                    	; data section, read-write
        an:    DD 0              	; this is a temporary var

section .text                    	; our code is always in the .text section
        global add_Str_N          	; makes the function appear in global scope
        extern printf            	; tell linker that printf is defined elsewhere 				; (not used in the program)

add_Str_N:                        	; functions are defined as labels
        push    ebp              	; save Base Pointer (bp) original value
        mov     ebp, esp         	; use base pointer to access stack contents
        pushad                   	; push all variables onto stack
        mov ecx, dword [ebp+8]	; get function argument

;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE STARTS HERE ;;;;;;;;;;;;;;;; 
        mov             dword [an], 0   ; initialize answer
        label_here:
        call check                      ; checking if the char is a letter or not put 1 in dx if yes  0 if not
        cmp dx,1                        ; chekcing if the char is a letter
        je increase_and_check           ; if it is a letter then move to increase_check
        add dword [ecx], 4
        jmp continue    

increase_and_check:
        add dword [ecx], 4              ; add 3
        call check                      ; check again if it is a letter
        cmp dx,0
        jne continue
        inc dword [an]                  ; if it does a letter increase the COUNTER
        jmp continue    

check:
        cmp     byte [ecx], 'A'         ; less then A not good
        jl      not_letter
        cmp     byte [ecx], 'z'         ; higher then z not good
        jg      not_letter                      
        cmp     byte [ecx], 'Z'         ; now if <= then Z its ok
        jle letter
        cmp     byte [ecx], 'a'         ; now if >=  then a its ok
        jge letter
        jmp not_letter  

letter:
        mov dx, 1
        ret

not_letter:
        mov dx, 0
        ret     
                                                
continue:
        inc ecx                         ; increment pointer
        cmp byte [ecx], 0               ; check if byte pointed to is zero
        jnz label_here                  ; keep looping until it is null terminated
;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE ENDS HERE ;;;;;;;;;;;;;;;; 
        popad                           ; restore all previously used registers
        mov     eax,[an]                ; return an (returned values are in eax)
        mov     esp, ebp
        pop     ebp
        ret 
