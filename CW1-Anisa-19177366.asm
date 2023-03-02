 ;Assembly language demonstration program
; Assemble command:
; "nasm -g -f elf64 -o CW1-Anisa-19177366.o CW1-Anisa-19177366.asm"
; Link command:
; "gcc CW1-Anisa-19177366.o -no-pie -o CW1-Anisa-19177366"
; Executable generated is: "CW1-Anisa-19177366"
; Can be run with: "./CW1-Anisa-19177366"


;--------------------------------------- absolute path to the I/O library. ------------------------------------
%include "/home/malware/asm/joey_lib_io_v6_release.asm"

; "global main" defines the entry point of the executable upon linking.
global main

; The ".data" sectionis used to define data and calculate the memory.
section .data
  
 ;---------------------------------Main MENU-------------------------------------------------------------
 ;As we can see we use value 10 and 0, which  are ASCII codes for linefeed/newline and NULL, respectively.
    str_main_menu db 10,\
                            "Main Menu", 10,\
                            " 1. Add User", 10,\
                            " 2. Add Computer", 10,\
                            " 3. Delete User", 10,\
                            " 4. Delete Computer", 10,\
                            " 5. Search for a user ID", 10,\
                            " 6. Search for a computer name", 10,\
                            " 7. List all users", 10,\
                            " 8. List all computers", 10,\
                            " 9. Exit", 10,\
                            "Please Enter Option 1 - 9", 10, 0
                            
 ;-------------- Program's message -----------------                           
    str_program_exit db "Program exited normally.", 10, 0
    str_option_selected db "Option selected: ", 0
    str_invalid_option db "Invalid option, please try again.", 10, 0
    str_array_full db "Can't add - storage full.", 10, 0
    str_array_empty db "Can't delete- list is empty", 10, 0
    str_no_match db "No match found.", 10, 0
    str_rec_deleted db "Record deleted.", 10, 0
    str_error_name db "Invalid name.", 10, 0
    str_error_length db "Input length error.", 10, 0
    
    ;-------------- User's message -----------------
    str_enter_surname db "Enter surname:", 10, 0
    str_enter_forename db "Enter forename:", 10, 0
    str_enter_age db "Enter age:", 10, 0
    str_enter_id db "Enter ID in pXXXXXXX format:", 10, 0
    str_user_email db "Enter email address in format sfirstname@helpdesk.co.uk:", 10, 0
    str_user_dept db "Enter department(Development, IT, Finance, HR):", 10, 0
     str_number_of_users db "Number of users: ", 10, 0
     str_error_ID db "Invalid userID Please try again!", 10, 0
     str_error_email db "Invalid email.", 10, 0
   
   	;-------------- Computer's message -----------------   
    str_number_of_computers db "Number of computers : ", 10, 0
   str_ip_address db "Enter IP address in xxx.xxx.xxx.xxx format:", 10, 0
    str_operating_system db "Enter an OS from a list(Windows, Linux, MacOS):", 10, 0
    str_purchase_date db "Enter purchase date in dd.mm.yyyy format:",10, 0
   str_computer_id db "Enter computer ID in cXXXXXXX format:", 10, 0
    
  ; ----------- Here we define the size of the block of memory that we want to reserve to hold the USERS' details---------------------------------
    ; A user record stores the following fields:
    ; forename = 64 bytes (string up to 63 characters plus a null-terminator)
    ; surname = 64 bytes (string up to 63 characters plus a null-terminator)
    ; department = 12 bytes (calculated based in longest department name, which is Development and it is 11 chars + 1 null = 12)
    ; email = sfirstname@helpdesk.co.uk 64 bytes (string 1+63+15+null= 80 chars)
	; UserID = 9 bytes (string up to 8 characters plus a null-terminator)
	;----------------Calculation of memory needed for users------------------------------------------
	; Total size of user record is therefore 64+64+12+80+9 = 229bytes
    size_user_record equ 229
    max_num_users equ 100 ; 100 users maximum in array
    size_users_array equ size_user_record*max_num_users ;22900
    current_number_of_users dq 0 ; this is a variable in memory which stores the number of users which have currently been entered into tthe array.
    
	
	  ; ----------- Here we define the size of the block of memory that we want to reserve to hold the COMPUTER' details-----------------------------
    ; A computer record stores the following fields:
    ; ComputerName = 9 bytes (string up to 8 characters(cXXXXXXX) plus a null-terminator)
    ; OS = 8 bytes (string is calculated based on longest OS name wich is Windows=7 chars +null = 8 chars)
    ; userid = 9 bytes (string up to 8 characters(pXXXXXXX) plus a null-terminator)
    ; IPaddress = 16 bytes (string up to 15 (255.255.255.255) characters plus a null terminator)
	; dateofpurchase = 11 bytes (string up to 10 characters(01.01.2012) plus a null-terminator)
	;----------------Calculation of memory needed for computers------------------------------------------
	; Total size of computer record is therefore 9+8+9+16+11 = 53bytes
    size_computer_record equ 53
    max_num_computers equ 500 
    size_computers_array equ size_computer_record*max_num_computers ; This calculation is performed at build time and is therefore hard-coded in the final executable.
    current_number_of_computers dq 0 ; this is a variable in memory which stores the number of computers which have currently been entered into tthe array.

