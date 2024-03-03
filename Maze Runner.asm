[org 0x100] 

jmp start 
str1:db 'Game Over!!!',0  
str2:db 'Score:',0
gamescore:dw 0
tickcount: dw 0  
asterickposition:dw 0
direction:dw 1	;1->towards right,2->towards left,3->down,4->up 
oldisr:dd 0 
oldisr1:dd 0

start: 
call printbackgroud 

xor ax, ax 
mov es, ax 

cli 
mov ax, [es:9*4] 
mov [oldisr], ax 
mov ax, [es:9*4+2] 
mov [oldisr+2], ax 
sti 

cli 
mov ax, [es:8*4] 
mov [oldisr1], ax 
mov ax, [es:8*4+2] 
mov [oldisr1+2], ax 
sti
 
cli ;hooking keyboard interrupt
mov word [es:9*4], kbisr 
mov [es:9*4+2], cs 
sti 

cli;hooking timmer interrupt 
mov word[es:8*4],timmer 
mov [es:8*4+2],cs 
sti  

loop1:cmp word[cs:direction],5;termination condition 
jne loop1

mov ax, [oldisr] ;unhooking keyboard interrupt 
mov bx, [oldisr+2] 
cli 
mov [es:9*4], ax 
mov [es:9*4+2], bx 
sti

mov ax, [oldisr1] ;unhooking timmer interrupt 
mov bx, [oldisr1+2] 
cli 
mov [es:8*4], ax
mov [es:8*4+2], bx 
sti

mov ax,0x4c00 
int 21h  
;===========================================================timmer======================================================
timmer: 
push ax
push es 
push di 
	push 140
	push word[cs:gamescore] 
	call printnum
	inc word [cs:tickcount]; increment tick count   
	cmp word[cs:tickcount],18;;;;;;;;;;;;;;decrese to increase speed;;;;;;;;;;;;;;;;;;;;; 
	jne end1 
	mov word[cs:tickcount],0 
	push 0xb800 
	pop es 
	
	call score
	
	mov al,'*' 
	mov di,[cs:asterickposition] 
	mov byte[es:di],0x20  
	
	cmp word[cs:direction],1 
	je case1 
	cmp word[cs:direction],2 
	je case2  
	cmp word[cs:direction],3 
	je case3 
	cmp word[cs:direction],4
	je case4
	jmp end1 
	
	case1:call right 
	jmp end1 
	case2:call left 
	jmp end1 
	case3:call down 
	jmp end1 
	case4:call up 
	
end1:mov al, 0x20 
out 0x20, al ; end of interrupt   
pop di 
pop es
pop ax 
iret  
;===========================================================right========================================================== 
right:
push di 
push ax 
push bx 	
	add word[cs:asterickposition],2 
	mov di,[cs:asterickposition] 
	mov byte[es:di],al 
	mov ax,[cs:asterickposition] 
	mov bl,160 
	div bl 
	cmp ah,0  
	jne end2
	mov di,[cs:asterickposition] 	
	mov byte[es:di],0x20  
	sub word[cs:asterickposition],158 
end2:pop bx 
pop ax 
pop di
ret	  
;===============================================================left==================================================== 
left: 
push di 
push ax 
push bx 
	sub word[cs:asterickposition],2 
	mov di,[cs:asterickposition] 
	mov byte[es:di],al 
	mov ax,[cs:asterickposition] 
	mov bl,160 
	div bl 
	cmp ah,0  
	jne end3  
	mov di,[cs:asterickposition] 	
	mov byte[es:di],0x20  
	add word[cs:asterickposition],158 
end3:pop bx 
pop ax 
pop di
ret	 
;===============================================================down====================================================  
down: 
push di 
push ax 
push bx 
	add word[cs:asterickposition],160 
	mov di,[cs:asterickposition] 
	mov byte[es:di],al 
	cmp word[cs:asterickposition],3840 
	jna end4  
	mov di,[cs:asterickposition] 	
	mov byte[es:di],0x20  
	sub word[cs:asterickposition],3840	
end4:pop bx 
pop ax 
pop di
ret
;================================================================up===================================================== 
up: 
push di 
push ax 
push bx 
	sub word[cs:asterickposition],160 
	mov di,[cs:asterickposition] 
	mov byte[es:di],al 
	cmp word[cs:asterickposition],160
	ja end5  
	mov di,[cs:asterickposition] 	
	mov byte[es:di],0x20  
	add word[cs:asterickposition],3840	
