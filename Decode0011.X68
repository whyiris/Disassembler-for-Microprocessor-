*-----------------------------------------------------------
* Title      :  Decode0011
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 0011, which are MOVE.W AND MOVEA.W
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 0011 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_0011
        JMP      jmp_move_w_000
        JMP      jmp_movea_w
        JMP      jmp_move_w_010  
        JMP      jmp_move_w_011
        JMP      jmp_move_w_100                
        JMP      not_0011_101  
        JMP      not_0011_110   
        JMP      jmp_move_w_111 

jmp_move_w_000
jmp_move_w_010
jmp_move_w_011
jmp_move_w_100
jmp_move_w_111
* At this point, we know the opcode is MOVE.W
* Now we branch to EA subroutine for further decoding
        LEA     move_str,A4         * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer    
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_MOVE             * branch to EA subroutine
        RTS
        
jmp_movea_w
* At this point, we know the opcode is MOVEA.W
* Now we branch to EA subroutine for further decoding
        LEA     movea_str,A4         * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer 
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_MOVEA             * branch to EA subroutine
        RTS

* At this point, we know the opcode is undecodable                      
not_0011_101
not_0011_110        JSR PROCESS_DATA   
                    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
