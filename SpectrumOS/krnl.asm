[BITS 16]

main:
mov al, 3h ; 10h (Video + text mode)
call set_video_mode

call disable_blinking

call hide_cursor

call load_icons

call clear_screen

mov dl, 36
mov dh, 11
call set_cursor_position

mov si, spectrum
call print_string

mov dl, 38
mov dh, 12
call set_cursor_position

mov cx, 1
mov bl, 01000000b
call draw_block

mov dl, 39
mov dh, 12
call set_cursor_position

mov cx, 1
mov bl, 11100000b
call draw_block

mov dl, 40
mov dh, 12
call set_cursor_position

mov cx, 1
mov bl, 10100000b
call draw_block

mov dl, 41
mov dh, 12
call set_cursor_position

mov cx, 1
mov bl, 10110000b
call draw_block

call delay

call clear_screen

call get_configuration
call get_utilities
call count_pages
call count_files

call clear_screen

mov cx, 2000
mov bl, 11110000b
call draw_block

mov byte [start_from], 0

; First start?
mov ax, frst_cfg_filename
call file_exists
jc key_loop

;mov ax, frst_cfg_filename
;call remove_file

mov ax, frst_exe_filename
mov bx, 1000h
call load_file
jc file_not_found

call 1000h

key_loop:
;call clear_screen

xor dx, dx
call set_cursor_position

mov cx, 2000
mov bl, 11110000b
call draw_block

pusha
mov dh, [file_selector_dh]
mov dl, [file_selector_dl]
call set_cursor_position

mov cx, 8
mov bl, 00001111b
call draw_block
popa

xor cx, cx
mov cl, byte [start_from]
call draw_list

call wait_for_key

cmp ah, 49h
jz .sub_page
cmp ah, 51h
jz .add_page

cmp ah, 48h
jz .go_up
cmp ah, 50h
jz .go_down
cmp ah, 75
jz .go_left
cmp ah, 77
jz .go_right
cmp al, 13
jz .execute
jmp key_loop

.sub_page:
cmp byte [selected_page], 1
ja .spcan
jmp key_loop

.spcan:
mov byte [file_selector_dh], 5
mov byte [file_selector_dl], 1

sub byte [default_selected_file], 32
mov al, byte [default_selected_file]
mov byte [selected_file], al

dec byte [selected_page]
sub byte [start_from], 32
jmp key_loop

.add_page:
mov al, byte [page]
cmp byte [selected_page], al
jb .apcan
jmp key_loop

.apcan:
mov byte [file_selector_dh], 5
mov byte [file_selector_dl], 1

add byte [default_selected_file], 32
mov al, byte [default_selected_file]
mov byte [selected_file], al

inc byte [selected_page]
add byte [start_from], 32
jmp key_loop

.go_up:
cmp byte [file_selector_dh], 5
ja .gucan
jmp key_loop

.gucan:
sub byte [selected_file], 8
sub byte [file_selector_dh], 6
jmp key_loop

.go_down:
cmp byte [file_selector_dh], 23
jb .gdcan
jmp key_loop

.gdcan:
mov al, byte [files]
mov bl, byte [selected_file]
add bl, 8
cmp bl, al
jbe .gdcan2
jmp key_loop

.gdcan2:
add byte [selected_file], 8
add byte [file_selector_dh], 6
jmp key_loop

.go_left:
cmp byte [file_selector_dl], 1
ja .glcan
jmp key_loop

.glcan:
dec byte [selected_file]
sub byte [file_selector_dl], 10
jmp key_loop

.go_right:
cmp byte [file_selector_dl], 71
jb .grcan
jmp key_loop

.grcan:
mov al, byte [files]
cmp byte [selected_file], al
jb .grcan2
jmp key_loop

.grcan2:
inc byte [selected_file]
add byte [file_selector_dl], 10
jmp key_loop

.execute:
mov byte [filename_counter], 1

mov si, applications
mov di, filename

.select_filename:
lodsb
cmp al, ','
jz .add_number
cmp al, 0
jz .add_number
mov byte [di], al
inc di
jmp .select_filename

.add_number:
mov al, byte [selected_file]
cmp byte [filename_counter], al
jz .start_process
mov di, filename
inc byte [filename_counter]
jmp .select_filename

.start_process:
mov byte [di], 0

mov ax, filename
mov bx, 1000h
call load_file
jc file_not_found

xor cx, cx
xor dx, dx
.loop:
call 1000h
pusha
mov bx, 1000h
call load_file
jc .skip
call 1000h
mov ax, filename
mov bx, 1000h
call load_file
popa
jmp .loop
.skip:
popa
jmp key_loop

file_not_found:
mov si, file_not_found_message
call message_box
jmp key_loop

frst_cfg_filename db 'FRST.CFG', 0
frst_exe_filename db 'FRST.EXE', 0
file_not_found_message db 'Error: File not found!', 0

disk_buffer equ 24576
spectrum db 'Spectrum', 0
username db 'Default', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
computer_name db 'Default-PC', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
speaker_status db 'ON', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
applications times 10000 db 0
buttons times 30000 db 0
selected_page db 1
start_from db 0
file_selector_dh db 5
file_selector_dl db 1
selected_file db 1
default_selected_file db 1
filename_counter db 1
filename times 13 db 0

%include 'lib\string.asm'
%include 'lib\screen.asm'
%include 'lib\files.asm'
%include 'lib\keyboard.asm'
%include 'lib\kernel16.asm'
%include 'lib\tui.asm'