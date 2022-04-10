scraddr = $0002
coladdr = $0004                
dataaddr = $0006

reset = $fffc

;------------------------------------------------

    *=$801
    
basicstart
    .byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00
    
    *=$810
    .offs $810-*
    
init
    lda #0
    sta $d020
    sta $d021
    
    jsr clrscr
    
    lda #<helptxt
    sta dataaddr
    lda #>helptxt
    sta dataaddr+1
    jsr printscreen
    
mainloop
    jsr readkeyboard
    jmp mainloop
    
    rts
    
readkeyboard
.block
    sei
    lda #%11111111
    sta $dc02
    lda #%00000000
    sta $dc03
    
    ;sprawdz shift
    lda #%11111101
    sta $dc00
    lda $dc01
    and #%10000000
    bne *+5
    jmp shiftpressed
    lda #%10111111
    sta $dc00
    lda $dc01
    and #%00010000
    bne *+5
    jmp shiftpressed
    
nomodifiers
    lda #%01111111 ;7
    sta $dc00
    
    lda $dc01
    and #%10000000
    bne *+5
    jsr reset
    
    lda #%11111110 ;0
    sta $dc00
    
    lda $dc01
    and #%10000000
    bne *+5
    jsr scrolldown
    
    jmp funcend
    
shiftpressed
    lda #%11111110 ;0
    sta $dc00
    
    lda $dc01
    and #%10000000
    bne *+5
    jsr scrollup

funcend
    cli
    rts
.bend

scrolldown
.block
    dec scrolltimer
    beq *+3
    rts
    
    lda dataaddr
    clc
    adc #40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    
    lda dataaddr+1
    cmp #>helptxtend
    bmi funcend
    lda dataaddr
    cmp #<helptxtend
    bmi funcend
correct
    lda #<helptxtend
    sta dataaddr
    lda #>helptxtend
    sta dataaddr+1
    
funcend
    jsr printscreen
    
    rts
.bend
    
scrollup
.block
    dec scrolltimer
    beq *+3
    rts
    
    lda dataaddr
    sec
    sbc #40
    sta dataaddr
    bcs *+4
    dec dataaddr+1
    
    lda dataaddr+1
    cmp #>helptxt
    beq *+4
    bpl funcend
    lda dataaddr
    cmp #<helptxt
    bpl funcend
correct
    lda #<helptxt
    sta dataaddr
    lda #>helptxt
    sta dataaddr+1
    
funcend
    jsr printscreen
    
    rts
.bend

printscreen
.block
    lda #$04
    sta scraddr+1
    lda #$00
    sta scraddr
    
    lda dataaddr+1
    sta coladdr+1
    lda dataaddr
    sta coladdr
    
    ldx #0
majorloop
    ldy #0
minorloop
    lda (coladdr),y
    sta (scraddr),y
    iny
    cpy #40
    bne minorloop
    
    lda scraddr
    clc
    adc #40
    sta scraddr
    bcc *+4
    inc scraddr+1
    
    lda coladdr
    clc
    adc #40
    sta coladdr
    bcc *+4
    inc coladdr+1
    
    inx
    cpx #25
    bne majorloop
loopend
    
    rts
.bend

clrscr
.block
    lda #32 ;spacja
    ldx #0
clrloop    
    sta 1024,x
    sta 1224,x
    sta 1424,x
    sta 1624,x
    sta 1824,x
    inx
    cpx #200
    bne clrloop
    
    lda #5 ;na zielono
    ldx #0
colloop
    sta 55296,x
    sta 55496,x
    sta 55696,x
    sta 55896,x
    sta 56096,x
    inx
    cpx #200
    bne colloop
    
    rts
.bend   

scrolltimer
    .byte $ff

helptxt
    .screen "        sprite studio 64 manual         "
    .screen "                                        "
    .screen "[run/stop] to quit [crsr down] to scroll"
    .screen "                                        "
    .screen "                                        "
    .screen " ============= drawing ================ "
    .screen "                                        "
    .screen "[joystick directions] or [crsr] to move "
    .screen "the drawing cursor around.              "
    .screen "                                        "
    .screen "[joystick fire] or [space] to place     "
    .screen "active color in place of cursor.        "
    .screen "                                        "
    .screen "[del] to erase / put background color in"
    .screen "place of cursor.                        "
    .screen "                                        "
    .screen "                                        "
    .screen " ========== changing colors =========== "
    .screen "                                        "
    .screen "[1] to choose main sprite color.        "
    .screen "                                        "
    .screen "[2] to choose multi color 1.            "
    .screen "                                        "
    .screen "[3] to choose multi color 2.            "
    .screen "                                        "
    .screen "[4] to choose background color.         "
    .screen "                                        "
    .screen "[f1] or [shift+f1] to change main sprite"
    .screen "color.                                  "
    .screen "                                        "
    .screen "[f3] or [shift+f3] to change multi color"
    .screen "1.                                      "
    .screen "                                        "
    .screen "[f5] or [shift+f5] to change multi color"
    .screen "2.                                      "
    .screen "                                        "
    .screen "[f7] or [shift+f7] to change background "
    .screen "color.                                  "
    .screen "                                        "
    .screen "                                        "
    .screen " ========= advanced editing =========== "
    .screen "                                        "
    .screen "[m] to switch on/off multicolor mode.   "
    .screen "                                        "
    .screen "[c=+x] to cut current sprite.           "
    .screen "                                        "
    .screen "[c=+c] to copy current sprite.          "
    .screen "                                        "
    .screen "[c=+v] to paste from clipboard to       "
    .screen "current sprite.                         "
    .screen "                                        "
    .screen "[f] to flip current sprite horizontally."
    .screen "                                        "
    .screen "[shift+f] to flip current sprite        "
    .screen "vertically.                             "
    .screen "                                        "
    .screen "[c=+,] to slide sprite left.            "
    .screen "                                        "
    .screen "[c=+.] to slide sprite right.           "
    .screen "                                        "
    .screen "[c=+:] to slide sprite down.            "
    .screen "                                        "
    .screen "[c=+@] to slide sprite up.              "
    .screen "                                        "
    .screen "                                        "
    .screen " ===== moving around and preview ====== "
    .screen "                                        "
    .screen "[+] or [-] to change address fo current "
    .screen "sprite.                                 "
    .screen "                                        "
    .screen "[l] to lock/unlock address of first     "
    .screen "animation frame.                        "
    .screen "                                        "
helptxtend
    .screen "[a] or [shift+a] to change number of    "
    .screen "animation frames.                       "
    .screen "                                        "
    .screen "[o] or [shift+o] to change number of    "
    .screen "overlaying sprites.                     "
    .screen "                                        "
    .screen "                                        "
    .screen " ======== saving and loading ========== "
    .screen "                                        "
    .screen "[c=+l] to load file from diskette.      "
    .screen "                                        "
    .screen "[c=+s] to save file on diskette. you    "
    .screen "should prefix filename with @: if you   "
    .screen "want to overwrite.                      "
    .screen "                                        "
    .screen "                                        "
    .screen " ========== miscellaneous ============= "
    .screen "                                        "
    .screen "[c=+q] to quit / return to basic.       "
    .screen "                                        "
    .screen "[e] to switch different screen          "
    .screen "background color.                       "
    .screen "                                        "
    .screen "[g] to switch on/off grid mode.         "
    .screen "                                        "
    .screen "                                        "
    
