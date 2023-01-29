; MAIN.ASM
; main code

; --- Program Start ---
SECTION "Program Start",ROM0[$0150]
START::
  di                         ; disable interrupts
  ld sp, $FFFE               ; set the stack to $FFFE

.setup
  ; setup graphics
  call WAIT_VRAM

  ; turn off LCD
  ld a, $00
  call SET_LDC_CFG

  call CLEAR_OAM
  call CLEAR_MAP

  ld hl, HEX_TILES
  ld c, 40
  call LOAD_TILES

  ld a, %11100100
  call SET_BACKGROUND_PALLETTE

  ld a, %10010011
  call SET_LDC_CFG

.test_cursor
  call WAIT_VBLANK
  call RESET_CURSOR
  call HELLO_WORLD

  call WAIT_VBLANK
  call NEWLINE
  call INDENT
  call WAIT_VBLANK
  call SPACE

  call WAIT_VBLANK
  call NEWLINE
  CALL GOODBYE_WORLD

.loop
  nop
  jr .loop
  

HELLO_WORLD:
  ld hl, strings.hello
  call PRINT_AT_CURSOR
  ret

GOODBYE_WORLD:
  ld hl, strings.goodbye
  call PRINT_AT_CURSOR
  ret

INDENT:
  ld hl, strings.indent
  call PRINT_AT_CURSOR
  ret

SPACE:
  ld hl, strings.space
  call PRINT_AT_CURSOR
  ret
