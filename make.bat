tmpx -i sprite-studio.s -o studio64.prg
tmpx -i help.s -o help.prg
tmpx -i examples.s -o examples.prg
tmpx -i examples2.s -o examples2.prg
tmpx -i examples3.s -o examples3.prg
tmpx -i empty.s -o empty.prg
del Sprite-Studio-64.d64
cc1541 -q -n "sprite studio 64" Sprite-Studio-64.d64
cc1541 -q -T DEL -f "----------------" -w cursor-sprites.raw Sprite-Studio-64.d64
cc1541 -q -P -f "studio64#a0,8,1" -w "studio64.prg" Sprite-Studio-64.d64
cc1541 -q -N -T DEL -f "----------------" -w cursor-sprites.raw Sprite-Studio-64.d64
cc1541 -q -P -f "help#a0,8,1" -w "help.prg" Sprite-Studio-64.d64
cc1541 -q -N -T DEL -f "----------------" -w cursor-sprites.raw Sprite-Studio-64.d64
cc1541 -q -f "examples" -w "examples.prg" Sprite-Studio-64.d64
cc1541 -q -f "examples2" -w "examples2.prg" Sprite-Studio-64.d64
cc1541 -q -f "examples3" -w "examples3.prg" Sprite-Studio-64.d64
cc1541 -q -f "empty" -w "empty.prg" Sprite-Studio-64.d64
cc1541 -q -N -T DEL -f "----------------" -w cursor-sprites.raw Sprite-Studio-64.d64
pause
