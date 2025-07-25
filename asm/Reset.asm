
rsInitPPURegs ; 80/8930

	.autsiz
	.databank ?

	; Sets PPU registers to startup values (mostly 0).

	; You shouldn't call this yourself.

	; Inputs:
	; None

	; Outputs:
	; None

	php
	sep #$20
	lda #NMITIMEN_Setting(true, false, false, false)
	sta NMITIMEN,b
	sta bBufferNMITIMEN

	stz WRIO,b
	stz WRMPYA,b
	stz WRMPYB,b
	stz WRDIVA,b
	stz WRDIVA+1,b
	stz WRDIVA+2,b
	stz HTIME,b
	stz HTIME+1,b
	stz VTIME,b
	stz VTIME+1,b
	stz MDMAEN,b
	stz HDMAEN,b
	stz APU00,b
	stz APU01,b
	stz APU02,b
	stz APU03,b

	lda #MEMSEL_Setting(true)
	sta MEMSEL,b
	sta bBufferMEMSEL

	lda #INIDISP_Setting(true)
	sta INIDISP,b
	sta bBufferINIDISP

	stz OBSEL,b
	stz OAMADD,b
	stz wBufferOAMADD

	lda #$80										; OAMADDH_Setting(true)
	sta OAMADD+1,b
	sta wBufferOAMADD+1

	stz OAMDATA,b
	stz OAMDATA,b
	stz BGMODE,b
	stz MOSAIC,b
	stz bBufferMOSAIC
	stz BG1SC,b
	stz BG2SC,b
	stz BG3SC,b
	stz BG4SC,b
	stz BG12NBA,b
	stz BG34NBA,b
	stz BG1HOFS,b
	stz BG1HOFS,b
	stz BG1VOFS,b
	stz BG1VOFS,b
	stz BG2HOFS,b
	stz BG2HOFS,b
	stz BG2VOFS,b
	stz BG2VOFS,b
	stz BG3HOFS,b
	stz BG3HOFS,b
	stz BG3VOFS,b
	stz BG3VOFS,b
	stz BG4HOFS,b
	stz BG4HOFS,b
	stz BG4VOFS,b
	stz BG4VOFS,b
	stz VMAIN,b
	stz M7SEL,b
	stz M7A,b
	stz M7B,b
	stz M7C,b
	stz M7D,b
	stz M7X,b
	stz M7Y,b
	stz W12SEL,b
	stz W34SEL,b
	stz WOBJSEL,b
	stz WH0,b
	stz WH1,b
	stz WH2,b
	stz WH3,b
	stz WBGLOG,b
	stz WOBJLOG,b
	stz TM,b
	stz TMW,b
	stz TS,b
	stz TSW,b
	stz CGWSEL,b
	stz CGADSUB,b

	lda #COLDATA_Setting(0, false, false, true)
	sta COLDATA,b
	sta bBufferCOLDATA_1
	lda #COLDATA_Setting(0, false, true, false)
	sta COLDATA,b
	sta bBufferCOLDATA_2
	lda #COLDATA_Setting(0, true, false, false)
	sta COLDATA,b
	sta bBufferCOLDATA_3

	stz SETINI,b
	plp
	rts

