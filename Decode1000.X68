*-----------------------------------------------------------
* Title      :  Decode 1000
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 1000, which are DIVU and OR
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 1000 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_1000
        JMP      jmp_or_000
        JMP      jmp_or_001
        JMP      jmp_or_010  
        JMP      jmp_divu
        JMP      jmp_or_100                
        JMP      jmp_or_101  
        JMP      jmp_or_110   
        JMP      not_1000_111

* At this point, we know the opcode is OR with byte size
* Now we branch to EA subroutine for further decoding
jmp_or_000
jmp_or_100
        LEA     or_str,A4           * put opcode for buffer
        MOVE.B  #$01,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_OR               * branch to EA subroutine
        RTS

* At this point, we know the opcode is OR with word size
* Now we branch to EA subroutine for further decoding
jmp_or_001
jmp_or_101
        LEA     or_str,A4           * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_OR               * branch to EA subroutine
        RTS

* At this point, we know the opcode is OR with long size
* Now we branch to EA subroutine for further decoding
jmp_or_010
jmp_or_110
        LEA     or_str,A4           * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_OR               * branch to EA subroutine
        RTS

* At this point, we know the opcode is DIVU with word size
* Now we branch to EA subroutine for further decoding
jmp_divu
        LEA     divu_str,A4           * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_DIVU               * branch to EA subroutine
        RTS

* At this point, we know this opcode is undecodable  
not_1000_111
        JSR     PROCESS_DATA
        RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
