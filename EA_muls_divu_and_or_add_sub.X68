*--------------------------------------------------------------------------------------
* Title      : 
* Written by : Hoi Yan Wu, Zhiming Zhong, Wai Kwan Shum
* Date       : May 2017
* Description: Examines appropriate bits to determine type and value of operand(s).
*              
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------

EA_MULS:
EA_DIVU:
* Get 3,4,5 bit for oper1 type and jump to the corresponding JUMP table
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_EA_MULS_DIVU,A0
                MOVE.W      (A1),D0        
                CLR.L       D1
                MOVE.B      #3,D1           
                LSR.W       D1,D0           
                AND.W       #$0007,D0       
                MULU        #6,D0           
                JSR         0(A0,D0)
                RTS        
                
JUM_345_EA_MULS_DIVU        JMP     code000_oper_1_type_EA_MULS_DIVU
                            JMP     code001_oper_1_type_EA_MULS_DIVU
                            JMP     code010_oper_1_type_EA_MULS_DIVU
                            JMP     code011_oper_1_type_EA_MULS_DIVU
                            JMP     code100_oper_1_type_EA_MULS_DIVU
                            JMP     code101_oper_1_type_EA_MULS_DIVU
                            JMP     code110_oper_1_type_EA_MULS_DIVU
                            JMP     code111_oper_1_type_EA_MULS_DIVU

* the type of operand 1 is data register 
* set the oper1type to 000
* get the number of data register
* set the oper1val to the number of data register
code000_oper_1_type_EA_MULS_DIVU        
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%000,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EA_MULS_DIVU
                    
code001_oper_1_type_EA_MULS_DIVU    JSR     PROCESS_DATA
                                    RTS


code010_oper_1_type_EA_MULS_DIVU
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%010,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EA_MULS_DIVU

code011_oper_1_type_EA_MULS_DIVU
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%011,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EA_MULS_DIVU

code100_oper_1_type_EA_MULS_DIVU
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%100,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EA_MULS_DIVU

code101_oper_1_type_EA_MULS_DIVU    JSR     PROCESS_DATA
                                    RTS
code110_oper_1_type_EA_MULS_DIVU    JSR     PROCESS_DATA
                                    RTS

* either immediate data or direct addressing mode
* Branch to the corresponding mode based on 0,1,2 bits 
* and set oper1 type to corresponding number
code111_oper_1_type_EA_MULS_DIVU                            
                    CLR.L       D0
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CMP.W       #%000,D0
                    BEQ         wordAddr_oper_1_EA_MULS_DIVU
                
                    CMP.W       #%001,D0
                    BEQ         longAddr_oper_1_EA_MULS_DIVU

                    CMP.W       #%100,D0
                    BEQ         immd_oper_1_EA_MULS_DIVU                
                    JSR         PROCESS_DATA
                    RTS  
wordAddr_oper_1_EA_MULS_DIVU
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
                BRA         oper_2_EA_MULS_DIVU           

longAddr_oper_1_EA_MULS_DIVU
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
                BRA         oper_2_EA_MULS_DIVU           

immd_oper_1_EA_MULS_DIVU
                CLR         oper1type
                CLR         extension_bytes
                ADD.W       #%111,oper1type
                ADD.W       #%100,oper1type
                
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D2
                MOVE.W      (A1),D2
                MOVE.L      D2,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EA_MULS_DIVU

oper_2_EA_MULS_DIVU
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type
                CLR.L       oper2val
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS
           
*--------------------------------------------------------------------------------------
     
EA_AND:
EA_OR:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0         * D0 now contains the address of the very first instruction
                AND.W       #$0100,D0       * Only keep the last 3 bits
                CMP.W       #0,D0
                BEQ         EA_Dn_AND_OR 
                
                CMP.W       #$0100,D0
                BEQ         Dn_EA_AND_OR
                

Dn_EA_AND_OR
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%000,oper1type
                CLR.L       oper1val
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.L      D0,oper1val
                
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_DnEA_AND_OR,A0
                MOVE.W      (A1),D0        
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS

JUM_345_DnEA_AND_OR       
                        JMP     code000_oper_2_type_DnEA_AND_OR
                        JMP     code001_oper_2_type_DnEA_AND_OR
                        JMP     code010_oper_2_type_DnEA_AND_OR
                        JMP     code011_oper_2_type_DnEA_AND_OR
                        JMP     code100_oper_2_type_DnEA_AND_OR
                        JMP     code101_oper_2_type_DnEA_AND_OR
                        JMP     code110_oper_2_type_DnEA_AND_OR
                        JMP     code111_oper_2_type_DnEA_AND_OR
                        
code000_oper_2_type_DnEA_AND_OR     JSR     PROCESS_DATA
                                    RTS
code001_oper_2_type_DnEA_AND_OR     JSR     PROCESS_DATA
                                    RTS

code010_oper_2_type_DnEA_AND_OR
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


code011_oper_2_type_DnEA_AND_OR
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

code100_oper_2_type_DnEA_AND_OR
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

code101_oper_2_type_DnEA_AND_OR     JSR     PROCESS_DATA
                                    RTS
code110_oper_2_type_DnEA_AND_OR     JSR     PROCESS_DATA
                                    RTS
code111_oper_2_type_DnEA_AND_OR
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0          * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_2_DnEA_AND_OR
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_2_DnEA_AND_OR

                JSR         PROCESS_DATA
                RTS

wordAddr_oper_2_DnEA_AND_OR
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


longAddr_oper_2_DnEA_AND_OR
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





EA_Dn_AND_OR
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_EADn_AND_OR,A0
                MOVE.W      (A1),D0        
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS

JUM_345_EADn_AND_OR       
                        JMP     code000_oper_1_type_EADn_AND_OR
                        JMP     code001_oper_1_type_EADn_AND_OR
                        JMP     code010_oper_1_type_EADn_AND_OR
                        JMP     code011_oper_1_type_EADn_AND_OR
                        JMP     code100_oper_1_type_EADn_AND_OR
                        JMP     code101_oper_1_type_EADn_AND_OR
                        JMP     code110_oper_1_type_EADn_AND_OR
                        JMP     code111_oper_1_type_EADn_AND_OR
                        
code000_oper_1_type_EADn_AND_OR
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%000,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_AND_OR

code001_oper_1_type_EADn_AND_OR    JSR     PROCESS_DATA
                                   RTS

code010_oper_1_type_EADn_AND_OR
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%010,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_AND_OR

code011_oper_1_type_EADn_AND_OR
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%011,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_AND_OR

code100_oper_1_type_EADn_AND_OR
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%100,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_AND_OR

code101_oper_1_type_EADn_AND_OR     JSR     PROCESS_DATA
                                    RTS
code110_oper_1_type_EADn_AND_OR     JSR     PROCESS_DATA
                                    RTS

code111_oper_1_type_EADn_AND_OR
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0          * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EADn_AND_OR
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EADn_AND_OR

                CMP.W       #%100,D0
                BEQ         immdData_oper_1_EADn_AND_OR
                JSR         PROCESS_DATA
                RTS

wordAddr_oper_1_EADn_AND_OR
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
                BRA         oper_2_EADn_AND_OR

longAddr_oper_1_EADn_AND_OR
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
                BRA         oper_2_EADn_AND_OR

immdData_oper_1_EADn_AND_OR
                CLR         oper1type
                CLR         extension_bytes

                CLR.L       D7
                ADD.W       #%111,oper1type
                ADD.W       #%100,oper1type
                MOVE.B      size,D7
                
                CMP.B       #4,D7
                BEQ         longData_oper_1_EADn_AND_OR
                
                CMP.B       #2,D7
                BEQ         wordData_oper_1_EADn_AND_OR


                CMP.B       #1,D7
                BEQ         byteData_oper_1_EADn_AND_OR  

