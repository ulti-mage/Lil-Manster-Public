
; Cartridge-specific settings

.enc "none"

MakerCode            = 1
GameCode             = "BFRJ"
ExpansionFLASHSize   = 0
ExpansionRAMSize     = 0
SpecialVersion       = 0
CartridgeSubtype     = None
CartridgeTitle       = "FE5 Lil' Manster"
CartridgeSpeed       = CartridgeSpeedFast
CartridgeMode        = CartridgeModeLoROM
CartridgeType        = CartridgeTypeROMRAMBattery
CartridgeCoprocessor = None
CartridgeROMSize     = $600000
CartridgeRAMSize     = $9000
CartridgeDestination = DestinationJapanese
CartridgeNew         = true
CartridgeVersion     = 0
CartridgeChecksum    = $9554

; Now to actually create the header

.if CartridgeNew == true

	.text format("%02X", MakerCode)
	.text GameCode

	.if (len(GameCode) == 4)
		.if (GameCode[0] != "T") && (GameCode[0] != "Z") && !(GameCode in ["042J", "MENU", "XBND"]) && (CartridgeDestination[1] != None)
			.cwarn GameCode[3] != CartridgeDestination[1], "Game code and destination mismatch."
		.endif
	.endif

	.fill 6, 0

	.byte GetShiftAmount(ExpansionFLASHSize / 1024)
	.byte GetShiftAmount(ExpansionRAMSize / 1024)
	.byte SpecialVersion

.else

	.fill 15, 0

.endif

.byte CartridgeSubtype

.cerror len(CartridgeTitle) > 21, "Cartridge title too long."

.union
	.fill 21, " "
	.text CartridgeTitle
.endu

.byte (CartridgeSpeed << 4) | CartridgeMode
.byte (CartridgeCoprocessor << 4) | CartridgeType
.byte $0D ;GetShiftAmount(CartridgeROMSize / 1024)
.byte GetShiftAmount(CartridgeRAMSize / 1024)
.byte CartridgeDestination[0]

.if CartridgeNew == true

	.byte $33

.else

	.byte MakerCode

.endif

.byte CartridgeVersion

.word CartridgeChecksum ^ $FFFF
.word CartridgeChecksum

