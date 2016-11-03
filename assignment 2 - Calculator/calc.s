section .data

flag_first_number: dd 0
flag_was_printed: dd 0


debug_flag: dd 0

_stderr: equ 2
_stdout: equ 1



size_of_stack: equ 5

length: dd 0

operand1: dd 0
operand2: dd 0

;list_of_number1: dd  0

byte_recived: dd 0

counter_succ_op: dd 0

;list_of_successfull_operations: dd 0



carry: dd 0

last_on_operands_list: dd 0


operand1_temp: dd 0
operand2_temp: dd 0

temp: db 0
temp_dd: dd 0

to_duplicate: dd 0

temp_last_on_dup_list: dd 0

head_of_list: dd 0
end_of_list: dd 0
counter_of_nodes: dd 0


stack: times size_of_stack dd 0 ; stack of pointers
counter_of_stack: dd 0 ;pointer to the top of the stack

argc: dd 0
argv: dd 0



text_calc: db "calc: ",0
len_text_calc: equ $-text_calc

error1: db "Error: Operand Stack Overflow",10,0
error1_len: equ $-error1

error2: db "Error: Insufficient Number of Arguments on Stack",10,0
error2_len: equ $-error2



error3: db "Error: Illegal Input",10,0
error3_len: equ $-error3

print_string: db "%s",10,0

debug1_text: db 10,"****debug1****",10,0
debug1_text_len: equ $-debug1_text

debug2_text: db 10,"****debug2****",10,0
debug2_text_len: equ $-debug2_text

debug3_text: db 10,"****debug3****",10,0
debug3_text_len: equ $-debug3_text

LC0: db "%d",10,0
LC0_len: equ $-LC0



new_line: db 10,0 
new_line_len: equ $-new_line

buffer: times 80 db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
     align 16
     global main
;If you use those functions the beginning of your text section will be as follows (no _start label): 
     
     extern printf
     ;extern fprintf
     extern malloc
     extern free
     ;extern fgets
     ;extern stderr
     ;extern stdin
     ;extern stdout
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main: 
    push ebp
    mov ebp,esp
    pushad
    
    
    
    
    mov eax, dword [ebp+8]
    mov dword [argc], eax
    
    
    mov eax, dword [ebp+12]
    mov dword [argv], eax
    
;    pushad
;    mov eax, dword [argv]
;    add eax,4
;    push dword [eax]
;    push print_string
;    call printf
;    popad
    
    
    
    mov edx,1
    mov ecx,0
    dec dword [argc]
loop1337:
    cmp dword [argc],0
    je con554
    
    mov eax, dword [argv]
    
    mov ebx, edx
loop_mini:
    
    dec ebx
    add eax,4
    cmp ebx,0
    jg loop_mini
    
    
    ; eax is a pointer to the begning of word
    
    push eax
    call check_if_debug
    add esp,4
    
    
    inc edx
    dec dword [argc]
    jmp loop1337
    
    
    
    
con554:

        
    mov dword [counter_of_stack], 0
    
    
    
    
    call my_calc
    
    
    
    push eax
    call print_register
    add esp,4
    
finito_la_comedya:   
    
    
    call cleaning_memory_for_the_stack
    
    popad
    pop ebp
    
    mov eax,1
    mov ebx,0
    int 0x80
  

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

print_list: ;gets address returns void
    
    push ebp 
    mov ebp,esp
    pushad
    
    mov dword [flag_first_number],0
    mov dword [flag_was_printed],0
    
    
    mov eax, dword [ebp+8]
    
    mov ebx,eax ; eax at the byte start
    inc ebx ;ebx at the POINTER
    
    ;print first nibble
    mov ecx,0
    mov cl,byte [eax]
    shr cl,4
    cmp ecx,0
    je dont_print
    
    mov dword [flag_first_number],1
    
    push ecx
    call print_char_syscall
    mov dword [flag_was_printed],1
    add esp,4
    ;move to right nibble
dont_print:
    
    mov ecx,0
    mov cl, byte [eax]
    shl cl,4
    shr cl,4
    
    cmp ecx,0
    je loop9
    cmp dword [flag_first_number],0
    je loop9
    mov dword [flag_first_number],1
    
    
    push ecx
    call print_char_syscall
    mov dword [flag_was_printed],1
    add esp,4
    
    ;need to add one more flag that indicated that 
    ;at least one number was printed else print zero
    
    
