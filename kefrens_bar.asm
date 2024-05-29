; ==================================================================================================
;
; Kefrens bars for DMG(Gameboy)
; 
; reimplementation by eagle0wl
; powered by rgbasm v0.7.0
;
; https://github.com/eagle0wl/
; masm0wl [at] hotmail [dot] com
;
; This program is a reimplementation based on reverse engineering "20y" by Snorpung.
; Thanks so much.
; https://www.pouet.net/prod.php?which=53492
; 

INCLUDE "hardware.inc"

def		KBAR_MASK				equ $C000
def		KBAR_2BPP0_0			equ $C100
def		KBAR_2BPP0_1			equ $C200
def		KBAR_2BPP1_0			equ $C300
def		KBAR_2BPP1_1			equ $C400
def		KBAR_TILE_LOW			equ $C500
def		KBAR_TILE_HIGH			equ $C600

def		KBAR_X					equ	$C700



SECTION "VBlank Interrupt", ROM0[$40]
	
	reti
	
	
SECTION "LCDC Status Interrupt", ROM0[$48]
	
	reti
	
	
SECTION "Timer Interrupt", ROM0[$50]
	
	reti
	
	
SECTION "Serial Interrupt", ROM0[$58]
	
	reti
	
	
SECTION "Keypad Interrupt", ROM0[$60]
	
	reti


SECTION "Org $0100", ROM0[$100]
	nop
	jp	EntryPoint

; Boot Logo
	NINTENDO_LOGO
	
; Rom Header Info
;			 0123456789abcde
	db		"Kefrens_Bar    "				; $0134-$0142 Game Name
	db		CART_COMPATIBLE_DMG				; $0143       Color GameBoy compatibility code
	db		$00, $00						; $0144-$0145 new license
	db		CART_INDICATOR_GB				; $0146       GameBoy/Super GameBoy indicator
	db		CART_ROM						; $0147       Cartridge type
	db		CART_ROM_32KB					; $0148       ROM size
	db		CART_SRAM_NONE					; $0149       SRAM size
	db		CART_DEST_JAPANESE				; $014A       Destination code
	db		0								; $014B       old license
	db		0								; $014C       mask ROM version number
	db		$00								; $014D       header check
	dw		$0000							; $014E-$014F global check
	

SECTION "Main Code", ROM0


; memcpy for VRAM
; 
; arguments:
;   de  src
;   hl  dist
;   bc  len
;
VRAM_Memcpy:
	ld		a, [rSTAT]
	and		STATF_BUSY
	jr		nz, VRAM_Memcpy
	ld		a, [de]
	ld		[hli], a
	inc		de
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, VRAM_Memcpy
	ret


; memset for VRAM
; 
; arguments:
;   hl  *buf
;   d   ch
;   bc  size
;
VRAM_Memset:
	ld		a, [rSTAT]
	and		STATF_BUSY
	jr		nz, VRAM_Memset
	ld		a, d
	ld		[hli], a
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, VRAM_Memset
	ret



; caliculated table making
; 
; arguments:
;   none
;
InitCalculatedTable:

	ld		d, 0
	ld		hl, KBAR_MASK
	ld		bc, 160/8
.ict_mask:
	ld		a, $00
	ld		[hli], a
	ld		a, $80
	ld		[hli], a
	ld		a, $C0
	ld		[hli], a
	ld		a, $E0
	ld		[hli], a
	ld		a, $F0
	ld		[hli], a
	ld		a, $F8
	ld		[hli], a
	ld		a, $FC
	ld		[hli], a
	ld		a, $FE
	ld		[hli], a
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, .ict_mask
	
	
	ld		d, 0
	ld		hl, KBAR_2BPP0_0
	ld		bc, 160/8
.ict_bar_2bpp0_0:
	ld		a, $A5
	ld		[hli], a
	ld		a, $52
	ld		[hli], a
	ld		a, $29
	ld		[hli], a
	ld		a, $14
	ld		[hli], a
	ld		a, $0A
	ld		[hli], a
	ld		a, $05
	ld		[hli], a
	ld		a, $02
	ld		[hli], a
	ld		a, $01
	ld		[hli], a
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_2bpp0_0
	
	
	ld		d, 0
	ld		hl, KBAR_2BPP0_1
	ld		bc, 160/8
