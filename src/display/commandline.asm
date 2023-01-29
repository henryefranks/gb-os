include "ramvars/display.inc"

SECTION "COMMAND LINE", ROM0

RESET_CURSOR::
    ld de, $00
    call PROMPT
    ret

LOAD_CURSOR_POS:
    ld a, [CURSOR_POS_L]
    ld d, a

    ld a, [CURSOR_POS_H]
    ld e, a

    ret

SAVE_CURSOR_POS:
    ld a, d
    ld [CURSOR_POS_L], a

    ld a, e
    ld [CURSOR_POS_H], a

    ret

NEWLINE::
    ld hl, $0020
    add hl, de
    ld a, l
    and a, $E0 ; round off anything below $20
    ld e, a
    ld d, h

    call PROMPT
    ret

PROMPT::
    ld a, (HEX_TILES.arrow - HEX_TILES) >> 4
    call DISPLAY_TILE
    inc de
    call SAVE_CURSOR_POS
    ret

    
PRINT_AT_CURSOR::
    call LOAD_CURSOR_POS
    call DISPLAY_STR
    call SAVE_CURSOR_POS
    ret
