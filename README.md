# Sprite Studio 64
Native sprite editor for Commodore 64.
## Overview
Sprite Studio 64 is native sprite editor for Commodore 64 computer.
It's made with simplicity and minimalism, however it doesn't mean lack of most important features.
Sprite Studio 64 can edit simultaneously 64 sprites - only 64 but it has also some tools for animating them and sprite overlay.
It can save your work on diskette in PRG file - this files can be loaded by basic LOAD command or be embedded in assembly source code.
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
* **[CBM+L]** - load file from diskette (device 8)
* **[CBM+S]** - save file on diskette (device 8) - prefix filename with @: if you want to overwrite
### MISC
* **[CBM+Q]** - exit from program and return to BASIC
* **[G]** - switch on/off the grid mode
* **[E]** - switch different (brown or default black) color of overall screen background
## Screenshots
![Screenshot 1](screenshot-0.jpg)
![Screenshot 2](screenshot-1.jpg)
![Screenshot 3](screenshot-2.jpg)
![Screenshot 4](screenshot-3.jpg)
