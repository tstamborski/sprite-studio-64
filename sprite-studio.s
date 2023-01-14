;------------------------------------------------
;stale z adresami zmiennych strony zerowej

scraddr = $0002 ;wskazniki do roznych miejsc w
coladdr = $0004 ;pamieci kolorow i ekranowej
                ;na uzytek roznych funkcji
                
previewaddr = $0006 ;wyłącznie na użytek
                    ;funkcji setuppreview
                
spriteaddr = $00fb ;adres obecnego sprite'u

dataaddr = $00fd ;dla funkcji wczytywania
                 ;i zapisywania

;------------------------------------------------
;stale z adresami funkcji kernal'a

scnkey = $ff9f
readst = $ffb7
setlfs = $ffba
setnam = $ffbd
open = $ffc0
close = $ffc3
chkin = $ffc6
chkout = $ffc9
clrchn = $ffcc
chrin = $ffcf
chrout = $ffd2
getin = $ffe4
clall = $ffe7
plot = $fff0
reset = $fffc
                
;------------------------------------------------
;STALE

;adresy sprite banku
bankmin = $3000
bankmax = $4000

;ktory kolor jest aktywny
spriteon = $02
multi0on = $01
multi1on = $03
bkgndon = $00

;jak dluga przerwa miedzy klatkami
;w animacji podgladu
animtimermax = $80

;------------------------------------------------
;------------------------------------------------
;MAKRA

;wypisuje stringa na ekranie
;adres stringa, pozycja wzgledem pamieci ekranu, dlugosc, kolor
print .macro
.block
    ldx #0
loop
    lda \1,x
    sta 1024+\2,x
    lda #\4
    sta $d800+\2,x
    inx
    cpx \3
    bne loop
.bend
.endm

;to samo co print tylko nie koloruje znakow
;adres stringa, pozycja wzgledem pamieci ekranu, dlugosc
write .macro
.block
    ldx #0
loop
    lda \1,x
    sta 1024+\2,x
    inx
    cpx \3
    bne loop
.bend
.endm

;obsluguje spowalniacze przyciskow
keytimermax = $80
spacetimer = 0
updowntimer = 1
leftrighttimer = 2
functiontimer = 3
;numer keytimer'a
handlekeytimer .macro
    dec keytimer+\1
    beq *+3
    rts
    lda #keytimermax
    sta keytimer+\1
.endm

;rysuje ikone programu
;pozycja wzgledem lewej krawedzi, pozycja wzgledem gornej
drawprgicon .macro
    ldx #80
    
    stx 1024+(40*\2)+\1
    inx
    stx 1024+(40*\2)+\1+1
    inx
    stx 1024+(40*\2)+\1+2
    inx
    stx 1024+(40*\2)+\1+3
    
    inx
    stx 1024+(40*(\2+1))+\1
    inx
    stx 1024+(40*(\2+1))+\1+1
    inx
    stx 1024+(40*(\2+1))+\1+2
    inx
    stx 1024+(40*(\2+1))+\1+3
    
    inx
    stx 1024+(40*(\2+2))+\1
    inx
    stx 1024+(40*(\2+2))+\1+1
    inx
    stx 1024+(40*(\2+2))+\1+2
    inx
    stx 1024+(40*(\2+2))+\1+3
    
    inx
    stx 1024+(40*(\2+3))+\1
    inx
    stx 1024+(40*(\2+3))+\1+1
    inx
    stx 1024+(40*(\2+3))+\1+2
    inx
    stx 1024+(40*(\2+3))+\1+3
    
    lda #12
    sta $d800+(40*\2)+\1
    sta $d800+(40*\2)+\1+1
    sta $d800+(40*(\2+1))+\1
    sta $d800+(40*(\2+1))+\1+1
    sta $d800+(40*(\2+2))+\1
    sta $d800+(40*(\2+2))+\1+1
    sta $d800+(40*(\2+3))+\1
    sta $d800+(40*(\2+3))+\1+1
    lda #2
    sta $d800+(40*\2)+\1+2
    sta $d800+(40*\2)+\1+3
    sta $d800+(40*(\2+1))+\1+2
    sta $d800+(40*(\2+1))+\1+3
    sta $d800+(40*(\2+2))+\1+2
    sta $d800+(40*(\2+2))+\1+3
    sta $d800+(40*(\2+3))+\1+2
    sta $d800+(40*(\2+3))+\1+3
.endm
    
;------------------------------------------------
;------------------------------------------------
; KOD STARTOWY DLA BASICA

    *=$801
basicstart
    .byte $0C,$08,$0A,$00,$9E,$20,$31,$36,$33,$38,$34,$00,$00,$00
    
;------------------------------------------------
;------------------------------------------------
;$1000
;MUSIC

    *=$1000
    .offs $1000-*
    
music
    .binary "Blade_Runner.dat",2
    
;------------------------------------------------
;------------------------------------------------
;zestaw niestandardowych znakow dla programu

    *=$2000
    .offs $2000-*
    .binary "sprite-studio-chars.raw"
    .binary "sprite-studio-chars-rev.raw"
    
;------------------------------------------------
;------------------------------------------------
;sprite'y na uzytek samego programu

    *=$2800
    .offs $2800-*
    
cursorsprite
    .binary "cursor-sprites.raw"
    
;------------------------------------------------
;------------------------------------------------
;ZMIENNE

clipboard ;trzymac tutaj wyrownane do 64 bajtow
    .repeat 64, $00
clipflag
    .byte $00

cursorx
    .byte $00
cursory
    .byte $00

multimode
    .byte $01
gridmode
    .byte $00
lightmode
    .byte $00
    
animationmode
    .byte $01
overlaymode
    .byte $01
addrlock
    .byte $00
sprite0base
    .byte $c0
sprite1base
    .byte $c0
sprite2base
    .byte $c0
sprite3base
    .byte $c0
animtimer
    .byte animtimermax
    
addrindex ;wartosc bcd x*64=adres sprite
    .byte $92, $01

spritecol
    .byte $02
multi0col
    .byte $0f
multi1col
    .byte $01
bkgndcol
    .byte $00
    
curcol ;spojrz stale na poczatku
    .byte $02

spriteindex
    .byte $00
spritebyte
    .byte $00
tmpbyte
    .byte $00,$00,$00
bitmask
    .byte $00
bitcounter
    .byte $00
counter3 ;żeby zliczać do trzech we funkcji 
    .byte $00 ;drawcanvasmulti i drawcanvassingle
    
canvaschar0 ;dla trybu single color
    .byte 160
;dwa znaki dla trybu multi color
canvaschar1
    .byte 160
canvaschar2
    .byte 160
    
mkeylock
    .byte $00
gkeylock
    .byte $00
fkeylock ;flip horizontal
    .byte $00
shiftfkeylock ;flip vertical
    .byte $00
ekeylock ;"light" mode
    .byte $00
pluskeylock
    .byte $00
minuskeylock
    .byte $00
akeylock
    .byte $00
shiftakeylock
    .byte $00
okeylock
    .byte $00
shiftokeylock
    .byte $00
lkeylock
    .byte $00
cbmlkeylock ;load
    .byte $00
cbmskeylock ;save
    .byte $00
cbmdkeylock ;disk dir view
    .byte $00
cbmxkeylock ;cut
    .byte $00
cbmckeylock ;copy
    .byte $00
cbmvkeylock ;paste
    .byte $00
cbmcommakeylock ;slide left
    .byte $00
cbmperiodkeylock ;slide right
    .byte $00
cbmcolonkeylock ;slide down
    .byte $00
cbmapekeylock ;slide up
    .byte $00
keytimer
    .repeat 4, keytimermax
    
filename
    .repeat 22, $00
filenamelen
    .byte $00

notstudio64str
    .screen "error: not a sprite studio 64 file      "
nodevstr
    .screen "error: device not present               "
invalidstr
    .screen "error: maybe invalid file               "
cantwritestr
    .screen "error: error while writing to file      "
emptystr
    .screen "                                        "
errormsglen
    .byte *-emptystr
getfilestr
    .screen "filename: "
getfilestrlen
    .byte *-getfilestr
    
spritestr
    .screen "sprite color "
spritestrlen
    .byte *-spritestr
multi0str
    .screen "multi-0 color"
multi0strlen
    .byte *-multi0str
multi1str
    .screen "multi-1 color"
multi1strlen
    .byte *-multi1str
bkgndstr
    .screen "bkgnd color  "
bkgndstrlen
    .byte *-bkgndstr
modestr
    .screen "multicolor: "
modestrlen
    .byte *-modestr
gridstr
    .screen "grid:       "
gridstrlen
    .byte *-gridstr
addrstr
    .screen "address:"
addrstrlen
    .byte *-addrstr
coordstr
    .screen "x:   y:"
coordstrlen
    .byte *-coordstr
animationstr
    .screen "animation:"
animationstrlen
    .byte *-animationstr
overlaystr
    .screen "overlay:"
overlaystrlen
    .byte *-overlaystr
lockstr
    .screen "addr lock:"
