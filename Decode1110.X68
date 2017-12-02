*-----------------------------------------------------------
* Title      :  Decode1110
* Written by :
* Date       :
* Description:  This file is to decode machine code that starts
*               with 1110, which are ASR, ASL, LSR, LSL, ROR and ROL
*-----------------------------------------------------------

***************************************************************************************
* Examine bits 6, 7, 8 for all possible opcodes with 1110 as most significant 4 bits 
***************************************************************************************  
      
* For processing bits 6, 7, 8 to do more elimination.
jmpT_1110
        JMP      jmp_asr_lsr_ror_b
        JMP      jmp_asr_lsr_ror_w
        JMP      jmp_asr_lsr_ror_l  
        JMP      jmp_asr_lsr_ror_ea
        JMP      jmp_asl_lsl_rol_b                
        JMP      jmp_asl_lsl_rol_w  
        JMP      jmp_asl_lsl_rol_l   
        JMP      jmp_asl_lsl_rol_ea

***************************************************************************************
* Update size for ASR, LSR, ROR, ASL, LSL and ROL before branching to EA subroutine
***************************************************************************************        
jmp_asr_lsr_ror_b
* At this point, we know the opcode is ASR, LSR or ROR with byte size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$01,size       * Update size for buffer
            BRA     FIND_ASR_LSR_ROR
         
jmp_asr_lsr_ror_w
* At this point, we know the opcode is ASR, LSR or ROR with word size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$02,size       * Update size for buffer
            BRA     FIND_ASR_LSR_ROR
            
jmp_asr_lsr_ror_l
* At this point, we know the opcode is ASR, LSR or ROR with long size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$04,size       * Update size for buffer
            BRA     FIND_ASR_LSR_ROR
            
jmp_asl_lsl_rol_b
* At this point, we know the opcode is ASL, LSL or ROL with byte size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$01,size       * Update size for buffer
            BRA     FIND_ASL_LSL_ROL
               
jmp_asl_lsl_rol_w
* At this point, we know the opcode is ASL, LSL or ROL with word size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$02,size       * Update size for buffer
            BRA     FIND_ASL_LSL_ROL
  
jmp_asl_lsl_rol_l
* At this point, we know the opcode is ASL, LSL or ROL with long size
* Now we update size for buffer, then examine bits 3, 4, 5 to determine which opcode it is
            MOVE.B  #$04,size       * Update size for buffer
            BRA     FIND_ASL_LSL_ROL
            
***************************************************************************************
* Examine bits 9, 10, 11 for ASR, LSR or ROR (memory shift)
***************************************************************************************
jmp_asr_lsr_ror_ea
            MOVE.B  #$02,size       * Update size for buffer 
            CLR     D0

            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction
            
            MOVE.B  #9,D1           *Shift 9 bits to the right 
                
            LSR.W   D1,D0
                                
            AND.W   #$0007,D0       * Only keep the last 3 bits
                
            CMP.B   #%000,D0         * Check if bits are 000
            BEQ     IS_ASR_MEM_SHIFT * If so, branch to ASR memory shift loop
            
            CMP.B   #%001,D0         * Check if bits are 001
            BEQ     IS_LSR_MEM_SHIFT * If so, branch to LSR memory shift loop

            CMP.B   #%011,D0         * Check if bits are 011
            BEQ     IS_ROR_MEM_SHIFT * If so, branch to ROR memory shift loop

            JSR    PROCESS_DATA        * We know it's not ASR, LSR or ROR (memory shift)
            RTS

***************************************************************************************
* Examine bits 9, 10, 11 for ASL, LSL or ROL (memory shift)
***************************************************************************************   
jmp_asl_lsl_rol_ea
            MOVE.B  #$02,size       * Update size for buffer 
            CLR     D0

            MOVE.L  cur_addr,A1     * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0         * D0 now contains the address of the very first instruction
            
            MOVE.B  #9,D1           *Shift 9 bits to the right 
                
            LSR.W   D1,D0
                                
            AND.W   #$0007,D0       * Only keep the last 3 bits
                
            CMP.B   #%000,D0         * Check if bits are 000
            BEQ     IS_ASL_MEM_SHIFT * If so, branch to ASR memory shift loop
            
            CMP.B   #%001,D0         * Check if bits are 001
            BEQ     IS_LSL_MEM_SHIFT * If so, branch to LSR memory shift loop

            CMP.B   #%011,D0         * Check if bits are 011
            BEQ     IS_ROL_MEM_SHIFT * If so, branch to ROR memory shift loop

            JSR     PROCESS_DATA        * We know it's not ASR, LSR or ROR (memory shift)
            RTS

