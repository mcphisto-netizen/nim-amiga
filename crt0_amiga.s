    ; Minimal crt0 for AmigaOS 1.3 (m68k, no clib2)
    ; Initializes SysBase and DOSBase, then calls main()

    SECTION code,code

    XDEF _start
    XREF _main
    XREF _SysBase
    XREF _DOSBase

_start:
    ; SysBase is at address 4 (AmigaOS convention)
    move.l 4.w,a6
    move.l a6,_SysBase

    ; Open dos.library (version 0 = any)
    lea dosname(pc),a1
    moveq #0,d0
    jsr -552(a6)          ; OpenLibrary
    move.l d0,_DOSBase
    beq.s .no_dos         ; Handle failure

    ; Call main()
    jsr _main

    ; Close dos.library
.no_dos
    move.l _DOSBase,a1
    beq.s .exit
    move.l _SysBase,a6
    jsr -414(a6)          ; CloseLibrary

.exit
    moveq #0,d0
    rts

dosname:
    dc.b "dos.library",0
    even