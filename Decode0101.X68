*-----------------------------------------------------------
* Title      :  Decode0000
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 0000, which are ADDI and SUBI
*-----------------------------------------------------------

* At this point, we know the opcode is either ADDQ, or a one we aren't required to decode.
* Now we examine bit 6, 7, 8 bits to find size. 
DECODE_0101
            CLR.L   D0

            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction          
                
            LSR.W   #6,D0       *Shift 6 bits to the right
                                
            AND.W   #$0007,D0       * Only keep the last 2 bits
                
            CMP.B   #%00,D0         * Check if it is byte
            BEQ     IS_BYTE_0101         * If so, branch to BYTE loop
            
            CMP.B   #%01,D0         * Check if it is word
            BEQ     IS_WORD_0101        * If so, branch to WORD loop

            CMP.B   #%10,D0         * Check if it is long
            BEQ     IS_LONG_0101         * If so, branch to LONG loop

            JSR     PROCESS_DATA        * we know it's neither ADDI nor SUBI
            RTS
            
* At this point, we know the size is byte, now we check 9,10,11 bits to do more elimination
IS_BYTE_0101
            MOVE.B  #$01,size
            BRA     IS_ADDQ         
            
* At this point, we know the size is word, now we check 9,10,11 bits to do more elimination
IS_WORD_0101
            MOVE.B  #$02,size
            BRA     IS_ADDQ  
            
* At this point, we know the size is long, now we check 9,10,11 bits to do more elimination
IS_LONG_0101
            MOVE.B  #$04,size
            BRA     IS_ADDQ  
            
** At this point, we know the opcode is either ADDI or SUBI,
** now we examine bit 9,10,11 bits to do more elimination 
*FIND_ADDI_SUBI
*            CLR D0
*
*            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
*            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction
*            
*            MOVE.B  #9,D1           *Shift 9 bits to the right                
*            LSR.W   D1,D0
*                                
*            AND.W   #$0007,D0       * Only keep the last 3 bits
*                
*            CMP.B   #%011,D0        * Check if bits are 011
*            BEQ     IS_ADDI         * If so, branch to ADDI loop
*            
*            CMP.B   #%010,D0        * Check if bits are 010
*            BEQ     IS_SUBI         * If so, branch to SUBI loop
*
*            JSR     PROCESS_DATA    * we know it's neither ADDI nor SUBI
*            RTS
*            
* At this point, we know the opcode is ADDI,
* Now we branch to EA subroutine for further decoding
IS_ADDQ
            LEA     addq_str,A4         * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_ADDQ             * branch to EA subroutine
            RTS    

** At this point, we know the opcode is SUBI,
** Now we branch to EA subroutine for further decoding
*IS_SUBI
*            LEA     subi_str,A4         * put opcode for buffer
*            JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
*            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
*            JSR     EA_SUBI             * branch to EA subroutine
*            RTS         






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
