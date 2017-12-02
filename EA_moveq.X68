*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_MOVEQ:
                CLR         oper1type
                MOVE.W      #%1011,oper1type
                CLR.L       D0
                MOVEA.L      cur_addr,A1     * Bug fixed here.
                MOVE.W      (A1),D0 
                AND.L       #$00FF,D0       * Only keep the last 8 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                
                CLR         oper2type
                MOVE.W      #%000,oper2type

                CLR.L       oper2val
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0
                MOVE.B      #9,D1
                LSR.W       D1,D0
                AND.W       #$0007,D0
                MOVE.L      D0,oper2val
                
                JSR         ADD_OPERANDS_TO_BUF
                
                RTS











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
