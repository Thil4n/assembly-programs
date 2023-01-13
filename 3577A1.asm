
;----------------------------------------------------------------;
;								 ;
;	NAME       :  DISSANAYAKA U.G.D.T			 ;
;	REG. NO    :  EG/2019/3577			         ;
;	MODULE     :  EE5202 - COMPUTER ARCHITECTURE	         ;
;	ASSIGNMENT :  I						 ;
;								 ;
;----------------------------------------------------------------;


global _start


;----------------------------------------------------------------;
;		        .DATA SECTION		                 ;
;----------------------------------------------------------------;
section .data

strPromptDigit db "Enter Marks : ", 0
sizePromptDigit equ $ - strPromptDigit

strPrintA db "A", 10, 0
strPrintB db "B", 10, 0
strPrintC db "C", 10, 0
strPrintD db "D", 10, 0

strPrintGrade db "Grade  = ", 0
sizePrintGrade equ $ - strPrintGrade


;----------------------------------------------------------------;
;		        .BSS SECTION		                 ;
;----------------------------------------------------------------;

section .bss
digitBuff resb 1




;----------------------------------------------------------------;
;		        .TXT SECTION		                 ;
;----------------------------------------------------------------;

section .text



%macro print 2              ; MACRO for printing

mov rax, 4
mov rbx, 1
mov rcx, %1
mov rdx, %2
int 0x80

%endmacro



%macro input 2             ; MACRO for getting input digit

mov rax, 3
mov rbx, 0
mov rcx, %1
mov rdx, %2
int 0x80

%endmacro


_end:                      ; Sub section for end the program
mov rax, 1
mov rbx, 0
int 0x80


			   ; Sub sections for print diferent grades
_printGradeA:
print strPrintA, 3
jmp _end

_printGradeB:
print strPrintB, 3
jmp _end

_printGradeC:
print strPrintC, 3
jmp _end

_printGradeD:
print strPrintD, 3
jmp _end

			   ; Start section
_start:

print strPromptDigit, sizePromptDigit
input digitBuff, 1

print strPrintGrade, sizePrintGrade

mov rax, 56               ; Decimal 8
cmp [digitBuff], rax
jge _printGradeA


mov rax, 53               ; Decimal 5
cmp [digitBuff], rax
jge _printGradeB


mov rax, 50               ; Decimal 2
cmp [digitBuff], rax
jge _printGradeC

jmp _printGradeD