***************************************************************************************
* Branch to EA subroutine for ASR, LSR, ROR, ASL, LSL and ROL (memory shift)
***************************************************************************************
* At this point, we know the opcode is ASR (memory shift)
* Now we branch to EA subroutine for further decoding
IS_ASR_MEM_SHIFT
        LEA     asr_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ASR             * branch to EA subroutine
        RTS

* At this point, we know the opcode is ASL (memory shift)
* Now we branch to EA subroutine for further decoding
IS_ASL_MEM_SHIFT
        LEA     asl_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ASL             * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is LSR (memory shift)
* Now we branch to EA subroutine for further decoding
IS_LSR_MEM_SHIFT
        LEA     lsr_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_LSR             * branch to EA subroutine
        RTS

* At this point, we know the opcode is LSL (memory shift)
* Now we branch to EA subroutine for further decoding
IS_LSL_MEM_SHIFT
        LEA     lsl_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_LSL             * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is ROR (memory shift)
* Now we branch to EA subroutine for further decoding
IS_ROR_MEM_SHIFT
        LEA     ror_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ROR             * branch to EA subroutine
        RTS
        
* At this point, we know the opcode is ROL (memory shift)
* Now we branch to EA subroutine for further decoding
IS_ROL_MEM_SHIFT
        LEA     rol_str,A4         * put opcode for buffer   
        JSR     ADD_OPCODE_TO_BUF  * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
        JSR     EA_ROL             * branch to EA subroutine
        RTS

***************************************************************************************
* Examine bits 3, 4, 5 for ASR, LSR and ROR
*************************************************************************************** 
FIND_ASR_LSR_ROR
            CLR     D0
            LEA     jmpT_asr_lsr_ror,A0
                
            MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
            LSR.W   #3,D0           * Shift 3 bits to the right
                                
            AND.W   #$0007,D0       * Only keep the last 3 bits

            MULU    #6,D0           * Form offset    

            JSR     0(A0,D0)        * Jump indirect with index
            
            RTS    * Complementary to 'JSR  0(A0,D0)' in code1110



jmpT_asr_lsr_ror
            JMP     jmp_asr
            JMP     jmp_lsr
            JMP     not_asr_lsr_ror
            JMP     jmp_ror
            JMP     jmp_asr
            JMP     jmp_lsr
            JMP     not_asr_lsr_ror
            JMP     jmp_ror

* At this point, we know the opcode is ASR
* Now we branch to EA subroutine for further decoding
jmp_asr
            LEA     asr_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_ASR               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASR_LSR_ROR

* At this point, we know the opcode is LSR
* Now we branch to EA subroutine for further decoding
jmp_lsr
            LEA     lsr_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_LSR               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASR_LSR_ROR

* At this point, we know the opcode is ROR
* Now we branch to EA subroutine for further decoding
jmp_ror
            LEA     ror_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_ROR               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASR_LSR_ROR

* At this point, we know the opcode is not ASR, LSR or ROR           
not_asr_lsr_ror
            JSR       PROCESS_DATA 
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASR_LSR_ROR

***************************************************************************************
* Examine bits 3, 4, 5 for ASL, LSL and ROL
*************************************************************************************** 
FIND_ASL_LSL_ROL
            CLR     D0
            LEA     jmpT_asl_lsl_rol,A0
                
            MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
            MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
            LSR.W   #3,D0           * Shift 3 bits to the right
                                
            AND.W   #$0007,D0       * Only keep the last 3 bits

            MULU    #6,D0           * Form offset    

            JSR     0(A0,D0)        * Jump indirect with index
            
            RTS     * Complementary to 'JSR  0(A0,D0)' in code1110


jmpT_asl_lsl_rol
            JMP     jmp_asl
            JMP     jmp_lsl
            JMP     not_asl_lsl_rol
            JMP     jmp_rol
            JMP     jmp_asl
            JMP     jmp_lsl
            JMP     not_asl_lsl_rol
            JMP     jmp_rol

* At this point, we know the opcode is ASL
* Now we branch to EA subroutine for further decoding
jmp_asl
            LEA     asl_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_ASL               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASL_LSL_ROL

* At this point, we know the opcode is LSL
* Now we branch to EA subroutine for further decoding
jmp_lsl
            LEA     lsl_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_LSL               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASL_LSL_ROL

* At this point, we know the opcode is ROL
* Now we branch to EA subroutine for further decoding
jmp_rol
            LEA     rol_str,A4           * put opcode for buffer
            JSR     ADD_OPCODE_TO_BUF    * branch to buffer subroutine
            JSR     ADD_SIZE_TO_BUF     * branch to buffer subroutine
            JSR     EA_ROL               * branch to EA subroutine
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASL_LSL_ROL

* At this point, we know the opcode is not ASL, LSL or ROL          
not_asl_lsl_rol
            JSR       PROCESS_DATA 
            RTS    * Complementary to 'JSR  0(A0,D0)' FIND_ASL_LSL_ROL


      




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