loop9: ;move to next NODE or end
    cmp dword [ebx],0
    je finish
    
    mov eax, dword [ebx] ; byte
    
    
    
    mov ebx,eax
    inc ebx ;pointer
    
    mov ecx,0
    mov cl,byte [eax]
    shr cl,4
    
    cmp ecx,0
    jne flag65
    cmp dword [flag_first_number],1
    je flag65
    jmp flag78
    
flag65: 
    mov dword [flag_first_number],1
    push ecx
    call print_char_syscall
        mov dword [flag_was_printed],1
    add esp,4
    
    
flag78:    
    mov ecx,0
    mov cl,byte [eax]
    shl cl,4
    shr cl,4
    
    cmp ecx,0
    jne flag678
    cmp dword [flag_first_number],1
    je flag678
    jmp loop9
    
    
flag678:
    mov dword [flag_first_number],1
    push ecx
    call print_char_syscall
        mov dword [flag_was_printed],1
    add esp,4
    jmp loop9
	
finish:
    cmp dword [flag_was_printed],1
    je finish76
    mov ecx,0
    push ecx
    call print_char_syscall
    add esp,4
    
finish76:
    popad
    pop ebp
    RET
    
    
    
    
    
    
    
    
    
	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
my_calc: ;VOID
    push ebp
    mov ebp,esp
    sub esp,4
    pushad
    


    loop1:
    ;printing to stdout
    pushad
    mov eax,4
    mov ebx,_stdout
    mov ecx,text_calc
    mov edx,len_text_calc
    int 0x80
    popad
    
    ;cleaning the buffer
    call clean_buffer
    
    ;getting input from stdin
    pushad
    mov eax,3
    mov ebx,0
    mov ecx, buffer
    mov edx,80
    int 0x80
    
    mov dword [byte_recived], eax
    popad
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;     debug MODE!!!!!         ;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cmp dword [debug_flag],1
    jne end_of_debug_mode
    
    
    pushad
    mov eax,4
    mov ebx,_stderr
    mov ecx,buffer
    mov edx,dword [byte_recived]
    int 0x80
    popad
    
    
    
    
    
end_of_debug_mode:
    ; now we check ERROR: ILLIEGEL INPUT
    cmp dword [byte_recived],2
    je ok888
    
    jmp ok8881
    
    
ok888:   ; one byte size input
    
    
    ;check if input is q so quit
    cmp byte [buffer],byte 'q'
    jne not_quit1
    
    
    
    mov eax, dword [counter_succ_op]
    mov dword [ebp-4],eax
    
    popad
    mov eax, dword [ebp-4]
    add esp,4
    pop ebp
    ret
    
not_quit1:
    
    cmp byte [buffer],byte 'p'
    jne not_quit2
    
    cmp dword [counter_of_stack],1
    jge here2
    call error_print2_func
    
here2:

    ;count the number of operators in infinity list
    call add_one_to_operator_counter
    
      
    
    call _pop
    push eax
  
    call print_list_debug
    add esp,4
    
    push eax
    call cleaning_list
    add esp,4
    
    call newline
    jmp loop1

not_quit2:
    
    cmp byte [buffer],byte 'd'
    jne not_quit3
    
    
    ; needs two checks one that there is an input two there is an output
    
    ;too many
    cmp dword [counter_of_stack],size_of_stack
    jne here367
    

    
    call error_print1_func
 
 here367:
    ;too less
    cmp dword [counter_of_stack],0
    jg here3
    

    call error_print2_func

    
here3:
    
    ;count the number of operators in infinity list
    call add_one_to_operator_counter
    
    
    
    call _pop
    mov dword [to_duplicate],eax
    push eax
    call make_dup_list
    add esp,4
    
    push eax
    call _push
    add esp,4

    push dword [to_duplicate]
    call _push
    add esp,4

    jmp loop1


    
    
not_quit3:
    cmp byte [buffer],byte '+'
    jne not_quit4
    
    
    cmp dword [counter_of_stack],2
    jge here4
    call error_print2_func
    
 here4:   
    ;count the number of operators in infinity list
    call add_one_to_operator_counter
    
    
    
    
    call _pop
    mov dword [operand1],eax
    call _pop
    mov dword [operand2],eax
    push dword [operand1]
    push dword [operand2]
    call add_two_lists
    add esp,8
    
    push eax
    call transform_list
    add esp,4
    
    push eax
    call _push
    add esp,4
    
    push dword [operand1]
    call cleaning_list
    add esp,4
    
    push dword [operand2]
    call cleaning_list
    add esp,4
    
    
    
    

    jmp loop1




