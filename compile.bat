rgbasm -L -o kefrens_bar.o kefrens_bar.asm
rgblink -o kefrens_bar.gb kefrens_bar.o
rgbfix -v -p 0xFF kefrens_bar.gb
