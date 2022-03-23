
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
exitMsg: db 0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'


start:  mov ah,9  ;to view a message 
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
        ;display the first message
        mov ah,09h  
        mov dx, offset firstNumMsg  
        int 21h 
        
        ;we will call InputNumber to handle the input
        mov cx,0 ;first we will move to cx 0 because we will increment on it later in InputNumber, cx reresent the number of digits (ie 2020 has 4 digits)
        call InputNumber  ;now we have our first number stored   
        
        push dx ;push to the stack to dont affect it 
        
        ;display second message
        mov ah,9
        mov dx, offset secondNumMsg        
        int 21h                 
        
        mov cx,0
        call InputNumber ;now we have our second number stored
        
        pop bx 
        add dx,bx ;the result is stored in dx
        push dx
         
        mov ah,9
        mov dx, offset resultMsg
        int 21h      
        
        mov cx,10000 ;this is the maximum number this calculator can handle
        pop dx
        call View 
        jmp exit
        
        
InputNumber: 
        mov ah,0
        int 16h ;use int 16h to read a key press
             
        mov dx,0 ;this is the initial register which we will add the values on each iteration 
        mov bx,1 ;this is the initial digit
         
        cmp al,0dh ;compare if the input is 'enter'key that means that the user has finished entering the number
          
        je FormNumber ;if the 'enter' key is pressed, then we have our number stored in the stack, so we will return it back using FormNumber 
        
        sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ASCII to decimal
        call ViewNumber ;view the key pressed on the screen
        
        mov ah,0 ;we will mov 0 to ah before we push ax to the stack because we only need the value in al
        push ax  ;push the value of ax to the stack
        inc cx   ;increment 1 to cx as this represent the counter for the number of digit
        jmp InputNumber ;then jump back to InputNumber to either take another number or press enter 
        
        
FormNumber:
        ;here we will take the values from the stack to add the number (ie. 148 = (1X100 + 4*10 + 8*1))
        pop ax ;here we will take the fisrt value (ie the first value of 148 is 8) 
        push dx ;this is 1   
        mul bx ;here we will multiply the value of dx and ax
        pop dx 
        
        add dx,ax ;add dx to ax which is the result of the multiplication, at first dx contains 0 
        
        mov ax,bx       
        mov bx,10 
        push dx ;push to the stack and pop it after the multiplication so it won't be affected
        mul bx ;this multiply the value by 10 (if it was 1 now is 10*1 = 10)
        pop dx  
        
        mov bx,ax ;we move the new value to bx, so when we jump back to the start the value of the multiplication will be stored in bx
        
        dec cx ;decrement the counter of digits after we finish with one 
        cmp cx,0 ;and compare the value if it is equal to 0 
        jne FormNumber ;jump to the start of FormNumber if it is not equal to zero 
        ret ;else return 

ViewNumber:    
        ;we will push ax and dx to the stack because we will change their values while viewing them, and we will pop them back after to don't affect their contents  
        push ax 
        push dx           
        
        mov dx,ax ;we will mov the value to dx as int 21h expect that the output is stored in it
        add dl,30h ;add 30 to its value to convert it back to ASCII, for the view we need the ASCII
        mov ah,2 ;to view a number of a value of a register
        int 21h 
        
        pop dx ;the last value added to the stack has to be the first to be popped back  
        pop ax
        ret
        
View:  
       ;divide the rasult by the maximum capacity (ie. 148/10000 => 0/1 + 0/10 + 1/100 + 4/1000 + 8/10000 = 0.0148) 
       mov ax,dx
       mov dx,0
       div cx ;divide by 10000 
       
       call ViewNumber ;view the number stored in ax, that is the quotient of the first divition
       mov bx,dx ;dx is the value of the remainder  
        
       mov dx,0
       mov ax,cx 
       
       mov cx,10 ;divide the value of cx by 10 (ie. 10000/10= 1000)
       div cx  
       
       mov dx,bx
        
       mov cx,ax ;move the result of the operation to ax
       
       cmp ax,0 ;compare if ax is equal to 0
       jne View
       ret
       
exit:  
       mov dx,offset exitMsg
       mov ah, 09h
       int 21h  


       mov ah, 0  ;press any key to finish the program
       int 16h

       ret     

Multiply:  

Subtract:   

Divide:     
                  
; add your code here

ret




