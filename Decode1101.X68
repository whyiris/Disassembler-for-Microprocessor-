*-----------------------------------------------------------
* Title      :  Decode 1101
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 1101, which are ADD and ADDA
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 1101 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_1101
        JMP      jmp_add_000
        JMP      jmp_add_001
        JMP      jmp_add_010  
        JMP      jmp_adda_011
        JMP      jmp_add_100                
        JMP      jmp_add_101  
        JMP      jmp_add_110   
        JMP      jmp_adda_111

* At this point, we know the opcode is ADD with byte size
* Now we branch to EA subroutine for further decoding
jmp_add_000
jmp_add_100
        LEA     add_str,A4           * put opcode for buffer
        MOVE.B  #$01,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ADD               * branch to EA subroutine
        RTS

* At this point, we know the opcode is ADD with word size
* Now we branch to EA subroutine for further decoding
jmp_add_001
jmp_add_101
        LEA     add_str,A4          * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ADD              * branch to EA subroutine
        RTS


* At this point, we know the opcode is ADD with long size
* Now we branch to EA subroutine for further decoding
jmp_add_010
jmp_add_110
        LEA     add_str,A4          * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ADD              * branch to EA subroutine
        RTS


* At this point, we know the opcode it ADDA with word size
* Now we branch to EA subroutine for further decoding
jmp_adda_011
        LEA     adda_str,A4         * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ADDA             * branch to EA subroutine
        RTS

* At this point, we know the opcode it ADDA with long size
* Now we branch to EA subroutine for further decoding   
jmp_adda_111
        LEA     adda_str,A4         * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ADDA             * branch to EA subroutine
        RTS
   








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