lockstrlen
    .byte *-lockstr
    
prgnamestr
    .screen "sprite studio 64"
prgnamestrlen
    .byte *-prgnamestr
versionstr
    .screen "ver. 1.0"
versionstrlen
    .byte *-versionstr
copyleftstr
    .screen "(c) 2023 by tobiasz stamborski"
copyleftstrlen
    .byte *-copyleftstr
musicstr
    .screen "music by raik picheta"
musicstrlen
    .byte *-musicstr
advocacystr
    .screen "pocket knife among sprite editors!"
advocacystrlen
    .byte *-advocacystr
splashinfostr
    .screen "hit space to continue"
splashinfostrlen
    .byte *-splashinfostr

;------------------------------------------------
;------------------------------------------------
;dodatkowe miejsce na kod dodatkowych
;funkcji programu

handlecbmcolonkeydown
    lda cbmcolonkeylock
    ora #$01
    sta cbmcolonkeylock
    rts
handlecbmcolonkeyup ;slide down
.block
    lda cbmcolonkeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    lda #<clipboard
    sta coladdr
    lda #>clipboard
    sta coladdr+1
    
    ldx #0
    lda coladdr
    clc
    adc #3
    sta coladdr
loop1major
    ldy #0
loop1minor
    lda (scraddr),y
    sta (coladdr),y
    iny
    cpy #3
    bne loop1minor
    
    lda scraddr
    clc
    adc #3
    sta scraddr
    lda coladdr
    clc
    adc #3
    sta coladdr
    inx
    cpx #20
    bne loop1major
    
    lda #<clipboard
    sta coladdr
    lda #>clipboard
    sta coladdr+1
    ldy #0
    lda (scraddr),y
    sta (coladdr),y
    iny
    lda (scraddr),y
    sta (coladdr),y
    iny
    lda (scraddr),y
    sta (coladdr),y
    
    ldy #0
loop2
    lda clipboard,y
    sta (spriteaddr),y
    iny
    cpy #63
    bne loop2
    
    jsr drawcanvas
    
    lda cbmcolonkeylock
    and #$fe
    sta cbmcolonkeylock
    rts
.bend
    
handlecbmapekeydown
    lda cbmapekeylock
    ora #$01
    sta cbmapekeylock
    rts
handlecbmapekeyup ;slideup
.block
    lda cbmapekeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    lda #<clipboard
    sta coladdr
    lda #>clipboard
    sta coladdr+1
    
    lda coladdr
    clc
    adc #60
    sta coladdr
    ldy #0
    lda (scraddr),y
    sta (coladdr),y
    iny
    lda (scraddr),y
    sta (coladdr),y
    iny
    lda (scraddr),y
    sta (coladdr),y
    
    lda #<clipboard
    sta coladdr
    lda #>clipboard
    sta coladdr+1
    ldx #0
    lda scraddr
    clc
    adc #3
    sta scraddr
loop1major
    ldy #0
loop1minor
    lda (scraddr),y
    sta (coladdr),y
    iny
    cpy #3
    bne loop1minor
    
    lda scraddr
    clc
    adc #3
    sta scraddr
    lda coladdr
    clc
    adc #3
    sta coladdr
    inx
    cpx #20
    bne loop1major
    
    ldy #0
loop2
    lda clipboard,y
    sta (spriteaddr),y
    iny
    cpy #63
    bne loop2
    
    jsr drawcanvas
    
    lda cbmapekeylock
    and #$fe
    sta cbmapekeylock
    rts
.bend

slideleft
.block
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    
    ldx #0
loop
    lda #0
    sta tmpbyte
    sta tmpbyte+1
    sta tmpbyte+2
    ldy #0
    lda (scraddr),y
    clc
    asl
    sta (scraddr),y
    bcc *+7
    lda #1
    sta tmpbyte
    iny
    lda (scraddr),y
    clc
    asl
    sta (scraddr),y
    bcc *+7
    lda #1
    sta tmpbyte+1
    iny
    lda (scraddr),y
    clc
    asl
    sta (scraddr),y
    bcc *+7
    lda #1
    sta tmpbyte+2
    
    ;y=2
    lda (scraddr),y
    ora tmpbyte
    sta (scraddr),y
    dey
    lda (scraddr),y
    ora tmpbyte+2
    sta (scraddr),y
    dey
    lda (scraddr),y
    ora tmpbyte+1
    sta (scraddr),y
    
    clc
    lda scraddr
    adc #3
    sta scraddr
    inx
    cpx #21
    bne loop
    
    rts
.bend

slideright
.block
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    
    ldx #0
loop
    lda #0
    sta tmpbyte
    sta tmpbyte+1
    sta tmpbyte+2
    ldy #0
    lda (scraddr),y
    clc
    lsr
    sta (scraddr),y
    bcc *+7
    lda #128
    sta tmpbyte
    iny
    lda (scraddr),y
    clc
    lsr
    sta (scraddr),y
    bcc *+7
    lda #128
    sta tmpbyte+1
    iny
    lda (scraddr),y
    clc
    lsr
    sta (scraddr),y
    bcc *+7
    lda #128
    sta tmpbyte+2
    
    ;y=2
    lda (scraddr),y
    ora tmpbyte+1
    sta (scraddr),y
    dey
    lda (scraddr),y
    ora tmpbyte
    sta (scraddr),y
    dey
    lda (scraddr),y
    ora tmpbyte+2
    sta (scraddr),y
    
    clc
    lda scraddr
    adc #3
    sta scraddr
    inx
    cpx #21
    bne loop
    
    rts
.bend
    
handlecbmcommakeydown
    lda cbmcommakeylock
    ora #$01
    sta cbmcommakeylock
    rts
handlecbmcommakeyup ;slideup
.block
    lda cbmcommakeylock
    and #$01
    bne *+3
    rts
    
    jsr slideleft
    lda multimode
    beq *+5
    jsr slideleft
    
    jsr drawcanvas
    
    lda cbmcommakeylock
    and #$fe
    sta cbmcommakeylock
    rts
.bend

handlecbmperiodkeydown
    lda cbmperiodkeylock
    ora #$01
    sta cbmperiodkeylock
    rts
handlecbmperiodkeyup ;slideup
.block
    lda cbmperiodkeylock
    and #$01
    bne *+3
    rts
    
    jsr slideright
    lda multimode
    beq *+5
    jsr slideright
    
    jsr drawcanvas
    
    lda cbmperiodkeylock
    and #$fe
    sta cbmperiodkeylock
    rts
.bend

disablepreview
    lda #$80
    sta $d015
    rts
    
setupmusic
    sei
    lda #$00
    jsr music
    cli
    rts
    
setupirqstd
    sei
    
    lda #%01111111
    sta $dc0d
    sta $dd0d
    
    and $d011
    sta $d011
    
    lda $dc0d
    lda $dd0d
    
    lda #210
    sta $D012

    lda #<irqstd
    sta $0314
    lda #>irqstd
    sta $0315

    lda #%00000001
    sta $D01A
    
    cli
    rts
    
setupirqkblisten
    sei
    
    lda #%01111111
    sta $dc0d
    sta $dd0d
    
    and $d011
    sta $d011
    
    lda $dc0d
    lda $dd0d
    
    lda #210
    sta $D012

    lda #<irqkblisten
    sta $0314
    lda #>irqkblisten
    sta $0315

    lda #%00000001
    sta $D01A
    
    cli
    rts
    
irqstd
    jsr music+3

    asl $d019
    jmp $ea81
    
irqkblisten
    jsr music+3

    asl $d019
    jmp $ea31

;------------------------------------------------
;------------------------------------------------
;$3000 - $4000
;IS SPRITE BANK

    *=$3000
    .offs $3000-*
    
    .binary "default-spritebank.raw"
    
;------------------------------------------------
;------------------------------------------------
; GŁÓWNY KOD PROGRAMU

    *=$4000
    .offs $4000-*
    
init
    lda #0
    sta $d021 ;ekran na czarno
    sta $d020
    
    lda #$30
    sta spriteaddr+1
    lda #$00
    sta spriteaddr
    
    jsr initcharset
    
    jsr showsplash ;splash screen
    
    jsr clrscr
    
    jsr draweditborder
    jsr setupall
    
    jsr setupmusic
    jsr setupirqstd
    
mainloop
    jsr readkeyboard
    jsr readjoy
    
    jsr updatecursor
    jsr updatepreview
    
    jmp mainloop
    
    rts
    
;------------------------------------------------

showsplash
.block
    lda #1
    sta $d021
    
    jsr clrscr
    
    #drawprgicon 4,4
    #print prgnamestr,(40*4)+9, prgnamestrlen,0
    #print versionstr,(40*6)+9, versionstrlen,0
    #print copyleftstr,(40*8)+9, copyleftstrlen,0
    #print musicstr,(40*10)+9, musicstrlen,0
    
    #print advocacystr,(40*16)+3, advocacystrlen,0
    
    #print splashinfostr,(40*23)+9, splashinfostrlen,0
    
    sei
    lda #%11111111
    sta $dc02
    lda #%00000000
    sta $dc03