.ict_bar_2bpp0_1:
	ld		a, $C3
	ld		[hli], a
	ld		a, $61
	ld		[hli], a
	ld		a, $30
	ld		[hli], a
	ld		a, $18
	ld		[hli], a
	ld		a, $0C
	ld		[hli], a
	ld		a, $06
	ld		[hli], a
	ld		a, $03
	ld		[hli], a
	ld		a, $01
	ld		[hli], a
	dec	bc
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_2bpp0_1
	
	
	ld		d, 0
	ld		hl, KBAR_2BPP1_0
	ld		bc, 160/8
.ict_bar_2bpp1_0:
	ld		a, $00
	ld		[hli], a
	ld		a, $80
	ld		[hli], a
	ld		a, $40
	ld		[hli], a
	ld		a, $A0
	ld		[hli], a
	ld		a, $50
	ld		[hli], a
	ld		a, $28
	ld		[hli], a
	ld		a, $94
	ld		[hli], a
	ld		a, $4A
	ld		[hli], a
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_2bpp1_0
	
	
	ld		d, 0
	ld		hl, KBAR_2BPP1_1
	ld		bc, 160/8
.ict_bar_2bpp1_1:
	ld		a, $00
	ld		[hli], a
	ld		a, $80
	ld		[hli], a
	ld		a, $C0
	ld		[hli], a
	ld		a, $60
	ld		[hli], a
	ld		a, $30
	ld		[hli], a
	ld		a, $18
	ld		[hli], a
	ld		a, $0C
	ld		[hli], a
	ld		a, $86
	ld		[hli], a
	dec		bc
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_2bpp1_1
	
	
	ld		d, 0
	ld		hl, KBAR_TILE_LOW
	ld		bc, 256/8
.ict_bar_tile_low:
	ld		a, d
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	ld		[hli], a
	dec		bc
	add		a, $10
	ld		d, a
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_tile_low
	
	
	ld		d, $80
	ld		hl, KBAR_TILE_HIGH
	ld		bc, 256/2
.ict_bar_tile_high_0:
	ld		a, d
	ld		[hli], a
	dec		bc
	ld		d, a
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_tile_high_0
	
	ld		d, $81
	ld		hl, KBAR_TILE_HIGH+$80
	ld		bc, 256/2
.ict_bar_tile_high_1:
	ld		a, d
	ld		[hli], a
	dec		bc
	ld		d, a
	ld		a, b
	or		a, c
	jp		nz, .ict_bar_tile_high_1
	
	ret



EntryPoint:

.WaitingVBlank1:
		ld		a, [rLY]
		cp		$90
	jp		c, .WaitingVBlank1
	
	; HIDE_BKG
	ld		a, LCDCF_BGOFF
	ld		[rLCDC], a
	
	; fill_bkg_rect(0, 0, 32, 32, 0x00);
	ld		d, 0
	ld		hl, _SCRN0
	ld		bc,	32*32
	call	VRAM_Memset
	
	; set_bkg_tiles(0, 0, 20, 1, (UBYTE **)KEFRENS_BKG);
	ld		de, TileMap
	ld		hl, _SCRN0
	ld		bc,	TileMapEnd - TileMap
	call	VRAM_Memcpy
	
	; for (int i = 0; i < 16*20; i++) {
	; 	set_vram_byte((UBYTE *)(0x8000+i), 0x00);
	; }
	ld		d, 0
	ld		hl, _VRAM8000
	ld		bc,	16*20
	call	VRAM_Memset
	
	; STAT_REG = STATF_MODE00;
	ld		a, [rSTAT]
	or		a, STATF_MODE00
	ld		[rSTAT], a
	
	;set_interrupts(VBL_IFLAG | LCD_IFLAG);
	ld		a, IEF_STAT | IEF_VBLANK
	ld		[rIE], a
	ei
	
	; SHOW_BKG
	ld		a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
	ld		[rLCDC], a
	
	; BGP Palette init
	ld		a, %11100100
	ld		[rBGP], a
	
	call	InitCalculatedTable
	
	ld		a, $00
	ld		[KBAR_X], a
	
	ld		de, 8			; d and e = value for calculate sine wave
	push	de
.WaitingVBlank2:
		ld		a, [rLY]
		cp		a, 144
	jr		c, .WaitingVBlank2
	