;-----------------------------------------BSS Section---------------------------------------------------
; The ".bss" section is where we define uninitialised data in memory.     
section .bss
    users: resb size_users_array; space for max_num_users user records. "resb = Reserve a Doubleword (4 bytes)
    computers: resb size_computers_array; resb space for max_num_computers records

;---------------------------------------Text Section------------------------------------------------------
; The ".text" section contains the executable code. 
section .text

;-----------------------------------------Main--------------------------------------------------------------
main: 
    mov rbp, rsp; for correct debugging
    ; We have these three lines for compatability only
    push rbp
    mov rbp, rsp
    sub rsp,32
    
  .menu_loop:
    call display_main_menu
    call read_int_new ; menu option (number) is in RAX
    mov rdx, rax ; store value in RDX
    ; Print the selected option back to the user
    mov rdi, str_option_selected
    call print_string_new
    mov rdi, rdx
    call print_int_new
    call print_nl_new
    ; Now jump to the correct option
    cmp rdx, 1
    je .option_1    ;Add User
    cmp rdx, 2
    je .option_2    ;Add PC
    cmp rdx, 3
    je .option_3    ;Delete User
    cmp rdx, 4
    je .option_4    ;Delete PC
    cmp rdx, 5      
    je .option_5    ;Search User
    cmp rdx, 6
    je .option_6    ; Search PC
    cmp rdx, 7
    je .option_7    ;List Users
    cmp rdx, 8
    je .option_8    ;List PCs
    cmp rdx, 9
    je .option_9    ;Exit
    ;otherwise is invalid option
    mov rdi, str_invalid_option
    call print_string_new
    jmp .menu_loop

  .option_1: ; 1. Add User
    ; Check that the array is not full    
    mov rdx, [current_number_of_users] ; This is indirect, hence [] to dereference
    cmp rdx, max_num_users ; Note that max_num_users is an immediate operand since it is defined at build-time
    jl .array_is_not_full ; If current_number_of_users < max_num_users then array is not full, so add new user.
    mov rdi, str_array_full ; display "array is full" message and loop back to main menu
    call print_string_new
    jmp .menu_loop
  .array_is_not_full:
    call add_user
    jmp .menu_loop
    
  .option_2: ; 2. Add Computer
      ; Check that the array is not full
    mov rdx, [current_number_of_computers] ; This is indirect, hence [] to dereference
    cmp rdx, max_num_computers
    jl .array_computers_not_full ;
    mov rdi, str_array_full 
    call print_string_new
    jmp .menu_loop
    .array_computers_not_full:
     call add_computer
     jmp .menu_loop     
    
  .option_3: ; 3. Delete User
    ; Check that the array is not empty    
    mov rdx, [current_number_of_users] ; This is indirect, hence [] to dereference
    cmp rdx, 0 
    jne .array_is_not_empty ; If current_number_of_users != 0
    mov rdi, str_array_empty
    call print_string_new
    jmp .menu_loop
  .array_is_not_empty:
    call delete_user
    jmp .menu_loop
    
   .option_4: ; 4. Delete Computer
    ; Check that the array is not empty    
    mov rdx, [current_number_of_computers] ; This is indirect, hence [] to dereference
    cmp rdx, 0 
    jne .array_not_empty_del ; If current_number_of_computers  != 0 
    mov rdi, str_array_empty
    call print_string_new
    jmp .menu_loop
  .array_not_empty_del:
    call delete_computer
    jmp .menu_loop
    
  .option_5: ; 4. Search by user ID
    call search_user
    jmp .menu_loop
    
  .option_6: ; 4. Search by computer name
    call search_computers
    jmp .menu_loop 
    
  .option_7: ; 2. List All Users
    call display_number_of_users
    call print_nl_new
    call list_all_users
    jmp .menu_loop
             
  .option_8: ; 4. List All Computers
    call display_number_of_computers
    call print_nl_new
    call list_all_computers
    jmp .menu_loop  

  .option_9: ; 9. Exit
    ; In order to exit the program we just display a message and return from the main function.
    mov rdi, str_program_exit
    call print_string_new

    xor rax, rax ; return zero
    ; and these lines are for compatability
    add rsp, 32
    pop rbp
    
    ret ; End function main
    
