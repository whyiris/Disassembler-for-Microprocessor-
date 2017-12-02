*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_ADDI:
EA_SUBI:
*--------------------------------------------------------------------
                * the type of operand 1 must be immediate data 
                CLR         oper1type
                MOVE.W      #%1011,oper1type
                
                * get the size of the operation
                * branch to different label to get the data 
                * according to the operation size
                CLR.L         D7
                MOVE.B      size,D7
                CMP.B       #4,D7
                BEQ         longImmdData_oper_1_EA_AISI
                
                CMP.B       #2,D7
                BEQ         wordImmdData_oper_1_EA_AISI

                CMP.B       #1,D7
                BEQ         byteImmdData_oper_1_EA_AISI

longImmdData_oper_1_EA_AISI
                CLR         extension_bytes
                MOVEA.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes
                BRA         oper_2_EA_AISI

wordImmdData_oper_1_EA_AISI
                CLR         extension_bytes
                MOVEA.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       oper1val
                CLR.L       D5
                MOVE.W      (A1),D5
                MOVE.L      D5,oper1val
                MOVE.W      #2,extension_bytes  
                BRA         oper_2_EA_AISI


byteImmdData_oper_1_EA_AISI
                CLR         extension_bytes
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D6
                MOVE.W      (A1),D6
                LSR.W       #8,D6
                CMP.L       #0,D6
                BNE         JUMP_TO_PROCESS_DATA
                CLR.L       oper1val
                CLR.L       D5
                MOVE.W      (A1),D5
                MOVE.L      D5,oper1val
                MOVE.W      #2,extension_bytes
                BRA         oper_2_EA_AISI


oper_2_EA_AISI
                CLR.L       D0  
*                MOVE.L      cur_addr,D0
                LEA         jmp_345_EA_AISI,A0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0
*                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
*                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       #3,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index  
                RTS         * Complementary to 'EA_ADDI' / 'EA_SUBI' in Decode.

jmp_345_EA_AISI   JMP      code000_oper_2_type_EA_AISI
                  JMP      code001_oper_2_type_EA_AISI
                  JMP      code010_oper_2_type_EA_AISI
                  JMP      code011_oper_2_type_EA_AISI
                  JMP      code100_oper_2_type_EA_AISI
                  JMP      code101_oper_2_type_EA_AISI
                  JMP      code110_oper_2_type_EA_AISI
                  JMP      code111_oper_2_type_EA_AISI

code000_oper_2_type_EA_AISI
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code001_oper_2_type_EA_AISI      JSR       PROCESS_DATA
                                 RTS
code010_oper_2_type_EA_AISI  
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%010,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code011_oper_2_type_EA_AISI
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%011,oper2type           *NOTE: fixed bug (used to be #%010)
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code100_oper_2_type_EA_AISI  
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%100,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

code101_oper_2_type_EA_AISI      JSR       PROCESS_DATA
                                 RTS

code110_oper_2_type_EA_AISI      JSR       PROCESS_DATA
                                 RTS

code111_oper_2_type_EA_AISI
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
*                MOVE.B      #9,D1           *Shift 9 bits to the right 
*                LSR.W       D1,D0
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_2_EA_AISI
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_2_EA_AISI

                JSR         PROCESS_DATA
                RTS

wordAddr_oper_2_EA_AISI
                CLR         oper2type
                ADD.W       #%111,oper2type
                ADD.W       #%000,oper2type
                
                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes,D5
                ADD.L       D5,A1
                ADD.L       #2,A1
                
                CLR.L       oper2val
                CLR.L       D6
                MOVE.W      (A1),D6
                MOVE.L      D6,oper2val
                
                ADD.W       #2,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS

longAddr_oper_2_EA_AISI
                CLR         oper2type
                ADD.W       #%111,oper2type
                ADD.W       #%001,oper2type

                MOVE.L      cur_addr,A1
                CLR.L       D5
                MOVE.W      extension_bytes,D5
                ADD.L       D5,A1
                ADD.L       #2,A1
                CLR.L       oper2val
                MOVE.L      (A1),oper2val
                ADD.W       #4,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