loop1
    lda #%01111111 ;7
    sta $dc00
    lda $dc01
    and #%00010000 ;spacja
    bne loop1
loop2
    lda $dc01
    and #%00010000 ;spacja
    beq loop2
    cli
    
    lda #0
    sta $d021
    rts
.bend

;------------------------------------------------

setuppreview
.block
    lda addrlock
    cmp #0
    bne *+10
    lda spriteaddr
    sta previewaddr
    lda spriteaddr+1
    sta previewaddr+1

    ;wskazniki
    jsr div64addr
    sta 2040
    sta sprite0base
    clc
    adc animationmode
    sta 2041
    sta sprite1base
    clc
    adc animationmode
    sta 2042
    sta sprite2base
    clc
    adc animationmode
    sta 2043
    sta sprite3base
    
    ;wspolrzedne
    lda $d010
    ora #%00001111
    sta $d010
    lda #0
    sta $d000
    sta $d002
    sta $d004
    sta $d006
    lda #155
    sta $d001
    sta $d003
    sta $d005
    sta $d007
    
    ;podwojna wysokosc/szerokosc
    lda #%00001111
    sta $d017
    sta $d01d
    
    lda previewaddr
    sta dataaddr
    lda previewaddr+1
    sta dataaddr+1
    
    ;ustawic kolor
    ldy #63
    lda (dataaddr),y
    sta $d027
    ;single/multi color
    jsr loadmultifrom
    cmp #0
    bne *+13
    lda $d01c
    and #%11111110
    sta $d01c
    jmp *+11
    lda $d01c
    ora #%00000001
    sta $d01c
    ;natepny sprite
    ldx #0
loop1
    lda dataaddr
    clc
    adc #$40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    inx
    cpx animationmode
    bne loop1
    
    ;ustawic kolor
    ldy #63
    lda (dataaddr),y
    sta $d028
    ;single/multi color
    jsr loadmultifrom
    cmp #0
    bne *+13
    lda $d01c
    and #%11111101
    sta $d01c
    jmp *+11
    lda $d01c
    ora #%00000010
    sta $d01c
    ;natepny sprite
    ldx #0
loop2
    lda dataaddr
    clc
    adc #$40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    inx
    cpx animationmode
    bne loop2
    
    ;ustawic kolor
    ldy #63
    lda (dataaddr),y
    sta $d029
    ;single/multi color
    jsr loadmultifrom
    cmp #0
    bne *+13
    lda $d01c
    and #%11111011
    sta $d01c
    jmp *+11
    lda $d01c
    ora #%00000100
    sta $d01c
    ;natepny sprite
    ldx #0
loop3
    lda dataaddr
    clc
    adc #$40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    inx
    cpx animationmode
    bne loop3
    
    ;ustawic kolor
    ldy #63
    lda (dataaddr),y
    sta $d02a
    ;single/multi color
    jsr loadmultifrom
    cmp #0
    bne *+13
    lda $d01c
    and #%11110111
    sta $d01c
    jmp *+11
    lda $d01c
    ora #%00001000
    sta $d01c
    ;natepny sprite
    ldx #0
loop4
    lda dataaddr
    clc
    adc #$40
    sta dataaddr
    bcc *+4
    inc dataaddr+1
    inx
    cpx animationmode
    bne loop4
    
    lda multi0col
    sta $d025
    lda multi1col
    sta $d026
    
    ;enable
    lda #$80
    sta $d015
    ldx #0
    lda #$01
    sta tmpbyte
enable
    lda $d015
    ora tmpbyte
    sta $d015
    asl tmpbyte
    inx
    cpx overlaymode
    bne enable
    
    rts
.bend

;pobiera tryb multicolor - 0 lub 1
;dla sprite z adresu dataaddr
loadmultifrom
.block
    ldy #63
    lda (dataaddr),y
    
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    
    rts
.bend

;dzieli adres sprite (previewaddr)
;przez 64
;a = wynik
div64addr
.block
    lda previewaddr
    sta scraddr
    lda previewaddr+1
    sta scraddr+1
    
    ldx #0
loop
    lda scraddr
    sec
    sbc #64
    inx
    sta scraddr
    bcs loop
    dec scraddr+1
    bpl loop
    dex
    
    txa    
    
    rts
.bend

updatepreview
    lda animationmode
    cmp #1
    bne *+3
    rts
    
    dec animtimer
    beq *+3
    rts
    lda #animtimermax
    sta animtimer
    
    lda sprite0base
    clc
    adc animationmode
    sta tmpbyte
    inc 2040
    lda 2040
    cmp tmpbyte
    bne *+8
    lda sprite0base
    sta 2040
    
    lda sprite1base
    clc
    adc animationmode
    sta tmpbyte
    inc 2041
    lda 2041
    cmp tmpbyte
    bne *+8
    lda sprite1base
    sta 2041
    
    lda sprite2base
    clc
    adc animationmode
    sta tmpbyte
    inc 2042
    lda 2042
    cmp tmpbyte
    bne *+8
    lda sprite2base
    sta 2042
    
    lda sprite3base
    clc
    adc animationmode
    sta tmpbyte
    inc 2043
    lda 2043
    cmp tmpbyte
    bne *+8
    lda sprite3base
    sta 2043
    
    rts

;------------------------------------------------

setupcursor
.block
    ;wskaznik
    lda #cursorsprite/$40
    sta 2047
    
    ;multi/single color
    lda multimode
    cmp #0
    beq *+13
    inc 2047
    lda #16
    sta tmpbyte
    jmp *+8
    lda #8
    sta tmpbyte
    
    ;wspolrzedne
    lda #24+8
    ldx cursorx
loop1
    clc
    adc tmpbyte
    dex
    bne loop1
    sta $d00e
    
    lda #50+8
    ldx cursory
loop2
    clc
    adc #8
    dex
    bne loop2
    sta $d00f
    
    ;ustawic single color dla tego sprite
    lda $d01c
    and #%01111111
    sta $d01c
    
    ;enable
    lda $d015
    ora #%10000000
    sta $d015
    
    ;wypisac wspolrzedne na ekranie
    jsr drawcoord
    
    rts
.bend
    
updatecursor
    inc $d02e
    bne *+5
    inc $d02e
    
    rts
    
;------------------------------------------------

setupall
    jsr readmultimode
    jsr drawoptions
    jsr setupcursor
    
    jsr readspritecol
    jsr correctcolchoose
    
    jsr drawaddress
    jsr drawcanvas
    
    jsr drawprevopts
    jsr setuppreview
    
    rts

;------------------------------------------------

draweditborder
.block
    ;obramowanie pola edycji
    lda #64 ;rogi
    sta 1024
    lda #66
    sta 1024+24+1
    lda #72
    sta 1024+(22*40)
    lda #74
    sta 1024+(22*40)+24+1
    
    lda #65 ;gora
    ldx #0
drawloop1
    sta 1024+1,x
    inx
    cpx #24
    bne drawloop1
    
    lda #73 ;dol
    ldx #0
drawloop2
    sta 1024+(22*40)+1,x
    inx
    cpx #24
    bne drawloop2

    lda #$04 ;lewy bok
    sta scraddr+1
    lda #$28
    sta scraddr
    ldy #0
    ldx #21
drawloop3
    lda #68
    sta (scraddr),y
    clc
    lda scraddr
    adc #40
    bcc *+4
    inc scraddr+1
    sta scraddr
    dex
    bne drawloop3
    
    lda #$04 ;prawy bok
    sta scraddr+1
    lda #$41
    sta scraddr
    ldy #0
    ldx #21
drawloop4
    lda #70
    sta (scraddr),y
    clc
    lda scraddr
    adc #40
    bcc *+4
    inc scraddr+1
    sta scraddr
    dex
    bne drawloop4
    
    rts
    
.bend
    
;------------------------------------------------