;---------------------------------------Display main MENU-----------------------------------------------
display_main_menu:
; No parameters
; Prints main menu
    push rdi
    mov rdi, str_main_menu
    call print_string_new
    pop rdi
    ret ; End function display_main_menu    
    

;------------------------------------Display nr of USERs----------------------------------------------------
display_number_of_users:
; Displays number of users in list (to STDOUT)
    push rdi
    mov rdi, str_number_of_users
    call print_string_new
    mov rdi, [current_number_of_users]
    call print_uint_new
    call print_nl_new
    pop rdi    
    ret ; End function display_number_of_users
 
    
;---------------------------------------Add USER--------------------------------------------------------
add_user: ; Adds a new user into the array

; First  check that the array is not full to prevent buffer overflow 
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    mov rcx, users ; base address of users array
    mov rax, QWORD[current_number_of_users] ; value of current_number_of_users
    mov rbx, size_user_record ; size_user_record is an immediate operand since it is defined at build time.
    mul rbx ; calculate address offset (returned in RAX).
    ; RAX now contains the offset of the next user record. 
    ;We need to add it to the base address of users record to get the actual address of the next empty user record.
    add rcx, rax ; calculate address of next unused users record in array
    ; RCX now contins address of next empty user record in the array, so we can fill up the data.

    ; get forename
    mov rdi, str_enter_forename
    call print_string_new ; print message
    call read_string_new ; get input from user     
    call .strlen ;call function strlen to get the length of string
    cmp rdx, 64 ; compare length with 64
    jg .display_error ; jump to display_error if grater than 64
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
  
  ; get surname
    add rcx, 64 ; move along by 64 bytes (which is the size reserved for the forename string)
    mov rdi, str_enter_surname
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen ;call function strlen to get the length of string
    cmp rdx, 64 ; compare length with 64
    jg .display_error ; jump to display_error if grater than 64
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
     ; get department
    add rcx, 64 ; move along by 64 bytes (which is the size reserved for the surname string)
    mov rdi, str_user_dept
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 12
    jg .display_error
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
     ;get id
    add rcx, 12 ; move along by 12 bytes (which is the size of department field)
;.enter_id_loop
    mov rdi, str_enter_id
    call print_string_new ; print message
    call read_string_new ; get input from user
   call .strlen ;call function strlen to get the length of string
    cmp rdx, 9 ; compare length with 9
    jg .display_error ; jump to display_error if grater than 9
   ;-----------------------validate id----------------------------------------------------------------------------------------
    ;cmp al, 'p'
    ;	jne .string_not_ok
    ; shl rax, 8 ; move the next byte into al
    ;	mov rcx, 7 ; this is our counter to count seven loops for the number chars
; .loop1:    
    ; cmp al, '0'
    ; jl .string_not_ok
    ; cmp al, '9'
    ; jg .string_not_ok
    ; shl rax, 8 ; move the next byte into al
    ;dec rcx ; decrement the counter varible
    ; cmp rcx, 0 ; check the counter variable
    ; jne .loop1 ; loop if not zero
; .string_not_ok:
    ; mov rdi, str_error_ID
    ; call print_string_new
    ; jmp .enter_id_loop
    
    ;---------------------------validate userID method----------------------------------------------------------------
    ;validate_name:
     ;    xor     rax, rax        ; Set return value to false.
     ;   cmp     byte [rdi], 'p' ; Is the first byte is 'p'?

      ;  jne     .out_ret        ; Jump to .out_ret if the first
                                 ; character is not p, bail out!

      ;   inc     rdi             ; Increment the pointer, start moving
                                 ; to the second byte.

        ; xor     rsi, rsi        ; Prepare a loop counter.