.Loop_in_VBlank:
		pop		de			; d and e = value for calculate sine wave
		ld		a, [KBAR_X]
		inc		a
		inc		a
		ld		[KBAR_X], a
		ld		e, a
		dec		a
		dec		a
		ld		d, a
		push	de
		
		xor		a, a
		ld		[rSCX], a
		ld		[rSCY], a
		ld		[$8000], a			; init VRAM
		ld		[$8001], a
		ld		[$8010], a
		ld		[$8011], a
		ld		[$8020], a
		ld		[$8021], a
		ld		[$8030], a
		ld		[$8031], a
		ld		[$8040], a
		ld		[$8041], a
		ld		[$8050], a
		ld		[$8051], a
		ld		[$8060], a
		ld		[$8061], a
		ld		[$8070], a
		ld		[$8071], a
		ld		[$8080], a
		ld		[$8081], a
		ld		[$8090], a
		ld		[$8091], a
		ld		[$80A0], a
		ld		[$80A1], a
		ld		[$80B0], a
		ld		[$80B1], a
		ld		[$80C0], a
		ld		[$80C1], a
		ld		[$80D0], a
		ld		[$80D1], a
		ld		[$80E0], a
		ld		[$80E1], a
		ld		[$80F0], a
		ld		[$80F1], a
		ld		[$8100], a
		ld		[$8101], a
		ld		[$8110], a
		ld		[$8111], a
		ld		[$8120], a
		ld		[$8121], a
		ld		[$8130], a
		ld		[$8131], a
	
		ld		a, 0
		ld		[rSCY], a
		
		pop		de			; d and e = value for calculate sine wave
		dec		e
		dec		e
		dec		e
		dec		d
		push	de
		
		; calculate X coordinate of bar
		ld		l, e
		ld		h, SineTable>>8
		ld		a, [hl]
		ld		l, d
		add		a, [hl]
		ld		e, a			; e = X coordinate of bar
		
		; example:
		;    +--- bar x=2, y=0
		;    |
		; +--v------------------------- LCD +
		; |  Oo.  .oO                       |
		; |Oo.  .ooOO                       |
		; |OoOo.  .oO                       |
		; |OoOooOo.  .oO                    |
		; |OoO. Oo  Oo.  .oO                |
		; |OoO. Oo  Oo. Oo.  .oO            |
		; |OoO. Oo  Oo. OoOo.  .oO          |
		; |OoO. Oo  Oo. Oo.  Oo.  .oO       |
		; |OoO. Oo  Oo. Oo.   Oo.  .oO      |
		; |OoO. Oo  Oo. Oo.  Oo.  .oOO      |
		; |OoO. Oo  Oo. Oo.o.  .oO.OoO      |
		; |OoO. Oo  Oo. Oo.  .oOoO.OoO      |
		; +---------------------------------+
		;
		; +--------+--------+--------+--------+-- ... --+--------+
		; |  Oo.  .|  Oo.  .|        |        |         |        |
		; |        |        |        |        |         |        |
		; |        |        |        |        |         |        |
		; |bar left|bar left|        |        |         |        |
		; | color1 | color2 |        |        |         |        |
		; |        |        |        |        |         |        |
		; | VRAM   | VRAM   | VRAM   | VRAM   |         | VRAM   |
		; |  $8000 |  $8001 |  $8002 |  $8003 |         |  $800F |
		; +--------+--------+--------+--------+-- ... --+--------+
		; |oO      |oO      |        |        |         |        |
		; |        |        |        |        |         |        |
		; |        |        |        |        |         |        |
		; |bar rightbar right        |        |         |        |
		; | color1 | color2 |        |        |         |        |
		; |        |        |        |        |         |        |
		; | VRAM   | VRAM   | VRAM   | VRAM   |         | VRAM   |
		; |  $8010 |  $8011 |  $8012 |  $8013 |         |  $801F |
		; +--------+--------+--------+--------+-- ... --+--------+
		; :        :        :        :        :         :        :
		
		; calculate VRAM address($8000-) from X coordinate of bar
		ld		d, KBAR_TILE_LOW>>8
		ld		a, [de]
		ld		l, a
		inc		d			; d = KBAR_TILE_HIGH>>8
		ld		a, [de]
		ld		h, a		; hl = VRAM address for bar left graphic (color1) ($8000, $8010, $8020...)
		
		; preparation of maskdata
		ld		d, KBAR_MASK>>8
		ld		a, [de]		; a = mask data for bar left
		cpl
		ld		c, a		; c = mask data for bar right
		inc		d			; de = KBAR_2BPP0_0 (color1 for bar left)
		ld		a, [de]
		ld		b, a		; b = graphic data for bar left
		ld		a, c		; 
		cpl					; a = mask data for bar for left
		inc		d			; de = KBAR_2BPP0_1 (color2 for bar left)
		
		;halt
		;nop					; nop is Required (Because the next instruction after halt may be ignored)
		
		; drawing bar (width = 16pixel, height = 1pixel)
		; drawing bar left (width = 8pixel, height = 1pixel)
		and		a, [hl]		; mask of graphic (for bar left/color1)
		or		a, b		; draw bar left (color1)
		ldi		[hl], a		; write bar left (color1) on VRAM
							; hl = bar left graphic (color2)
		ld		a, c		; a = mask data for bar right
		cpl					; a = mask data for bar left
		and		a, [hl]		; mask of graphic (for bar left/color2)
		ld		b, a
		ld		a, [de]
		or		a, b		; draw bar left (color2)
		ld		[hl], a		; write bar left (color2) on VRAM
		ld		a, $0F
		add		a, l
		ld		l, a
		jr		nc, .skipMoveUp1
			inc		h
