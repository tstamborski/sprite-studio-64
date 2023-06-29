# ![](https://github.com/tstamborski/pixelart-icons/blob/main/png/commodore-tool32.png) Sprite Studio 64
Native sprite editor for Commodore 64. Pocket knife among sprite editors!

## Screenshots
![Screenshot 1](screenshot-0.jpg)
![Screenshot 2](screenshot-1.jpg)
![Screenshot 3](screenshot-2.jpg)
![Screenshot 4](screenshot-3.jpg)

## Overview
Sprite Studio 64 is a native sprite editor for Commodore 64 computer.
It's made with simplicity and minimalism.
Sprite Studio 64 can edit simultaneously 64 sprites - only 64 but it has also some tools for animating them and sprite overlay.
It can save your work on diskette in a PRG file - this files can be loaded by basic LOAD command or be embedded in an assembly source code.
**Diskette image for latest version is [_here_](https://github.com/tstamborski/sprite-studio-64/releases/download/v1.1/Sprite-Studio-64.d64).**

## Disclaimer / Additional credits
Music used in this program is not mine - it was taken from https://www.hvsc.c64.org/ and its author is **Raik Picheta (Eco)**.

Thanks to scener **Soci** for a patch fixing program to doesn't use fixed 8 device number in loading/saving routines.

## Short instruction / Keyboard shortcuts
*IF YOU ARE USING EMULATOR THERE IS BETTER TO USE POSITIONAL THEN SYMBOLIC KEYBOARD.*
### DRAWING
* **[joystick directions]** or **[CRSR]** - move the drawing cursor around
* **[joystick fire]** or **[space]** - put choosen color in place of cursor
* **[del]** - erase / put background color in place of cursor
### CHANGING COLORS
* **[F1]** or **[Shift+F1]** - change sprite color
* **[F3]** or **[Shift+F3]** - change first multi-mode color
* **[F5]** or **[Shift+F5]** - change second multi-mode color
* **[F7]** or **[Shift+F7]** - change background color
* **[1]** - choose main sprite color for drawing
* **[2]** - choose multi color 1 for drawing
* **[3]** - choose multi color 2 for drawing
* **[4]** - choose background color for drawing
### ADVANCED EDITING
* **[M]** - switch on/off multicolor mode
* **[CBM+X]** - "cut" current sprite
* **[CBM+C]** - "copy" current sprite
* **[CBM+V]** - "paste" from clipboard to current sprite
* **[F]** - flip sprite horizontally (it affects the clipboard!)
* **[Shift+F]** - flip sprite vertically (it affects the clipboard!)
* **[CBM+,]** - slide sprite left
* **[CBM+.]** - slide sprite right
* **[CBM+:]** - slide sprite down
* **[CBM+@]** - slide sprite up
### MOVING AROUND AND PREVIEW
* **[+]** and **[-]** - change actual address by 64 bytes (it can edit 64 sprites, from address $3000 to $4000, simultaneously)
* **[L]** - "lock" address of first animation frame
* **[A]** or **[Shift+A]** - change number of animation frames
* **[O]** or **[Shift+O]** - change number of overlaying sprites
### SAVING AND LOADING
* **[CBM+L]** - load file from diskette
* **[CBM+S]** - save file on diskette - prefix filename with @: if you want to overwrite
* **[CBM+D]** - display disk directory
### MISC
* **[CBM+Q]** - exit from program and return to BASIC
* **[G]** - switch on/off the grid mode

## Building from source instructions
For building from source, you can use shipped make.bat batch file, but you will need following tools somewhere in PATH environment variable:
* **TMPx** assembler.
* **cc1541** tool for creating commodore floppy images.
* **Exomizer** cruncher - for packaging/zipping prg files.

If you want to use run.bat and runhelp.bat it will be nice to have **VICE** x64.exe somewhere in the PATH too.