not_quit4:
    cmp byte [buffer],byte '&'
    jne ok8881
    
    cmp dword [counter_of_stack],2
    jge here5
    call error_print2_func
    
 here5:   
    ;count the number of operators in infinity list
    call add_one_to_operator_counter
    
    
    
    
    call _pop
    mov dword [operand1],eax
    call _pop
    mov dword [operand2],eax
    push dword [operand1]
    push dword [operand2]
    call bitwise_two_lists
    add esp,8
    mov dword [operand1], ecx
    mov dword [operand2], edx
    
    
    push eax
    call _push
    add esp,4
    
    push dword [operand1]
    call cleaning_list
    add esp,4
    
    push dword [operand2]
    call cleaning_list
    add esp,4
    jmp loop1
    
    ; IF ITS NOT d,p,&,+ and has only one letter, check if its a number otherwise its muse be ILLIEGEL
    
    

    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
ok8881:
     
  ;check if its a really a number
  
      call length_of_string
      mov ebx, dword [length]
      mov eax,0
      loop8881:
	  ;less then 0
	  cmp byte [buffer+eax],48
	  jge here6
	  call error_print3_func
here6:
	  
	  ;more  then 9
	  cmp byte [buffer+eax],57
	  jle here7
	  call error_print3_func
here7:	  
	  inc eax
	  dec ebx
	  cmp ebx,0
	  jne loop8881

  
  



not_quit5:
    
    
    
    call length_of_string
    
    call fixing_input
   

    call convert_number_to_list ;return adress lo LIST of number
    
    
    ;push the number to the stack
    
    
    cmp dword [counter_of_stack],size_of_stack
    jne here8
    call error_print1_func

here8:
    push eax
    call _push
    add esp,4
   
    
    
    
  
    
    

    
    
    jmp loop1
    
pre_finish:


    
    
    
    popad
    
    pop ebp
    
    RET
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


_pop: ; gets nothing, returns the list
    push ebp
    mov ebp,esp
    sub esp,4
    pushad
    
      
    cmp dword [counter_of_stack],0
    je error_print2
    
    
    mov ebx, dword [counter_of_stack]
    dec ebx
    mov ecx, dword [stack+4*ebx]
    
    
    
    ;push ebx
    ;call print_register
    ;add esp,4
    
    
    
    dec dword [counter_of_stack]
    
    
    jmp done7
    
    
    
    
error_print2:
    
    
    mov eax,4
    mov ebx,1
    mov ecx,error2
    mov edx,error2_len
    int 0x80
    
    
    popad
    pop ebp
    add esp,4 ;instead of RET
    jmp loop1
    ;ret

    
    
done7:  
    
    mov dword [ebp-4],ecx
    popad
    mov eax, dword [ebp-4]
    add esp,4
    pop ebp
    
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    

_push: ; gets a address to list

    push ebp
    mov ebp,esp
    pushad
    
    mov ecx, dword [ebp+8]    
    cmp dword [counter_of_stack],size_of_stack
    je error_print1

    mov ebx, dword [counter_of_stack]
    mov dword [stack+4*ebx], ecx
    
    
    
    ;push ebx
    ;call print_register
    ;add esp,4
    
    
    
    inc dword [counter_of_stack]
    
    
    jmp done6
    
    
    
    
error_print1:
    
    
    mov eax,4
    mov ebx,1
    mov ecx,error1
    mov edx,error1_len
    int 0x80
    
    
    popad
    pop ebp
    add esp,4 ;instead of RET
    jmp loop1
    ;ret
    
    
done6:  

    popad

    pop ebp
    RET






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
convert_number_to_list: ;return address

    push ebp
    mov ebp,esp
    sub esp,4 ; space for answer
    pushad
    mov edx,0
    
    ;inizilize
    mov dword [head_of_list],0
    mov dword [counter_of_nodes],0
    mov dword [end_of_list],0
    ;check if its zoogi
    mov eax, dword [length]
    
    cmp eax,2
    je special_case
    
    
    AND eax,1
    cmp eax,1
    je ezoogi
    jmp zoogi
