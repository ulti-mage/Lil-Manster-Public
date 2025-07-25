
rlDemoRain ; 9A/E53D

	.al
	.xl
	.autsiz
	.databank ?

	jsl rlDisableVBlank

	sep #$20
	lda #INIDISP_Setting(true)
	sta bBufferINIDISP
	rep #$20

	sep #$20
	lda #INIDISP_Setting(true)
	sta INIDISP,b
	rep #$20

	lda #(`$A0EA58)<<8
	sta lR18+1
	lda #<>$A0EA58
	sta lR18
	lda #(`$7FB0F5)<<8
	sta lR19+1
	lda #<>$7FB0F5
	sta lR19
	jsl rlAppendDecompList
	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, $7FB0F5, $0400, VMAIN_Setting(true), $4000

	lda #(`$9FB9C0)<<8
	sta lR18+1
	lda #<>$9FB9C0
	sta lR18
	lda #(`$7FB0F5)<<8
	sta lR19+1
	lda #<>$7EB0F5
	sta lR19
	jsl rlAppendDecompList
	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, $7FB0F5, $0200, VMAIN_Setting(true), $B000

	lda #(`$9FB9F9)<<8
	sta lR18+1
	lda #<>$9FB9F9
	sta lR18
	lda #(`aBG1TilemapBuffer)<<8
	sta lR19+1
	lda #<>aBG1TilemapBuffer
	sta lR19
	jsl rlAppendDecompList
	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG1TilemapBuffer, $0800, VMAIN_Setting(true), $E000

	lda #(`$9FBA75)<<8
	sta lR18+1
	lda #<>$9FBA75
	sta lR18
	lda #(`aBG3TilemapBuffer)<<8
	sta lR19+1
	lda #<>aBG3TilemapBuffer
	sta lR19
	jsl rlAppendDecompList
	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG3TilemapBuffer, $0800, VMAIN_Setting(true), $A000

	lda #(`DemoRainPalette)<<8
	sta lR18+1
	lda #<>DemoRainPalette
	sta lR18
	lda #(`aBGPaletteBuffer.aPalette1)<<8
	sta lR19+1
	lda #<>aBGPaletteBuffer.aPalette1
	sta lR19
	lda #size(aBGPaletteBuffer.aPalette1)+size(aBGPaletteBuffer.aPalette2)
	sta lR20
	jsl rlBlockCopy

	lda #(`aDemoRainLightningColorTable)<<8
	sta aProcSystem.wInput0+1,b
	lda #<>aDemoRainLightningColorTable
	sta aProcSystem.wInput0,b

	lda #(`$949F97)<<8
	sta lR44+1
	lda #<>$949F97
	sta lR44
	jsl rlProcEngineCreateProc

	lda #(`procDemoRain)<<8
	sta lR44+1
	lda #<>procDemoRain
	sta lR44
	jsl rlProcEngineCreateProc

	sep #$20

	lda #T_Setting(true, false, true, false, false)
	sta bBufferTM

	lda #T_Setting(false, true, false, false, true)
	sta bBufferTS

	lda #CGWSEL_Setting(false, true, CGWSEL_MathAlways, CGWSEL_BlackNever)
	sta bBufferCGWSEL

	lda #CGADSUB_Setting(CGADSUB_Add, true, true, false, true, false, false, true)
	sta bBufferCGADSUB

	lda bBufferBG1SC
	and #~BGSC_Size
	sta bBufferBG1SC

	lda bBufferBG3SC
	and #~BGSC_Size
	sta bBufferBG3SC

	rep #$20

	sep #$20
	lda #INIDISP_Setting(false, 0)
	sta bBufferINIDISP
	rep #$20

	sep #$20
	lda #INIDISP_Setting(false, 0)
	sta INIDISP,b
	rep #$20

	jsl rlEnableVBlank
	rtl

DemoRainPalette ; 9A/E661
	.word $3000, $0000, $5EF7, $7BFF, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4
	.word $0843, $2108, $39CE, $5EF7, $7BFF, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4, $57D4

aDemoRainLightningColorTable ; 9A/E6A1

	; Starting position in palette buffer
	.byte (aBGPaletteBuffer.aPalette1 + 2 - aBGPaletteBuffer) / 2

	; Color count
	.byte $01

	; Short pointer to palettes
	.addr _Palettes

	; Palette table entry index
	.byte (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2
	.byte (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal01 - _Palettes)/2, (_Pal01 - _Palettes)/2, (_Pal01 - _Palettes)/2, (_Pal02 - _Palettes)/2, (_Pal02 - _Palettes)/2, (_Pal02 - _Palettes)/2, (_Pal03 - _Palettes)/2, (_Pal03 - _Palettes)/2, (_Pal03 - _Palettes)/2
	.byte (_Pal04 - _Palettes)/2, (_Pal04 - _Palettes)/2, (_Pal04 - _Palettes)/2, (_Pal05 - _Palettes)/2, (_Pal05 - _Palettes)/2, (_Pal05 - _Palettes)/2, (_Pal06 - _Palettes)/2, (_Pal06 - _Palettes)/2, (_Pal07 - _Palettes)/2, (_Pal07 - _Palettes)/2, (_Pal08 - _Palettes)/2, (_Pal08 - _Palettes)/2, (_Pal09 - _Palettes)/2, (_Pal09 - _Palettes)/2, (_Pal0A - _Palettes)/2, (_Pal0A - _Palettes)/2
	.byte (_Pal0B - _Palettes)/2, (_Pal0C - _Palettes)/2, (_Pal0D - _Palettes)/2, (_Pal0E - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2
	.byte (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal00 - _Palettes)/2, (_Pal02 - _Palettes)/2, (_Pal02 - _Palettes)/2, (_Pal04 - _Palettes)/2, (_Pal04 - _Palettes)/2, (_Pal06 - _Palettes)/2, (_Pal06 - _Palettes)/2, (_Pal08 - _Palettes)/2, (_Pal0A - _Palettes)/2, (_Pal0C - _Palettes)/2, (_Pal0D - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2
	.byte (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, (_Pal0F - _Palettes)/2, $FE

	_Palettes

	_Pal00 .word $7C00
	_Pal01 .word $7400
	_Pal02 .word $6C00
	_Pal03 .word $6000
	_Pal04 .word $5800
	_Pal05 .word $5000
	_Pal06 .word $4800
	_Pal07 .word $4000
	_Pal08 .word $3400
	_Pal09 .word $2C00
	_Pal0A .word $2400
	_Pal0B .word $1C00
	_Pal0C .word $1400
	_Pal0D .word $0800
	_Pal0E .word $0000
	_Pal0F .word $0000

procDemoRain .dstruct structProcInfo, "xx", None, rlProcDemoRainOnCycle, None ; 9A/E7C4

rlProcDemoRainOnCycle ; 9A/E7CC

	.al
	.xl
	.autsiz
	.databank ?

	inc aProcSystem.aBody0,b,x

	lda aProcSystem.aBody0,b,x
	clc
	adc wMapScrollXPixels,b
	sta wBufferBG1HOFS

	lda aProcSystem.aBody0,b,x
	eor #-1
	inc a
	clc
	adc wMapScrollYPixels,b
	sta wBufferBG1VOFS

	inc aProcSystem.aBody1,b,x
	inc aProcSystem.aBody1,b,x

	lda aProcSystem.aBody1,b,x
	clc
	adc wMapScrollXPixels,b
	sta wBufferBG3HOFS

	lda aProcSystem.aBody1,b,x
	eor #-1
	inc a
	clc
	adc wMapScrollYPixels,b
	sta wBufferBG3VOFS

	rtl
