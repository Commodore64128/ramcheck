;------------------------------------------
; SuperCPU Ramcheck
; Scott Hutter / xlar54
;------------------------------------------

.cpu "65816"
.include "macros.asm"

*=$0801

    .word (+), 2005
    .null $9e, format("%d",start)
 +  .word 0

start:    
    lda #<msg1      ; print the welcome message
    sta $fe 
    lda #>msg1
    sta $ff
    jsr print
    
loop:
    lda msg3+1      ; get bank number
    cmp #$39        ; = 9 ?
    beq end         ; if so, end
    clc             ; if not, add one
    adc #$01
    sta msg3+1      ; store the new bank number

dotest:
    jsr ramtest     ; execute the test

prtbank:
    lda #<msg2      ; print "Bank nn " (checkmark or X)
    sta $fe 
    lda #>msg2
    sta $ff
    jsr print
    jmp loop
end:
    rts


    ; common printing routine
print:
    ldy #$00
nextch:
    lda ($fe),y
    beq +
    jsr $FFD2
    iny
    jmp nextch
+   rts

msg1:
    .text $93,$0e,"SuperCPU Ramcheck",$0d,$00
msg2:
    .text $0d,"Bank "
msg3:
    .byte $30, $32, $20, $00, $00, $00, $00

ramtest:
    native              ; 65816 mode        
    rega8               ; 8 bit accumulator
    lda msg3+1          ; switch to data bank #n
    sec
    sbc #$30
    setdatabank
    regxy16             ; 16 bit index registers

storeram:
    ldy #$0000          ; loop through entire bank memory
    lda #$a0
-   sta $0000,y         ; populate entire bank with $a0
    iny
    cpy #$0000
    bne -

loadram:
    ldy #$0000          ; loop through entire bank memory
-   lda $0000,y
    cmp #$a0            ; check against $a0
    bne rambad
    iny
    cpy #$0000
    bne -

ramgood:
    lda #$00            ; set databank to 0
    setdatabank
    lda #$fa            ; print a checkmark
    sta msg3+3
    jmp cleanup

rambad:
    lda #$00            ; set databank to 0
    setdatabank
    lda #'X'            ; print an X
    sta msg3+3

cleanup:
    emulation           ; 6502 mode
    rts