zoogi:
    ; check if there is only one node
    mov eax,dword [counter_of_nodes]
    mov ebx,0
    mov ebx,dword [length]
    ;if there is zoogi num so the num of nodes in total will be half
    shr ebx,1
    cmp eax, ebx
    jg done2
    
    ;ELSE - start making regular nodes
    
     ; counter
    mov ecx,0
    
    ;reads the first byte and transform to 4 nibble
    mov cl,byte [buffer+edx]
    shl cl,4
    
    ;reads the first byte and transform to 4 nibble
    inc edx
    mov ebx,0
    mov bl,byte [buffer+edx]
    ;merge
    OR cl,bl
    ;for the next iteration
    inc edx
    ;making new node
    call _malloc_5
    
    ;moving BCD num to the begining
    mov byte [eax],cl
    
    inc dword [counter_of_nodes]
    ;
    ;linking proccess
    ;
    cmp dword [counter_of_nodes],1
    je make_first;
    ;if not first
    mov ebx,dword [end_of_list] ; look at the node
    inc ebx ; take the pointer inside the node
    mov dword [ebx],eax ; point to the next node
    mov dword [end_of_list],eax ; update end of list
     mov ecx, dword [length]
     dec ecx
    cmp edx,ecx
    jl zoogi
    
    jmp done2

     
      
make_first:
      
      mov dword [head_of_list],eax
      mov dword [end_of_list],eax
      jmp zoogi
      


ezoogi:
    ;taking care of the first node
    mov ebx,0
    mov bl,byte [buffer]
    call _malloc_5
    
    mov byte [eax],bl
    inc dword [counter_of_nodes]
    
    mov dword [head_of_list],eax
    mov dword [end_of_list], eax
    inc edx
    jmp zoogi
     

  






    

      
done2:
    mov eax,dword [head_of_list]
    mov dword [ebp-4],eax ; RETURNING POINTER TO THE START OF THE LIST
    popad
    mov eax, dword [ebp-4]
    add esp,4 ;close this sessami
    pop ebp
    
    RET
    
special_case:
    
    mov ecx,0
    mov cl,byte [buffer]
    shl cl,4
    mov ebx,0
    mov bl, byte [buffer+1]
    OR cl,bl
    call _malloc_5
    mov byte [eax],cl
    inc eax
    mov dword [eax],0
    dec eax
    mov dword [head_of_list],eax
    jmp done2
    
    

	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 





_malloc_5: ;RETURN
    push ebp
    mov ebp,esp
    sub esp,4 ; space for answer
    pushad
    

    push dword 5
    call malloc

    add esp,4
    ; intial pointer to NULL

    
    inc eax
    


    mov dword [eax],0

    dec eax
    ; END intial pointer to NULL
    mov dword [ebp-4],eax ; RETURNING POINTER TO THE START OF THE LIST

    


    popad
    mov eax, dword [ebp-4]
    add esp,4 ;close this sessami
    pop ebp
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

length_of_string: ;void
    push ebp
    mov ebp,esp

    pushad
    
    mov eax,0 ;counter
    
loop2:

    cmp byte [buffer+eax],0
    je done1
    inc eax
    jmp loop2
 
done1:
    dec eax
    mov dword [length],eax
    
    popad
    

    pop ebp
    RET

    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fixing_input:
    push ebp
    mov ebp,esp
    pushad

    mov eax, 0
loop4:
    
    sub byte [buffer+eax],byte 48
    inc eax
    cmp eax,dword [length]
    jl loop4
loop5:
   
    mov byte [buffer+eax],byte 64 ;@@@@@@@@@@@@@@@@@@@@@@
    inc eax
    cmp eax,80
    jl loop5
    
    
    

    popad

    pop ebp
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cleaning_memory_for_the_stack: ;VOID
    
    
    push ebp
    mov ebp,esp
    pushad
    
    
    cmp dword [counter_of_stack],0
    je done5
    
    

    
    mov eax,0
    
loop6:
   
    push dword [stack+eax*4] ;push the address of the begining of the LIST
    
    
    call cleaning_list
    
    
    add esp,4
    
    inc eax
    
    cmp eax, dword [counter_of_stack]   
    
    jl loop6
    
done5:   
    

    
    popad
    
    pop ebp
    RET
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cleaning_list: ;gets an address, return VOID

    push ebp
    mov ebp,esp

    pushad
    
    
