*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

*<<<<<<< HEAD
EA_move:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         jmp_345_EA_MOVE,A0
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index       
                RTS         * Complementary to 'JSR  EA_MOVE'
              
        
**=======
*EA_MOVE:

*>>>>>>> 330ddb90732e1a281d61ac25c586be3b3f7f0cfa

jmp_345_EA_MOVE     JMP      code000_oper_1_type_EA_MOVE
                    JMP      code001_oper_1_type_EA_MOVE
                    JMP      code010_oper_1_type_EA_MOVE
                    JMP      code011_oper_1_type_EA_MOVE
                    JMP      code100_oper_1_type_EA_MOVE
                    JMP      code101_oper_1_type_EA_MOVE
                    JMP      code110_oper_1_type_EA_MOVE
                    JMP      code111_oper_1_type_EA_MOVE
                    
code000_oper_1_type_EA_MOVE
                CLR.L       D0
                CLR.W       oper1type
                MOVE.W      #%000,oper1type * NOTE: This must be .W since operXtype is word size

                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
*                AND.W       #$0007,D0       * Only keep the last 3 bits
                AND.W       #$0007,D0         * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVE

                

code001_oper_1_type_EA_MOVE
                CLR.L       D7
                MOVE.B      size,D7
                CMP.B       #1,D7
                BEQ         code101_oper_1_type_EA_MOVE


                CLR.L       D0
                CLR.W       oper1type
                MOVE.W      #%001,oper1type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val        * NOTE: changed this from CLR.W to CLR.L since oper1val is long value.
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVE

code010_oper_1_type_EA_MOVE
                CLR.L       D0
                CLR.W       oper1type
                MOVE.W      #%010,oper1type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val        * NOTE: changed this from CLR.W to CLR.L since oper1val is long value.
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVE
                
code011_oper_1_type_EA_MOVE
                CLR.L       D0
                CLR.W       oper1type
                MOVE.W      #%011,oper1type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val        * NOTE: changed this from CLR.W to CLR.L since oper1val is long value.
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVE
                
code100_oper_1_type_EA_MOVE
                CLR.L       D0
                CLR.W       oper1type
                MOVE.W      #%100,oper1type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val        * NOTE: changed this from CLR.W to CLR.L since oper1val is long value.
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVE
                
code101_oper_1_type_EA_MOVE      JSR       PROCESS_DATA
                                 RTS
code110_oper_1_type_EA_MOVE      JSR       PROCESS_DATA
                                 RTS
code111_oper_1_type_EA_MOVE
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                CLR.L       oper1val
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EA_MOVE
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EA_MOVE


                CMP.W       #%100,D0         * NOTE: Fixed bug: This used to say #001.
                BEQ         immdData_oper_1_EA_MOVE
                JSR         PROCESS_DATA
                RTS

wordAddr_oper_1_EA_MOVE
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%000,oper1type * NOTE: This must be .W since operXtype is word size
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes
                BRA         oper_2_EA_MOVE

longAddr_oper_1_EA_MOVE
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%001,oper1type * NOTE: This must be .W since operXtype is word size

                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes

                BRA         oper_2_EA_MOVE
                
immdData_oper_1_EA_MOVE
                CLR         oper1type
                CLR         extension_bytes

                CLR.L       D7
                ADD.W       #%111,oper1type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%100,oper1type * NOTE: This must be .W since operXtype is word size
                MOVE.B      size,D7
                
                CMP.B       #4,D7
                BEQ         longImmd_Data_oper_1_EA_MOVE
                
                CMP.B       #2,D7
                BEQ         wordImmd_Data_oper_1_EA_MOVE


                CMP.B       #1,D7
                BEQ         byteImmd_Data_oper_1_EA_MOVE  
                BRA         oper_2_EA_MOVE
                
                
longImmd_Data_oper_1_EA_MOVE
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes     
                BRA         oper_2_EA_MOVE
                     
wordImmd_Data_oper_1_EA_MOVE
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EA_MOVE
                
byteImmd_Data_oper_1_EA_MOVE

                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D7
                MOVE.W      (A1),D7
                LSR.W       #8,D7
                CMP.L       #0,D7
                BNE         JUMP_TO_PROCESS_DATA
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EA_MOVE


oper_2_EA_MOVE
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         jmp_678_EA_MOVE,A0
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                LSR.W       #6,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset    
                JSR         0(A0,D0)        * Jump indirect with index    

                RTS     * NOTE: We need this since we called JSR to get into jmp_345_EA_MOVE. This RTS complements that JSR.            

