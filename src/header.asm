; HEADER.ASM
; cartridge header data

INCLUDE "header.inc"

SECTION	"Org $00",ROM0[$0000]
  jp $100

SECTION	"Org $08",ROM0[$0008]
  jp $100

SECTION	"Org $10",ROM0[$0010]
  jp $100

SECTION	"Org $18",ROM0[$0018]
  jp $100

SECTION	"Org $20",ROM0[$0020]
  jp $100

SECTION	"Org $28",ROM0[$0028]
  jp $100

SECTION	"Org $30",ROM0[$0030]
  jp $100

SECTION	"Org $38",ROM0[$0038]
  jp $100

SECTION	"V-Blank",ROM0[$0040]
  reti

SECTION	"LCD",ROM0[$0048]
  reti

SECTION	"Timer",ROM0[$0050]
  reti

SECTION	"Serial",ROM0[$0058]
  reti

SECTION	"Joypad",ROM0[$0060]
  reti

SECTION	"Start",ROM0[$0100]
  nop
  jp START

SECTION	"Logo",ROM0[$0104]
  NINTENDO_LOGO

SECTION	"Title",ROM0[$0134]
  DB "{TITLE}"

SECTION	"Manufacturer",ROM0[$013F]
  DB "{MANUFACTURER}"

SECTION	"Flags",ROM0[$0143]
  DB FLAG_CGB_DMG
  DW $0000 ; licensee code - leave blank
  DB FLAG_SGB_NONE
  DB CART_ROM_ONLY
  DB ROM_SIZE_32K
  DB RAM_SIZE_NONE
  DB REGION_WORLD
  DB $33 ; use new licensee code
  DB VERSION

SECTION	"Header Checksum",ROM0[$014D]
  DB $00

SECTION	"Global Checksum",ROM0[$014E]
  DW $00
