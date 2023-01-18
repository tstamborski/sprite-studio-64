scraddr = $0002
coladdr = $0004                
dataaddr = $0006

reset = $fffc

;------------------------------------------------
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
    jsr initcharset
    
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
    lda dataaddr
    clc
    adc #40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    
    lda dataaddr+1
    cmp #>(helptxtend-1000)
    bmi funcend
    lda dataaddr
    cmp #<(helptxtend-1000)
    bmi funcend
correct
    lda #<(helptxtend-1000)
    sta dataaddr
    lda #>(helptxtend-1000)
    sta dataaddr+1
    
funcend
    jsr printscreen
    rts
.bend
    
scrollup
.block
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

    lda #$04
    sta scraddr+1
    lda #$00
    sta scraddr
    
    lda #$d8
    sta coladdr+1
    lda #$00
    sta coladdr
    
    ldx #0
majorloop2
    ldy #0
    lda #5
    sta textcolor
minorloop2
    lda (scraddr),y
    cmp #61 ;"="
    bne *+7
    lda #1
    sta textcolor
    
    lda (scraddr),y
    cmp #29 ;"]"
    bne *+7
    lda #5
    sta textcolor
    
    lda textcolor
    sta (coladdr),y
    
    lda (scraddr),y
    cmp #27 ;"["
    bne *+7
    lda #7
    sta textcolor
    
    iny
    cpy #40
    bne minorloop2
    
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
    bne majorloop2
loopend2
    
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

initcharset
    ;zapisac adres ekranu i charsetu
    lda #$1a
    sta $d018

    rts

textcolor
    .byte 5

helptxt
    .screen "     == sprite studio 64 manual ==      "
    .screen "                                        "
    .screen "[run/stop] to quit [crsr down] to scroll"
    .screen "                                        "
    .screen "                                        "
    .screen " ========= table of contents ========== "
    .screen "                                        "
    .screen "[1] drawing                             "
    .screen "                                        "
    .screen "[2] changing colors                     "
    .screen "                                        "
    .screen "[3] advanced editing                    "
    .screen "                                        "
    .screen "[4] moving around and preview           "
    .screen "                                        "
    .screen "[5] saving and loading                  "
    .screen "                                        "
    .screen "[6] miscellaneous                       "
    .screen "                                        "
    .screen "                                        "
    .screen " ============= drawing ================ "
    .screen "                                        "
    .screen "[joystick directions] or [crsr] to move "
    .screen "                                        "
    .screen "the drawing cursor around.              "
    .screen "                                        "
    .screen "                                        "
    .screen "[joystick fire] or [space] to put active"
    .screen "                                        "
    .screen "color in place of cursor.               "
    .screen "                                        "
    .screen "                                        "
    .screen "[del] to erase / put background color in"
    .screen "                                        "
    .screen "place of cursor.                        "
    .screen "                                        "
    .screen "                                        "
    .screen " ========== changing colors =========== "
    .screen "                                        "
    .screen "[1] to choose main sprite color.        "
    .screen "                                        "
    .screen "                                        "
    .screen "[2] to choose multi color 1.            "
    .screen "                                        "
    .screen "                                        "
    .screen "[3] to choose multi color 2.            "
    .screen "                                        "
    .screen "                                        "
    .screen "[4] to choose background color.         "
    .screen "                                        "
    .screen "                                        "
    .screen "[f1] or [shift+f1] to change main sprite"
    .screen "                                        "
    .screen "color.                                  "
    .screen "                                        "
    .screen "                                        "
    .screen "[f3] or [shift+f3] to change multi color"
    .screen "                                        "
    .screen "1.                                      "
    .screen "                                        "
    .screen "                                        "
    .screen "[f5] or [shift+f5] to change multi color"
    .screen "                                        "
    .screen "2.                                      "
    .screen "                                        "
    .screen "                                        "
    .screen "[f7] or [shift+f7] to change background "
    .screen "                                        "
    .screen "color.                                  "
    .screen "                                        "
    .screen "                                        "
    .screen " ========= advanced editing =========== "
    .screen "                                        "
    .screen "[m] to switch on/off multicolor mode.   "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+x] to cut current sprite.          "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+c] to copy current sprite.         "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+v] to paste from clipboard to      "
    .screen "                                        "
    .screen "current sprite.                         "
    .screen "                                        "
    .screen "                                        "
    .screen "[f] to flip current sprite horizontally."
    .screen "                                        "
    .screen "                                        "
    .screen "[shift+f] to flip current sprite        "
    .screen "                                        "
    .screen "vertically.                             "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+,] to slide sprite left.           "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+.] to slide sprite right.          "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+:] to slide sprite down.           "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+@] to slide sprite up.             "
    .screen "                                        "
    .screen "                                        "
    .screen " ===== moving around and preview ====== "
    .screen "                                        "
    .screen "[+] or [-] to change address fo current "
    .screen "                                        "
    .screen "sprite.                                 "
    .screen "                                        "
    .screen "                                        "
    .screen "[l] to lock/unlock address of first     "
    .screen "                                        "
    .screen "animation frame.                        "
    .screen "                                        "
    .screen "                                        "
    .screen "[a] or [shift+a] to change number of    "
    .screen "                                        "
    .screen "animation frames.                       "
    .screen "                                        "
    .screen "                                        "
    .screen "[o] or [shift+o] to change number of    "
    .screen "                                        "
    .screen "overlaying sprites.                     "
    .screen "                                        "
    .screen "                                        "
    .screen " ======== saving and loading ========== "
    .screen "                                        "
    .screen "[cbm+l] to load file from diskette.     "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+s] to save file on diskette. you   "
    .screen "                                        "
    .screen "should prefix filename with @: if you   "
    .screen "                                        "
    .screen "want to overwrite.                      "
    .screen "                                        "
    .screen "                                        "
    .screen "[cbm+d] to display disk directory.      "
    .screen "                                        "
    .screen "                                        "
    .screen " ========== miscellaneous ============= "
    .screen "                                        "
    .screen "[cbm+q] to quit / return to basic.      "
    .screen "                                        "
    .screen "                                        "
    .screen "[g] to switch on/off grid mode.         "
    .screen "                                        "
    .screen "                                        "
helptxtend

;------------------------------------------------
;------------------------------------------------

    *=$2800
    .offs $2800-*
    .binary "sprite-studio-chars.raw"