;.do_loop:
       ;  mov     dl, [rdi]       ; Take one byte.

       ;  cmp     dl, '0'         ; If it's below '0', then it's not
                                 ; a number.
        ; jb      .out_ret        ; Return false.

      ;   cmp     dl, '9'         ; If it's above '9', then it's not
                                 ; a number.
      ;   ja      .out_ret        ; Return false.

        ; inc     rsi             ; Increment the loop counter.
       ;  inc     rdi             ; Increment the string pointer.
      ;   cmp     rsi, 7
       ;  jl      .do_loop        ; Jump back to the top if esi < 6

       ;  cmp     byte [rdi], 0   ; Make sure the 8th byte is a NUL
                                 ; char (end of string).
       ;  jne     .out_ret        ; Return false if it isn't a NUL char.

       ;  mov     rax, 1          ; Return true
;.out_ret:
        ; ret

    
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
   
   ;get email
    add rcx, 9 ; move along by 9 bytes (which is the size of userID field)
    mov rdi, str_user_email
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 80
    jg .display_error
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
    inc QWORD[current_number_of_users] ; increment our number of users counter, since we have just added a record into the array.
  
  jmp .done 
  
.strlen:
       push rdi
       push rcx
       push rax
      
       mov rdi, rax
       mov rcx, -1
       xor eax, eax
       repne scasb 
       not rcx
       mov rdx, rcx
        
       pop rax
       pop rcx
       pop rdi
       ret; End of strlen
       
    .display_error:
        mov rdi, str_error_length
        call print_string_new
        call print_nl_new
        call print_nl_new  
        call print_nl_new
        jmp .done 
       
    .done:
        pop rsi    
        pop rdi    
        pop rdx
        pop rcx
        pop rbx 
        ret ; End function add_user

        
   
