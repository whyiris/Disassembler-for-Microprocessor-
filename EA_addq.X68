*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_ADDQ:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1
                LSR.W       D1,D0
                AND.W       #$0007,D0
                

                CLR         oper1type
                ADD.W       #%111,oper1type     
                ADD.W       #%100,oper1type

                CMP.B       #0,D0
                BEQ         ADDQ_Data_is_eight
                

                
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                
                BRA         ADDQ_Data_EA_oper_2
                

                
ADDQ_Data_is_eight
                CLR.L       oper1val
                MOVE.L      #0008,oper1val
                BRA         ADDQ_Data_EA_oper_2
                
         
       

ADDQ_Data_EA_oper_2
                CLR.L       D0  
                LEA         jmp_345_EA_ADDQ,A0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0
                LSR.W       #3,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index  
                RTS         * Complementary to 'EA_ADDI' / 'EA_SUBI' in Decode.
                
jmp_345_EA_ADDQ   JMP      code000_oper_2_type_EA_ADDQ
                  JMP      code001_oper_2_type_EA_ADDQ
                  JMP      code010_oper_2_type_EA_ADDQ
                  JMP      code011_oper_2_type_EA_ADDQ
                  JMP      code100_oper_2_type_EA_ADDQ
                  JMP      code101_oper_2_type_EA_ADDQ
                  JMP      code110_oper_2_type_EA_ADDQ
                  JMP      code111_oper_2_type_EA_ADDQ


code000_oper_2_type_EA_ADDQ
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code001_oper_2_type_EA_ADDQ
                CLR.L       D0
                CLR         oper2type
                
                CLR.L       D7
                MOVE.B      size,D7
                CMP.B       #1,D7
                BEQ         JUMP_TO_PROCESS_DATA
                
                MOVE.W      #%001,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
code010_oper_2_type_EA_ADDQ
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%010,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
code011_oper_2_type_EA_ADDQ
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%011,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
code100_oper_2_type_EA_ADDQ
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%100,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS


code101_oper_2_type_EA_ADDQ      JSR       PROCESS_DATA
                                 RTS
code110_oper_2_type_EA_ADDQ      JSR       PROCESS_DATA
                                 RTS
code111_oper_2_type_EA_ADDQ
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_2_EA_ADDQ
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_2_EA_ADDQ
                
                JSR         ADD_OPERANDS_TO_BUF
                RTS




wordAddr_oper_2_EA_ADDQ
                CLR         oper2type
                CLR         extension_bytes
                ADD.W       #%111,oper2type
                ADD.W       #%000,oper2type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper2val
                MOVE.W      #2,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS

longAddr_oper_2_EA_ADDQ
                CLR         oper2type
                CLR         extension_bytes
                ADD.W       #%111,oper2type
                ADD.W       #%001,oper2type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.L      (A1),D2
                MOVE.L      D2,oper2val
                MOVE.W      #4,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS

                










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
