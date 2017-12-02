*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_JSR:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.B       #%010,D0
                BEQ         code010_oper_1_type_EA_JSR
                CMP.B       #%111,D0
                BEQ         code111_oper_1_type_EA_JSR
                JSR         PROCESS_DATA 
                RTS

code010_oper_1_type_EA_JSR
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%010,oper1type
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0
                CLR.L       oper1val
                MOVE.L      D0,oper1val  
                JSR         ADD_OPERANDS_TO_BUF
                RTS
code111_oper_1_type_EA_JSR
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EA_JSR
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EA_JSR

                JSR         PROCESS_DATA 
                RTS
                
wordAddr_oper_1_EA_JSR
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%000,oper1type
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       oper1val
                CLR.L       D5
                MOVE.W      (A1),D5
                MOVE.L      D5,oper1val
                ADD.W       #2,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS


longAddr_oper_1_EA_JSR
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%001,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       oper1val
                MOVE.L      (A1),oper1val
                ADD.W       #4,extension_bytes
                JSR         ADD_OPERANDS_TO_BUF
                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