riResetE ; 80/8A36

	.autsiz
	.databank ?

	; Handles resetting the game

	; Inputs:
	; None

	; Outputs:
	; None

	sei ; disable interrupts
	clc
	xce
	bcc + ; soft reset

	; Else hard reset

	rep #$30
	tdc
	bne + ; shouldn't happen legitimately?

	; Compare routine offset to reset vector

	ldx #<>riResetE
	cpx <>aRESETVectorE,b
	bne + ; changing the vector is bad

	; This actually starts executing in bank $80
	; the other branches continue execution in bank $00
	; this is important later

	jml +

	+

	; Setup stack pointer

	rep #$30
	tsx
	txy
	ldx #<>aStackSpace.bFirstFree
	txs

	; Set access times, force blank
	; disable irqs, joypad read

	sep #$20
	lda #MEMSEL_Setting(true)
	sta MEMSEL,b
	lda #INIDISP_Setting(true)
	sta INIDISP,b
	stz NMITIMEN,b
	stz MDMAEN,b
	stz HDMAEN,b
	rep #$30

	; Check if the magic number has been
	; written before, if so then everything
	; is fine and we skip checking for
	; irregularities

	.enc "none"

	lda aEngineName,b
	cmp #"EL"
	bne +
	lda aEngineName+2,b
	cmp #"M0"
	beq _SkipJumpChecks

	+

	; Check to see if we arrived here by
	; a jump constructed in RAM

	dec y
	lda $0000,b,y ; get word from RAM
	inc a
	cmp <>aRESETVectorE,b ; check if it matches vector
	beq _AntipiracyScreen ; flash piracy message
	ldx #$0000

	_JumpLoop

	; Next, check for other kinds of jumps
	; in RAM

	; These are hacky -- the .virtual means that
	; their results are discarded, and the vectors are
	; actually supposed to be in bank $00 rather than $80.

	.virtual

	_AbsoluteIndirectJump .block

	jmp (<>aRESETVectorE)

	.bend

	_AbsoluteJump .block

	jmp <>riResetE,k

	.bend

	.endv

	lda $0000,b,x
	and #$00FF
	cmp #_AbsoluteIndirectJump[0] ; jmp (wordaddress)
	beq _AbsoluteIndirect
	cmp #_AbsoluteJump[0] ; jmp wordaddress
	beq _Absolute
	cmp #$0060 ; sequence?
	beq _Sequence

	_ContinueJumpCheck
	inc x
	cpx #$2000 - 2 ; last word
	bne _JumpLoop

	_SkipJumpChecks

	; if we're still in bank $00
	; then things aren't right

	phk
	phk
	pla
	beq _AntipiracyScreen
	bra _SkipAntipiracy

	_AntipiracyScreen
	lda #$0000
	tcd
	jsl $8AAFCA

	_AbsoluteIndirect
	ldy $0001,b,x ; check to see if the address matches
	cpy #<>aRESETVectorE ; jmp (<>$FFFC)
	beq _AntipiracyScreen
	cpy #$1FFF ; jmp (<>$1FFF) ; check if we're out of the first $2000
	bge _ContinueJumpCheck
	lda $0000,b,y ; check if the target is the reset routine
	cmp #<>riResetE ; jmp (<>$8A36)
	beq _AntipiracyScreen
	bra _ContinueJumpCheck

	_Absolute
	ldy $0001,b,x ; check if the target is the reset routine
	cpy #<>riResetE ; jmp $8A36
	beq _AntipiracyScreen
	bra _ContinueJumpCheck

	_Sequence
	txa
	tcd
	ldy #$0000
	lda #$6160 ; 60..81

	_SequenceLoop
	cmp $0000,b,x
	bne _NotSequence
	clc
	adc #$0202
	inc x
	inc x
	inc y
	inc y
	cpy #$0020
	bne _SequenceLoop
	bra _AntipiracyScreen

	_NotSequence
	tdc
	tax
	bra _ContinueJumpCheck

	_SkipAntipiracy
	lda #$0000
	tcd
	jsl $8AB000 ; irregularity check
	sta aEngineUnknown,b
	sta aEngineUnknown+2,b
	lda #"EL"
	sta aEngineName,b
	lda #"M0"
	sta aEngineName+2,b

	_ClearRAM
	pea #$7E00
	plb
	plb
	ldx #<>aStackSpace.bFirstFree-1

	_ClearRAMStartLoop
	stz $0000,b,x
	dec x
	dec x
	bpl _ClearRAMStartLoop
	ldx #$2000 - 2 ; last word

	_Clear7ELoop
	stz $2000,b,x
	stz $4000,b,x
	stz $6000,b,x
	stz $8000,b,x
	stz $A000,b,x
	stz $C000,b,x
	stz $E000,b,x
	dec x
	dec x
	bpl _Clear7ELoop
	pea #$7F00
	plb
	plb
	ldx #$2000 - 2 ; last word

	_Clear7FLoop
	stz $0000,b,x
	stz $2000,b,x
	stz $4000,b,x
	stz $6000,b,x
	stz $8000,b,x
	stz $A000,b,x
	stz $C000,b,x
	stz $E000,b,x
	dec x
	dec x
	bpl _Clear7FLoop

	phk
	plb

	.databank `*

	rep #$30
	lda #((VMDATA - PPU_REG_BASE) << 8) | DMAP_DMA_Setting(DMAP_CPUToIO, DMAP_Mode1, DMAP_Fixed1)
	sta DMA_IO[0].DMAP,b
	lda #(`_808B72+1)<<8
	sta DMA_IO[0].A1+1,b
	lda #<>_808B72+1
	sta DMA_IO[0].A1,b

	_808B72
	lda #$0000
	sta DMA_IO[0].DAS,b
	stz VMADD,b
	sep #$20
	lda #1        ; MDMAEN_Setting(true, false, false, false, false, false, false, false)
	sta MDMAEN,b
	rep #$20
	jsr rsInitPPURegs
	jsl rlSoundSystemSetup
	lda #40
	sta wJoyRepeatDelay
	lda #10
	sta wJoyRepeatInterval
	lda #<>rsUnknown80A605
	sta wVBlankPointer
	lda #<>rsUnknown8082D9
	sta wIRQPointer
	lda #<>rsUnknown80A63B
	sta wMainLoopPointer
	jmp rsUnknown808BC8

rsResetAlreadyInitialized ; 80/8BA7

	.autsiz
	.databank ?

	rep #$30
	ldx #<>aStackSpace.bFirstFree
	txs
	sep #$20

	; Force blank, stop DMA, stop irqs

	lda #INIDISP_Setting(true)
	sta INIDISP,b
	stz NMITIMEN,b
	stz MDMAEN,b
	stz HDMAEN,b
	rep #$30
	jmp riResetE._ClearRAM

rsUnknown808BC2 ; 80/8BC2

	.autsiz
	.databank ?

	rep #$30
	jsl rlHaltUntilVBlank

rsUnknown808BC8 ; 80/8BC8

	.autsiz
	.databank ?

	rep #$30
	pea #<>rsUnknown808BC2-1
	jmp (wMainLoopPointer)