drawcolorchoose
.block
    ;kratki na kolory
    lda #64
    sta 1024+40+27
    sta 1024+40+30
    sta 1024+40+33
    sta 1024+40+36
    lda #65
    sta 1024+40+28
    sta 1024+40+31
    sta 1024+40+34
    sta 1024+40+37
    lda #66
    sta 1024+40+29
    sta 1024+40+32
    sta 1024+40+35
    sta 1024+40+38
    
    lda #68
    sta 1024+80+27
    sta 1024+80+30
    sta 1024+80+33
    sta 1024+80+36
    lda #70
    sta 1024+80+29
    sta 1024+80+32
    sta 1024+80+35
    sta 1024+80+38
    
    lda #72
    sta 1024+120+27
    sta 1024+120+30
    sta 1024+120+33
    sta 1024+120+36
    lda #73
    sta 1024+120+28
    sta 1024+120+31
    sta 1024+120+34
    sta 1024+120+37
    lda #74
    sta 1024+120+29
    sta 1024+120+32
    sta 1024+120+35
    sta 1024+120+38
    
    ;pokolorowac jako nieaktywne najpierw
    lda #11
    
    sta $d800+40+27
    sta $d800+40+30
    sta $d800+40+33
    sta $d800+40+36
    
    sta $d800+40+28
    sta $d800+40+31
    sta $d800+40+34
    sta $d800+40+37
    
    sta $d800+40+29
    sta $d800+40+32
    sta $d800+40+35
    sta $d800+40+38
    
    sta $d800+80+27
    sta $d800+80+30
    sta $d800+80+33
    sta $d800+80+36
    
    sta $d800+80+29
    sta $d800+80+32
    sta $d800+80+35
    sta $d800+80+38
    
    sta $d800+120+27
    sta $d800+120+30
    sta $d800+120+33
    sta $d800+120+36
    
    sta $d800+120+28
    sta $d800+120+31
    sta $d800+120+34
    sta $d800+120+37
    
    sta $d800+120+29
    sta $d800+120+32
    sta $d800+120+35
    sta $d800+120+38
    
    ;wypelnic wybranymi kolorami
    lda #69
    sta 1024+80+28
    sta 1024+80+31
    sta 1024+80+34
    sta 1024+80+37
    lda spritecol
    sta $d800+80+28
    lda multi0col
    sta $d800+80+31
    lda multi1col
    sta $d800+80+34
    lda bkgndcol
    sta $d800+80+37
    
    lda curcol
    cmp #spriteon
    bne *+5
    jmp drawspritechoose
    cmp #multi0on
    bne *+5
    jmp drawmulti0choose
    cmp #multi1on
    bne *+5
    jmp drawmulti1choose
    jmp drawbkgndchoose
    
drawspritechoose
    #print spritestr,27,spritestrlen,5
    
    ;pokolorowac jako aktywny
    lda #1
    sta $d800+40+27
    sta $d800+40+28
    sta $d800+40+29
    sta $d800+80+27
    sta $d800+80+29
    sta $d800+120+27
    sta $d800+120+28
    sta $d800+120+29
    
    rts
    
drawmulti0choose
    #print multi0str,27,multi0strlen,5

    lda #1
    sta $d800+40+30
    sta $d800+40+31
    sta $d800+40+32
    sta $d800+80+30
    sta $d800+80+32
    sta $d800+120+30
    sta $d800+120+31
    sta $d800+120+32
    
    rts
    
drawmulti1choose
    #print multi1str,27,multi1strlen,5

    lda #1
    sta $d800+40+33
    sta $d800+40+34
    sta $d800+40+35
    sta $d800+80+33
    sta $d800+80+35
    sta $d800+120+33
    sta $d800+120+34
    sta $d800+120+35
    
    rts
    
drawbkgndchoose
    #print bkgndstr,27,bkgndstrlen,5

    lda #1
    sta $d800+40+36
    sta $d800+40+37
    sta $d800+40+38
    sta $d800+80+36
    sta $d800+80+38
    sta $d800+120+36
    sta $d800+120+37
    sta $d800+120+38
    
    rts
    
.bend
;------------------------------------------------

drawoptions
.block
    #print modestr,200+27,modestrlen,5
    
    lda multimode
    cmp #0
    bne multi
single
    lda #67
    jmp next1
multi
    lda #71
next1
    sta 1024+200+39
    
    #print gridstr,240+27,gridstrlen,5
    
    lda gridmode
    cmp #0
    bne grid
nogrid
    lda #67
    jmp next2
grid
    lda #71
next2
    sta 1024+240+39
    
    rts
.bend

;------------------------------------------------

drawaddress
.block
    #print addrstr,320+27,addrstrlen,5
    
    lda #36 ;$
    sta 1024+320+35
    
    lda spriteaddr+1
    lsr
    lsr
    lsr
    lsr
    sec
    cmp #10
    bcc digit1
hexdigit1
    sec
    sbc #9
    jmp end1
digit1
    clc
    adc #48
end1
    sta 1024+320+36
    
    lda spriteaddr+1
    and #$0f
    sec
    cmp #10
    bcc digit2
hexdigit2
    sec
    sbc #9
    jmp end2
digit2
    clc
    adc #48
end2
    sta 1024+320+37
    
    lda spriteaddr
    lsr
    lsr
    lsr
    lsr
    sec
    cmp #10
    bcc digit3
hexdigit3
    sec
    sbc #9
    jmp end3
digit3
    clc
    adc #48
end3
    sta 1024+320+38
    
    lda spriteaddr
    and #$0f
    sec
    cmp #10
    bcc digit4
hexdigit4
    sec
    sbc #9
    jmp end4
digit4
    clc
    adc #48
end4
    sta 1024+320+39
    
    lda #42 ;*
    sta 1024+360+37
    lda #54 ;6
    sta 1024+360+38
    lda #52 ;4
    sta 1024+360+39
    
    lda #5 ;zielony
    sta $d800+360+37
    sta $d800+360+38
    sta $d800+360+39
    sta $d800+360+34
    sta $d800+360+35
    sta $d800+360+36
    
    lda addrindex+1
    and #$0f
    clc
    adc #48
    sta 1024+360+34
    lda addrindex
    lsr
    lsr
    lsr
    lsr
    clc
    adc #48
    sta 1024+360+35
    lda addrindex
    and #$0f
    clc
    adc #48
    sta 1024+360+36
    
    rts
.bend

;------------------------------------------------

drawprevopts
.block
    #print animationstr,800+27,animationstrlen,5
    #print overlaystr,840+27,overlaystrlen,5
    #print lockstr,880+27,lockstrlen,5
    
    lda animationmode
    clc
    adc #48
    sta 1024+800+37
    
    lda overlaymode
    clc
    adc #48
    sta 1024+840+35
    
    lda addrlock
    cmp #0
    bne *+15
    lda #96
    sta 1024+880+37
    lda #97
    sta 1024+880+38
    jmp *+13
    lda #32
    sta 1024+880+38
    lda #98
    sta 1024+880+37
    
    lda #1
    sta $d800+800+37
    sta $d800+840+35
    sta $d800+880+37
    sta $d800+880+38

    rts
.bend

;------------------------------------------------

drawcoord
    #print coordstr, 440+27, coordstrlen, 5
    
    lda cursorx
    jsr div10
    txa
    clc
    adc #48
    sta 1024+440+29
    tya
    clc
    adc #48
    sta 1024+440+30
    
    lda #1 ;biały
    sta $d800+440+29
    sta $d800+440+30
    
    lda cursory
    jsr div10
    txa
    clc
    adc #48
    sta 1024+440+34
    tya
    clc
    adc #48
    sta 1024+440+35

    rts

;zwraca reszte i wynik dzielenia przez 10
;dla liczby 0-99 w akumulatorze
;x = wynik
;y = reszta
div10
.block
    ldx #0
loop
    sec
    sbc #10
    inx
    bcs loop
    
    dex
    adc #10
    tay

    rts
.bend

;------------------------------------------------

drawcanvas
    lda multimode
    and #$01
    bne *+6
    jsr drawcanvassingle
    rts
    jsr drawcanvasmulti
    rts
    
drawcanvassingle
.block
    ldy #0
    lda #$d8
    sta coladdr+1
    lda #$04
    sta scraddr+1
    lda #$29
    sta scraddr
    sta coladdr
    lda #0
    sta counter3
drawloop
    lda (spriteaddr),y
    sta spritebyte
    sty spriteindex
    
    ldx #0
byteloop
    lda spritebyte
    sta tmpbyte
    
    txa
    tay
shiftloop
    cpy #0
    beq shiftloopend
    lsr tmpbyte
    dey
    bne shiftloop
shiftloopend
    
    lda tmpbyte
    and #$01
    cmp #spriteon
    beq drawspritecol
    cmp #bkgndon
    beq drawbkgndcol
drawspritecol
    lda spritecol
    jmp byteend
drawbkgndcol
    lda bkgndcol
    jmp byteend
byteend

    pha
    stx tmpbyte
    lda #7
    sec
    sbc tmpbyte
    tay
    pla
    
    sta (coladdr),y
    lda canvaschar0
    sta (scraddr),y
    
    inx
    cpx #8
    bne byteloop

    ldy spriteindex
    iny
    inc counter3
    lda counter3
    cmp #3
    beq linedown
right8
    lda scraddr
    clc
    adc #8
    bcc *+6
    inc scraddr+1
    inc coladdr+1
    sta scraddr
    sta coladdr
    jmp advend
linedown
    lda #0
    sta counter3
    lda scraddr
    clc
    adc #24
    bcc *+6
    inc scraddr+1
    inc coladdr+1
    sta scraddr
    sta coladdr
advend
    cpy #63
    beq drawend
    jmp drawloop
drawend

    rts
.bend

drawcanvasmulti
.block
    ldy #0
    lda #$d8
    sta coladdr+1
    lda #$04
    sta scraddr+1
    lda #$29
    sta scraddr
    sta coladdr
    lda #0
    sta counter3
drawloop
    lda (spriteaddr),y
    sta spritebyte
    sty spriteindex
    
    ldx #0
byteloop
    lda spritebyte
    sta tmpbyte
    
    txa
    tay
