
procUnknown9A8019 .dstruct structProcInfo, "xx", rlProcUnknown9A8019Init, None, aProcUnknown9A8019Code ; 9A/8019

rlProcUnknown9A8019Init ; 9A/8021

	.al
	.xl
	.autsiz
	.databank ?

	lda aProcSystem.wInput1,b
	sta lR18
	lda aProcSystem.wInput2,b
	sta lR18+1
	jsl $8ABB6B

	ora #$0900
	sta wR0

	lda #(`procUnknown9A804A)<<8
	sta lR44+1
	lda #<>procUnknown9A804A
	sta lR44
	jsl rlProcEngineCreateProc

	rtl

aProcUnknown9A8019Code ; 9A/8043

	PROC_HALT_WHILE procUnknown9A804A
	PROC_END

procUnknown9A804A .dstruct structProcInfo, "xx", None, None, aProcUnknown9A804ACode ; 9A/804A

aProcUnknown9A804ACode ; 9A/8052

	PROC_CALL rlUnknown9A8074
	PROC_CALL rlUnknown9A8098
	PROC_CALL rlUnknown9A80D7
	PROC_HALT_WHILE $94CCDF
	PROC_CALL rlUnknown9A808B
	PROC_YIELD 120
	PROC_CALL rlUnknown9A80FE
	PROC_END

rlUnknown9A8074 ; 9A/8074

	.al
	.xl
	.autsiz
	.databank ?

	lda lR18
	sta aProcSystem.aBody1,b,x
	lda lR18+1
	sta aProcSystem.aBody2,b,x

	lda wR0
	sta aProcSystem.aBody3,b,x

	jsl $8ABB9D

	sta aProcSystem.aBody4,b,x

	rtl

rlUnknown9A808B ; 9A/808B

	.al
	.xl
	.autsiz
	.databank ?

	sep #$20

	lda #T_Setting(true, true, true, false, true)
	sta bBufferTM

	rep #$20

	jsl rlEnableBG3Sync
	rtl

rlUnknown9A8098 ; 9A/8098

	.al
	.xl
	.autsiz
	.databank `wBGUpdateFlags

	jsl $858033

	lda aProcSystem.aBody3,b,x
	and #$00FF
	dec a
	sta wR0

	lda aProcSystem.aBody3,b,x
	xba
	and #$00FF
	dec a
	sta wR1

	lda aProcSystem.aBody4,b,x
	inc a
	inc a
	sta wR2

	lda #$0004
	sta wR3

	jsl $8593AD
	jsl $85805C
	jsl $85827A
	jsl $858310

	stz wBGUpdateFlags

	sep #$20

	lda #T_Setting(false, true, false, false, true)
	sta bBufferTM

	rep #$20

	rtl

rlUnknown9A80D7 ; 9A/80D7

	.al
	.xl
	.autsiz
	.databank ?

	lda #$0800
	sta wR0

	lda #$0002
	sta wR1

	lda #$0002
	sta wR2

	lda #$0000
	sta wR3

	lda aProcSystem.aBody1,b,x
	sta lR18
	lda aProcSystem.aBody2,b,x
	sta lR18+1

	lda aProcSystem.aBody3,b,x
	tax
	jsl rlUnknownDialogueText

	rtl

rlUnknown9A80FE ; 9A/80FE

	.al
	.xl
	.autsiz
	.databank ?

	sep #$20

	lda #T_Setting(true, true, true, false, true)
	sta bBufferTM

	lda #T_Setting(false, false, false, false, false)
	sta bBufferTS

	lda #CGWSEL_Setting(false, false, CGWSEL_MathAlways, CGWSEL_BlackNever)
	sta bBufferCGWSEL

	lda #CGADSUB_Setting(CGADSUB_Add, false, false, false, false, false, false, false)
	sta bBufferCGADSUB

	rep #$20

	lda #<>aBG1TilemapBuffer
	sta wR0
	lda #$02FF
	jsl rlFillTilemapByWord

	lda #<>aBG3TilemapBuffer
	sta wR0
	lda #$01DF
	jsl rlFillTilemapByWord

	jsl rlEnableBG1Sync
	jsl rlEnableBG3Sync

	rtl
