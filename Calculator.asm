
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h        

jmp start 
                           
                           
; add the first message: msg 
; 0dh,0ah: enter a new line
msg: db "1) Add",0dh,0ah,"2) Multiply",0dh,0ah,"3) Subtract",0dh,0ah,"4) Divide",0dh,0ah,"$" 
errorMsg: db 0dh,0ah,"Invalid Input, press any key to continue",0dh,0ah,0dh,0ah,"$"
firstNumMsg: db 0dh,0ah,"Enter first number: $"  
secondNumMsg: db 0dh,0ah,"Enter second number: $"
resultMsg: db 0dh,0ah,"Result is = $"    
msg6:    db      0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'


start:  mov ah,9  
        mov dx, offset msg  ;move to dx the value of the message
        int 21h   ;interrupt 21h to display the first message 
        
        mov ah,0  ;store the value of the keyboard input 
        int 16h   ;interrupt 16h to read the input key  
        
        cmp al,31h ;the input will be stored in al, we need to compare the input with 31h (Where, 31H is ASCII value for 1, 32H is ASCII value for 2, and so on)
        je Addition  ;if is equal to 1 jump to the addition  
        
        cmp al,32h 
        je Multiply
        
        cmp al,33h 
        je Subtract 
        
        cmp al,34h 
        je Divide 
              
        ;If the input is not valid, display an error message      
        mov ah,9  
        mov dx, offset errorMsg  
        int 21h      
           
        ;wait an input to restart the program   
        mov ah,0   
        int 16h   
        jmp start
        
                       
Addition: 
        mov ah,09h  ;then let us handle the case of addition operation
            mov dx, offset firstNumMsg  ;first we will display this message enter first no also using int 21h
            int 21h
            mov cx,0 ;we will call InputNo to handle our input as we will take each number seprately
            call InputNumber  ;first we will move to cx 0 because we will increment on it later in InputNo
            push dx
            mov ah,9
            mov dx, offset secondNumMsg
            int 21h 
            mov cx,0
            call InputNumber
            pop bx
            add dx,bx
            push dx 
            mov ah,9
            mov dx, offset resultMsg
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit
        
        
InputNumber: 
        mov ah,0
            int 16h ;then we will use int 16h to read a key press     
            mov dx,0  
            mov bx,1 
            cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
            je FormNumber ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
            sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
            call ViewNumber ;then call ViewNo to view the key we pressed on the screen
            mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
            push ax  ;push the contents of ax to the stack
            inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
            jmp InputNumber ;then we will jump back to input number to either take another number or press enter 
        
        
FormNumber:
        pop ax  
            push dx      
            mul bx
            pop dx
            add dx,ax
            mov ax,bx       
            mov bx,10
            push dx
            mul bx
            pop dx
            mov bx,ax
            dec cx
            cmp cx,0
            jne FormNumber
            ret 

ViewNumber:    
        push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
           push dx ;the stack we will do these so, we don't affect their contents
           mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           pop dx  
           pop ax
           ret
        
View:
       mov ax,dx
       mov dx,0
       div cx 
       call ViewNumber
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0
       jne View
       ret
       
exit:   mov dx,offset msg6
        mov ah, 09h
        int 21h  


        mov ah, 0
        int 16h

        ret     

Multiply:  

Subtract:   

Divide:     
                  
; add your code here

ret