.skipMoveUp1:
							; hl = VRAM address for bar right graphic (color1) ($8000+$10, $8010+$10, $8020+$10...)
		; drawing bar right (width = 8pixel, height = 1pixel)
		ld		a, c		; a = mask data for bar (right)
		and		a, [hl]		; mask of graphic (for bar right/color1)
		ld		b, a
		inc		d			; de = KBAR_2BPP1_0 (color1 for bar right)
		ld		a, [de]		; 
		or		a, b		; draw bar right (color1)
		ldi		[hl], a		; write bar right (color1) on VRAM
							; hl = bar right graphic (color2)
		ld		a, c		; a = mask data for bar right
		and		a, [hl]		; mask of graphic (for bar right/color2)
		ld		b, a
		inc		d			; de = KBAR_2BPP1_1 (color2 for bar left)
		ld		a, [de]		; 
		or		a, b		; draw bar right (color2)
		ld		[hl], a		; write bar right (color2) on VRAM
		
.WaitEndofVBlank:
			ld		a, [rLY]
			cp		0
		jr		nz, .WaitEndofVBlank
		
		xor		a
		ld		b, a
		ld		[rLYC], a
		
.Loop_in_HBlank:
			pop		de			; d and e = value for calculate sine wave
			dec		e
			dec		e
			dec		e
			dec		d
			push	de
			
			; calculate X coordinate of bar
			ld		l, e
			ld		h, SineTable>>8
			ld		a, [hl]
			ld		l, d
			add		a, [hl]
			ld		e, a			; e = X coordinate of bar
			
			; calculate VRAM address($8000-) from X coordinate of bar
			ld		d, KBAR_TILE_LOW>>8
			ld		a, [de]
			ld		l, a
			inc		d			; d = KBAR_TILE_HIGH>>8
			ld		a, [de]
			ld		h, a		; hl = VRAM address for bar left graphic (color1) ($8000, $8010, $8020...)
			
			; preparation of maskdata
			ld		d, KBAR_MASK>>8
			ld		a, [de]		; a = mask data for bar left
			cpl
			ld		c, a		; c = mask data for bar right
			inc		d			; de = KBAR_2BPP0_0 (color1 for bar left)
			ld		a, [de]
			ld		b, a		; b = graphic data for bar left
			ld		a, c		; 
			cpl					; a = mask data for bar for left
			inc		d			; de = KBAR_2BPP0_1 (color2 for bar left)
			
			halt				; draw scanline
			nop					; nop is Required (Because the next instruction after halt may be ignored)
			
			; drawing bar (width = 16pixel, height = 1pixel)
			; drawing bar left (width = 8pixel, height = 1pixel)
			and		a, [hl]		; mask of graphic (for bar left/color1)
			or		a, b		; draw bar left (color1)
			ldi		[hl], a		; write bar left (color1) on VRAM
								; hl = bar left graphic (color2)
			ld		a, c		; a = mask data for bar right
			cpl					; a = mask data for bar left
			and		a, [hl]		; mask of graphic (for bar left/color2)
			ld		b, a
			ld		a, [de]
			or		a, b		; draw bar left (color2)
			ld		[hl], a		; write bar left (color2) on VRAM
			ld		a, $0F
			add		a, l
			ld		l, a
			jr		nc, .skipMoveUp2
				inc		h
