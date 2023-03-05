;----------------------------------------------------------------;
;								                                 ;
;	NAME       :  DISSANAYAKA U.G.D.T			                 ;
;	REG. NO    :  EG/2019/3577			                         ;
;	MODULE     :  EE5202 - COMPUTER ARCHITECTURE	             ;
;	ASSIGNMENT :  III						                     ;
;								                                 ;
;----------------------------------------------------------------;


;----------------------------------------------------------------;
;		        .DATA SECTION		                             ;
;----------------------------------------------------------------;

section .data

strPromptNumberOne db "[~] Enter the number one : ", 0
sizePromptNumberOne equ $ - strPromptNumberOne

strPromptNumberTwo db "[~] Enter the number two : ", 0
sizePromptNumberTwo equ $ - strPromptNumberTwo

strPrintSum db "[~] The summation is : ", 0
sizePrintSum equ $ - strPrintSum

strErrorInput db "[ERROR] Input is invalid!", 10, 10 ,0
sizeErrorInput equ $ - strErrorInput

strNewLine db 10,0
sizeNewLine equ $ - strNewLine

numberFiveBuff db "3577", 0


;----------------------------------------------------------------;
;		        .BSS SECTION		                             ;
;----------------------------------------------------------------;

section .bss

resultBuff resb 5

numberOneBuff resb 4
numberTwoBuff resb 4

tempBuff resb 5


;----------------------------------------------------------------;
;		        .TXT SECTION		                             ;
;----------------------------------------------------------------;

section .text

global _start


									; Macro for print
									; Arg [1st -> Buff | 2nd-> Size]
%macro print 2                        
	mov rax,4
	mov rbx,1
	mov rcx, %1
	mov rdx, %2
	int 0x80
%endmacro


									; Macro for input
									; Arg [1st -> Buff | 2nd-> Size]
%macro input 2                        
	mov rax,3
	mov rbx,0
	mov rcx, %1
	mov rdx, %2
	int 0x80
%endmacro
									; Macro for fill buffer 
									; Arg [1st -> Buff | 2nd -> Size | 3rd-> Fill value]
%macro fillBuff 3 
    mov edi, %1
    mov al, %3
    mov rcx, %2
    rep stosb
%endmacro


									; Macro for fill buffer with padding
									; Arg [1st -> Buff | 2nd -> No. of digits | 3rd -> Seq. no.]
									
									; [!] Since macro is calling multiple times, it's needded 
									; 	  to define dynamic labels to avoide redefining same labels.
									;     Seq. no. is used for that.
%macro fillPadding 3 
 	%push fillPadding_%3
    %define copyLoop copyLoop_%3
	%define endCopyLoop endCopyLoop_%3

	mov r8, 4
	mov r9, %2
	sub r8, r9

	fillBuff %1, r8, 0x30            ; Fill free space (Left) with char.  '0' 

	mov rdi, %1
	mov rsi, 0

									; Fill rest of space  with input digits
	%$copyLoop:
		mov al, byte[tempBuff + rsi] 
		mov byte[%1 + rsi + r8], al
		cmp rsi, 4
		je %$endCopyLoop
		inc rsi
		jmp %$copyLoop

	%$endCopyLoop:	
	%pop fillPadding_%3
%endmacro

									; Macro for fill get the number
									; Arg [
									;	      1st -> Prompt str. | 2nd -> Prompt str. size 
									;         3rd-> Buff | 4th -> Seq. no.
									;	  ]
									
%macro getNumber 4
    %push getNumber_%4
    %define startGetNumber startGetNumber_%4
    %define checkDigit checkDigit_%4
    %define endOfStr endOfStr_%4
    %define notANumber notANumber_%4
    %define endGetNumber endGetNumber_%4

    push rax                       ; Store the values of using registers
    push rcx
    push rdx

    %$startGetNumber:
    print %1, %2
    fillBuff tempBuff, 5, 0x41     ; Completely fill temp. buff. with char. 'A'
    input tempBuff, 5

    mov rsi, 0

    %$checkDigit:
    mov cl, byte[tempBuff + rsi]

    cmp cl, 10 						; New line char.
    je %$endOfStr

    cmp cl, '0'
    jl %$notANumber

    cmp cl, '9'
    jg %$notANumber

    cmp rsi, 4						; Max char. count = 4
    je %$endOfStr

    inc rsi
    jmp %$checkDigit

    %$endOfStr:
    fillPadding %3, rsi, %4
    jmp %$endGetNumber

    %$notANumber:
    print strErrorInput, sizeErrorInput
    jmp %$startGetNumber

    %$endGetNumber:					; Restore registers from the stack
    pop rdx
    pop rcx
    pop rax

	%pop getNumber_%4
    %endmacro

_start: 


getNumber strPromptNumberOne, sizePromptNumberOne, numberOneBuff, 1
getNumber strPromptNumberTwo, sizePromptNumberTwo, numberTwoBuff, 2


	mov rsi, 4     					; loop index = 4
	mov cl, 0      					; carry = 0


_addNext: 
	mov al, byte[numberOneBuff + rsi - 1]
	mov bl, byte[numberFiveBuff + rsi - 1]
	add al, bl
	add al, cl
	sub al, 96						; if al = al - 96
	mov cl, 0                   	; carry = 0
	cmp al, 10
	jl _noCarry

	sub al, 10
	mov cl, 1						; carry = 1


_noCarry:
	add al, 0x30
	mov byte[resultBuff + rsi], al
	dec rsi
	cmp rsi, 0
	jg _addNext

	add cl, 0x30
	mov byte[resultBuff + rsi], cl
	
	print strPrintSum, sizePrintSum
	print resultBuff, 5
	print strNewLine, sizeNewLine
	
_exit:
	mov rax, 1
	mov rbx, 0
	int 0x80