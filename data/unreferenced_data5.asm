unreferenced_data5:
.if PAL = 1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FB,$FF,$FF,$FF,$EF,$7F,$FF,$FF
        .byte   $FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF
        .byte   $FF,$FB,$EF,$FF,$FF,$FF,$BF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $AF,$FF,$FF,$7F,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
.else

romSource := $35
pieceIndex := $37
stagedPieces := $0300

initRomAddress:
    lda frameCounter+1
.ifdef DEBUG
    lda #<testData
.endif
    sta romSource
    lda frameCounter
    ora #$80
.ifdef DEBUG
    lda #>testData
.endif
    sta romSource+1
    jsr setupNewStagedPieces
    jmp gameModeState_initGameState

.ifdef DEBUG
testData:
    .byte %00011100
    .byte %01110001
    .byte %11000111 ; 07070707

    .byte %11100011
    .byte %10001110
    .byte %00111000 ; 70707070

    .byte %00000101
    .byte %00111001
    .byte %01110111 ; 01234567

    .byte %11111010
    .byte %11000110
    .byte %10001000 ; 76543210
.endif

chooseNextTetrimino:
    ldx pieceIndex
    bpl @noReload
    jsr setupNewStagedPieces
@noReload:
    dec pieceIndex
    lda stagedPieces,x
    cmp #$07
    beq chooseNextTetrimino
    tax
    lda spawnTable,x
    rts

setupNewStagedPieces:
    ldy #$00
    lda (romSource),y
    pha
    lsr
    lsr
    pha
    lsr
    lsr
    lsr
    sta stagedPieces+7
    pla
    and #$7
    sta stagedPieces+6
    iny
    lda (romSource),y
    tax
    asl
    pla
    rol
    and #$7
    sta stagedPieces+5
    txa
    lsr
    php
    pha
    lsr
    lsr
    lsr
    and #$7
    sta stagedPieces+4
    pla
    and #$7
    sta stagedPieces+3
    iny
    lda (romSource),y
    tax
    plp
    ror
    lsr
    lsr
    pha
    lsr
    lsr
    lsr
    sta stagedPieces+2
    pla
    and #$7
    sta stagedPieces+1
    txa
    and #$7
    sta stagedPieces+0
    lda romSource
    clc
    adc #$03
    sta romSource
    lda romSource+1
    adc #$00
    ora #$80
    sta romSource+1
    ldx #$07
    stx pieceIndex
    rts
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$EF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
.endif
