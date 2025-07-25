
rlCopyWindowTilemapRect ; 81/FA24

	.al
	.xl
	.autsiz
	.databank ?

	php
	rep #$30
	lda #$0020
	sec
	sbc wR0
	asl a
	sta wR2
	stz wR4
	stz wR5

	-
	lda wR0
	sta wR3

	-
	ldy wR4
	lda [lR18],y
	ldy wR5
	sta [lR19],y
	inc wR4
	inc wR4
	inc wR5
	inc wR5
	dec wR3
	bne -

	lda wR4
	clc
	adc wR2
	sta wR4
	dec wR1
	bne --

	plp
	rtl

rlRevertWindowTilemapRect ; 81/FA59

	.al
	.xl
	.autsiz
	.databank ?

	php
	rep #$30
	lda #$0020
	sec
	sbc wR0
	asl a
	sta wR2
	stz wR4
	stz wR5

	-
	lda wR0
	sta wR3

	-
	ldy wR5
	lda [lR18],y
	ldy wR4
	sta [lR19],y
	inc wR4
	inc wR4
	inc wR5
	inc wR5
	dec wR3
	bne -

	lda wR4
	clc
	adc wR2
	sta wR4
	dec wR1
	bne --

	plp
	rtl

aCopyInventoryItemInfoWindowTextLayerWindowInfo ; 81/FA8E
	.byte 12, 22
	.long aBG3TilemapBuffer
	.byte $00
	.long $7F8614

aCopyInventoryItemInfoWindowBackgroundLayerWindowInfo ; 81/FA97
	.byte 12, 22
	.long aBG2TilemapBuffer
	.byte $00
	.long $7F8614

aCopyInventorySkillInfoWindowTextLayerWindowInfo ; 81/FAA0
	.byte 12, 15
	.long aBG3TilemapBuffer
	.byte $00
	.long $7F8614

aCopyInventorySkillInfoWindowBackgroundLayerWindowInfo ; 81/FAA9
	.byte 12, 15
	.long aBG2TilemapBuffer
	.byte $00
	.long $7F8614

aCopyTradeItemInfoWindowTextLayerWindowInfo ; 81/FAB2
	.byte 12, 22
	.long aBG3TilemapBuffer
	.byte $00
	.long $7F8614

aCopyTradeItemInfoWindowBackgroundLayerWindowInfo ; 81/FABB
	.byte 12, 22
	.long aBG2TilemapBuffer
	.byte $00
	.long $7F8614

rlCopyInventoryItemInfoWindowTilemaps ; 81/FAC4

	.al
	.xl
	.autsiz
	.databank ?

	; Save the section of the screen that the window
	; is drawn over

	; Source

	lda #>`aBG3TilemapBuffer
	sta lR18+1
	lda #<>aBG3TilemapBuffer + ((0 + (6 * $20)) * 2) ; ((X + (Y * $20)) * 2) 
	sta lR18

	; Dest

	lda #<>$7F9214
	sta lR19
	lda #>`$7F9214
	sta lR19+1

	; Width

	lda #12
	sta wR0

	; Height

	lda #22 	; vanilla 18
	sta wR1
	jsl rlCopyWindowTilemapRect

	lda #>`aBG2TilemapBuffer
	sta lR18+1
	lda #<>aBG2TilemapBuffer + ((0 + (6 * $20)) * 2)
	sta lR18
	lda #<>$7F8C14
	sta lR19
	lda #>`$7F8C14
	sta lR19+1
	lda #12
	sta wR0
	lda #22 	; vanilla 18
	sta wR1
	jsl rlCopyWindowTilemapRect

	; Now clear the area for the text layer

	lda #<>aCopyInventoryItemInfoWindowTextLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer,b
	lda #>`aCopyInventoryItemInfoWindowTextLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer+1,b
	lda #$01DF
	sta aCurrentTilemapInfo.wFillTile,b
	jsl $87D69D

	; Create window borders

	lda #<>$85801A
	sta lR18
	lda #>`$85801A
	sta lR18+1
	lda #$0800
	sta aCurrentTilemapInfo.wBaseTile,b
	jsl $87D7FD

	; Copy borders to tilemap

	ldx #((0 + (6 * $20)) * 2) ; 1/10
	jsl $87D4DD

	; Create background

	lda #<>aCopyInventoryItemInfoWindowBackgroundLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer,b
	lda #>`aCopyInventoryItemInfoWindowBackgroundLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer+1,b
	lda #<>$85970F
	sta lR18
	lda #>`$85970F
	sta lR18+1
	lda #$3C00
	sta aCurrentTilemapInfo.wBaseTile,b
	jsl $87D6FC

	; Copy background to tilemap

	ldx #((0 + (6 * $20)) * 2)
	jsl $87D4DD

	; Draw them

	jsl rlEnableBG2Sync
	jsl rlEnableBG3Sync

	; Play a sound

	lda #$000C
	jsl rlUnknown808C87
	rtl