end5:pop bx 
pop ax 
pop di
ret
;===================================================print backgroud===================================================== 
printbackgroud: 
push di 
push es 
push ax 
push cx   
	call clearscreen 
	
	push str2
	push 6 
	push 124 
	call printstring
	
	cld
	push 0xb800 
	pop es 
	
	mov di,380;top
	mov ax,0x2020
	mov cx,20
	pb2:stosw 
	loop pb2 
	mov di,3580;bottom
	mov cx,20
	pb1:stosw 
	loop pb1 
	mov di,1950;left center
	mov cx,15
	pb3:stosw 
	loop pb3
	mov di,2020;right center
	mov cx,15
	pb4:stosw 
	loop pb4 
	mov ax,0x4020;middle
	mov di,880
	mov cx,15
	pb5:stosw 
	add di,158 
	loop pb5 
	mov di,820;left 2 shade
	mov cx,7
	pb6:
	mov ax,0x4020
	stosw 
	add di,158 
	mov ax,0x2020 
	stosw 
	add di,158
	loop pb6 
	mov di,940;right 2 shade
	mov cx,7
	pb7:
	mov ax,0x4020
	stosw 
	add di,158 
	mov ax,0x2020 
	stosw 
	add di,158
	loop pb7 
	mov ax,0x4020;top left diagonal
	mov di,350
	mov cx,7
	pb8:stosw 
	add di,162 
	loop pb8 
	mov di,450;top right diagonal
	mov cx,7
	pb9:stosw 
	add di,154 
	loop pb9 
	mov di,3550;bottom left diagonal
	mov cx,8
	pb10:stosw 
	sub di,158 
	loop pb10
	mov di,3650;bottom right diagonal
	mov cx,8
	pb11:stosw 
	sub di,166 
	loop pb11
	
pop cx 
pop ax 
pop es 
pop di
ret
;=====================================================clear screen====================================================== 
clearscreen: 
push ax
push es 
push cx 
push di
	mov ax,0xb800 
	mov es,ax 
	mov cx, 2000 
	mov di,0 
	cld
	mov ax,0x0720
	rep stosw 
pop ax
pop es 
pop cx 
pop di
ret
;==========================================================print num======================================================= 
printnum: 
push bp 
mov bp, sp 
push es 
push ax 
push bx 
push cx 
push dx 
push di 
	mov ax, 0xb800 
	mov es, ax ; point es to video base 
	mov ax, [bp+4] ; load number in ax 
	mov bx, 10 ; use base 10 for division 
	mov cx, 0 ; initialize count of digits 
	
	nextdigit:
		mov dx, 0 ; zero upper half of dividend 
		div bx ; divide by 10 
		add dl, 0x30 ; convert digit into ascii value 
		push dx ; save ascii value on stack 
		inc cx ; increment count of values 
		cmp ax, 0 ; is the quotient zero 
		jnz nextdigit ; if no divide it again 
	
	mov di, [bp+6] ; point di to 70th column 
	
	nextpos: pop dx ; remove a digit from the stack 
		mov dh, 0x07 ; use normal attribute 
		mov [es:di], dx ; print char on screen 
		add di, 2 ; move to next screen location 
		loop nextpos ; repeat for all digits on stack 
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 4 
;===================================================print string======================================================= 
printstring: 
push bp 
mov bp,sp 
push cx 
push si 
push ax 
push di 
push es 
push ds
	push cs 
	pop ds 
	mov cx,[bp+6];size 
	mov si,[bp+8];address 
	mov ax,0xb800 
	mov es,ax  
	mov di,[bp+4];location
	cld 
	mov ah,0x07   

	l1:lodsb 
	stosw 
	loop l1
pop ds 
pop es 
pop di 
pop ax 
pop si
pop cx 
pop bp 
ret 6  
;===================================================================================================================== 
kbisr: push ax 
push cx 
	in al,0x60  
	
	cmp al,0xC8 
	je up1
	cmp al,0xD0 
	je down1 
	cmp al,0xCB
	je left1 
	cmp al,0xCD 
	je right1
	jmp end6
	
	up1:mov word[cs:direction],4 
	jmp end6 
	down1:mov word[cs:direction],3 
	jmp end6 
	left1:mov word[cs:direction],2 
	jmp end6 
	right1:mov word[cs:direction],1 
end6: 
pop cx
pop ax 
jmp far [cs:oldisr] ; call the original ISR  
;========================================================score========================================================  
score:
push di 
push es 
push ax
	mov di,[cs:asterickposition] 
	push 0xb800 
	pop es  
	mov ah,0x40 
	mov al,'*' 
	cmp word[es:di],ax
	je gameover  
	mov ah,0x20 
	cmp word[es:di],ax 
	je incscore
	jmp end7 
	
	gameover: 
		call clearscreen
		push str1 
		push 12 
		push 1990 
		call printstring 
		push str2
		push 6 
		push 2150 
		call printstring 
		push 2164 
		push word[cs:gamescore] 
		call printnum
		mov word[cs:direction],5
		jmp end7 
	
	incscore:inc word[cs:gamescore] 
	mov word[es:di],0x0720
end7:
pop ax
pop es 
pop di
ret