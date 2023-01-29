SECTION "JUMP_TABLE_SUBROUTINE", ROM0
JUMP_TABLE::
    ; execute jump table encoded below a call to this routine
    ; use as follows:
    ; | ld a, u8 ; load offset into a
    ; | call JUMP_TABLE
    ; | dw .loc0
    ; | dw .loc1
    ; | dw .loc2
    ; | etc...
    ; +
    ;
    ; where .locX defines the location to jump to for an offset X (in order)
    ; and e8 is any unsigned (ie positive) 8 bit offset
    ;
    ; arguments:
    ; > registers
    ;   * a (u8) - offset to jump to
    ; > stack
    ;   * sp + 0 (r16) - table start addr
    ;
    ; registers altered: a, d, e, hl
    ;

    ; load [$00, a] into de and shift left to multiply by 2
    ld e, a
    ld d, $00
    sla e       ; shifts msb into carry
    rl d        ; rotate shifts carry into lsb of d

    ; take our return address off the stack as
    ; this defines the start of our jump table
    pop hl
    add hl, de ; add offset to pointer

    ; copy the contents of hl and hl+1 (ie
    ; the address hl points to) into hl
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld l, e
    ld h, d

    ; finally, jump to our desired address
    jp hl
