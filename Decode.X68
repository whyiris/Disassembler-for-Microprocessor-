*-----------------------------------------------------------
* Title      :  Decode
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

DECODE_FIRST_INSTR:
    
                SUBQ.L #2, cur_addr         * Only for the very first instruction, subtract 2 from 
                                            * cur_addr so when DECODE_NEXT_INSTR is reached, 
                                            * "ADDQ.L #2, cur_addr" will set cur_addr back to the 
                                            * intended cur_addr value.
                MOVE.W #$0000, extension_bytes  * Must be set to 0 before decoding very 1st instr 
                                                * in this set. (otherwise it's $FFFF)
                                                
                MOVE.W  #$0000, num_of_cur_disp_decoded_lines
    
***************************************************************************************
* Begin decoding machine code at current address. Examine the 4 most significant bits first.
***************************************************************************************     
DECODE_NEXT_INSTR:

                 JSR     SET_UP_BUF         * Reset buffer.

                 ADDQ.L #2, cur_addr        * increment cur_addr by word length for the single 
                                            *   effective address operation word. (1st 16 bits of 
                                            *   instruction)
                                            
                CLR.L   D1                      
                MOVE.W  extension_bytes, D1
                ADD.L   D1, cur_addr        * increment cur_addr by extension_bytes to set
                                            *   cur_addr to address of next instruction.
                                            
                        
                 * Reset EA-related variables
                 MOVE.B #$FF, size
                 MOVE.W #$0000, extension_bytes   * This line must come after we add extension_bytes to cur_addr.
                 MOVE.W #$FFFF, oper1type
                 MOVE.W #$FFFF, oper2type
                 MOVE.L #$FFFFFFFF, oper1val
                 MOVE.L #$FFFFFFFF, oper2val
                 
                                            
                 MOVE.L cur_addr,D0
                 CMP.L  end_addr,D0          * Have we reached the end of the instructions?
                 BGE    REACHED_END_ADDR
                 
                 
                * Check num of lines of decoded lines currently displayed to screen.     
                CLR     D0
                MOVE.W  num_of_cur_disp_decoded_lines, D0
                MOVE.W  #27, max_num_of_decoded_lines_to_disp       * Adjustable.
                MOVE.W  max_num_of_decoded_lines_to_disp, D1        * For testing
                CMP.W   max_num_of_decoded_lines_to_disp, D0            * What size is a constant created using EQU directive?
                BGE     PROMPT_TO_DISP_NEXT_SET_OF_LINES
                
DONE_CHECKING_LINES_OF_OUTPUT:
                 
              
                 JSR     ADD_CUR_ADDR_TO_BUF       
                    
                 LEA     jmp_table,A0        *Index into the table

                 CLR.L   D0                  *Zero it
                 
                 MOVE.L  cur_addr,A1      * A1 now contains the address of the current instruction
                 MOVE.W  (A1),D0        * D0 now contains the contents of the current instruction

                 MOVE.B  #shift,D1       *Shift 12 bits to the right  

                 LSR.W   D1,D0           *Move the bits

* Consider the next instruction. Why do we have to multiply the index 
* by 6? How many bytes does a single jump table entry require? 

                MULU    #6,D0       *Form offset     

                JSR     0(A0,D0)   *Jump indirect with index
                
                JSR     DISP_LINE_BUF_CONTENTS    * After decoding each instruction.
                ADDI.W  #$0001, num_of_cur_disp_decoded_lines

               
                BRA     DECODE_NEXT_INSTR     * NOTE: We must have this line or else when we RTS from  EA_MOVE, we'll resume execution at the jmp_table.

                    

jmp_table      JMP         code0000
               JMP         code0001
               JMP         code0010
               JMP         code0011
               JMP         code0100
               JMP         code0101
               JMP         code0110
               JMP         code0111
               JMP         code1000
               JMP         code1001
               JMP         code1010
               JMP         code1011
               JMP         code1100
               JMP         code1101
               JMP         code1110
               JMP         code1111

        
*The following subroutines will get filled in as you decode the instructions . For *now, just exit gracefully.

code0000    JSR DECODE_0000
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR 
code0001
* At this point, we know the opcode is MOVE.B
* Now we branch to EA subroutine for further decoding
        LEA     move_str,A4         * put opcode for buffer
        MOVE.B  #$01,size           * update size for buffer
        JSR     ADD_OPCODE_TO_BUF   * branch to buffer subroutine
        JSR     ADD_SIZE_TO_BUF   * branch to buffer subroutine
        JSR     EA_MOVE             * branch to EA subroutine
        RTS     * Complementary to JSR(A0, D0 in DECODE_NEXT_INSTR)
        
code0010
* At this point, we know the opcode is either MOVE.L or MOVEA.L, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_0010,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           *Shift 6 bits to the right   
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index          
                
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR 
                
code0011
* At this point, we know the opcode is either MOVE.W or MOVEA.W, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_0011,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right 
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index
                
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR 
                
code0100       
* At this point, we know the opcode is either NOP, RTS, JSR, LEA, MOVEM, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_0100,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right 

                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index         

                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        
                  
code0101    JSR DECODE_0101
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        


code0110    JSR DECODE_0110
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        


code0111    JSR DECODE_0111
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        


code1000
* At this point, we know the opcode is either DIVU or OR, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_1000,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right   
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index
                
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        
    
code1001
* At this point, we know the opcode is either DIVU or OR, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_1001,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right     
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        

                
code1010    JSR PROCESS_DATA
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        

code1011    JSR PROCESS_DATA
            RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        


code1100
* At this point, we know the opcode is either MULS or AND, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_1100,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right    
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index
                
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR        

                
code1101    
* At this point, we know the opcode is either ADD or ADDA, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR  D0
                LEA  jmpT_1101,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W       #6,D0           * Shift 6 bits to the right 
                
                AND.W       #$0007,D0       * Only keep the last 3 bits

                MULU        #6,D0           * Form offset    

                JSR          0(A0,D0)        * Jump indirect with index
                
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR      

code1110
* At this point, we know the opcode is ASR, ASL, LSR, LSL, ROR or ROL, or a one we aren't required to decode.
* Now  we examine bits 6, 7, 8 to do more elimination.
                CLR     D0
                LEA     jmpT_1110,A0
                
                MOVE.L  cur_addr,A1      * A1 now contains the address of the very first instruction
                MOVE.W  (A1),D0        * D0 now contains the address of the very first instruction
                
                LSR.W   #6,D0           * Shift 6 bits to the right
                
                AND.W   #$0007,D0       * Only keep the last 3 bits

                MULU    #6,D0           * Form offset    

                JSR     0(A0,D0)        * Jump indirect with index
                              
                RTS  * Complementary to 'JSR   0(A0,D0)' in DECODE_NEXT_INSTR      
                
code1111    JSR PROCESS_DATA
            RTS        


***************************************************************************************
* Process undecodable data.
***************************************************************************************  
PROCESS_DATA:
* At this point, we know the code at cur_addr is not decodable by this disassembler.

                JSR     ADD_DATA_TO_BUF  
                *JSR     DISP_LINE_BUF_CONTENTS     * No longer calling this here.
                
                MOVE.W  #$0000, extension_bytes   * reset extension byte count in case it was incremented.
                
                RTS     * Complementary to 'JSR PROCESS_DATA'
                
                
* To allow for branching to PROCESS_DATA                
JUMP_TO_PROCESS_DATA:
                JSR PROCESS_DATA
                RTS
                



***************************************************************************************
* Includes
*************************************************************************************** 
    INCLUDE 'Decode0000.X68'
    INCLUDE 'Decode0010.X68'
    INCLUDE 'Decode0011.X68'
    INCLUDE 'Decode0100.X68'
    INCLUDE 'Decode0101.X68'    *added at June, 1, 2017.
    INCLUDE 'Decode0110.X68'
    INCLUDE 'Decode0111.X68'
    INCLUDE 'Decode1000.X68'
    INCLUDE 'Decode1001.X68'
    INCLUDE 'Decode1100.X68'
    INCLUDE 'Decode1101.X68'
    INCLUDE 'Decode1110.X68'
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
