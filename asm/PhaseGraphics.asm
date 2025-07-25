
rlGetPhaseChangeGraphics ; 81/B563

	.al
	.xl
	.autsiz
	.databank `wBGUpdateFlags

	lda wBGUpdateFlags
	beq +

	rtl

	+
	lda #$0017
	jsl rlUnknown808C87

	stz wUnknown000302,b
	jsl $8593EB
	sep #$20
	lda #T_Setting(false, false, false, false, true)
	sta bBufferTM
	lda #T_Setting(false, true, true, false, false)
	sta bBufferTS
	lda #CGADSUB_Setting(CGADSUB_Add, false, false, false, false, false, true, true)
	sta bBufferCGADSUB
	lda #CGWSEL_Setting(false, true, CGWSEL_MathAlways, CGWSEL_BlackNever)
	sta bBufferCGWSEL
	rep #$30
	lda #<>$F2E780
	sta lR18
	lda #>`$F2E780
	sta lR18+1
	lda #$0800
	sta wR0
	lda #$2000
	sta wR1
	lda wCurrentPhase,b
	jsl $83B296
	txa
	asl a
	tax
	lda aPhaseGraphicOffsetTable,x
	clc
	adc lR18
	sta lR18
	jsl rlDMAByPointer
	lda #<>$F4E000
	sta lR18
	lda #>`$F4E000
	sta lR18+1
	lda #$0800
	sta wR0
	lda #$1C00
	sta wR1
	jsl rlDMAByPointer
	jsl $87B171
	rtl

aPhaseGraphicOffsetTable ; 81/B5D3
	.word $0000
	.word $0800
	.word $1000

rlUnknown81B5D9 ; 81/B5D9

	.al
	.xl
	.autsiz
	.databank ?

	lda #(`$9E81E0)<<8
	sta lR18+1
	lda #<>$9E81E0
	sta lR18
	lda #(`aOAMPaletteBuffer.aPalette7)<<8
	sta lR19+1
	lda #<>aOAMPaletteBuffer.aPalette7
	sta lR19
	lda #size(aOAMPaletteBuffer.aPalette7)
	sta lR20
	jsl rlBlockCopy

	lda #(`$9E81E0)<<8
	sta lR18+1
	lda #<>$9E81E0
	sta lR18
	lda #(`aBGPaletteBuffer.aPalette1)<<8
	sta lR19+1
	lda #<>aBGPaletteBuffer.aPalette1
	sta lR19
	lda #size(aBGPaletteBuffer.aPalette1)
	sta lR20
	jsl rlBlockCopy

	lda #$0010
	sta wR0
	lda #<>aOAMPaletteBuffer.aPalette7
	sta wR1
	lda #$B8FD
	sta wR2
	stz wR3
	jsl $83CA69

	lda wCurrentPhase,b
	jsl $83B296

	txa
	sta wR0
	asl a
	clc
	adc wR0
	tax
	lda aUnknown81B695,x
	sta lR18
	lda aUnknown81B695+1,x
	sta lR18+1
	lda #$0012
	sta wR0
	lda #$0003
	sta wR1
	lda #$CA8A
	sta lR19
	lda #$2400
	sta aCurrentTilemapInfo.wBaseTile,b
	jsl $84A3FF
	jsl rlEnableBG1Sync
	jsl $87B171

	phx
	lda #(`procUnknown81BDA3)<<8
	sta lR44+1
	lda #<>procUnknown81BDA3
	sta lR44
	jsl rlProcEngineCreateProc
	plx

	phx
	lda #(`procUnknown81BE18)<<8
	sta lR44+1
	lda #<>procUnknown81BE18
	sta lR44
	jsl rlProcEngineCreateProc
	plx

	phx
	lda #(`procPhaseGraphicSprites)<<8
	sta lR44+1
	lda #<>procPhaseGraphicSprites
	sta lR44
	jsl rlProcEngineCreateProc
	plx

	rtl

aUnknown81B695 ; 81/B695
	.long $9E82C0
	.long $9E8380
	.long $9E8440

rlUnknown81B69E ; 81/B69E

	.al
	.xl
	.autsiz
	.databank ?

	jsl rlProcEngineFreeProc
	rtl