;-------------------------------------------Search USER----------------------------------------------
search_user:
; Finds a user by ID in array
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    lea rbx, [users] ; load base address of the users array into RSI. In other words, RSI points to the users array.

    mov rdi, str_enter_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    mov rdi, rax ; address of new string into rdi
    
    call .strlen
    cmp rax, 9
    jne .display_error ;exit if not equal
    
    mov rdx, [current_number_of_users] ; we will use RDX for the counter in our loop
    ;debug
    ;mov rdi, rsi
    ;call print_string_new
    ;call print_nl_new
    
  .start_loop:
    cmp rdx, 0
    je .display_error ; if the counter is a zero then we have finished our loop
    lea rsi, [rbx + 140] ; move the pointer along to the point of ID
    mov rcx, 9            ; load the string length for comparison 
    cld ;clears direction flag
    push rdi ;push value to the stack to preserve it
    repe cmpsb            ; compare the strings
    pop rdi  ;reset value after compare
    je .display_record ; if the strings match display record
    add rbx, size_user_record ; move the address to point to the next record in the array
    dec rdx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
    
  .strlen:
   push rdi
   push rcx
   mov rcx, -1
   xor eax, eax
   repne scasb 
   not rcx
   mov rax, rcx 
   pop rcx
   pop rdi
   ret; End of strlen
   
  .display_record:
        ;display the user record
    mov rdi, rbx ; put the pointer to the current record in RDI, to pass to the print_string_new function
    ;display forename
    call print_string_new
    mov rdi,' ' ; space character, between forename and surname.
    call print_char_new ; print a space
    ;display surname
    lea rdi, [rbx + 64] ; move the pointer along by 64 bytes from the base address of the record (the size of the forename string)
    call print_string_new
    call print_nl_new
    ;display ID
    lea rdi, [rbx + 128] ; move the pointer along by 128 bytes from the base address of the record (combined size of the forename and surname strings) 
    call print_string_new
    call print_nl_new
    ;display dept
    lea rdi, [rbx + 137] ; move the pointer along by 137 bytes from the base address of the record 
    call print_string_new
    call print_nl_new
    ;display email
    lea rdi, [rbx + 149] ; move the pointer along by 149 bytes from the base address of the record 
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop
    
    .display_error:
    mov rdi, str_no_match
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop 
 
    .finish_loop:
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function search_user:

   
;--------------------------------------Delete USER---------------------------------------------------
delete_user:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    lea rbx, [users] ; load base address of the users array into RBX. In other words, RBX points to the users array.
    
    
    mov rdi, str_enter_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    mov rdi, rax ; address of new string into rdi
    
    call .strlen
    cmp rax, 9
    jne .display_error ;exit if not equal
    
    mov rdx, [current_number_of_users] ; we will use RDX for the counter in our loop
    
  .start_loop:
    cmp rdx, 0
    je .display_error ; if the counter is a zero then we have finished our loop
    lea rsi, [rbx + 140] ; move the pointer along to the point of ID
    mov rcx, 9            ; load the string length for comparison 
    cld ;clears direction flag
    push rdi ;push value to the stack to preserve it
    repe cmpsb            ; compare the strings
    pop rdi  ;reset value after compare
    je .delete_record ; if the strings match display record
    add rbx, size_user_record ; move the address to point to the next record in the array
    dec rdx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
    
  .strlen:
   push rdi
   push rcx
   mov rcx, -1
   xor eax, eax
   repne scasb 
   not rcx
   mov rax, rcx 
   pop rcx
   pop rdi
   ret   
    
    .delete_record:   ;delete the user record
  
    ;Calculate how many records after based on current pos
    mov rdi, QWORD[current_number_of_users]
    sub rdi, rdx 
    add rdi, 1 ;gets position in RDI
  
    mov rdx, QWORD[current_number_of_users]
    sub rdx, rdi ;rdx stores how many left
 
    mov rax, rdx
    mov rcx, size_user_record
    mul rcx  ;rax stores size of records left
    
    ;copy next records
    lea     rsi, [rbx + size_user_record]  ; rsi = address of buffer to copy from
    lea     rdi, [rbx]                      ; rdi = address of buffer to copy to
    mov     rcx, rax                        ; rcx = number of bytes to copy

    cld                     ; clear direction flag 
    rep     movsb           ; execute movsb ECX times
    
    mov rdi, str_rec_deleted
    
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    
    dec QWORD[current_number_of_users] ; decrement our number of users counter, since we have just deleted a record into the array.
    jmp .finish_loop 
    
.display_error:
    mov rdi, str_no_match
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop 
 
.finish_loop:
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function delete_user:
    

 ;-----------------------------------List Users------------------------------------------------------   
list_all_users:
; Takes no parameters (users is global)
; Lists full details of all users in the array
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    lea rsi, [users] ; load base address of the users array into RSI. In other words, RSI points to the users array.
    mov rcx, [current_number_of_users] ; we will use RCX for the counter in our loop

    ;this is the start of our loop
  .start_loop:
    cmp rcx, 0
    je .finish_loop ; if the counter is a zero then we have finished our loop
    ;display the user record
    mov rdi, rsi ; put the pointer to the current record in RDI, to pass to the print_string_new function
    
    ;display forename
    call print_string_new
    mov rdi,' ' ; space character, between forename and surname.
    call print_char_new ; print a space
    
    ;display surname
    lea rdi, [rsi + 64] ; move the pointer along by 64 bytes from the base address of the record (the size of the forename string)
    call print_string_new
    call print_nl_new
    
    ;display dept
    lea rdi, [rsi + 128] ; move the pointer along by 1128 bytes from the base address of the record (the size of the forename and surname string)
    call print_string_new
    call print_nl_new
    
    ;display ID
    lea rdi, [rsi+ 140] ; move the pointer along by 140 bytes from the base address of the record (combined size of the  strings till  the end of department) 
    call print_string_new
    call print_nl_new
    
    ;display email
    lea rdi, [rsi + 149] ; move the pointer along by 149 bytes from the base address of the record 
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    
    add rsi, size_user_record ; move the address to point to the next record in the array
    dec rcx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
  .finish_loop:
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function list_all_users


 ;-----------------------------------Display nr of Computers----------------------------------------------
display_number_of_computers:; Displays number of users in list

    push rdi
    mov rdi, str_number_of_computers
    call print_string_new
    mov rdi, [current_number_of_computers]
    call print_uint_new
    call print_nl_new
    pop rdi    
    ret ; End function display_number_of_computers