loop7:
    mov eax,dword [ebp+8] ;pointer to the start of the list
    mov ebx, eax ; 
    mov ecx,ebx
    inc ebx ; pointer at the POINTER of the node
    
    
    cmp dword [ebx],0 ; check whether its zero    
    je done3 ; if it does finish gracefully
    
    
    ;ELSE
    mov ecx,dword [ebx] 
   
    inc ecx ; pointer at the next POINTER node

loop8:
    cmp dword [ecx],0 ; check if its zero
    je done4
    
    mov ebx,ecx ; forward ebx
    mov ecx,dword [ecx] ; forward ecx
    inc ecx ; to the POINTER location
    jmp loop8
    
    
done4:  
    push dword [ebx] ; deleted from the end-1 node
    call free
    add esp,4
    mov dword [ebx],0 ; update to zero the pointer of last
    jmp loop7
    
    
done3:
    
    
    push eax
    call free
    add esp,4
    
    

    popad

    pop ebp
    
    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
debug1: ;VOID
    push ebp
    mov ebp,esp
    pushad
    
    pushad
    mov eax,4
    mov ebx,1
    mov ecx,debug1_text
    mov edx,debug1_text_len
    int 0x80
    popad
    

    popad
    pop ebp
    RET
    
debug2: ;VOID

    push ebp
    mov ebp,esp
    pushad
    
    pushad
    mov eax,4
    mov ebx,1
    mov ecx,debug2_text
    mov edx,debug2_text_len
    int 0x80
    popad
    

    popad

    pop ebp
    RET
    
debug3: ;VOID

    push ebp
    mov ebp,esp
    pushad
    
    pushad
    mov eax,4
    mov ebx,1
    mov ecx,debug3_text
    mov edx,debug3_text_len
    int 0x80
    popad
    

    popad

    pop ebp
    RET


newline: ; VOID
    push ebp
    mov ebp,esp

    pushad
    
    pushad
    mov eax,4
    mov ebx,1
    mov ecx,new_line
    mov edx,new_line_len
    int 0x80
    popad
    

    popad
    pop ebp
    RET
 
 
 
clean_buffer:
    push ebp
    mov ebp,esp
    sub esp,4 ; space for answer
    pushad
    
    mov eax,0
loop3:
    mov dword [buffer+eax*4],0
    inc eax
    cmp eax, 80
    jl loop3
    
    mov dword [ebp-4],eax ; saving answer
    popad
    mov eax, dword [ebp-4]
    add esp,4 ;close this sessami
    pop ebp
    RET
    
print_register: ;VOID
    push ebp
    mov ebp,esp

    pushad
    
    push dword [ebp+8]
    push LC0
    call printf
    add esp,8
    
    
  
    

    popad
    pop ebp
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
print_char_syscall: ;VOID
    push ebp
    mov ebp,esp

    pushad

    

    mov eax,4
    mov ebx,1
    
    
    mov ecx, dword [ebp+8]
    add ecx,48
    mov byte [temp],cl
    mov ecx, temp
    
    mov edx,1
    int 0x80

    
    
    
  
    

    popad
    pop ebp
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

make_dup_list: ;recive an adresss and return an address
    
    push ebp
    mov ebp,esp
    sub esp,4
    pushad
    
    mov ebx, dword [ebp+8]
    ;first in the list
    call _malloc_5
    mov edx,0
    mov dl, byte [ebx]
    mov byte [eax], dl
    inc eax
    mov dword [eax],0
    dec eax
    mov dword [ebp-4],eax
    mov dword [temp_last_on_dup_list],eax
    ;check if contintu
    inc ebx
    cmp dword [ebx],0
    je finish3
    dec ebx
 
loop10:
    inc ebx
    mov ebx, dword [ebx]
    call _malloc_5
    mov edx,0
    mov dl, byte [ebx]
    mov byte [eax],dl
    mov ecx, dword [temp_last_on_dup_list]
    inc ecx
    mov dword [ecx], eax
    mov dword [temp_last_on_dup_list],eax
    inc eax
    mov dword [eax],0
    inc ebx
    cmp dword [ebx],0
    je finish3
    dec ebx
    jmp loop10
    
    
    
    
    
    
