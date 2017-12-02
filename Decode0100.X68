*-----------------------------------------------------------
* Title      :  Decode0100
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 0100, which are NOP, RTS, JSR, MOVEM and LEA
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 0100 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_0100
            JMP      not_0100_000
            JMP      jmp_nop_rts
            JMP      jmp_jsr_movem_w 
            JMP      jmp_movem_l
            JMP      not_0100_100                
            JMP      not_0100_101 
            JMP      not_0100_110   
            JMP      jmp_lea 

* We know that the opcode is undecodable  
not_0100_000
not_0100_100
not_0100_101
not_0100_110
            JSR       PROCESS_DATA
            RTS

* At this point, we know the opcode is either NOP or RTS 
jmp_nop_rts
            CLR     D0
            MOVE.L  cur_addr,A1
            MOVE.W  (A1),D0     * D0 now contains the word of the instruction at cur_addr
            
            CMPI.W  #$4E71,D0   * compares instruction with NOP machine code
            BEQ     IS_NOP      * branch to buffer if it is NOP
            
            CMPI.W  #$4E75,D0   * compares instruction with RTS machine code
            BEQ     IS_RTS      * branch to buffer if it is RTS
            
            *   we know that the opcode is undecodable
            JSR       PROCESS_DATA
            RTS

* At this point, we know the opcode is either JSR or MOVEM with word size
* we now examine 7, 8, 9 bits to do more elimination         
jmp_jsr_movem_w
            CLR     D0
            MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
             
            MOVE.B  #9,D1           * Shift 9 bits to the right   
            LSR.W   D1,D0
                
            AND.W   #$0007,D0       * Only keep the last 3 bits

            CMP.B   #%100,D0        * Check if the bits are 100
            BEQ     IS_MOVEM_WORD        * If so, branch to MOVEM loop

            CMP.B   #%110,D0        * Check if the bits are 110
            BEQ     IS_MOVEM_WORD        * If so, branch to MOVEM loop
        
            CMP.B   #%111,D0        * Check if the bits are 111
            BEQ     IS_JSR          * If so, branch to JSR loop

            JSR       PROCESS_DATA  * we know the opcode is undecodable
            RTS

* At this point, we know the opcode is either MOVEM with long size
* we now examine 7, 8, 9 bits to do more elimination             
jmp_movem_l
            CLR     D0
            MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
             
            MOVE.B  #9,D1           * Shift 9 bits to the right   
            LSR.W   D1,D0
                
            AND.W   #$0007,D0       * Only keep the last 3 bits

            CMP.B   #%100,D0        * Check if the bits are 100
            BEQ     IS_MOVEM_LONG        * If so, branch to MOVEM loop

            CMP.B   #%110,D0        * Check if the bits are 110
            BEQ     IS_MOVEM_LONG        * If so, branch to MOVEM loop
        
            JSR     PROCESS_DATA    * we know the opcode is undecodable
            RTS

* At this point, we know the opcode is LEA,
* we now branch to EA subroutine
jmp_lea
        LEA     lea_str,A4          * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     EA_LEA              * branch to EA subroutine
        RTS
                       
***************************************************************************************************
* EA Subroutines
***************************************************************************************************
IS_NOP
        LEA     nop_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        RTS

IS_RTS
        LEA     rts_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        RTS
        
IS_JSR
        LEA     jsr_str,A4          * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     EA_JSR              * branch to EA subroutine
        RTS

IS_MOVEM_WORD
        LEA     movem_str,A4        * put opcode for buffer
        MOVE.B  #$02,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_MOVEM            * branch to EA subroutine
        RTS

IS_MOVEM_LONG
        LEA     movem_str,A4        * put opcode for buffer
        MOVE.B  #$04,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_MOVEM            * branch to EA subroutine
        RTS
        
        





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