;---------------------------------------Add COMPUTER-----------------------------------------------------
add_computer:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    mov rcx, computers ; base address of users array
    mov rax, QWORD[current_number_of_computers] ; value of current_number_of_users
    mov rbx, size_computer_record ; size_user_record is an immediate operand since it is defined at build time.
    mul rbx ; calculate address offset (returned in RAX).
    ; RAX now contains the offset of the next computer record. We need to add it to the base address of computer record to get the actual address of the next empty user record.
    add rcx, rax ; calculate address of next unused computer record in array
    ; RCX now contins address of next empty user record in the array, so we can fill up the data.

    ; get computer name
    mov rdi, str_computer_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 9
    jg .display_error  
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
    ; get ip address
    add rcx, 9 ; move along by 9 bytes 
    mov rdi, str_ip_address
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 16
    jg .display_error  
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
    ; get OS
    add rcx, 16 ; move along by 16 bytes 
    mov rdi, str_operating_system
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 8
    jg .display_error  
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
    ; get user id
    add rcx, 8 ; move along by 8 bytes (which is the size of OS field)
    mov rdi, str_enter_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 9
    jg .display_error  
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    
    ; get date of purchase
    add rcx, 9 ; move along by 9 bytes (which is the size of id field)
    mov rdi, str_purchase_date
    call print_string_new ; print message
    call read_string_new ; get input from user
    call .strlen
    cmp rdx, 11
    jg .display_error  
    mov rsi, rax ; address of new string into rsi
    mov rdi, rcx ; address of memory slot into rdi
    call copy_string ; copy string from input buffer into user record in array
    inc QWORD[current_number_of_computers] ; increment our number of users counter, since we have just added a record into the array.
    jmp .done
    
    .strlen:
       push rdi
       push rcx
       push rax
      
       mov rdi, rax
       mov rcx, -1
       xor eax, eax
       repne scasb 
       not rcx
       mov rdx, rcx
    
       pop rax
       pop rcx
       pop rdi
       ret; End of strlen
       
    .display_error:
        mov rdi, str_error_length
        call print_string_new
        call print_nl_new
        call print_nl_new  
        call print_nl_new
        jmp .done 
        
    .done:  
        pop rsi    
        pop rdi    
        pop rdx
        pop rcx
        pop rbx 
        ret ; End function add_computer
    
;-----------------------Search Computer by name----------------------------------------------------
search_computers:
; Finds a user by ID in array
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    lea rbx, [computers] ; load base address of the users array into RSI. In other words, RSI points to the users array.
    
    
    mov rdi, str_computer_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    mov rdi, rax ; address of new string into rdi
    
    call .strlen
    cmp rax, 9
    jne .display_error ;exit if not equal
    
    
    mov rdx, [current_number_of_computers] ; we will use RDX for the counter in our loop
 
  .start_loop:
    cmp rdx, 0
    je .display_error ; if the counter is a zero then we have finished our loop
    lea rsi, [rbx] ; move the pointer along to the point of ID
    mov rcx, 9            ; load the string length for comparison 
    cld ;clears direction flag
    push rdi ;push value to the stack to preserve it
    repe cmpsb            ; compare the strings
    pop rdi  ;reset value after compare
    je .display_record ; if the strings match display record
    add rbx, size_computer_record ; move the address to point to the next record in the array
    dec rdx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
    
  .strlen:
   push rdi
   push rcx
   mov rcx, -1
   xor eax, eax
   repne scasb 
   not rcx
   mov rax, rcx 
   pop rcx
   pop rdi
   ret; End of search_computers
   
  .display_record:
        ;display the  record
    mov rdi, rbx ; put the pointer to the current record in RDI, to pass to the print_string_new function
    ;display compter name
    call print_string_new
    call print_nl_new
    ;display ip address
    lea rdi, [rbx + 9] ; move the pointer along by 9 bytes from the base address of the record (the size of the forename string)
    call print_string_new
    call print_nl_new
    ;display OS
    lea rdi, [rbx + 25] ; 
    call print_string_new
    call print_nl_new
    ;diplay user ID
    lea rdi, [rbx + 33] ; move the pointer along by 8
    call print_string_new
    call print_nl_new
    ;diplay purchase date
    lea rdi, [rbx + 42] ; move the pointer along by 9
    call print_string_new
    call print_nl_new
    
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop 
    
    .display_error:
    mov rdi, str_no_match
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop 
 
    .finish_loop:
 
    
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function search_computer:

