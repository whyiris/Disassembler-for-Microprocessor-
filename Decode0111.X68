*-----------------------------------------------------------
* Title      :  Decode0111
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 0111, which is MOVEQ
*-----------------------------------------------------------

DECODE_0111
* At this point, we know the opcode is MOVEQ, or a one we aren't required to decode.
* Now  we examine bit 8 to do more elimination.

            CLR     D0
            
            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.B  (A1),D0         * D0 now contains the address of the very first instruction
                
            LSR.B   #1,D0           * check if the 8th bit of machine code (opcode part) is 0
            BCC     IS_MOVEQ       * we know it's MOVEQ
            JSR     PROCESS_DATA    * we know it's not MOVEQ
            RTS

IS_MOVEQ
            LEA     moveq_str,A4         * put opcode for buffer
            MOVE.B  #$04,size           * update size for buffer 
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     EA_MOVEQ             * branch to EA subroutine
            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
