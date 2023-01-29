INCLUDE "display.inc"

SECTION "GRAPHICS",ROM0
WAIT_VBLANK::
    ldh a,[$FF44]		  ; get current scanline
    cp $91			      ; check if v-blank
    jr nz, WAIT_VBLANK
    ret

WAIT_VRAM::
    ld   hl, $FF41     ; STAT Register
.loop
    bit  1, [hl]       ; Wait until Mode is 0 or 1
    jr nz, .loop
    ret

WAIT_nVRAM::
    ld   hl, $FF41     ; STAT Register
.loop
    bit  1, [hl]       ; Wait until Mode is 0 or 1
    jr z, .loop
    ret


SET_LDC_CFG::
    ldh [LCDC],a
    ret

SET_BACKGROUND_PALLETTE::
    ldh [BGP], a
    ret

CLEAR_OAM::
    ; clearing the OAM RAM
    ld hl, _OAMRAM  ; load OAM address ($FE00)
    ld c, $A0       ; counter

.loop:
    ld a, $00
    ld [hli], a
    dec c
    jr nz, .loop

    ret
  

CLEAR_MAP::
    ld hl, _SCRN0    ; load bg map address ($9800)
    ld bc, 32*32    ; 16 bit counter

.loop:
    ld [hl], (HEX_TILES.space - HEX_TILES) >> 4
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop

    ret


LOAD_TILES::
    ; assumes tiles start address is stored in hl
    ; assumes number of items to store are in c
    ld de, _VRAM

    ; shift left four times to multiply by 12 (16 bytes per tile)
    REPT 4
        sla c       ; shifts msb into carry
        rl b        ; rotate shifts carry into lsb of b
    ENDR

.loop:
    ld a, [hli]
    ld [de], a
    inc de
    dec bc

    ld a, b
    or c
    jr nz, .loop

    ret
    
DISPLAY_TILE::
    ; assumes de points to the square to place the tile in
    ld hl, _SCRN0
    add hl, de
    ld [hl], a
    ret


DISPLAY_STR::
    ; null terminated string stored in (hl) at the display pointer (de)
    ld a, [hl]
    cp a, $00
    ret z

    push hl ; store addr
    
    call DISPLAY_STR_CHAR
    
    pop hl ; retrieve addr

    inc hl
    inc de

    jr DISPLAY_STR

DISPLAY_STR_CHAR::
    cp a, "!"
    jr z, .bang

    cp a, ">"
    jr z, .arrow

    cp a, " "
    jr z, .space

.letter
    sub a, "A"
    add a, (HEX_TILES.A - HEX_TILES) >> 4
    jr .display_tile

.bang
    ld a, (HEX_TILES.bang - HEX_TILES) >> 4
    jr .display_tile

.space
    ld a, (HEX_TILES.space - HEX_TILES) >> 4
    jr .display_tile

.arrow
    ld a, (HEX_TILES.arrow - HEX_TILES) >> 4
    jr .display_tile

.display_tile
    call DISPLAY_TILE
    ret