longData_oper_1_EADn_AND_OR
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes     
                BRA         oper_2_EADn_AND_OR

wordData_oper_1_EADn_AND_OR
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D5
                MOVE.W      (A1),D5
                MOVE.L      D5,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EADn_AND_OR

byteData_oper_1_EADn_AND_OR
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
                BRA         oper_2_EADn_AND_OR

oper_2_EADn_AND_OR
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type
                CLR.L       oper2val
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS

*--------------------------------------------------------------------------------------


EA_ADD:
EA_SUB:
                CLR.L       D0
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0         * D0 now contains the address of the very first instruction
                AND.W       #$0100,D0       * Only keep the last 3 bits
                CMP.W       #0,D0
                BEQ         EA_Dn_ADD_SUB 
                
                CMP.W       #$0100,D0
                BEQ         Dn_EA_ADD_SUB


Dn_EA_ADD_SUB
                CLR.L       D0
                CLR         oper1type
                MOVE.W      #%000,oper1type
                CLR.L       oper1val
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.L      D0,oper1val
                
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_DnEA_ADD_SUB,A0
                MOVE.W      (A1),D0        
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS
    
JUM_345_DnEA_ADD_SUB
                        JMP     code000_oper_2_type_DnEA_ADD_SUB
                        JMP     code001_oper_2_type_DnEA_ADD_SUB
                        JMP     code010_oper_2_type_DnEA_ADD_SUB
                        JMP     code011_oper_2_type_DnEA_ADD_SUB
                        JMP     code100_oper_2_type_DnEA_ADD_SUB
                        JMP     code101_oper_2_type_DnEA_ADD_SUB
                        JMP     code110_oper_2_type_DnEA_ADD_SUB
                        JMP     code111_oper_2_type_DnEA_ADD_SUB
                        
code000_oper_2_type_DnEA_ADD_SUB    JSR     PROCESS_DATA
                                    RTS
code001_oper_2_type_DnEA_ADD_SUB    JSR     PROCESS_DATA
                                    RTS

code010_oper_2_type_DnEA_ADD_SUB
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%010,oper2type
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CLR.L        oper2val
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS


code011_oper_2_type_DnEA_ADD_SUB
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

code100_oper_2_type_DnEA_ADD_SUB
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

code101_oper_2_type_DnEA_ADD_SUB    JSR     PROCESS_DATA
                                    RTS
code110_oper_2_type_DnEA_ADD_SUB    JSR     PROCESS_DATA
                                    RTS
code111_oper_2_type_DnEA_ADD_SUB
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0          * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_2_DnEA_ADD_SUB
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_2_DnEA_ADD_SUB

                JSR     PROCESS_DATA
                RTS

wordAddr_oper_2_DnEA_ADD_SUB
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

longAddr_oper_2_DnEA_ADD_SUB
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



EA_Dn_ADD_SUB
                CLR.L       D0
                MOVE.L      cur_addr,A1
                LEA         JUM_345_EADn_ADD_SUB,A0
                MOVE.W      (A1),D0        
                CLR.L       D1
                MOVE.B      #3,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MULU        #6,D0           * Form offset
                JSR         0(A0,D0)        * Jump indirect with index EA_MOVEA:
                RTS

JUM_345_EADn_ADD_SUB       
                        JMP     code000_oper_1_type_EADn_ADD_SUB
                        JMP     code001_oper_1_type_EADn_ADD_SUB
                        JMP     code010_oper_1_type_EADn_ADD_SUB
                        JMP     code011_oper_1_type_EADn_ADD_SUB
                        JMP     code100_oper_1_type_EADn_ADD_SUB
                        JMP     code101_oper_1_type_EADn_ADD_SUB
                        JMP     code110_oper_1_type_EADn_ADD_SUB
                        JMP     code111_oper_1_type_EADn_ADD_SUB
                        
code000_oper_1_type_EADn_ADD_SUB
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%000,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_ADD_SUB
                    
