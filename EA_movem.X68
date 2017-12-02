*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_MOVEM:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.B       #%110,D0
                BEQ         MOVEM_EA_LIST
                BNE         MOVEM_LIST_EA

*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------                
MOVEM_LIST_EA                
                LEA         JUM_MOVEM_LIST_EA,A0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS         * Complementary to 'JSR  EA_MOVEM' 
  
JUM_MOVEM_LIST_EA       JMP     code000_MOVEM_LIST_EA
                        JMP     code001_MOVEM_LIST_EA
                        JMP     code010_MOVEM_LIST_EA
                        JMP     code011_MOVEM_LIST_EA
                        JMP     code100_MOVEM_LIST_EA
                        JMP     code101_MOVEM_LIST_EA
                        JMP     code110_MOVEM_LIST_EA
                        JMP     code111_MOVEM_LIST_EA

code000_MOVEM_LIST_EA    JSR     PROCESS_DATA
                         RTS
code001_MOVEM_LIST_EA    JSR     PROCESS_DATA
                         RTS
code010_MOVEM_LIST_EA
                CLR.W       oper2type
                CLR         extension_bytes
                CLR.L       D0
                MOVE.W      #2,extension_bytes
                MOVE.W      #%010,oper2type
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                BRA         MOVEM_LIST_EA_DECODE_LIST

code011_MOVEM_LIST_EA    JSR     PROCESS_DATA
                         RTS
code100_MOVEM_LIST_EA
                CLR         oper2type
                CLR         extension_bytes
                CLR.L       D0
                MOVE.W      #2,extension_bytes
                MOVE.W      #%100,oper2type
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper2val
                MOVE.L      D0,oper2val
                BRA         MOVEM_LIST_EA_DECODE_LIST_2

code101_MOVEM_LIST_EA    JSR     PROCESS_DATA
                         RTS
code110_MOVEM_LIST_EA    JSR     PROCESS_DATA
                         RTS
code111_MOVEM_LIST_EA
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_LIST_EA_MOVEM

                CMP.W       #001,D0
                BEQ         longAddr_LIST_EA_MOVEM

wordAddr_LIST_EA_MOVEM
                CLR         oper2type
                CLR         extension_bytes
                ADD.W       #%111,oper2type
                ADD.W       #%000,oper2type
                
                MOVE.L      cur_addr,A1
                ADD.L       #4,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper2val
                MOVE.W      #4,extension_bytes
                BRA         MOVEM_LIST_EA_DECODE_LIST         

longAddr_LIST_EA_MOVEM
                CLR         oper2type
                CLR         extension_bytes
                ADD.W       #%111,oper2type
                ADD.W       #%001,oper2type
                
                MOVE.L      cur_addr,A1
                ADD.L       #4,A1
                CLR.L       D2
                MOVE.L      (A1),D2
                MOVE.L      D2,oper2val
                MOVE.W      #6,extension_bytes
                BRA         MOVEM_LIST_EA_DECODE_LIST 
   
MOVEM_LIST_EA_DECODE_LIST 
                CLR         oper1type
                ADD.W       #%111,oper1type
                ADD.W       #%110,oper1type
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
                
MOVEM_LIST_EA_DECODE_LIST_2
                CLR         oper1type
                ADD.W       #%111,oper1type
                ADD.W       #%111,oper1type
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
MOVEM_EA_LIST
                LEA         JUM_MOVEM_EA_LIST,A0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS
                
JUM_MOVEM_EA_LIST       JMP     code000_MOVEM_EA_LIST
                        JMP     code001_MOVEM_EA_LIST
                        JMP     code010_MOVEM_EA_LIST
                        JMP     code011_MOVEM_EA_LIST
                        JMP     code100_MOVEM_EA_LIST
                        JMP     code101_MOVEM_EA_LIST
                        JMP     code110_MOVEM_EA_LIST
                        JMP     code111_MOVEM_EA_LIST

code000_MOVEM_EA_LIST    JSR     PROCESS_DATA
                         RTS
code001_MOVEM_EA_LIST    JSR     PROCESS_DATA
                         RTS
code010_MOVEM_EA_LIST
                CLR         oper1type
                CLR         extension_bytes
                MOVE.W      #2,extension_bytes
                MOVE.W      #%010,oper1type
                
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         MOVEM_EA_LIST_DECODE_LIST
                
code011_MOVEM_EA_LIST
                CLR         oper1type
                CLR         extension_bytes
                MOVE.W      #2,extension_bytes

                MOVE.W      #%011,oper1type
                MOVE.L      cur_addr,A1
                CLR.L       D0
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L       oper1val
                MOVE.L      D0,oper1val
                BRA         MOVEM_EA_LIST_DECODE_LIST
                
code100_MOVEM_EA_LIST    JSR     PROCESS_DATA
                         RTS
code101_MOVEM_EA_LIST    JSR     PROCESS_DATA
                         RTS
code110_MOVEM_EA_LIST    JSR     PROCESS_DATA
                         RTS
code111_MOVEM_EA_LIST
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_EA_LIST_MOVEM

                CMP.W       #001,D0
                BEQ         longAddr_EA_LIST_MOVEM

wordAddr_EA_LIST_MOVEM
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%000,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #4,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #4,extension_bytes
                BRA         MOVEM_EA_LIST_DECODE_LIST         

longAddr_EA_LIST_MOVEM
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%001,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #4,A1
                CLR.L       D2
                MOVE.L      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #6,extension_bytes
                BRA         MOVEM_EA_LIST_DECODE_LIST 

MOVEM_EA_LIST_DECODE_LIST    
                CLR         oper2type
                ADD.W       #%111,oper2type
                ADD.W       #%110,oper2type
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
