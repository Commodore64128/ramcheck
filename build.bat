64tass -a src\ramcheck.asm -l target\ramcheck.lbl -L target\ramcheck.lst -o target\ramcheck
cd target
c1541 -attach supercpu.d64 -delete ramcheck
c1541 -attach supercpu.d64 -write ramcheck ramcheck
cd ..