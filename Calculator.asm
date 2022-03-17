
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h        

jmp start 
                           
                           
; add the first message: msg 
; 0dh,0ah: enter a new line
msg: db "1) Add",0dh,0ah,"2) Multiply",0dh,0ah,"3) Subtract",0dh,0ah,"4) Divide",0dh,0ah,"$" 
errorMsg: db 0dh,0ah,"Invalid Input, press any key to continue",0dh,0ah,0dh,0ah,"$"


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

Multiply:  

Subtract:   

Divide:     
                  
; add your code here

ret