jmp_678_EA_MOVE   JMP      code000_oper_2_type_EA_MOVE
                  JMP      code001_oper_2_type_EA_MOVE
                  JMP      code010_oper_2_type_EA_MOVE
                  JMP      code011_oper_2_type_EA_MOVE
                  JMP      code100_oper_2_type_EA_MOVE
                  JMP      code101_oper_2_type_EA_MOVE
                  JMP      code110_oper_2_type_EA_MOVE
                  JMP      code111_oper_2_type_EA_MOVE
                  
code000_oper_2_type_EA_MOVE
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                MOVE.B      #9,D1           *Shift 9 bits to the right 
                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val     * NOTE: changed this from .W to .L since operXval is long value.
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE

code001_oper_2_type_EA_MOVE      JSR       PROCESS_DATA
                                 RTS
code010_oper_2_type_EA_MOVE
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%010,oper2type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                MOVE.B      #9,D1           *Shift 9 bits to the right 
                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val     * NOTE: changed this from .W to .L since operXval is long value.
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE

code011_oper_2_type_EA_MOVE
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%011,oper2type * NOTE: This must be .W since oper2type is word size
                MOVE.L      cur_addr,A1     * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                MOVE.B      #9,D1           *Shift 9 bits to the right 
                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val     * NOTE: changed this from .W to .L since operXval is long value.
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE

code100_oper_2_type_EA_MOVE
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%100,oper2type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                MOVE.B      #9,D1           *Shift 9 bits to the right 
                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val     * NOTE: changed this from .W to .L since operXval is long value.
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE
code101_oper_2_type_EA_MOVE      JSR       PROCESS_DATA 
                                 RTS
code110_oper_2_type_EA_MOVE      JSR       PROCESS_DATA 
                                 RTS
code111_oper_2_type_EA_MOVE
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                MOVE.B      #9,D1           *Shift 9 bits to the right 
                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_mode_oper_2_EA_MOVE
                
                CMP.W       #001,D0
                BEQ         longAddr_mode_oper_2_EA_MOVE

                CMP.W       #001,D0
                BEQ         immdData_mode_oper_2_EA_MOVE
                JSR         PROCESS_DATA
                
                *NOTE: ADDED RTS HERE        * This RTS complements the JSR in oper_2_EA_MOVE
                RTS

                
wordAddr_mode_oper_2_EA_MOVE
                CLR         oper2type
                ADD.W       #%111,oper2type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%000,oper2type * NOTE: This must be .W since operXtype is word size
                
                * Move current address to A1
                * see if there is any extension bytes
                * if yes, add 2 and number of extension bytes to skip the data
                * then we can get the value of operand 2
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes,D5
                
                ADD.L       D5,A1
                ADD.L       #2,A1
                
                * Make sure data store in oper2val with leading zeros
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper2val
                ADD.W       #2,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE

longAddr_mode_oper_2_EA_MOVE
                CLR         oper2type
                ADD.W       #%111,oper2type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%001,oper2type * NOTE: This must be .W since operXtype is word size
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes,D5
                ADD.L       D5,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper2val
                ADD.W       #4,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE
                
                
immdData_mode_oper_2_EA_MOVE
                CLR         oper2type
                CLR.L       D7
                ADD.W       #%111,oper2type * NOTE: This must be .W since operXtype is word size
                ADD.W       #%100,oper2type * NOTE: This must be .W since operXtype is word size
                MOVE.B      size,D7
                
                CMP.B       #4,D7
                BEQ         longImmdData_oper_2_EA_MOVE
                
                CMP.B       #2,D7
                BEQ         wordImmdData_oper_2_EA_MOVE

                CMP.B       #1,D7
                BEQ         byteImmdData_oper_2_EA_MOVE
                
                *NOTE: ADDED RTS HERE        * This RTS complements the JSR in oper_2_EA_MOVE
                RTS
                
longImmdData_oper_2_EA_MOVE
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes, D5
                ADDA.L      D5, A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                ADD.W       #4,extension_bytes     
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE
                     
wordImmdData_oper_2_EA_MOVE
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes, D5
                ADD.L       D5,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                
                MOVE.L      D2,oper1val
                ADD.W       #2,extension_bytes     
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE
                
byteImmdData_oper_2_EA_MOVE
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes, D5
                ADD.L       D5,A1
                ADD.L       #2,A1
                CLR.L       D7
                MOVE.W      (A1),D7
                LSR.W       #8,D7
                CMP.L       #0,D7
                BNE         JUMP_TO_PROCESS_DATA
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                ADD.W       #2,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS         * This RTS complements the JSR in oper_2_EA_MOVE



            















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
