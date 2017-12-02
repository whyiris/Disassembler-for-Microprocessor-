*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_BCC:
EA_BRA:

                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$00FF,D0       * Only keep the last 3 bits
                CLR         oper1type
                ADD.W       #%111,oper1type
                ADD.W       #%001,oper1type
                CMP.B       #0,D0
                BEQ         oper_1_EA_BCC
                
                
                LSL.B       #1,D0
                BCS         oper1_EA_BCC_IS_NEG
                
                BCC         oper1_EA_BCC_IS_VALID
                
oper1_EA_BCC_IS_VALID        
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$00FF,D0       * Only keep the last 3 bits
                MOVE.L      cur_addr,D1
                ADD.L       #2,D1
*                ADD.L       D0,D1
                ADD.L       D0,D1
                MOVE.L      D1,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                                

oper_1_EA_BCC
                CLR         extension_bytes
                MOVE.W      #2,extension_bytes
                MOVE.L      cur_addr,A1
                MOVE.L      cur_addr,D0           *D0 have the current address
                ADD.L       #2,A1
                CLR.L       D1
                MOVE.W      (A1),D1         *D1 have the displacement 
                LSL.W       #1,D1
                BCS         calculate_actual_address_Word
                
                MOVE.L      cur_addr,D0                 
                ADD.L       #$2,D0          *add 2 to current address to get PC value
*                ADD.L        D1,D0
                CLR.L       D1
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.W      (A1),D1
                ADD.L       D1,D0           *add displacement to PC value to get address of label
                MOVE.L      D0,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
   
calculate_actual_address_Word
                MOVE.L      #$FFFE,D5
                CLR.L       D1
                MOVE.W      (A1),D1

                SUB.L       D1,D5
                MOVE.L      cur_addr,D6
                SUB.L       D5,D6
                MOVE.L      D6,oper1val
                
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
oper1_EA_BCC_IS_NEG
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D1       * D0 now contains the address of the very first instruction
                AND.W       #$00FF,D1       * Only keep the last 3 bits

                MOVE.L      #$00FE,D0
                SUB.L       D1,D0

                MOVE.L      cur_addr,D6 
                SUB.L       D0,D6

                MOVE.L      D6,oper1val
                
                
                JSR         ADD_OPERANDS_TO_BUF
                RTS
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