;----------------------------------------Delete COMPUTER------------------------------------------------
delete_computer:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    
    lea rbx, [computers] ; load base address of the users array into RBX. In other words, RBX points to the users array.
    
    mov rdi, str_computer_id
    call print_string_new ; print message
    call read_string_new ; get input from user
    mov rdi, rax ; address of new string into rdi
    
    call .strlen
      
    cmp rax, 9
    jne .display_error ;exit if not equal
    
    
    mov rdx, [current_number_of_computers] ; we will use RDX for the counter in our loop
    
  .start_loop:
    cmp rdx, 0
    je .display_error ; if the counter is a zero then we have finished our loop
    lea rsi, [rbx] ; move the pointer along to the point of ID
    mov rcx, 9            ; load the string length for comparison 
    cld ;clears direction flag
    push rdi ;push value to the stack to preserve it
    repe cmpsb            ; compare the strings
    pop rdi  ;reset value after compare
    je .delete_record ; if the strings match display record
    add rbx, size_computer_record ; move the address to point to the next record in the array
    dec rdx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
    
  .strlen:
   push rdi
   push rcx
   mov rcx, -1
   xor eax, eax
   repne scasb 
   not rcx
   mov rax, rcx 
   pop rcx
   pop rdi
   ret
   
    
 .delete_record:  ;Delete the record
  
    ;Calculate how many records after based on current pos
    mov rdi, QWORD[current_number_of_computers]
    sub rdi, rdx 
    add rdi, 1 ;gets position in RDI
  
    mov rdx, QWORD[current_number_of_computers]
    sub rdx, rdi ;rdx stores how many left
 
    mov rax, rdx
    mov rcx, size_user_record
    mul rcx  ;rax stores size of records left
    
    ;copy next records
    lea     rsi, [rbx + size_computer_record]  ; rsi = address of buffer to copy from
    lea     rdi, [rbx]                      ; rdi = address of buffer to copy to
    mov     rcx, rax                        ; rcx = number of bytes to copy

    cld                     ; clear direction flag 
    rep     movsb           ; execute movsb ECX times
    
    mov rdi, str_rec_deleted
    
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    
    dec QWORD[current_number_of_computers] ; decrement our number of computers counter, since we have just deleted a record into the array.
    jmp .finish_loop 
    
    .display_error:
    mov rdi, str_no_match
    call print_string_new
    call print_nl_new
    call print_nl_new  
    call print_nl_new
    jmp .finish_loop 
 
    .finish_loop:
    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function delete_computer:
    
;----------------------------------List all computers--------------------------------------------------
list_all_computers:
; Lists full details of all computers in the array
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    lea rsi, [computers] ; load base address of the users array into RSI. In other words, RSI points to the users array.
    mov rcx, [current_number_of_computers] ; we will use RCX for the counter in our loop

    ;this is the start of our loop
  .start_loop:
    cmp rcx, 0
    je .finish_loop ; if the counter is a zero then we have finished our loop
        ;display the  record
    mov rdi, rsi ; put the pointer to the current record in RDI, to pass to the print_string_new function
    ;display compter name
    call print_string_new
    call print_nl_new
    ;display ip address
    lea rdi, [rsi + 9] ; move the pointer along by 9 bytes from the base address of the record (the size of the forename string)
    call print_string_new
    call print_nl_new
    ;display OS
    lea rdi, [rsi + 25] ; 
    call print_string_new
    call print_nl_new
    ;diplay user ID
    lea rdi, [rsi + 33] ; move the pointer along by 8
    call print_string_new
    call print_nl_new
    ;diplay purchase date
    lea rdi, [rsi + 42] ; move the pointer along by 9
    call print_string_new
    call print_nl_new
    call print_nl_new
    call print_nl_new
    add rsi, size_computer_record ; move the address to point to the next record in the array
    dec rcx ; decrement our counter variable
    jmp .start_loop ; jump back to the start of the loop (unconditional jump)
  .finish_loop:

    pop rsi    
    pop rdi    
    pop rdx
    pop rcx
    pop rbx 
    ret ; End function list_all_computers