rlRevertInventoryItemInfoWindowTilemaps ; 81/FB70

	.al
	.xl
	.autsiz
	.databank ?

	; Fetch the saved tilemaps and copy them back

	lda #>`aBG3TilemapBuffer
	sta lR19+1
	lda #<>aBG3TilemapBuffer + ((0 + (6 * $20)) * 2)
	sta lR19
	lda #<>$7F9214
	sta lR18
	lda #>`$7F9214
	sta lR18+1
	lda #12
	sta wR0
	lda #22 ; 18v
	sta wR1
	jsl rlRevertWindowTilemapRect

	lda #>`aBG2TilemapBuffer
	sta lR19+1
	lda #<>aBG2TilemapBuffer + ((0 + (6 * $20)) * 2)
	sta lR19
	lda #<>$7F8C14
	sta lR18
	lda #>`$7F8C14
	sta lR18+1
	lda #12
	sta wR0
	lda #22 ; 18v
	sta wR1
	jsl rlRevertWindowTilemapRect

	jsl rlEnableBG2Sync
	jsl rlEnableBG3Sync

	lda #$0021
	jsl rlUnknown808C87
	rtl

rlCopyInventorySkillInfoWindowTilemaps ; 81/FBC4

	.al
	.xl
	.autsiz
	.databank ?

	; Same as the item info stuff above

	lda #>`aBG3TilemapBuffer
	sta lR18+1
	lda #<>aBG3TilemapBuffer + ((2 + (30 * $20)) * 2)
	sta lR18
	lda #<>$7F9214
	sta lR19
	lda #>`$7F9214
	sta lR19+1
	lda #15
	sta wR0
	lda #15
	sta wR1
	jsl rlCopyWindowTilemapRect

	lda #>`aBG2TilemapBuffer
	sta lR18+1
	lda #<>aBG2TilemapBuffer + ((2 + (30 * $20)) * 2)
	sta lR18
	lda #<>$7F8C14
	sta lR19
	lda #>`$7F8C14
	sta lR19+1
	lda #15
	sta wR0
	lda #15
	sta wR1
	jsl rlCopyWindowTilemapRect

	lda #<>aCopyInventorySkillInfoWindowTextLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer,b
	lda #>`aCopyInventorySkillInfoWindowTextLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer+1,b
	lda #$01DF
	sta aCurrentTilemapInfo.wFillTile,b
	jsl $87D69D

	lda #<>$85801A
	sta lR18
	lda #>`$85801A
	sta lR18+1
	lda #$0800
	sta aCurrentTilemapInfo.wBaseTile,b
	jsl $87D7FD

	ldx #((2 + (30 * $20)) * 2)
	jsl $87D4DD

	lda #<>aCopyInventorySkillInfoWindowBackgroundLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer,b
	lda #>`aCopyInventorySkillInfoWindowBackgroundLayerWindowInfo
	sta aCurrentTilemapInfo.lInfoPointer+1,b
	lda #<>$85970F
	sta lR18
	lda #>`$85970F
	sta lR18+1
	lda #$3C00
	sta aCurrentTilemapInfo.wBaseTile,b
	jsl $87D6FC

	ldx #((2 + (30 * $20)) * 2)
	jsl $87D4DD

	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG2TilemapBuffer+$0780, $03C0, VMAIN_Setting(true), $F780

	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG3TilemapBuffer+$0780, $03C0, VMAIN_Setting(true), $A780

	lda #$000C
	jsl rlUnknown808C87
	rtl

rlRevertInventorySkillInfoWindowTilemaps ; 81/FC82

	.al
	.xl
	.autsiz
	.databank ?

	lda #>`aBG3TilemapBuffer
	sta lR19+1
	lda #<>aBG3TilemapBuffer + ((2 + (30 * $20)) * 2)
	sta lR19
	lda #<>$7F9214
	sta lR18
	lda #>`$7F9214
	sta lR18+1
	lda #15
	sta wR0
	lda #15
	sta wR1
	jsl rlRevertWindowTilemapRect

	lda #>`aBG2TilemapBuffer
	sta lR19+1
	lda #<>aBG2TilemapBuffer + ((2 + (30 * $20)) * 2)
	sta lR19
	lda #<>$7F8C14
	sta lR18
	lda #>`$7F8C14
	sta lR18+1
	lda #15
	sta wR0
	lda #15
	sta wR1
	jsl rlRevertWindowTilemapRect
	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG2TilemapBuffer+$0780, $03C0, VMAIN_Setting(true), $F780

	jsl rlDMAByStruct

	.dstruct structDMAToVRAM, aBG3TilemapBuffer+$0780, $03C0, VMAIN_Setting(true), $A780

	lda #$0021
	jsl rlUnknown808C87
	rtl

rlClearInventorySkillInfoWindow ; 81/FCE8

	.al
	.xl
	.autsiz
	.databank ?

	php
	phb
	sep #$20
	lda #`wInfoWindowTarget
	pha
	rep #$20
	plb

	.databank `wInfoWindowTarget

	lda #(`procSkillInfo)<<8
	sta lR44+1
	lda #<>procSkillInfo
	sta lR44
	jsl rlProcEngineFindProc
	stz wInfoWindowTarget
	jsr rsProcItemInfoClearIcons
	jsl rlProcEngineFreeProc
	plb
	plp
	rtl