.skipMoveUp2:
								; hl = VRAM address for bar right graphic (color1) ($8000+$10, $8010+$10, $8020+$10...)
			; drawing bar right (width = 8pixel, height = 1pixel)
			ld		a, c		; a = mask data for bar (right)
			and		a, [hl]		; mask of graphic (for bar right/color1)
			ld		b, a
			inc		d			; de = KBAR_2BPP1_0 (color1 for bar right)
			ld		a, [de]		; 
			or		a, b		; draw bar right (color1)
			ldi		[hl], a		; write bar right (color1) on VRAM
								; hl = bar right graphic (color2)
			ld		a, c		; a = mask data for bar right
			and		a, [hl]		; mask of graphic (for bar right/color2)
			ld		b, a
			inc		d			; de = KBAR_2BPP1_1 (color2 for bar left)
			ld		a, [de]		; 
			or		a, b		; draw bar right (color2)
			ld		[hl], a		; write bar right (color2) on VRAM
			
			;ld		a, [rLY]	; FA 44 FF  ld a, $FF44  (3byte, 4clock)
			ldh		a, [rLY]	; F0 44     ld a, ($FF00+$44) （2byte, 3clock, LR35902 exclusive instruction）
			cp		a, 144
			jr		nc, .Loop_in_VBlank_End
			
			ld		b, a		
			dec		a			
			cpl					; a = -[rLY]
			
			;ld		[rSCY], a	; EA 42 FF  ld a, $FF42  (3byte, 4clock)
			ldh		[rSCY], a	; E0 42     ld ($FF00+$42), a （2byte, 3clock, LR35902 exclusive instruction）

		jr		.Loop_in_HBlank

.Loop_in_VBlank_End:
	jp		.Loop_in_VBlank




SECTION "Org $3E00", ROM0[$3E00]
TileMap:
	db	$00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
	db	$10, $11, $12, $13
TileMapEnd:


SECTION "Org $3F00", ROM0[$3F00]
SineTable:
	db	$26, $28, $2A, $2C, $2D, $2F, $31, $33, $35, $36, $38, $3A, $3B, $3D, $3E, $3F
	db	$41, $42, $43, $44, $46, $47, $47, $48, $49, $4A, $4A, $4B, $4B, $4C, $4C, $4C
	db	$4C, $4C, $4C, $4C, $4B, $4B, $4A, $4A, $49, $48, $48, $47, $46, $45, $43, $42
	db	$41, $40, $3E, $3D, $3B, $3A, $38, $36, $35, $33, $31, $2F, $2E, $2C, $2A, $28
	db	$26, $24, $22, $21, $1F, $1D, $1B, $19, $18, $16, $14, $13, $11, $10, $0E, $0D
	db	$0B, $0A, $09, $08, $07, $06, $05, $04, $03, $02, $02, $01, $01, $00, $00, $00
	db	$00, $00, $00, $00, $01, $01, $02, $02, $03, $04, $04, $05, $06, $07, $08, $0A
	db	$0B, $0C, $0E, $0F, $11, $12, $14, $15, $17, $19, $1B, $1C, $1E, $20, $22, $24
	db	$26, $28, $29, $2B, $2D, $2F, $31, $32, $34, $36, $38, $39, $3B, $3C, $3E, $3F
	db	$41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4A, $4B, $4B, $4C, $4C, $4C
	db	$4C, $4C, $4C, $4C, $4B, $4B, $4A, $4A, $49, $49, $48, $47, $46, $45, $44, $42
	db	$41, $40, $3E, $3D, $3B, $3A, $38, $37, $35, $33, $31, $30, $2E, $2C, $2A, $28
	db	$26, $25, $23, $21, $1F, $1D, $1B, $1A, $18, $16, $15, $13, $11, $10, $0E, $0D
	db	$0C, $0A, $09, $08, $07, $06, $05, $04, $03, $02, $02, $01, $01, $00, $00, $00
	db	$00, $00, $00, $00, $01, $01, $01, $02, $03, $03, $04, $05, $06, $07, $08, $09
	db	$0B, $0C, $0D, $0F, $10, $12, $14, $15, $17, $19, $1A, $1C, $1E, $20, $22, $23
SineTableEnd:
