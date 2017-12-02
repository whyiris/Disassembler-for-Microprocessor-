*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_ASR:
EA_ASL:
EA_LSR:
EA_LSL:
EA_ROR:
EA_ROL:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #6,D1
                LSR.W       D1,D0
                AND.W       #$0003,D0
                CMP.W       #%11,D0
                BEQ         SHIFT_EA

                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #5,D1
                LSR.W       D1,D0
                AND.W       #$0001,D0
                CMP.W       #%1,D0
                BEQ         SHIFT_Dn_Dn
                BNE         SHIFT_Data_Dn
                
                
SHIFT_EA        CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JMP_SHIFT_EA,A0
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index            
                RTS

JMP_SHIFT_EA    JMP     code000_oper_1_EA_SHIFT
                JMP     code001_oper_1_EA_SHIFT
                JMP     code010_oper_1_EA_SHIFT
                JMP     code011_oper_1_EA_SHIFT
                JMP     code100_oper_1_EA_SHIFT
                JMP     code101_oper_1_EA_SHIFT
                JMP     code110_oper_1_EA_SHIFT
                JMP     code111_oper_1_EA_SHIFT

code000_oper_1_EA_SHIFT      JSR       PROCESS_DATA
                             RTS
code001_oper_1_EA_SHIFT      JSR       PROCESS_DATA
                             RTS
code010_oper_1_EA_SHIFT
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%010,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code011_oper_1_EA_SHIFT
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%011,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
code100_oper_1_EA_SHIFT
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%100,oper1type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0         * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
code101_oper_1_EA_SHIFT      JSR       PROCESS_DATA
                             RTS
code110_oper_1_EA_SHIFT      JSR       PROCESS_DATA
                             RTS
code111_oper_1_EA_SHIFT
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EA_SHIFT
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EA_SHIFT


wordAddr_oper_1_EA_SHIFT
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
                JSR         ADD_OPERANDS_TO_BUF
                RTS

longAddr_oper_1_EA_SHIFT
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
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
SHIFT_Dn_Dn
                CLR         oper1type
                MOVE.W      #%000,oper1type     

                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1
                LSR.W       D1,D0
                AND.W       #$0007,D0

                CLR.L       oper1val
                MOVE.L      D0,oper1val
                
                CLR         oper2type
                MOVE.W      #%000,oper2type
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0

                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
SHIFT_Data_Dn
                CLR         oper1type
                ADD.W       #%111,oper1type     
                ADD.W       #%100,oper1type

                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1
                LSR.W       D1,D0
                AND.W       #$0007,D0

                CMP.B       #0,D0
                BEQ         SHIFT_Data_is_eight
                
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         SHIFT_Data_Dn_oper_2
                
SHIFT_Data_is_eight     
                CLR.L       oper1val
                MOVE.L      #$8,oper1val
                BRA         SHIFT_Data_Dn_oper_2

                
SHIFT_Data_Dn_oper_2
                CLR         oper2type
                MOVE.W      #%000,oper2type
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0

                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