finish3:      
    
    popad
    mov eax, dword [ebp-4]
    add esp,4
    pop ebp
    RET
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
add_two_lists: ; gets two elements returns one
  
  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  push dword [ebp+12]
  call transform_list
  mov dword [operand1_temp], eax
  add esp,4
  
  push dword [ebp+8]
  call transform_list
  mov dword [operand2_temp], eax
  add esp,4
  
  ;; lets boogy
  
  
  call _malloc_5
  mov dword [last_on_operands_list], eax
  mov dword [ebp-4], eax

    
    call get_next_number_operand1
    mov ecx, eax
    call get_next_number_operand2
    mov edx, eax
    

    
    
    mov eax,0
    mov al,cl
    add al,dl
    daa
    jc ok1
    mov dword [carry],0
    clc
back1:    

    
    
    mov ebx, dword [last_on_operands_list]
    mov byte [ebx], al
    inc ebx
    mov dword [ebx],0
    
    call update_operand_lists
    call check_final
    cmp eax,0 ; 0 final 1 not final
    je fin88


    
the_LOOP:
    
    

    
    call _malloc_5
    mov ebx, dword [last_on_operands_list]
    inc ebx
    mov dword [ebx], eax
    mov dword [last_on_operands_list],eax
    
    call get_next_number_operand1
    mov ecx, eax
    call get_next_number_operand2
    mov edx, eax

    
    mov eax,0
    mov al,cl
    clc
    cmp dword [carry],1
    jne back88  
    stc
    adc al,dl
    daa
    jc ok2
    mov dword [carry],0
    clc
    jmp back27
back88:
    
    add al,dl
    daa
    jc ok2
    mov dword [carry],0
    clc
back27:

    
    mov ebx, dword [last_on_operands_list]
    mov byte [ebx], al
    inc ebx
    mov dword [ebx],0
    
    call update_operand_lists
    
    call check_final
    cmp eax,1 ; 0 final 1 not final
    je the_LOOP

    


fin88:
  cmp dword [carry],1
  je add_one_because_of_carry
b_dylan: 

  popad
  mov eax, dword [ebp-4]
  add esp,4
  pop ebp
  ret
  
ok1:
    mov dword [carry],1
    jmp back1
    
ok2:
    mov dword [carry],1
    jmp back27
    
add_one_because_of_carry:
    call _malloc_5
    mov byte [eax],1
    inc eax
    mov dword [eax],0
    dec eax
    mov ebx, dword [last_on_operands_list]
    inc ebx
    mov dword [ebx],eax
    mov dword [last_on_operands_list],eax
    
    
    jmp b_dylan
  

  
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

transform_list: ; gets one elements returns new list address
; i didnt did a fix for 0000 !!!!!!!!!
  
  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  
  call _malloc_5
  mov dword [ebp-4],eax
  inc eax
  mov dword [eax],0
  dec eax
  
  mov ebx,dword [ebp+8]
  mov edx,0
  mov dl, byte [ebx]
  mov byte [eax],dl
  
loop11:
  inc ebx
  cmp dword [ebx],0
  je finito
  mov ebx, dword [ebx]
  call _malloc_5
  mov ecx,0
  mov cl, byte [ebx]
  mov byte [eax],cl
  mov ecx, dword [ebp-4]
  mov dword [ebp-4],eax
  inc eax
  mov dword [eax],ecx
  jmp loop11
    
  
  
  
finito:
  popad
  mov eax, dword [ebp-4]
  add esp,4
  pop ebp
  ret
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


get_next_number_operand1: ;
  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  mov dword [ebp-4],0
  
  cmp dword [operand1_temp],0
  je fin1
  
  mov eax,0
  mov ebx, dword [operand1_temp]
  mov al, byte [ebx]
  mov dword [ebp-4],eax

fin1:
  popad
  mov eax, dword [ebp-4]
  add esp,4
  pop ebp
  ret

  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  
get_next_number_operand2: ;
  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  mov dword [ebp-4],0
  
  cmp dword [operand2_temp],0
  je fin2
  
  mov eax,0
  mov ebx, dword [operand2_temp]
  mov al, byte [ebx]
  mov dword [ebp-4],eax

fin2:
  popad
  mov eax, dword [ebp-4]
  add esp,4
  pop ebp
  ret
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
check_final: ;1 not final 0 final

  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  mov eax,0
  mov dword [ebp-4],eax ; final brerat mehdal
  
  
  cmp dword [operand1_temp],0
  jne close1

  cmp dword [operand2_temp],0
  jne close2
  

  

finish17:
  popad
  mov eax, dword [ebp-4]
  add esp,4
  pop ebp
  RET
  
  
