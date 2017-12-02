*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------
EA_LEA:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_EA_LEA,A0
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS         * Complementary to 'JSR  EA_LEA'
                
JUM_345_EA_LEA      JMP     code000_opr_1_type_EA_LEA
                    JMP     code001_opr_1_type_EA_LEA
                    JMP     code010_opr_1_type_EA_LEA
                    JMP     code011_opr_1_type_EA_LEA
                    JMP     code100_opr_1_type_EA_LEA
                    JMP     code101_opr_1_type_EA_LEA
                    JMP     code110_opr_1_type_EA_LEA
                    JMP     code111_opr_1_type_EA_LEA

code000_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code001_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code010_opr_1_type_EA_LEA      
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%010,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EA_LEA
code011_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code100_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code101_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code110_opr_1_type_EA_LEA    JSR     PROCESS_DATA
                             RTS
code111_opr_1_type_EA_LEA
                    CLR.L       D0
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CMP.W       #000,D0
                    BEQ         wordAddr_oper_1_EA_LEA
                
                    CMP.W       #001,D0
                    BEQ         longAddr_oper_1_EA_LEA                
                    JSR         PROCESS_DATA
                    RTS    
                
wordAddr_oper_1_EA_LEA
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%000,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes
                BRA         oper_2_EA_LEA           
     
longAddr_oper_1_EA_LEA
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%001,oper1type
                
                MOVEA.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.L      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #4,extension_bytes
                BRA         oper_2_EA_LEA   
                
                
oper_2_EA_LEA
                CLR.L       D0
                CLR         oper2type
                CLR.L       oper2val
                MOVEA.L      cur_addr,A1         * Fixed bug.
                MOVE.W      (A1), D0    
                LSR.W       #8,D0               * Fixed bug (used to be #3)
                LSR.W       #1,D0               * Fixed bug (used to be #3)
                
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.W      #%001,oper2type
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

   



*--------------------------------------------------------------------------------------                                 
EA_MOVEA:                
EA_ADDA:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_EA_MOVEA_ADDA,A0
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index            
                RTS         * Complementary to 'JSR  EA_MOVEA / EA_ADDA'
                
                
JUM_345_EA_MOVEA_ADDA   JMP      code000_opr_1_type_EA_MOVEA_ADDA
                        JMP      code001_opr_1_type_EA_MOVEA_ADDA
                        JMP      code010_opr_1_type_EA_MOVEA_ADDA
                        JMP      code011_opr_1_type_EA_MOVEA_ADDA
                        JMP      code100_opr_1_type_EA_MOVEA_ADDA
                        JMP      code101_opr_1_type_EA_MOVEA_ADDA
                        JMP      code110_opr_1_type_EA_MOVEA_ADDA
                        JMP      code111_opr_1_type_EA_MOVEA_ADDA
                    
code000_opr_1_type_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%000,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVEA_ADDA

code001_opr_1_type_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%001,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVEA_ADDA

code010_opr_1_type_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%010,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVEA_ADDA

code011_opr_1_type_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%011,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVEA_ADDA

code100_opr_1_type_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%100,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         oper_2_EA_MOVEA_ADDA

code101_opr_1_type_EA_MOVEA_ADDA    JSR     PROCESS_DATA
                                    RTS
code110_opr_1_type_EA_MOVEA_ADDA    JSR     PROCESS_DATA
                                    RTS
code111_opr_1_type_EA_MOVEA_ADDA    
                CLR.L       D0
*                CLR         oper1type
*                MOVE.B      #%010,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EA_MOVEA_ADDA
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EA_MOVEA_ADDA

                CMP.W       #%100,D0
                BEQ         immdAddr_oper_1_EA_MOVEA_ADDA
                JSR         PROCESS_DATA
                RTS     

wordAddr_oper_1_EA_MOVEA_ADDA
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%000,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes
                BRA         oper_2_EA_MOVEA_ADDA           
     

longAddr_oper_1_EA_MOVEA_ADDA
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%001,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.L      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #4,extension_bytes
                BRA         oper_2_EA_MOVEA_ADDA           


immdAddr_oper_1_EA_MOVEA_ADDA
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%100,oper1type
                CLR.L       D7
                MOVE.B      size, D7
                CMP.B       #4,D7
                BEQ         longImmdData_opr_1_EA_MOVEA_ADDA
                
                CMP.B       #2,D7
                BEQ         wordImmdData_opr_1_EA_MOVEA_ADDA

longImmdData_opr_1_EA_MOVEA_ADDA
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes     
                BRA         oper_2_EA_MOVEA_ADDA

wordImmdData_opr_1_EA_MOVEA_ADDA
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EA_MOVEA_ADDA


oper_2_EA_MOVEA_ADDA
                CLR.L       D0
                CLR         oper2type
                CLR.L       oper2val
                
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0
                LSR.W       #8,D0
                LSR.W       #1,D0
                AND.L       #$00000007,D0       * Only keep the last 3 bits
                MOVE.W      #%001,oper2type
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