shiftloop
    cpy #0
    beq shiftloopend
    lsr tmpbyte
    dey
    bne shiftloop
shiftloopend
    
    lda tmpbyte
    and #$03
    cmp #spriteon
    beq drawspritecol
    cmp #multi0on
    beq drawmulti0col
    cmp #multi1on
    beq drawmulti1col
    cmp #bkgndon
    beq drawbkgndcol
drawspritecol
    lda spritecol
    jmp byteend
drawmulti0col
    lda multi0col
    jmp byteend
drawmulti1col
    lda multi1col
    jmp byteend
drawbkgndcol
    lda bkgndcol
    jmp byteend
byteend

    pha
    stx tmpbyte
    lda #6
    sec
    sbc tmpbyte
    tay
    pla
    
    sta (coladdr),y
    iny
    sta (coladdr),y
    lda canvaschar2
    sta (scraddr),y
    dey
    lda canvaschar1
    sta (scraddr),y
    
    inx
    inx
    cpx #8
    bne byteloop

    ldy spriteindex
    iny
    inc counter3
    lda counter3
    cmp #3
    beq linedown
right8
    lda scraddr
    clc
    adc #8
    bcc *+6
    inc scraddr+1
    inc coladdr+1
    sta scraddr
    sta coladdr
    jmp advend
linedown
    lda #0
    sta counter3
    lda scraddr
    clc
    adc #24
    bcc *+6
    inc scraddr+1
    inc coladdr+1
    sta scraddr
    sta coladdr
advend
    cpy #63
    beq drawend
    jmp drawloop
drawend

    rts
.bend

;------------------------------------------------

readkeyboard
.block
    ;sei
    
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
    jmp shifpressed
    lda #%10111111
    sta $dc00
    lda $dc01
    and #%00010000
    bne *+5
    jmp shifpressed
    
    ;sprawdz C=
    lda #%01111111
    sta $dc00
    lda $dc01
    and #%00100000
    bne *+5
    jmp cbmpressed
    
nomodifiers
    ;bez modyfikatorow
    lda #%11011111 ;5
    sta $dc00
    
    lda $dc01
    and #%00001000
    bne *+8
    jsr handleminuskeydown
    jmp *+6
    jsr handleminuskeyup
    
    lda $dc01
    and #%00000001
    bne *+8
    jsr handlepluskeydown
    jmp *+6
    jsr handlepluskeyup
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handlelkeydown
    jmp *+6
    jsr handlelkeyup
    
    lda #%11101111 ;4
    sta $dc00
    
    lda $dc01
    and #%01000000
    bne *+8
    jsr handleokeydown
    jmp *+6
    jsr handleokeyup
    
    lda $dc01
    and #%00010000
    bne *+8
    jsr handlemkeydown
    jmp *+6
    jsr handlemkeyup
    
    lda #%11110111 ;3
    sta $dc00
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handlegkeydown
    jmp *+6
    jsr handlegkeyup
    
    lda #%11111011 ;2
    sta $dc00
    
    lda $dc01
    and #%00100000
    bne *+8
    jsr handlefkeydown
    jmp *+6
    jsr handlefkeyup
    
    lda #%01111111 ;7
    sta $dc00
    
    lda $dc01
    and #%00010000
    bne *+5
    jsr handlespacekey
    
    lda $dc01
    and #%00000001
    bne *+5
    jsr handle1key
    
    lda $dc01
    and #%00001000
    bne *+5
    jsr handle2key
    
    lda #%11111101
    sta $dc00
    
    lda $dc01
    and #%00000001
    bne *+5
    jsr handle3key
    
    lda $dc01
    and #%00001000
    bne *+5
    jsr handle4key
    
    lda #%11111101 ;1
    sta $dc00
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handleakeydown
    jmp *+6
    jsr handleakeyup
    
    lda $dc01
    and #%01000000
    bne *+8
    jsr handleekeydown
    jmp *+6
    jsr handleekeyup
    
    lda #%11111110 ;0
    sta $dc00
    
    lda $dc01
    and #%00000001
    bne *+5
    jsr handledelkey
    
    lda $dc01
    and #%10000000
    bne *+5
    jsr handledownkey
    
    lda $dc01
    and #%00000100
    bne *+5
    jsr handlerightkey
    
    lda $dc01
    and #%00010000
    bne *+5
    jsr handlef1keydown
    
    lda $dc01
    and #%00100000
    bne *+5
    jsr handlef3keydown
    
    lda $dc01
    and #%01000000
    bne *+5
    jsr handlef5keydown
    
    lda $dc01
    and #%00001000
    bne *+5
    jsr handlef7keydown
    
    cli
    rts
    
shifpressed ;ze shiftem
    lda #%11111101 ;1
    sta $dc00
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handleshiftakeydown
    jmp *+6
    jsr handleshiftakeyup
    
    lda #%11111011 ;2
    sta $dc00
    
    lda $dc01
    and #%00100000
    bne *+8
    jsr handleshiftfkeydown
    jmp *+6
    jsr handleshiftfkeyup
    
    lda #%11101111 ;4
    sta $dc00
    
    lda $dc01
    and #%01000000
    bne *+8
    jsr handleshiftokeydown
    jmp *+6
    jsr handleshiftokeyup

    lda #%01111111 ;7
    sta $dc00
    
    lda $dc01
    and #%00010000
    bne *+5
    jsr handlespacekey
    
    lda #%11111110 ;0
    sta $dc00
    
    lda $dc01
    and #%00000001
    bne *+5
    jsr handledelkey
    
    lda $dc01
    and #%10000000
    bne *+5
    jsr handleupkey
    
    lda $dc01
    and #%00000100
    bne *+5
    jsr handleleftkey
    
    lda $dc01
    and #%00010000
    bne *+5
    jsr handlef2keydown
    
    lda $dc01
    and #%00100000
    bne *+5
    jsr handlef4keydown
    
    lda $dc01
    and #%01000000
    bne *+5
    jsr handlef6keydown
    
    lda $dc01
    and #%00001000
    bne *+5
    jsr handlef8keydown

    cli
    rts
    
cbmpressed
    lda #%01111111 ;7
    sta $dc00

    lda $dc01
    and #%01000000
    bne *+5
    jsr reset ;CBM+Q
    
    lda #%11011111 ;5
    sta $dc00
    
    lda $dc01
    and #%10000000
    bne *+8
    jsr handlecbmcommakeydown
    jmp *+6
    jsr handlecbmcommakeyup
    
    lda $dc01
    and #%00010000
    bne *+8
    jsr handlecbmperiodkeydown
    jmp *+6
    jsr handlecbmperiodkeyup
    
    lda $dc01
    and #%00100000
    bne *+8
    jsr handlecbmcolonkeydown
    jmp *+6
    jsr handlecbmcolonkeyup
    
    lda $dc01
    and #%01000000
    bne *+8
    jsr handlecbmapekeydown
    jmp *+6
    jsr handlecbmapekeyup
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handlecbmlkeydown
    jmp *+6
    jsr handlecbmlkeyup
    
    lda #%11111101 ;1
    sta $dc00
    
    lda $dc01
    and #%00100000
    bne *+8
    jsr handlecbmskeydown
    jmp *+6
    jsr handlecbmskeyup
    
    lda #%11111011 ;2
    sta $dc00
    
    lda $dc01
    and #%00000100
    bne *+8
    jsr handlecbmdkeydown
    jmp *+6
    jsr handlecbmdkeyup
    
    lda $dc01
    and #%10000000
    bne *+8
    jsr handlecbmxkeydown
    jmp *+6
    jsr handlecbmxkeyup
    
    lda $dc01
    and #%00010000
    bne *+8
    jsr handlecbmckeydown
    jmp *+6
    jsr handlecbmckeyup
    
    lda #%11110111 ;3
    sta $dc00
    
    lda $dc01
    and #%10000000
    bne *+8
    jsr handlecbmvkeydown
    jmp *+6
    jsr handlecbmvkeyup
    
    cli
    rts
.bend

;------------------------------------------------

handleupkey
    #handlekeytimer updowntimer
    
    dec cursory
    lda cursory
    cmp #255
    bne *+7
    lda #0
    sta cursory
    
    jsr setupcursor
    
    rts
    
handledownkey
    #handlekeytimer updowntimer
    
    inc cursory
    lda cursory
    cmp #21
    bne *+7
    lda #20
    sta cursory
    
    jsr setupcursor
    
    rts
    
handleleftkey
    #handlekeytimer leftrighttimer

    dec cursorx
    lda cursorx
    cmp #255
    bne *+7
    lda #0
    sta cursorx
    
    jsr setupcursor
    
    rts
    
handlerightkey
    #handlekeytimer leftrighttimer
    
    lda multimode
    cmp #0
    beq *+10
    lda #12
    sta tmpbyte
    jmp *+8
    lda #24
    sta tmpbyte
    
    inc cursorx
    lda cursorx
    cmp tmpbyte
    bne *+11
    dec tmpbyte
    lda tmpbyte
    sta cursorx
    
    jsr setupcursor

    rts
    