close1:
  mov dword [ebp-4],1
  jmp finish17
  
close2:
  mov dword [ebp-4],1
  jmp finish17

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
update_operand_lists: ;VOID
  
  
  
  push ebp
  mov ebp,esp
  pushad
  
  
  mov eax, dword [operand1_temp]
  
  cmp eax, 0
  jne update1
  
  jmp c1
  
update1:
    mov eax, dword [operand1_temp]
    inc eax
    cmp dword [eax],0
    je special_update1
    
    mov eax, dword [eax]
    mov dword [operand1_temp], eax
    jmp c1

special_update1:

   mov dword [operand1_temp],0
  
 
 c1:
  mov eax, dword [operand2_temp]
  cmp eax,0
  jne update2
  jmp c2
   
update2:
    mov eax, dword [operand2_temp]
    inc eax
    cmp dword [eax],0
    je special_update2
    
    mov eax, dword [eax]
    mov dword [operand2_temp], eax   
    jmp c2
special_update2:

    mov dword [operand2_temp],0
   
c2:  
  popad
  pop ebp
  ret

  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

list_size: ;gets a pointer to list returns num
  
  
  
  push ebp
  mov ebp,esp
  sub esp,4
  pushad
  
  mov eax,1 ;counter
  mov ecx, dword [ebp+8]
 loop13:
  
  inc ecx
  cmp dword [ecx],0
  je fff8
  inc eax
  mov ecx,dword [ecx]
  jmp loop13
  
  
fff8:

  mov dword [ebp-4], eax
  
  popad
  
  mov eax,dword [ebp-4]
  add esp,4
  pop ebp
  
  ret
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bitwise_two_lists: ;gets two lists returns one list of bitwise
  ;returns in eax the new list, in ecx and edx editable lists!
  push ebp
  mov ebp,esp
  sub esp,12 ;!!!!!!!!!!!!! eax>ecx>edx
  pushad
  
  
  ;ebx represent the diff betwin the long and the short
  mov eax, dword [ebp+12]
  mov dword [operand1_temp], eax
  
  mov eax, dword [ebp+8]
  mov dword [operand2_temp], eax
  
  
  
  push dword [operand1_temp]
  
  call list_size
  
  mov ecx ,eax
  add esp,4
  
  push dword [operand2_temp]
  call list_size
  mov edx, eax
  add esp,4
  
  
  
  cmp ecx,edx
  je ahla
  jl add_to_list1
  jmp add_to_list2
  
add_to_list1:
    sub edx,ecx
loop22:
    
    call _malloc_5
    mov byte [eax],0
    inc eax
    mov ebx, dword [operand1_temp]
    mov dword [eax],ebx
    dec eax
    mov dword [operand1_temp], eax
    dec edx
    cmp edx,0
    jg loop22

    jmp ahla
  
  
  
  
add_to_list2:
    sub ecx,edx
loop23:
    call _malloc_5
    mov byte [eax],0
    inc eax
    mov ebx, dword [operand2_temp]
    mov dword [eax],ebx
    dec eax
    mov dword [operand2_temp], eax
    dec ecx
    cmp ecx,0
    jg loop23

    jmp ahla

  
  
  
  
  
  
ahla:
    
    push dword [operand1_temp]
    call list_size
    mov dword [temp_dd], eax
    


    add esp,4
    
    call _malloc_5
    mov dword [head_of_list], eax
    mov dword [last_on_operands_list], eax
    
    mov ecx,0
    mov edx,0
    pushad
    call get_next_number_operand1
    mov byte [temp], al
    popad
    
    mov cl, byte [temp]
    
    pushad
    call get_next_number_operand2
    mov byte [temp], al
    popad
    
    mov dl, byte [temp]
    
    AND cl,dl
    
    
    
    mov byte [eax],cl
    inc eax
    mov dword [eax],0
    dec eax
    
    dec dword [temp_dd]
    
    cmp dword [temp_dd],0
    je fin66
    
    mov ebx, dword [temp_dd]
    
