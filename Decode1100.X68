*-----------------------------------------------------------
* Title      :  Decode 1100
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 1100, which are MULS and AND
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 1000 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_1100
        JMP      jmp_and_000
        JMP      jmp_and_001
        JMP      jmp_and_010  
        JMP      not_1100_011
        JMP      jmp_and_100                
        JMP      jmp_and_101  
        JMP      jmp_and_110   
        JMP      jmp_muls

* At this point, we know the opcode is AND with byte size
* Now we branch to EA subroutine for further decoding
jmp_and_000
jmp_and_100
        LEA     and_str,A4           * put opcode for buffer
        MOVE.B  #$01,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_AND               * branch to EA subroutine
        RTS

* At this point, we know the opcode is AND with word size
* Now we branch to EA subroutine for further decoding
jmp_and_001
jmp_and_101
        LEA     and_str,A4          * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_AND              * branch to EA subroutine
        RTS


* At this point, we know the opcode is AND with long size
* Now we branch to EA subroutine for further decoding
jmp_and_010
jmp_and_110
        LEA     and_str,A4          * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_AND              * branch to EA subroutine
        RTS

* At this point, we know the opcode is undecodable
not_1100_011
        JSR     PROCESS_DATA
        RTS

* At this point, we know the opcode is MULS with word size
* Now we branch to EA subroutine for further decoding
jmp_muls
        LEA     muls_str,A4         * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_MULS             * branch to EA subroutine
        RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