handledelkey
    #handlekeytimer spacetimer
    
    lda curcol
    pha
    lda #bkgndon
    sta curcol
    
    lda multimode
    cmp #0
    bne *+8
    jsr spacekeysingle
    jmp *+6
    jsr spacekeymulti
    
    pla
    sta curcol
    
    rts
    
handlespacekey
    #handlekeytimer spacetimer
    
    lda multimode
    cmp #0
    bne *+6
    jsr spacekeysingle
    rts
    jsr spacekeymulti
    rts

spacekeymulti
.block
    lda #0
    ldx cursory
    cpx #0
    beq loopend1
    clc
loop1
    adc #3
    dex
    bne loop1
loopend1
    sta spriteindex
    
    lda cursorx
    ldx #0
    sec
loop2
    inx
    sbc #4
    bcs loop2
    dex
    
    ;4 - reszta z dzielenia
    ;do przesuniecia bitowego nizej
    eor #$ff
    and #$03
    sta bitcounter
    
    ;suma ze wspolrzednych x i y
    lda spriteindex
    stx spriteindex
    clc
    adc spriteindex
    tay
    sty spriteindex
    
    ;pobrac wlasciwy bajt ze sprite'a
    lda (spriteaddr),y
    sta spritebyte
    
    ;przesuniecie bitowe
    lda curcol
    ldx bitcounter
    cpx #0
    beq loopend3
loop3
    asl
    asl
    dex
    bne loop3
loopend3
    sta tmpbyte
    
    lda #$03
    ldx bitcounter
    cpx #0
    beq loopend4
loop4
    asl
    asl
    dex
    bne loop4
loopend4
    eor #$ff
    sta bitmask
    
    lda spritebyte
    and bitmask
    ora tmpbyte
    ldy spriteindex
    sta (spriteaddr),y
    
    jsr drawcanvasmulti
    
    rts
.bend

spacekeysingle
.block
    lda #0
    ldx cursory
    cpx #0
    beq loopend1
    clc
loop1
    adc #3
    dex
    bne loop1
loopend1
    sta spriteindex
    
    lda cursorx
    ldx #0
    sec
loop2
    inx
    sbc #8
    bcs loop2
    dex
    
    ;8 - reszta z dzielenia
    ;do przesuniecia bitowego nizej
    eor #$ff
    and #$07
    sta bitcounter
    
    ;suma ze wspolrzednych x i y
    lda spriteindex
    stx spriteindex
    clc
    adc spriteindex
    tay
    sty spriteindex
    
    ;pobrac wlasciwy bajt ze sprite'a
    lda (spriteaddr),y
    sta spritebyte
    
    ;przesuniecie bitowe
    lda curcol
    cmp #0
    beq *+4
    lda #$01
    ldx bitcounter
    cpx #0
    beq loopend3
loop3
    asl
    dex
    bne loop3
loopend3
    sta tmpbyte
    
    lda #$01
    ldx bitcounter
    cpx #0
    beq loopend4
loop4
    asl
    dex
    bne loop4
loopend4
    eor #$ff
    sta bitmask
    
    lda spritebyte
    and bitmask
    ora tmpbyte
    ldy spriteindex
    sta (spriteaddr),y
    
    jsr drawcanvassingle
    
    rts
.bend

;------------------------------------------------

handle1key
    lda #spriteon
    sta curcol
    
    jsr drawcolorchoose
    
    rts
handle2key
    lda multimode
    cmp #0
    bne *+3
    rts
    
    lda #multi0on
    sta curcol
    
    jsr drawcolorchoose
    
    rts
handle3key
    lda multimode
    cmp #0
    bne *+3
    rts
    
    lda #multi1on
    sta curcol
    
    jsr drawcolorchoose
    
    rts
handle4key
    lda #bkgndon
    sta curcol
    
    jsr drawcolorchoose
    
    rts
    
;------------------------------------------------
    
handlef1keydown
    #handlekeytimer functiontimer
    
    inc spritecol
    jsr writespritecol
    jsr setupall
 
    rts
handlef2keydown
    #handlekeytimer functiontimer
    
    dec spritecol
    jsr writespritecol
    jsr setupall
    
    rts
    
handlef3keydown
    #handlekeytimer functiontimer
    
    inc multi0col
    jsr setupall
    
    rts
handlef4keydown
    #handlekeytimer functiontimer
    
    dec multi0col
    jsr setupall
    
    rts
    
handlef5keydown
    #handlekeytimer functiontimer
    
    inc multi1col
    jsr setupall

    rts
handlef6keydown
    #handlekeytimer functiontimer
    
    dec multi1col
    jsr setupall

    rts
    
handlef7keydown
    #handlekeytimer functiontimer
    
    inc bkgndcol
    jsr setupall

    rts
handlef8keydown
    #handlekeytimer functiontimer
    
    dec bkgndcol
    jsr setupall
    
    rts
    
writespritecol
    lda spritecol
    and #$0f
    sta tmpbyte
    
    ldy #63
    lda (spriteaddr),y
    and #$f0
    ora tmpbyte
    sta (spriteaddr),y
    
    rts
    
;------------------------------------------------

handlemkeydown
    lda mkeylock
    ora #$01
    sta mkeylock
    rts
handlemkeyup
.block
    lda mkeylock
    and #$01
    bne *+3
    rts
    
    lda multimode
    eor #$01
    sta multimode

    ;poprawic wspolrzedne kursora
    cmp #0
    beq *+8
    lsr cursorx
    jmp *+6
    asl cursorx
    
    jsr writemultimode
    
    jsr setupall
    
    lda mkeylock
    and #$fe
    sta mkeylock
    rts
.bend
    
handlegkeydown
    lda gkeylock
    ora #$01
    sta gkeylock
    rts
handlegkeyup
.block
    lda gkeylock
    and #$01
    bne *+3
    rts
    
    lda gridmode
    eor #$01
    sta gridmode
    
    and #$01
    beq gridoff
gridon
    lda #76
    sta canvaschar0
    lda #77
    sta canvaschar1
    lda #78
    sta canvaschar2
    jmp ifend
gridoff
    lda #160
    sta canvaschar0
    sta canvaschar1
    sta canvaschar2
ifend
    jsr setupall
    
    lda gkeylock
    and #$fe
    sta gkeylock
    rts
.bend

writemultimode
    lda multimode
    asl
    asl
    asl
    asl
    asl
    asl
    asl
    sta tmpbyte

    ldy #63
    lda (spriteaddr),y
    and #%01111111
    ora tmpbyte
    sta (spriteaddr),y
    
    rts

correctcolchoose
.block
    lda multimode
    cmp #0
    bne fend
    lda curcol
    cmp #multi0on
    beq correct
    cmp #multi1on
    beq correct
    jmp fend
correct
    lda #spriteon
    sta curcol
fend
    jsr drawcolorchoose
    rts
.bend

;------------------------------------------------

handleekeydown
    lda ekeylock
    ora #$01
    sta ekeylock
    rts
handleekeyup
.block
    lda ekeylock
    and #$01
    bne *+3
    rts
    
    lda lightmode
    eor #$01
    sta lightmode
    cmp #0
    bne *+10
    lda #0
    sta $d021
    jmp *+8
    lda #9
    sta $d021
    
    lda ekeylock
    and #$fe
    sta ekeylock
    rts
.bend

;------------------------------------------------

handlepluskeydown
    lda pluskeylock
    ora #$01
    sta pluskeylock
    rts
handlepluskeyup
.block
    lda pluskeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    clc
    adc #$40
    sta spriteaddr
    bcc *+4
    inc spriteaddr+1
    
    lda spriteaddr+1
    cmp #$40
    bne *+13
    lda #$3f
    sta spriteaddr+1
    lda #$c0
    sta spriteaddr
    jmp funcend
    
    sed
    clc
    lda addrindex
    adc #1
    sta addrindex
    bcc *+5
    inc addrindex+1
    cld
    
    lda #$00
    sta cursorx
    sta cursory
    
    jsr setupall
    
funcend
    lda pluskeylock
    and #$fe
    sta pluskeylock
    rts
.bend

handleminuskeydown
    lda minuskeylock
    ora #$01
    sta minuskeylock
    rts
handleminuskeyup
.block
    lda minuskeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    sec
    sbc #$40
    sta spriteaddr
    bcs *+4
    dec spriteaddr+1
    
    lda spriteaddr+1
    cmp #$2f
    bne *+13
    lda #$30
    sta spriteaddr+1
    lda #$00
    sta spriteaddr
    jmp funcend
    
    sed
    sec
    lda addrindex
    sbc #1
    sta addrindex
    bcs *+5
    dec addrindex+1
    cld
    
    lda #$00
    sta cursorx
    sta cursory
    
    jsr setupall
    
funcend
    lda minuskeylock
    and #$fe
    sta minuskeylock
    rts
.bend

readspritecol
    ldy #63
    lda (spriteaddr),y
    and #$0f
    sta spritecol
    
    rts
    
readmultimode
    ldy #63
    lda (spriteaddr),y
    and #%10000000
    beq *+8
    
    lda #$01
    sta multimode
    rts
    
    lda #$00
    sta multimode
    rts
    