loop24:
    
    call update_operand_lists
    call _malloc_5
    inc eax
    mov dword [eax],0
    dec eax
    
    mov ecx,0
    mov edx,0
    pushad
    call get_next_number_operand1
    mov byte [temp], al
    popad
    
    mov cl, byte [temp]
    
    pushad
    call get_next_number_operand2
    mov byte [temp], al
    popad
    
    mov dl, byte [temp]
    
    AND cl,dl
    

    
    mov byte [eax],cl
    mov edx, dword [last_on_operands_list]
    inc edx
    mov dword [edx], eax
    mov dword [last_on_operands_list],eax
    

    dec ebx
    cmp ebx,0
    jg loop24

  
  
 fin66: 
  
  mov eax, dword [head_of_list]
  mov dword [ebp-4], eax
  mov ecx, dword [operand1_temp]
  mov dword [ebp-8], ecx
  mov edx, dword [operand2_temp]
  mov dword [ebp-12], edx
  popad
  mov eax,dword [ebp-4]
  mov ecx,dword [ebp-8]
  mov edx,dword [ebp-12]
  add esp,12
  pop ebp
  ret
  
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



error_print1_func:


  push ebp
  mov ebp,esp
  pushad
    
    
    mov eax,4
    mov ebx,1
    mov ecx,error1
    mov edx,error1_len
    int 0x80
    
  
  popad
  pop ebp
  add esp,4
  jmp loop1
  
  
error_print2_func:


  push ebp
  mov ebp,esp
  pushad
    
    
    mov eax,4
    mov ebx,1
    mov ecx,error2
    mov edx,error2_len
    int 0x80
    
  
  popad
  pop ebp
  add esp,4 ;delete return adress
  jmp loop1
  
  
error_print3_func:


  push ebp
  mov ebp,esp
  pushad
    
    
    mov eax,4
    mov ebx,1
    mov ecx,error3
    mov edx,error3_len
    int 0x80
    
  
  popad
  pop ebp
  add esp,4 ;delete return address
  jmp loop1 
 
 

  
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


add_one_to_operator_counter:

    push ebp
    mov ebp,esp
    pushad
    
    
    
    inc dword [counter_succ_op]
    

    

    
    popad
    pop ebp
    ret
  
check_if_debug: ;gets address to word, check if equals to "-d", if true update flag, returns VOID

    push ebp
    mov ebp,esp
    pushad
    
    mov ebx, dword [ebp+8]
    mov ecx, dword [ebx]
    mov dword [temp_dd],ecx 
   
    push ebx
    call length_of_string2
    add esp,4
    
    
    mov ebx, dword [temp_dd]
    cmp eax,2
    jne bye
    
    cmp byte [ebx], 45
    jne bye
    
    inc ebx
    cmp byte [ebx], 100
    jne bye
    mov dword [debug_flag],1
    
    
    
    
    
bye:    
    popad
    pop ebp
    ret
    
    
 length_of_string2: ;returns to eax the ans
    push ebp
    mov ebp,esp
    sub esp,4
    pushad
    
    mov ebx, dword [ebp+8]
    mov ebx, dword [ebx]
    mov eax,0 ;counter
    
loop2111:
    
    cmp byte [ebx+eax],0
    je done1111
    inc eax
    jmp loop2111
 
done1111:
    
    mov dword [ebp-4],eax
    
    popad
    mov eax, dword [ebp-4]
    add esp,4
    pop ebp
    RET
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    
print_list_debug:

    push ebp
    mov ebp,esp
    pushad
    
    mov dword [flag_was_printed],0
    mov dword [flag_first_number],0
    mov eax, dword [ebp+8]
    
 lambda1:   
    mov ecx,0
    mov cl, byte [eax]
    
    shr cl,4
    
    cmp ecx,0
    jne next1
    cmp dword [flag_first_number],1
    je next1
    jmp next2

next1:
    mov dword [flag_first_number],1
    mov dword [flag_was_printed],1
    
    
    
    
    pushad
    push ecx
    call print_char_syscall
    add esp,4
    popad

next2:
    
    mov ecx,0
    mov cl, byte [eax]
    shl cl,4
    shr cl,4
    
    cmp ecx,0
    jne next3
    cmp dword [flag_first_number],1
    je next3
    jmp next4
    
    
next3:
    mov dword [flag_first_number],1
    mov dword [flag_was_printed],1
    pushad
    push ecx
    call print_char_syscall
    add esp,4
    popad
    
next4:    
    inc eax
    cmp dword [eax],0
    je salamat
    mov eax, dword [eax]
    jmp lambda1
    
    
salamat:    
    cmp dword [flag_was_printed],1
    je salamat2
    mov ecx,0
    push ecx
    call print_char_syscall
    add esp,4
    
salamat2:    
    popad
    pop ebp
    ret