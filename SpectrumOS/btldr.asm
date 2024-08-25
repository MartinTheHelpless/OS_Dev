[BITS 16]
[ORG 0h]
 
? equ 0
imageLoadSeg equ 1000h

jmp short start
nop

bsoemname db "Spectrum"
bpbbytespersector dw ?
bpbsectorspercluster db ?
bpbreservedsectors dw ?
bpbnumberoffats db ?
bpbrootentries dw ?
bpbtotalsectors dw ?
bpbmedia db ?
bpbsectorsperfat dw ?
bpbsectorspertrack dw ?
bpbheadspercylinder dw ?
bpbhiddensectors dd ?
bpbtotalsectorsbig dd ?
bsdrivenumber db ?
bsunused db ?
bsextbootsignature db ?
bsserialnumber dd ?         
bsvolumelabel db "Spectrum  "
bsfilesystem db "FAT12   "

start:
mov dx, 0
mov ch, 0
mov cl, 13
mov ah, 1
int 10h
pusha
mov ah, 0h
mov al, 3h
int 10h
popa
cld
int 12h
shl ax, 6
sub ax, 512 / 16
mov es, ax
sub ax, 2048 / 16
mov ss, ax
mov sp, 2048
mov cx, 256
mov si, 7c00h
xor di, di
mov ds, di
rep movsw
push es
push word main

retf
 
main:
push cs
pop ds
mov [bsdrivenumber], dl
mov ax, [bpbbytespersector]
shr ax, 4
mov cx, [bpbsectorsperfat]
mul cx
mov di, ss
sub di, ax
mov es, di
xor bx, bx
mov ax, [bpbhiddensectors]
mov dx, [bpbhiddensectors+2]
add ax, [bpbreservedsectors]
adc dx, bx
call readsector
mov bx, ax
mov di, dx
mov ax, 32
mov si, [bpbrootentries]
mul si
div word [bpbbytespersector]
mov cx, ax
mov al, [bpbnumberoffats]
cbw
mul word [bpbsectorsperfat]
add ax, bx
adc dx, di
push es
push word imageLoadSeg
pop es
xor bx, bx
call readsector
add ax, cx
adc dx, bx
push dx
push ax
mov di, bx
mov dx, si
mov si, krnl_sys_filename
mov cx, 11

findnamecycle:
cmp byte [es:di], ch
je findnamefailed
pusha
repe cmpsb
popa
je findnamefound
add di, 32
dec dx
jnz findnamecycle

findnamefailed:
jmp errfind

findnamefound:
mov si, [es:di+1ah]

readnextcluster:
mov cx, 0fh
mov dx, 4240h
mov ah, 86h
int 15h
call readcluster
cmp si, 0ff8h
jc readnextcluster
cli
mov ax, imageLoadSeg
mov es, ax
mov ax, es
mov es, ax
mov ds, ax
mov ss, ax
xor sp, sp
push es
push word 0h
sti
mov cx, 0fh
mov dx, 4240h
mov ah, 86h
int 15h

retf
 
readcluster:
mov bp, sp
lea ax, [si-2]
xor ch, ch
mov cl, [bpbsectorspercluster]
mul cx
add ax, [ss:bp+1*2]
adc dx, [ss:bp+2*2]
call readsector
mov ax, [bpbbytespersector]
shr ax, 4
mul cx
mov cx, es
add cx, ax
mov es, cx
mov ax, 3
mul si
shr ax, 1
xchg ax, si
push ds
mov ds, [ss:bp+3*2]
mov si, [ds:si]
pop ds
jnc readclustereven
shr si, 4

readclustereven:
and si, 0fffh

readclusterdone:
ret

readsector:
pusha
 
readsectornext:
mov di, 5
 
readsectorretry:
pusha
div word [bpbsectorspertrack]
mov cx, dx
inc cx
xor dx, dx
div word [bpbheadspercylinder]
mov ch, al
shl ah, 6
or cl, ah
mov dh, dl
mov dl, [bsdrivenumber]
mov ax, 201h
int 13h
jnc readsectordone
xor ah, ah
int 13h
popa
dec di
jnz readsectorretry
jmp short errread
 
readsectordone:
popa
dec cx
jz readsectordone2
add bx, [bpbbytespersector]
add ax, 1
adc dx, 0
jmp short readsectornext
        
readsectordone2:
popa

ret
 
errread:
errfind:
jmp short $

times (512-13-($-$$)) db 0

krnl_sys_filename db "KRNL    SYS"

dw 0aa55h