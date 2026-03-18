    ; Minimal crt0 for AmigaOS 1.3
    ; Only initializes SysBase and DOSBase
    ; Graphics/Intuition opened on-demand by modules

    SECTION code,code

    XDEF _start
    XREF _main
    XREF _SysBase
    XREF _DOSBase

_start:
    move.l 4.w,a6
    move.l a6,_SysBase

    lea dosname(pc),a1
    moveq #0,d0
    jsr -552(a6)
    move.l d0,_DOSBase

    jsr _main

    move.l _DOSBase,a1
    beq.s .no_dos
    move.l _SysBase,a6
    jsr -414(a6)
.no_dos
    moveq #0,d0
    rts

dosname:
    dc.b "dos.library",0
    even