* Word and long only
* check size to make sure it is not byte 
code001_oper_1_type_EADn_ADD_SUB
                    CLR.L       D0
                    CLR         oper1type
                    
                    CLR.L       D7
                    MOVE.B      size,D7
                    CMP.B       #1,D7
                    BEQ         JUMP_TO_PROCESS_DATA

                    MOVE.W      #%001,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_ADD_SUB



code010_oper_1_type_EADn_ADD_SUB
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%010,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_ADD_SUB

code011_oper_1_type_EADn_ADD_SUB
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%011,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_ADD_SUB

code100_oper_1_type_EADn_ADD_SUB
                    CLR.L       D0
                    CLR         oper1type
                    MOVE.W      #%100,oper1type
                    MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                    MOVE.W      (A1),D0       * D0 now contains the address of the very first instruction
                    AND.W       #$0007,D0       * Only keep the last 3 bits
                    CLR.L       oper1val
                    MOVE.L      D0,oper1val
                    BRA         oper_2_EADn_ADD_SUB

code101_oper_1_type_EADn_ADD_SUB    JSR     PROCESS_DATA
                                    RTS
code110_oper_1_type_EADn_ADD_SUB    JSR     PROCESS_DATA
                                    RTS

code111_oper_1_type_EADn_ADD_SUB
                CLR.L       D0
                MOVE.L      cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W      (A1),D0          * D0 now contains the address of the very first instruction
                AND.W       #$0007,D0       * Only keep the last 3 bits
                CMP.W       #000,D0
                BEQ         wordAddr_oper_1_EADn_ADD_SUB
                
                CMP.W       #001,D0
                BEQ         longAddr_oper_1_EADn_ADD_SUB

                CMP.W       #001,D0
                BEQ         immdData_oper_1_EADn_ADD_SUB
                JSR         PROCESS_DATA
                RTS

wordAddr_oper_1_EADn_ADD_SUB
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
                BRA         oper_2_EADn_ADD_SUB

longAddr_oper_1_EADn_ADD_SUB
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
                BRA         oper_2_EADn_ADD_SUB

immdData_oper_1_EADn_ADD_SUB
                CLR         oper1type
                CLR         extension_bytes

                CLR.L       D7
                ADD.W       #%111,oper1type
                ADD.W       #%100,oper1type
                MOVE.B      size,D7
                
                CMP.B       #4,D7
                BEQ         longData_oper_1_EADn_ADD_SUB
                
                CMP.B       #2,D7
                BEQ         wordData_oper_1_EADn_ADD_SUB


                CMP.B       #1,D7
                BEQ         byteData_oper_1_EADn_ADD_SUB 

longData_oper_1_EADn_ADD_SUB
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                MOVE.L      (A1),oper1val
                MOVE.W      #4,extension_bytes     
                BRA         oper_2_EADn_ADD_SUB

wordData_oper_1_EADn_ADD_SUB
                CLR.L       oper1val
                MOVE.L      cur_addr,A1
                ADD.L       #2,A1
                CLR.L       D5
                MOVE.W      (A1),D5
                MOVE.L      D5,oper1val
                MOVE.W      #2,extension_bytes     
                BRA         oper_2_EADn_ADD_SUB

byteData_oper_1_EADn_ADD_SUB
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
                BRA         oper_2_EADn_ADD_SUB

oper_2_EADn_ADD_SUB
                CLR.L       D0
                CLR         oper2type
                MOVE.W      #%000,oper2type
                CLR.L       oper2val
                MOVE.L      cur_addr,A1
                MOVE.W      (A1),D0        * D0 now contains the address of the very first instruction
                CLR.L       D1
                MOVE.B      #9,D1           *Shift 3 bits to the right 
                LSR.W       D1,D0           * shift the 32 bits right 8 bits. (what remains is the 8MSB of the original example, plus some leading 0 's.)
                AND.W       #$0007,D0       * Only keep the last 3 bits
                MOVE.L      D0,oper2val
                JSR         ADD_OPERANDS_TO_BUF
                RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