;------------------------------------------------

handleakeydown
    lda akeylock
    ora #$01
    sta akeylock
    rts
handleakeyup
.block
    lda akeylock
    and #$01
    bne *+3
    rts
    
    inc animationmode
    lda animationmode
    cmp #9
    bne *+7
    lda #8
    sta animationmode
    
    jsr setupall
    
    lda akeylock
    and #$fe
    sta akeylock
    rts
.bend

handleshiftakeydown
    lda shiftakeylock
    ora #$01
    sta shiftakeylock
    rts
handleshiftakeyup
.block
    lda shiftakeylock
    and #$01
    bne *+3
    rts
    
    dec animationmode
    lda animationmode
    cmp #0
    bne *+7
    lda #1
    sta animationmode
    
    jsr setupall
    
    lda shiftakeylock
    and #$fe
    sta shiftakeylock
    rts
.bend

handleokeydown
    lda okeylock
    ora #$01
    sta okeylock
    rts
handleokeyup
.block
    lda okeylock
    and #$01
    bne *+3
    rts
    
    inc overlaymode
    lda overlaymode
    cmp #5
    bne *+7
    lda #4
    sta overlaymode
    
    jsr setupall
    
    lda okeylock
    and #$fe
    sta okeylock
    rts
.bend

handleshiftokeydown
    lda shiftokeylock
    ora #$01
    sta shiftokeylock
    rts
handleshiftokeyup
.block
    lda shiftokeylock
    and #$01
    bne *+3
    rts
    
    dec overlaymode
    lda overlaymode
    cmp #0
    bne *+7
    lda #1
    sta overlaymode
    
    jsr setupall
    
    lda shiftokeylock
    and #$fe
    sta shiftokeylock
    rts
.bend

handlelkeydown
    lda lkeylock
    ora #$01
    sta lkeylock
    rts
handlelkeyup
.block
    lda lkeylock
    and #$01
    bne *+3
    rts
    
    lda addrlock
    eor #$01
    sta addrlock
    
    jsr setupall
    
    lda lkeylock
    and #$fe
    sta lkeylock
    rts
.bend

;------------------------------------------------
;funkcje wczytywania/zapisywania na dyskietce

handlecbmdkeydown
    lda cbmdkeylock
    ora #$01
    sta cbmdkeylock
    rts
handlecbmdkeyup
.block
    lda cbmdkeylock
    and #$01
    bne *+3
    rts

    lda #$00
    sta $d015 ;wylaczyc sprite'y
    lda #"$"
    sta filename
    
    ;kod zerzniety z forum csdb.dk (z lekkimi wlasnymi zmianami)
    ;z postu uzytkownika iAN CooG - thank you :)
    JSR $E544      ;clear screen
    lda #$1e       ;tekst na zielono
    jsr chrout
    LDA #$01
    LDX #<filename
    LDY #>filename
    JSR $FFBD      ; set filename "$"
    LDA #$08
    STA $BA        ; device #8
    LDA #$60
    STA $B9        ; secondary chn
    JSR $F3D5      ; open for serial bus devices
    JSR $F219      ; set input device
    LDY #$04
labl1
    inc $d020
    JSR $EE13      ; input byte on serial bus
    DEY
    BNE labl1      ; get rid of Y bytes
    LDA $C6        ; key pressed?
    ORA $90        ; or EOF?
    BNE labl2      ; if yes exit
    inc $d020
    JSR $EE13      ; now get in AX the dimension
    TAX            ; of the file
    inc $d020
    JSR $EE13
    JSR $BDCD      ; print number from AX
    lda #" "
    jsr chrout     ;spacja po numerze linii
labl3
    inc $d020
    JSR $EE13      ; now the filename
    JSR $E716      ; put a character to screen
    BNE labl3      ; while not 0 encountered
    JSR $AAD7      ; put a CR , end line
    LDY #$02       ; set 2 bytes to skip
    BNE labl1      ; repeat
labl2
    JSR $F642      ; close serial bus device
    JSR $F6F3      ; restore I/O devices to default
    lda #0
    sta $d020

    #print splashinfostr, (40*24), splashinfostrlen, 1
    
    lda #%11111111
    sta $dc02
    lda #%00000000
    sta $dc03
w8space1
    lda #%01111111 ;7
    sta $dc00
    lda $dc01
    and #%00010000 ;spacja
    bne w8space1
w8space2
    lda $dc01
    and #%00010000 ;spacja
    beq w8space2

    jsr clrscr
    jsr draweditborder
    jsr setupall

    lda cbmdkeylock
    and #$fe
    sta cbmdkeylock
    rts
.bend

handlecbmlkeydown
    lda cbmlkeylock
    ora #$01
    sta cbmlkeylock
    rts
handlecbmlkeyup
.block
    lda cbmlkeylock
    and #$01
    bne *+3
    rts
    
    jsr clrmsgs
    jsr getfilename
    cmp #0
    bne cancel
    
    jsr loadfile
    
    lda #$00
    sta cursorx
    sta cursory
    
    jsr setupall

    lda cbmlkeylock
    and #$fe
    sta cbmlkeylock
    rts

cancel
    jsr clrmsgs
    
    lda cbmlkeylock
    and #$fe
    sta cbmlkeylock
    rts
.bend

handlecbmskeydown
    lda cbmskeylock
    ora #$01
    sta cbmskeylock
    rts
handlecbmskeyup
.block
    lda cbmskeylock
    and #$01
    bne *+3
    rts
    
    jsr clrmsgs
    jsr getfilename
    cmp #0
    bne cancel
    ldx filenamelen
    lda #","
    sta filename,x
    inx
    lda #"p"
    sta filename,x
    inx
    lda #","
    sta filename,x
    inx
    lda #"w"
    sta filename,x
    inx
    stx filenamelen
    
    jsr savefile

    lda cbmskeylock
    and #$fe
    sta cbmskeylock
    rts

cancel
    jsr clrmsgs
    
    lda cbmskeylock
    and #$fe
    sta cbmskeylock
    rts
.bend

;------------------------------------------------
;funkcje do obsługi schowka

handlecbmxkeydown
    lda cbmxkeylock
    ora #$01
    sta cbmxkeylock
    rts
handlecbmxkeyup
.block
    lda cbmxkeylock
    and #$01
    bne *+3
    rts
    
    jsr copy
    
    ldy #0
loop
    lda #0
    sta (spriteaddr),y
    iny
    cpy #63
    bne loop
    
    lda #$00
    sta cursorx
    sta cursory
    jsr setupcursor
    
    jsr drawcanvas

    lda cbmxkeylock
    and #$fe
    sta cbmxkeylock
    rts
.bend

handlecbmckeydown
    lda cbmckeylock
    ora #$01
    sta cbmckeylock
    rts
handlecbmckeyup
.block
    lda cbmckeylock
    and #$01
    bne *+3
    rts
    
    jsr copy

    lda cbmckeylock
    and #$fe
    sta cbmckeylock
    rts
.bend

handlecbmvkeydown
    lda cbmvkeylock
    ora #$01
    sta cbmvkeylock
    rts
handlecbmvkeyup
.block
    lda cbmvkeylock
    and #$01
    bne *+3
    rts
    
    lda clipflag
    cmp #0
    bne *+5
    jmp fend
    
    ldy #0
loop
    lda clipboard,y
    sta (spriteaddr),y
    iny
    cpy #64
    bne loop
    
    lda #$00
    sta cursorx
    sta cursory
    
    jsr setupall

fend
    lda cbmvkeylock
    and #$fe
    sta cbmvkeylock
    rts
.bend

copy
.block
    ldy #0
loop
    lda (spriteaddr),y
    sta clipboard,y
    iny
    cpy #64
    bne loop
    
    lda #$01
    sta clipflag
    
    rts
.bend

;------------------------------------------------
;funkcje do odwracania sprite w pionie i poziomie

handlefkeydown
    lda fkeylock
    ora #$01
    sta fkeylock
    rts
handlefkeyup
.block
    lda fkeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    
    lda #<clipboard ;powinien byc tez wyrownany do 64
    sta coladdr
    lda #>clipboard
    sta coladdr+1

    ;przewracamy pokolei do schowka
    ldx #0
majorloop
    ldy #1
    lda (scraddr),y
    sta spritebyte
    lda multimode
    cmp #0
    bne *+8
    jsr revbitssingle
    jmp *+6
    jsr revbitsmulti
    lda spritebyte
    ldy #1
    sta (coladdr),y
    
    ldy #0
    lda (scraddr),y
    sta spritebyte
    lda multimode
    cmp #0
    bne *+8
    jsr revbitssingle
    jmp *+6
    jsr revbitsmulti
    lda spritebyte
    ldy #2
    sta (coladdr),y
    
    ldy #2
    lda (scraddr),y
    sta spritebyte
    lda multimode
    cmp #0
    bne *+8
    jsr revbitssingle
    jmp *+6
    jsr revbitsmulti
    lda spritebyte
    ldy #0
    sta (coladdr),y
    
    lda coladdr
    clc
    adc #3
    sta coladdr
    lda scraddr
    clc
    adc #3
    sta scraddr
    inx
    cpx #21
    bne majorloop
    
    ;przewrocone spowrotem do sprite banku
    ldy #0
