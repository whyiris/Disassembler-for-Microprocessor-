*-----------------------------------------------------------
* Title      :  Decode1001
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 1001, which is SUB
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 1001 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_1001
        JMP      jmp_sub_000
        JMP      jmp_sub_001
        JMP      jmp_sub_010  
        JMP      not_1001_011
        JMP      jmp_sub_100                
        JMP      jmp_sub_101 
        JMP      jmp_sub_110  
        JMP      not_1001_111
 
* At this point, we know the opcode is SUB with byte size
* Now we branch to EA subroutine for further decoding       
jmp_sub_000
jmp_sub_100
        LEA     sub_str,A4          * put opcode for buffer
        MOVE.B  #$01,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_SUB              * branch to EA subroutine
        RTS

* At this point, we know the opcode is SUB with word size
* Now we branch to EA subroutine for further decoding 
jmp_sub_001
jmp_sub_101
        LEA     sub_str,A4          * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_SUB              * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is SUB with long size
* Now we branch to EA subroutine for further decoding 
jmp_sub_010
jmp_sub_110
        LEA     sub_str,A4          * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_SUB              * branch to EA subroutine
        RTS
 
* At this point, we know the opcode is undecodable
not_1001_011 
not_1001_111    JSR PROCESS_DATA
                RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
