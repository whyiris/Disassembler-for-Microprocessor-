*-----------------------------------------------------------
* Title      :  Decode0110
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 0110, which are BCC and BRA
*-----------------------------------------------------------

* At this point, we know the opcode is either BCC or BRA, or a one we aren't required to decode.
* Now we examine bit 8,9,10,11 to do more elimination.
DECODE_0110


            CLR     D0
            
            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction
            AND.W   #$FF,D0
            CMP.W   #0,D0
            BEQ     BRANCH_IS_WORD_SIZE
            
            BNE     BRANCH_IS_BYTE_SIZE
            

BRANCH_IS_WORD_SIZE
            MOVE.B  #$02,size 
            BRA     FIND_WHICH_BRANCH

BRANCH_IS_BYTE_SIZE 
            MOVE.B  #$01,size
            BRA     FIND_WHICH_BRANCH
            


FIND_WHICH_BRANCH             
            CLR     D0
            
            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction


            
            LSR.W   #8,D0           * Shift 8 bits to the right
            AND.W   #$000F,D0       * Only keep the last 4 bits
            
            CMP.B   #%0000,D0       * Check if 8-11 bits are 0000
            BEQ     IS_BRA          * If so, branch to BRA loop
            
            CMP.B   #%0100,D0       * Check if 8-11 bits are 0100
            BEQ     IS_BCC          * If so, branch to BCC loop
            
            CMP.B   #%1100,D0       * Check if 8-11 bits are 1100
            BEQ     IS_BGE          * If so, branch to BGE loop
            
            CMP.B   #%1101,D0       * Check if 8-11 bits are 1101
            BEQ     IS_BLT          * If so, branch to BLT loop
            
            CMP.B   #%0010,D0
            BEQ     IS_BHI
            
            CMP.B   #%0011,D0
            BEQ     IS_BLS

            CMP.B   #%0101,D0
            BEQ     IS_BCS

            CMP.B   #%0110,D0
            BEQ     IS_BNE

            CMP.B   #%0111,D0
            BEQ     IS_BEQ

            CMP.B   #%1000,D0
            BEQ     IS_BVC

            CMP.B   #%1001,D0
            BEQ     IS_BVS

            CMP.B   #%1010,D0
            BEQ     IS_BPL

            CMP.B   #%1011,D0
            BEQ     IS_BMI

            CMP.B   #%1110,D0
            BEQ     IS_BGT

            CMP.B   #%1111,D0
            BEQ     IS_BLE
            
            
            JSR     PROCESS_DATA    * We know it's neither BCC nor BRA
            RTS
            
            
IS_BHI
        LEA     bhi_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS    


IS_BLS
        LEA     bls_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS    
        
IS_BCS
        LEA     bcs_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        
IS_BNE
        LEA     bne_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS           
  
IS_BEQ
        LEA     beq_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        

IS_BVC
        LEA     bvc_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        
IS_BVS
        LEA     bvs_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        
IS_BPL
        LEA     bpl_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        
IS_BMI
        LEA     bmi_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
        
IS_BGT
        LEA     bgt_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   

IS_BLE
        LEA     ble_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS   
* At this point, we know the opcode is BRA
* Now we branch to EA subroutine for further decoding          
IS_BRA
        LEA     bra_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BRA             * branch to EA subroutine
        RTS

* At this point, we know the opcode is BCC
* Now we branch to EA subroutine for further decoding         
IS_BCC
        LEA     bcc_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BCC             * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is BGE
* Now we branch to EA subroutine for further decoding 
IS_BGE
        LEA     bge_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BCC             * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is BLT
* Now we branch to EA subroutine for further decoding 
IS_BLT
        LEA     blt_str,A4         * put opcode for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_BCC             * branch to EA subroutine
        RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