loop
    lda clipboard,y
    sta (spriteaddr),y
    iny
    cpy #63
    bne loop
    
    ;i odrysowujemy
    jsr drawcanvas

    lda fkeylock
    and #$fe
    sta fkeylock
    rts
.bend

revbitssingle ;operuje na zmiennej spritebyte
.block
    lda #0
    sta tmpbyte
    
    lda spritebyte
    and #%10000000
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%01000000
    lsr
    lsr
    lsr
    lsr
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00100000
    lsr
    lsr
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00010000
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    ;i z drugiej strony
    lda spritebyte
    and #%00000001
    asl
    asl
    asl
    asl
    asl
    asl
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00000010
    asl
    asl
    asl
    asl
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00000100
    asl
    asl
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00001000
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    ;lda tmpbyte
    sta spritebyte

    rts
.bend

revbitsmulti ;operuje na zmiennej spritebyte
.block
    lda #0
    sta tmpbyte

    lda spritebyte
    and #%11000000
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00000011
    asl
    asl
    asl
    asl
    asl
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00110000
    lsr
    lsr
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    lda spritebyte
    and #%00001100
    asl
    asl
    sta bitmask
    lda tmpbyte
    ora bitmask
    sta tmpbyte
    
    ;lda tmpbyte
    sta spritebyte

    rts
.bend

handleshiftfkeydown
    lda shiftfkeylock
    ora #$01
    sta shiftfkeylock
    rts
handleshiftfkeyup
.block
    lda shiftfkeylock
    and #$01
    bne *+3
    rts
    
    lda spriteaddr
    sta scraddr
    lda spriteaddr+1
    sta scraddr+1
    
    lda #<clipboard ;powinien byc tez wyrownany do 64
    sta coladdr
    lda #>clipboard
    sta coladdr+1

    ;przewracamy pokolei do schowka
    ldx #0
    lda coladdr
    clc
    adc #60
    sta coladdr
majorloop

    ldy #0
minorloop
    lda (scraddr),y
    sta (coladdr),y
    iny
    cpy #3
    bne minorloop
    
    lda coladdr
    sec
    sbc #3
    sta coladdr
    lda scraddr
    clc
    adc #3
    sta scraddr
    inx
    cpx #21
    bne majorloop
    
    ;przewrocone spowrotem do sprite banku
    ldy #0
loop
    lda clipboard,y
    sta (spriteaddr),y
    iny
    cpy #63
    bne loop
    
    ;i odrysowujemy
    jsr drawcanvas

    lda shiftfkeylock
    and #$fe
    sta shiftfkeylock
    rts
.bend

;------------------------------------------------

readjoy
    lda #$00
    sta $dc02
    
    lda $dc00
    and #$10
    bne *+5
    jsr handlespacekey
    
    lda $dc00
    and #$01
    bne *+5
    jsr handleupkey
    
    lda $dc00
    and #$02
    bne *+5
    jsr handledownkey
    
    lda $dc00
    and #$04
    bne *+5
    jsr handleleftkey
    
    lda $dc00
    and #$08
    bne *+5
    jsr handlerightkey
    
    rts
    
;------------------------------------------------

getfilename
.block
    jsr setupirqkblisten

    #print getfilestr,(40*23),getfilestrlen,5

    ldx #23
    ldy #10
    clc
    jsr plot
    
    lda #5 ;petscii white
    jsr chrout
    
    lda #0
    sta filenamelen
    
preget
    jsr getin
    bne preget
get
    jsr getin
    beq get
    
    cmp #13 ;CR
    beq end
    cmp #3 ;run/stop
    beq cancel
    cmp #20 ;del
    beq del
    cmp #17
    beq get
    cmp #29
    beq get
    cmp #145
    beq get
    cmp #157
    beq get
    
    ldx filenamelen
    inx
    cpx #19
    beq get
    stx filenamelen
    
    dex
    sta filename,x
    jsr chrout
    jmp get
    
del
    ldx filenamelen
    cpx #0
    beq *+9
    dex
    stx filenamelen
    jsr chrout
    jmp get
end
    jsr setupirqstd
    lda #0
    rts
cancel
    jsr setupirqstd
    lda #1
    rts
.bend

savefile
    lda #0
    ldx #0
    ldy #0
    jsr setnam
    lda #15
    ldx #8
    ldy #15
    jsr setlfs
    jsr open
    
    lda filenamelen
    ldx #<filename
    ldy #>filename
    jsr setnam
    lda #2
    ldx #8
    ldy #2
    jsr setlfs
    clc
    jsr open
    bcc *+5
    jmp errornodev
    jsr printdiskmsg
    lda 1024+(40*24)
    cmp #"0"
    beq *+5
    jmp loadend
    lda 1024+(40*24)+1
    cmp #"0"
    beq *+5
    jmp loadend
    
    ldx #2
    jsr chkout
    
    inc $d020
    lda #<bankmin
    jsr chrout
    jsr readst
    cmp #0
    beq *+5
    jmp errorwrite
    inc $d020
    lda #>bankmin
    jsr chrout
    jsr readst
    cmp #0
    beq *+5
    jmp errorwrite
    
.block
    lda #<bankmin
    sta dataaddr
    lda #>bankmin
    sta dataaddr+1
majorloop
    ldy #0
minorloop
    jsr readst
    cmp #0
    beq *+5
    jmp errorwrite
    inc $d020
    lda (dataaddr),y
    jsr chrout
    iny
    bne minorloop
    inc dataaddr+1
    lda dataaddr+1
    cmp #>bankmax
    bne majorloop
.bend
    
    jmp loadend ;takie same jak i "saveend"

loadfile
    lda #0
    ldx #0
    ldy #0
    jsr setnam
    lda #15
    ldx #8
    ldy #15
    jsr setlfs
    jsr open
    
    lda filenamelen
    ldx #<filename
    ldy #>filename
    jsr setnam
    lda #2
    ldx #8
    ldy #2
    jsr setlfs
    clc
    jsr open
    bcc *+5
    jmp errornodev
    jsr printdiskmsg
    lda 1024+(40*24)
    cmp #"0"
    beq *+5
    jmp loadend
    lda 1024+(40*24)+1
    cmp #"0"
    beq *+5
    jmp loadend

    ldx #2
    jsr chkin
    
    inc $d020
    jsr chrin
    cmp #<bankmin
    beq *+5
    jmp errornotstudio64
    inc $d020
    jsr chrin
    cmp #>bankmin
    beq *+5
    jmp errornotstudio64
    
    jsr disablepreview

.block
    lda #<bankmin
    sta dataaddr
    lda #>bankmin
    sta dataaddr+1
majorloop
    ldy #0
minorloop
    jsr readst
    cmp #0
    beq *+5
    jmp errorread
    inc $d020
    jsr chrin
    sta (dataaddr),y
    iny
    bne minorloop
    inc dataaddr+1
    lda dataaddr+1
    cmp #>bankmax
    bne majorloop
.bend
    
loadend
    lda #2
    jsr close
    
    lda #15
    jsr close
    
    jsr clrchn
    
    lda #0
    sta $d020
    
    jsr setuppreview

    rts
    
errornotstudio64
    lda errormsglen
    ldx #<notstudio64str
    ldy #>notstudio64str
    jsr printmsg
    
    jmp loadend
    
errornodev
    lda errormsglen
    ldx #<nodevstr
    ldy #>nodevstr
    jsr printmsg
    
    jmp loadend
    
errorread
    lda errormsglen
    ldx #<invalidstr
    ldy #>invalidstr
    jsr printmsg
    
    jmp loadend
    
errorwrite
    lda errormsglen
    ldx #<cantwritestr
    ldy #>cantwritestr
    jsr printmsg
    
    jmp loadend
    
printdiskmsg
.block
    ldx #15
    jsr chkin
    
    ldx #24
    ldy #0
    clc
    jsr plot
    
    lda #30 ;petscii green
    jsr chrout
loop
    jsr chrin
    cmp #13 ;petscii CR
    beq loopend
    jsr chrout
    jmp loop
loopend

    rts
.bend
 
;wypisuje komunikat na zielono
;w ostatniej linijce ekranu
;a = len, x = <string, y = >string
printmsg
.block
    stx dataaddr
    sty dataaddr+1
    tay
    
loop
    dey
    lda (dataaddr),y
    sta 1024+(40*24),y
    lda #5
    sta $d800+(40*24),y
    cpy #0
    bne loop
    
    rts
.bend

clrmsgs
    #write emptystr,(40*23),errormsglen
    #write emptystr,(40*24),errormsglen
    rts

;------------------------------------------------

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
    
    lda #1 ;na bialo
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

;------------------------------------------------
    
initcharset
    ;zapisac adres ekranu i charsetu
    lda #$18
    sta $d018

    rts
    
