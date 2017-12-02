*--------------------------------------------------------------------------------------------------
* Title      : I/O
* Written by : Zhiming Zhong, Wai Kwan Shum, Hoi Yan Wu
* Date       : May 10, 2017
* Description: Contains the subroutines which perform decoding of instructions for
*              Disassembler program.
*              Disassembler disassembles machine code back to Assembly language code.
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------------------

    
CLEAR_THE_SCREEN:
    MOVE.L  #$FF00, D1
    MOVE.L  #11, D0
    TRAP    #15


***************************************************************************************************
* Display welcome/Display prompt/Take input
***************************************************************************************************
INTROIO:
    LEA     welcome_msg,A1   
    MOVE.L  #13,D0
    TRAP    #15 
    RTS

PROMPT_TO_CONTINUE:
    MOVE.L  #$FFFF, continue_or_not    * reset value of continue_or_not

    LEA     new_line, A1
    MOVE.L  #13,D0
    TRAP    #15 

    LEA     continue_prompt, A1
    MOVE.L  #13,D0
    TRAP    #15 
    
    MOVEA.L #continue_or_not,A1
    MOVE.L  #2,D0
    TRAP    #15 
    
    CMP.W   #$1, D1     * Check if length of input was 1. (For Trap task #2, length was automatically saved to D1.W)
    BNE     PROMPT_TO_CONTINUE
    
    * At this point, we know the input was 1 char (saved into memory as 1 byte) long.
    
    CLR     D1
    MOVE.B  continue_or_not, D1
    
    * Make sure character entered was <= '1', otherwise, prompt to continue again
    CMP.B   #$31, D1
    BGT     PROMPT_TO_CONTINUE     
    
    * Make sure character entered was >= '0', otherwise, prompt to continue again
    CMP.B   #$30, D1
    BLT     PROMPT_TO_CONTINUE   

    RTS     * Complementary to 'JSR PROMPT_TO_CONTINUE' in REACHED_END_ADDR


PROMPT_TO_DISP_NEXT_SET_OF_LINES:

    LEA     disp_next_set_of_lines_msg, A1      *TODO: Fix bug. This doesn't display. 
    MOVE.L  #13, D0
    TRAP    #15
    
    MOVE.L  #2, D0    
    TRAP    #15     * User must press enter for program to continue execution after this point.

    MOVE.W  #$0000, num_of_cur_disp_decoded_lines   * Reset displayed lines count.
    
    *JSR     CLEAR_THE_SCREEN
    
    JSR     DISP_HEADING  * Re-display heading.
        
    BRA     DONE_CHECKING_LINES_OF_OUTPUT   * This isn't RTS since this subroutine is not called through JSR 


PROMPT:
    *MOVE.L  #$FFFFFFFF, end_addr    * So that in CHECK_INPUT_ADDRESSES, end_addr is considered valid before user inputs an end_addr.
    
PROMPT_START_ADDR:

    MOVE.B  #$01, input_was_valid    * This gets set to 0 if in CHECK_INPUT_ADDR, input is found to be invalid.
    
    LEA     prompt_start,A1   
    MOVE.L  #13,D0
    TRAP    #15  
                 
    MOVEA.L #addr_of_starting_addr,A1   * addr_of_starting_addr is where inputted starting location 
                                        *       will be saved to after trap task 2.
    MOVE.L  #2,D0
    TRAP    #15 
    MOVE.W  D1, bytes_of_input_start_addr

    JSR     CHECK_INPUT_ADDR
    CLR     D0
    MOVE.B  input_was_valid, D0
    CMPI.B  #$01, D0
    BEQ     PROMPT_END_ADDR             * If input starting addr is valid, take in end addr.
    
    JSR     DISP_ERROR_MSG
    BRA     PROMPT_START_ADDR

PROMPT_END_ADDR:

    MOVE.B  #$01, input_was_valid    * This gets set to 0 if in CHECK_INPUT_ADDR, input is found to be invalid.

    LEA     prompt_end,A1   
    MOVE.L  #13,D0
    TRAP    #15  
                
    MOVEA.L #addr_of_ending_addr,A1     * addr_of_starting_addr is where inputted starting location 
                                        *       will be saved to after trap task 2.
                
    MOVE.L  #2,D0
    TRAP    #15 
    MOVE.W  D1, bytes_of_input_end_addr

    JSR     CHECK_INPUT_ADDR

    CLR     D0
    MOVE.B  input_was_valid, D0
    CMPI.B  #$1, D0
    BEQ     FINISHED_PROMPTING             * If input starting addr is valid, take in end addr.
    
    JSR     DISP_ERROR_MSG
    BRA     PROMPT_END_ADDR
    
   
FINISHED_PROMPTING:

    JSR     INPUT_TO_HEX_START_END_ADDR
    
    RTS     * Complementary to 'JSR  PROMPT' in DECODE_NEXT_SET_OF_INSTR
 






*         
*PROMPT:
*    LEA     prompt_start,A1   
*    MOVE.L  #13,D0
*    TRAP    #15  
*                 
*    MOVEA.L #addr_of_starting_addr,A1   * addr_of_starting_addr is where inputted starting location 
*                                        *       will be saved to after trap task 2.
*    MOVE.L  #2,D0
*    TRAP    #15 
*    MOVE.W  D1, bytes_of_input_start_addr
*    JSR     CHECK_INPUT                 * Error checking    * Complementary to RTS in DONE_CHECKING_WHOLE_INPUT_VAL
*
*    LEA     prompt_end,A1   
*    MOVE.L  #13,D0
*    TRAP    #15  
*                
*    MOVEA.L #addr_of_ending_addr,A1     * addr_of_starting_addr is where inputted starting location 
*                                        *       will be saved to after trap task 2.
*                
*    MOVE.L  #2,D0
*    TRAP    #15 
*    MOVE.W  D1, bytes_of_input_end_addr
*    JSR     CHECK_INPUT                 * Error checking   * Complementary to RTS in DONE_CHECKING_WHOLE_INPUT_VAL
*    
*    JSR     INPUT_TO_HEX_START_END_ADDR
*    
*    RTS     * Complementary to 'JSR  PROMPT' in DECODE_NEXT_SET_OF_INSTR
                

                
CHECK_INPUT_ADDR:
    * Check that input value (start or end addr) is 1-8 chars, positive, and only contains valid 
    * chars (0-9, A-F, a-f). (Checking that start address < end address is done after ascii->hex 
    * conversion, condensation, and length normalization.)
                
    * length must be between 1 and 8 characters, inclusive. (Automatically saved as 1-8 bytes.)
    CMP.W   #8, D1                      * Byte input length was stored in D1.W (after trap task 2)                                
    BGT     INPUT_WAS_INVALID
    CMP.W   #1, D1
    BLT     INPUT_WAS_INVALID
                
    * Input must be positive. Display error message if the value is negative.
    MOVE.B  #$2D, D2                    *0x2D corresponds to the "-" ASCII symbol
    CMP.B   (A1), D2
    BEQ     INPUT_WAS_INVALID

CHECK_CHAR_VALIDITY: 
    * Each character must be valid hex char. 

    MOVE.B  #0, D6
    MOVE.B  #1, D7
CHECK_CHAR_VALIDITY_UPPER_HALF:
    * Check upper 4 bytes.
    MOVE.L (A1),$A200           * $A200 will now hold the top 4 bytes of the input value      
    MOVE.L  #0, D3
    MOVE.L  #4, D4
    CMP.W   #4,D1               * if length of input < 4, loop length-of-input times, for upper 
                                *        half of input
                                
    BLT     SET_UP_LOOP_WITH_D1_ITERATIONS      
    BRA     CHECK_CHAR_VALIDITY_LOOP
                
CHECK_CHAR_VALIDITY_LOWER_HALF:
    CMP.B   D5, D6              * Stop if the lower half has already been checked.
    BEQ     DONE_CHECKING_WHOLE_INPUT_VAL

    ADDA.L  #4,A1               * now examine lower 4 bytes of input.
    MOVE.L (A1),D5              * D5 will now hold bottom 4 bytes of the input value
    SUBA.L  #4,A1
                
    MOVE.L  #0, D3              * set up for loop
    CMP.W   #4, D1   
    BLT     DONE_CHECKING_WHOLE_INPUT_VAL   * if length of input < 4, we don't need to check past 
                                            *       the first 4 bytes of the input
                
    * At this point we know length of input >= 4 bytes. Set up for loop.
    MOVE.W  D1, D4   
    SUBI.W  #4, D4
    BRA     CHECK_CHAR_VALIDITY_LOOP

SET_UP_LOOP_WITH_D1_ITERATIONS:
    MOVE.W  D1, D4
    BRA     CHECK_CHAR_VALIDITY_LOOP

CHECK_CHAR_VALIDITY_LOOP:
    * Loop through each character in the input value
               
    * If this isn't the very first iteration, shift input value right 1 byte.
    CMP.B   #1, D3
    BGE     SHIFT_INPUT_VAL_LEFT_1_BYTE

                         
CHECK_CHAR_VALIDITY_LOOP_PART2:
    * Second half of this loop.

    CMP.B   D3, D4              * Are we done yet?
    BEQ     CHECK_CHAR_VALIDITY_LOWER_HALF
    ADDI.B  #1, D3              * increment counter
                
    CLR     D5
    MOVE.B  $A200, D5           * only look at next top byte at $A200
               
    CMP.B   #$30, D5            * 0x30 corresponds to ASCII character '0'
    BLT     INPUT_WAS_INVALID      * the char was invalid
    CMP.B   #$39, D5            * 0x39 corresponds to ASCII character '9'
    BLE     CHECK_CHAR_VALIDITY_LOOP    * the char was valid.
                
    CMP.B   #$41, D5            * 0x41 corresponds to ASCII character 'A'
    BLT     INPUT_WAS_INVALID   * the char was invalid
    CMP.B   #$46, D5            * 0x46 corresponds to ASCII character 'F'
    BLE     CHECK_CHAR_VALIDITY_LOOP    * the char was valid.

    CMP.B   #$61, D5            * 0x61 corresponds to ASCII character 'a'
    BLT     INPUT_WAS_INVALID   * the char was invalid
    CMP.B   #$66, D5            * 0x66 corresponds to ASCII character 'f'
    BLE     CHECK_CHAR_VALIDITY_LOOP    * the char was valid.
               
    * at this point, we know the character is out of the valid range. (It's > 'f')
    BRA     INPUT_WAS_INVALID  * the char was invalid

DONE_CHECKING_WHOLE_INPUT_VAL:
    JSR     VERIFY_INPUT_ADDR_IS_EVEN
    RTS     * Complementary to 'JSR     CHECK_INPUT' in PROMPT subroutine.         
                
SHIFT_INPUT_VAL_LEFT_1_BYTE:
    * Shifts input value left 1 byte to allow us to check the next byte.    
    MOVE.L  $A200, D5           *copy entire top/bottom half of input value into D5 for shifing
    LSL.L   #8, D5 
    MOVE.L  D5, $A200
    BRA     CHECK_CHAR_VALIDITY_LOOP_PART2
    
INPUT_WAS_INVALID:
    MOVE.B  #$00, input_was_valid
    *JSR     DISP_ERROR_MSG     * Display outside of CHECK_INPUT subroutine call. Inside PROMPT.
    RTS     * Complementary to 'JSR  CHECK_INPUT_ADDRí
    
DISP_ERROR_MSG:
    * Display error error message and prompts user for input again.
    LEA     input_error_msg, A1
    MOVE.L  #13, D0
    TRAP    #15 
    
    LEA     new_line, A1
    MOVE.L  #13, D0
    TRAP    #15 
    
    RTS     * Complementary to ëJSR  DISP_ERROR_MSG
    
    
    
    
VERIFY_INPUT_ADDR_IS_EVEN:  
    
    MOVE.L  A1, addr_of_last_byte_of_input
    ADD.L   D1, addr_of_last_byte_of_input
    SUBI.L  #1, addr_of_last_byte_of_input
 
    MOVEA.L addr_of_last_byte_of_input, A2
    MOVE.B  (A2), byte_of_interest
    
    JSR     ONE_BYTE_ASCII_TO_HEX   * Convert the 1 byte from ascii to hex. Save it to byte_of_interest.
    
    CLR     D4
    MOVE.B  byte_of_interest, D4    
    DIVU.W  #2, D4                  * Divide by 2
    
    ANDI.L  #$11110000, D4          * Examine remainder
    CMPI.L  #0, D4                  * If remainder != 0, input was invalid.
    BNE     INPUT_WAS_INVALID
    

             
ONE_BYTE_ASCII_TO_HEX:
* converts the byte_of_interest from hex representation of ascii to hex.
    LEA     byte_of_interest, A2
    CMP.B   #$39, (A2)          * compare byte value at cur addr w/hex repres. of ASCII symbol '9'
    BGT     ONE_BYTE_CONVERT_LETTER
    SUB.B   #48,(A2)            * subtract 48 from hex repres. of ASCII number symbol to get symbol
    RTS

ONE_BYTE_CONVERT_LETTER:
    SUB.B   #55,(A2)            * subtract 55 from hex repres. of ASCII letter symbol to get symbol
    RTS          
                      
***************************************************************************************************   
* Process user input, converting ASCII to hex.
***************************************************************************************************
INPUT_TO_HEX_START_END_ADDR:


INPUT_TO_HEX_START_ADDR:         
   
    MOVE.L  #addr_of_starting_addr, addr_of_input_addr_of_interest   
             
INPUT_TO_HEX:
    MOVEA.L  #0,A0
    MOVEA.L  #8,A1              * iterate through each of the 8 bytes of input
    MOVEA.L  addr_of_input_addr_of_interest,A2    * current address of byte of interest
LOOP_INPUT_TO_HEX:
    CMP.L   A0,A1   
    BEQ     CONDENSE
    ADDA.L  #1,A0               * increment counter
    CMP.B   #$39, (A2)          * compare byte value at cur addr w/hex repres. of ASCII symbol '9'
    BGT     CONVERT_LETTER
    SUB.B   #48,(A2)+           * subtract 48 from hex repres. of ASCII number symbol to get symbol
    BRA     LOOP_INPUT_TO_HEX
                
CONVERT_LETTER:
    SUB.B   #55,(A2)+           * subtract 55 from hex repres. of ASCII letter symbol to get symbol
    BRA     LOOP_INPUT_TO_HEX
                
CONDENSE:
    MOVEA.L  #0,A0                      * initialize for loop increment counter
    MOVEA.L  #4,A1                      * iterate 4 times (over 4 pairs of bytes)
    MOVEA.L  addr_of_input_addr_of_interest,A2      * addr_of_input_addr_of_interest is the addr of
                                                    *       upper byte in leftmost pair of bytes

    MOVEA.L  addr_of_input_addr_of_interest,A3
    ADDA.L  #1,A3                       * addr_of_input_addr_of_interest + 1 is the address of the 
                                        *       lower byte in the leftmost pair of bytes.
        
    MOVEA.L  addr_of_input_addr_of_interest,A4        
    ADDA.L  #$10,A4                     * addr_of_input_addr_of_interest + 10_16 is the location at
                                        *       which we store the first condensed byte
        
CONDENSE_LOOP:
    MOVE.L  A1,D2
    CMP.L   A0,D2                       * Are we done yet?
    BEQ     INPUT_TO_HEX_END_ADDR
    MOVE.B  (A2),D1                     * copy data from upper byte to D1
    LSL.B   #4, D1                      * shift upper byte left by 4 bits              
                                        *       E.G.  upper byte: 1A ---> A0
                                        
    ANDI.B  #%00001111, (A3)            * mask top 4 bits of lower byte so that addition will not 
                                        *       change the upper hex digit (This only applies in 
                                        *       cases in which user did not enter the full 8 char.)
                                        
    ADD.B   (A3),D1                     * add lower byte to shifted upper byte         
                                        *       E.G.  lower byte: 02; sum: A2
                                        
    MOVE.B  D1, (A4)+                   * copy new condensed byte to new updated address
    ADDA.L  #$2,A2                      * increment upper byte address stored in A0 by 2 bytes
    ADDA.L  #$2,A3                      * increment lower byte address stored in A1 by 2 bytes
    ADDA.L  #1,A0                       * increment counter
    BRA     CONDENSE_LOOP
        
INPUT_TO_HEX_END_ADDR:
    MOVE.L  #addr_of_ending_addr, D1     
    CMP.L   addr_of_input_addr_of_interest, D1  * Is addr of input value already set to 
                                                *       addr_of_ending_addr? If so, end loc has 
                                                *       already been converted to hex.
    BEQ     SAVE_START_AND_END
       
    MOVE.L  D1,addr_of_input_addr_of_interest    
    BRA     INPUT_TO_HEX                        * Convert end loc from hex repres. of ASCII, to hex
        
SAVE_START_AND_END:
    MOVE.L  $0000A010, cur_addr    
    MOVE.L  $0000A018, end_addr  

INPUT_LENGTH_NORMALIZATION:
    * Make start and end addresses 4 bytes long.
       
    MOVEA.L #cur_addr, A2
    MOVEA.L #end_addr, A3
    MOVE.L  (A2), D1
    MOVE.L  (A3), D2
    MOVE.W  bytes_of_input_start_addr, D3
    MOVE.W  bytes_of_input_end_addr, D4
        
    MOVE.W  #8, D5 
    MOVE.W  #8, D6
    SUB.W   D3, D5                      * D5 now holds #of bytes of 0's to add to front of cur_addr
    SUB.W   D4, D6                      * D6 now holds #of bytes of 0's to add to front of end_addr
        
    MULU.W  #4, D5                      * bits input start addr omitted ==  (8 bits / 2) * bytes of
                                        *       input start addr omitted. 
                                        
    MULU.W  #4, D6                      * bits input end addr omitted ==  (8 bits / 2) * bytes of 
                                        *       input end addr omitted.
                                        *       Divide by 2 since each char of user input was saved
                                        *       as 1 whole byte but after conversion and condensa.,
                                        *       each char is represented by 1 hex digit.)
        
    LSR.L   D5, D1                      * logical shift rather than arithmetic shift. No sign extension.
    LSR.L   D6, D2                      * logical shift rather than arithmetic shift. No sign extension.
       
    MOVE.L  D1, cur_addr                * save length-normalized cur_addr.
    MOVE.L  D2, end_addr                * save length-normalized end_addr.
    
    
    RTS


CHECK_IF_START_ADDR_LT_END_ADDR:
    * Input error checking, part 2: Check that end_addr > cur_addr. Display error message if not.
    * Note: we perform this part of the error checking after condensing and calibration for ease of 
    * comparison, since start and end addresses are now both exactly 4 bytes long (before, they 
    * could have been anywhere from 1 to 8 bytes long) 
    MOVE.L  cur_addr, A2
    CMPA.L  end_addr, A2
    BLT     START_ADDR_IS_LT_END_ADDR
    
    JSR     DISP_ERROR_MSG
    
    JSR     PROMPT          * Reprompt for start and end addresses. This will
                            * redo all the other error checking and the to_hex and length normalization operations.
    
    BRA     CHECK_IF_START_ADDR_LT_END_ADDR
    
    * At this point, starting location is stored in cur_addr and ending loc is stored in end_addr         
    
START_ADDR_IS_LT_END_ADDR:
    RTS     
    
    *REMOVE???
*    MOVE.B  continue_or_not, D3
*    CMP.B   #$31, D3                * #$31  == '1' in ASCII. 
*    BEQ     DECODE_NEXT_SET_OF_INSTR
*    
*        
    
DISP_HEADING:
    LEA     new_line, A1
    MOVE.B  #13, D0
    TRAP    #15
    LEA     heading, A1             * displaying column headings
    MOVE.B  #13, D0
    TRAP    #15    
    RTS                            
    
***************************************************************************************************
* Set up line buffer.
***************************************************************************************************                

SET_UP_BUF:
    
    MOVE.L   #line_buffer, buf_start_addr   * save addr of line buffer into buf_start_addr variable
    MOVEA.L  buf_start_addr, A2             * move addr of line buffer start into A2.
    MOVE.L   buf_start_addr, buf_end_addr   * set buffer end address equal to start address.
    RTS
  
***************************************************************************************************
* Add to buffer the cur addr as a 32-bit (8-digit) hexadecimal number converted from hex to ascii.
***************************************************************************************************                
ADD_CUR_ADDR_TO_BUF:

    MOVE.L  #cur_addr, target_value_addr
    JSR     ADD_LONG_VALUE_TO_BUF      
                
    RTS    

***************************************************************************************************
* Add to buffer the opcode of current instruction. 
***************************************************************************************************  
ADD_OPCODE_TO_BUF:
* Examine contents of A4 (contains addr of opcode string to be added to buffer. Add this to buffer:
*    1. tab
*    2. opcode string

    MOVE.L  #tab, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  A4, target_str_addr     * A4 contains the address where the opcode string is located.
    JSR     ADD_TARG_STR_TO_BUF
    
    RTS
    
***************************************************************************************************
* Add to buffer the size of current instruction. 
***************************************************************************************************  
    
ADD_SIZE_TO_BUF:
* Examine the value of the size variable (contains either $01, $02, $04, or $FF corresponding to 
* byte, word, long, or none size, respectively)
* Add the appropriate size string (.B, .W, .L) to buffer.
    
    MOVE.B  size, D1
    CMP.B   #$01, D1
    BEQ     ADD_SIZE_B_TO_BUF
    CMP.B   #$02, D1
    BEQ     ADD_SIZE_W_TO_BUF
    CMP.B   #$04, D1
    BEQ     ADD_SIZE_L_TO_BUF
    
    BRA     DONE_ADD_OPCODE_TO_BUF  * If size is none of these ($01, $02, $04, no string will be
                                    *   added to buffer)
    
ADD_SIZE_B_TO_BUF:
    MOVE.L  #size_byte_str, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DONE_ADD_OPCODE_TO_BUF

ADD_SIZE_W_TO_BUF:
    MOVE.L  #size_word_str, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DONE_ADD_OPCODE_TO_BUF
    
ADD_SIZE_L_TO_BUF
    MOVE.L  #size_long_str, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DONE_ADD_OPCODE_TO_BUF
    
DONE_ADD_OPCODE_TO_BUF
    RTS
    
    
***************************************************************************************************
* Add to buffer operands 1 and 2 of current instruction, if they exist, in the appropriate format
* according to the type of each operand as stored in variables oper1type/oper2type. 
* Precondition: If current instruction does have 1 or 2 operands, the type and value of these 
* operands have been saved into the appropriate variables (oper1type, oper2type, oper1value, 
* oper2value). 

    * Operand type code table:
    * Operand type  Operand type code              String composition
    * ------------  -----------------              ------------------
    * Dn                  $0000 = #%000               'D' + reg#
    * An                  $0001 = #%001               'A' + reg#
    * (An)                $0002 = #%010               '(' + reg# + ')'
    * (An)+               $0003 = #%011               '(' + reg# + ')+'
    * -(An)               $0006 = #%110               '-(' + reg# + ')'
    * (xxx).W             $0007 = #%111 = 111 + 000   '$' + val 
    * (xxx).L             $0008 = #%1000 = 111 + 001  '$' + val 
    * #<data>             $000B = #%1011 = 111 + 100  '#' + val
    * no operand          $FFFF   
    * <reg list> A7-A0...D7-D0 
                         *$000D = 1101 = 111+110
    * <reg list> D0-D7...A0-A7 
                         *$000E = 1110 = 111+111                     
    
***************************************************************************************************  

ADD_OPERANDS_TO_BUF:

* Remove. Placeholder,for testing.****************************
    *TODO: Fill these in with real operand1 and real operand2.
    
    *MOVE.L  #some_operand1, target_str_addr
    *JSR     ADD_TARG_STR_TO_BUF
    
    *MOVE.L  #operand_separator, target_str_addr
    *JSR     ADD_TARG_STR_TO_BUF
    
    *MOVE.L  #some_operand2, target_str_addr
    *JSR     ADD_TARG_STR_TO_BUF
*************************************************************    
    
    MOVE.B  #$01, cur_operand       * cur_operand holds either 1 or 2, corresponding to the current operand.
   
ADD_OPERAND_1:
*TODO: COMPLETE THIS SUBROUTINE, UNCOMMENT.

    MOVE.W  oper1type, D1
    MOVE.W  oper1type, cur_oper_type
    MOVE.L  oper1val, D2
    MOVE.L  oper1val, cur_oper_val
    
    CMP.W   #$FFFF, D1             * If there is no operand 1, then there are no operands for this instruction. Exit subroutine.
    BEQ     DONE_ADDING_OPERANDS_TO_BUF
    
    MOVE.L  #tab, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    BRA     ADD_OPER_TYPE_AND_VAL
    
    
ADD_OPERAND_2:
*TODO: COMPLETE THIS SUBROUTINE.
    
    MOVE.W  oper2type, D1
    MOVE.W  oper2type, cur_oper_type
    MOVE.L  oper2val, D2
    MOVE.L  oper2val, cur_oper_val
    
    CMP.W   #$FFFF, D1             * If there is no operand 2, then we're done. Exit subroutine.
    BEQ     DONE_ADDING_OPERANDS_TO_BUF
    
    MOVE.L  #operand_separator, target_str_addr     * operand separator: ', '
    JSR     ADD_TARG_STR_TO_BUF
    
    BRA     ADD_OPER_TYPE_AND_VAL  
    
ADD_OPER_TYPE_AND_VAL:
    * Type is in D1.W, value is in D2.L
    
    MOVE.W  cur_oper_type, D1
    MOVE.L  cur_oper_val, D2


    CMP.W   #$0000, D1
    BEQ     ADD_OPERAND_DATA_REG_DIRECT
    
    CMP.W   #$0001, D1
    BEQ     ADD_OPERAND_ADDR_REG_DIRECT
    
    CMP.W   #$0002, D1
    BEQ     ADD_OPERAND_ADDR_REG_INDIRECT
    
    CMP.W   #$0003, D1
    BEQ     ADD_OPERAND_ADDR_REG_INDIR_POSTI
    
    CMP.W   #$0004, D1
    BEQ     ADD_OPERAND_ADDR_REG_INDIR_PREDE
    
    CMP.W   #$0007, D1
    BEQ     ADD_OPERAND_ABSOLUTE_SHORT_ADDR
   
    CMP.W   #$0008, D1
    BEQ     ADD_OPERAND_ABSOLUTE_LONG_ADDR
   
    CMP.W   #$000B, D1
    BEQ     ADD_OPERAND_IMMEDIATE_DATA
    
    CMP.W   #%1101, D1
    BEQ     ADD_OPERAND_REG_LIST_A7_TO_D0
    
    CMP.W   #%1110, D1
    BEQ     ADD_OPERAND_REG_LIST_D0_TO_A7
   
    * (This line should not be reached if decode and EA portions are correct)
    JSR     PROCESS_DATA
    
   
ADD_OPERAND_DATA_REG_DIRECT:
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #d, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  cur_oper_val, cur_reg_num
    JSR     ADD_REG_NUM     * Complementary to RTS's in ADD_REG_NUM_[x]
   
    BRA     CHECK_IF_DONE_ADDING_OPERANDS


ADD_OPERAND_ADDR_REG_DIRECT:
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #a, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  cur_oper_val, cur_reg_num
    JSR     ADD_REG_NUM     * Complementary to RTS's in ADD_REG_NUM_[x]
    BRA     CHECK_IF_DONE_ADDING_OPERANDS


ADD_OPERAND_ADDR_REG_INDIRECT:
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #left_paren, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  #a, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  cur_oper_val, cur_reg_num
    JSR          ADD_REG_NUM     * Complementary to RTS's in ADD_REG_NUM_[x]
    
    MOVE.L  #right_paren, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    BRA     CHECK_IF_DONE_ADDING_OPERANDS

    
ADD_OPERAND_ADDR_REG_INDIR_POSTI:
*TODO: COMPLETE THIS SUBROUTINE.
    MOVE.L  #left_paren, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  #a, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  cur_oper_val, cur_reg_num
    JSR     ADD_REG_NUM     * Complementary to RTS's in ADD_REG_NUM_[x]
    
    MOVE.L  #right_paren_incr, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    BRA     CHECK_IF_DONE_ADDING_OPERANDS

    
ADD_OPERAND_ADDR_REG_INDIR_PREDE:
*TODO: COMPLETE THIS SUBROUTINE.
    MOVE.L  #left_paren_decr, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  #a, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  cur_oper_val, cur_reg_num
    JSR     ADD_REG_NUM     * Complementary to RTS's in ADD_REG_NUM_[x]
    
    MOVE.L  #right_paren, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    BRA     CHECK_IF_DONE_ADDING_OPERANDS

    
ADD_OPERAND_ABSOLUTE_SHORT_ADDR:    *(word)
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #dollar_sign, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
*    *Try!!!!!
*    MOVE.L  cur_oper_val, A1
*    ADD.L   #2,A1
*    CLR.L   D3
*    MOVE.W  (A1),D3
*    
*    *original!!!
*    MOVE.L  cur_oper_val, D3
*    
*    MOVE.W  D3, target_value_addr

    *MOVE.L  cur_oper_val, D3
    *MOVE.W  D3, target_value_addr
    
    *MOVE.W  D3, $0000A300
    *MOVE.L  #$0000A300, target_value_addr
    
    MOVEA.L #cur_oper_val, A1
    ADDA.L  #2, A1
    MOVE.L  A1, target_value_addr

    JSR     ADD_WORD_VALUE_TO_BUF  
    
    BRA     CHECK_IF_DONE_ADDING_OPERANDS

    
ADD_OPERAND_ABSOLUTE_LONG_ADDR:
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #dollar_sign, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
        
*    *Try!!!!!
*    MOVE.L  cur_oper_val, A1
*    ADD.L   #2,A1
*    CLR.L   D3
*    MOVE.L  (A1),D3
    
    *original!!!
*    MOVE.L  cur_oper_val, D3
*    *MOVE.W  D3, target_value_addr
*    
*    MOVE.L  D3, $0000A300
*    MOVE.L  #$0000A300, target_value_addr
*
    MOVEA.L #cur_oper_val, A1
    MOVE.L  A1, target_value_addr
    *JSR     ADD_WORD_VALUE_TO_BUF
    JSR     ADD_LONG_VALUE_TO_BUF 
    
    BRA     CHECK_IF_DONE_ADDING_OPERANDS
   
    
ADD_OPERAND_IMMEDIATE_DATA:
*TODO: COMPLETE THIS SUBROUTINE.

    MOVE.L  #pound_sign, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  #dollar_sign, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.B  size, D3
    CMP.B   #$01, D3    * byte size -> converts to word size.
    BEQ     ADD_OPERAND_IMMEDIATE_DATA_WORD
    
    CMP.B   #$02, D3    * byte size -> converts to word size.
    BEQ     ADD_OPERAND_IMMEDIATE_DATA_WORD
    
    CMP.B   #$04, D3    * byte size -> converts to word size.
    BEQ     ADD_OPERAND_IMMEDIATE_DATA_LONG
    
    BRA     CHECK_IF_DONE_ADDING_OPERANDS
    

ADD_OPERAND_IMMEDIATE_DATA_WORD:
    MOVE.W  D2, $0000A300
    MOVE.L  #$0000A300, target_value_addr
    JSR     ADD_WORD_VALUE_TO_BUF      
    BRA     CHECK_IF_DONE_ADDING_OPERANDS

ADD_OPERAND_IMMEDIATE_DATA_LONG:
    MOVE.L  D2, $0000A300
    MOVE.L  #$0000A300, target_value_addr
    JSR     ADD_LONG_VALUE_TO_BUF      
    BRA     CHECK_IF_DONE_ADDING_OPERANDS
    
    
    
* Register list mask correspondence for A7 - D0
* A7 A6 A5 A4 A3 A2 A1 A0 D7 D6 D5 D4 D3 D2 D1 D0
* 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00    
ADD_OPERAND_REG_LIST_A7_TO_D0    
*TODO: COMPLETE THIS SUBROUTINE.
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #1,D5
    BCS     DISPLAY_A7_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A7_MOVEM_A7_TO_D0      
DISPLAY_A7_MOVEM_A7_TO_D0
    MOVE.L  #a7_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A6_MOVEM_A7_TO_D0
NOT_DISPLAY_A7_MOVEM_A7_TO_D0
    BRA     DECODE_A6_MOVEM_A7_TO_D0




*********A6********* 
DECODE_A6_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #2,D5
    BCS     DISPLAY_A6_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A6_MOVEM_A7_TO_D0
DISPLAY_A6_MOVEM_A7_TO_D0
    MOVE.L  #a6_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A5_MOVEM_A7_TO_D0   
NOT_DISPLAY_A6_MOVEM_A7_TO_D0
    BRA     DECODE_A5_MOVEM_A7_TO_D0
        
        

*********A5********* 
DECODE_A5_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #3,D5
    BCS     DISPLAY_A5_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A5_MOVEM_A7_TO_D0
DISPLAY_A5_MOVEM_A7_TO_D0
    MOVE.L  #a5_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A4_MOVEM_A7_TO_D0
NOT_DISPLAY_A5_MOVEM_A7_TO_D0
    BRA     DECODE_A4_MOVEM_A7_TO_D0
    

*********A4********* 
DECODE_A4_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #4,D5
    BCS     DISPLAY_A4_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A4_MOVEM_A7_TO_D0
DISPLAY_A4_MOVEM_A7_TO_D0
    MOVE.L  #a4_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A3_MOVEM_A7_TO_D0
NOT_DISPLAY_A4_MOVEM_A7_TO_D0
    BRA     DECODE_A3_MOVEM_A7_TO_D0
    
    
*********A3*********     
DECODE_A3_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #5,D5
    BCS     DISPLAY_A3_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A3_MOVEM_A7_TO_D0
DISPLAY_A3_MOVEM_A7_TO_D0
    MOVE.L  #a3_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A2_MOVEM_A7_TO_D0
NOT_DISPLAY_A3_MOVEM_A7_TO_D0
    BRA     DECODE_A2_MOVEM_A7_TO_D0


*********A2********* 
DECODE_A2_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #6,D5
    BCS     DISPLAY_A2_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A2_MOVEM_A7_TO_D0
DISPLAY_A2_MOVEM_A7_TO_D0
    MOVE.L  #a2_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A1_MOVEM_A7_TO_D0
NOT_DISPLAY_A2_MOVEM_A7_TO_D0
    BRA     DECODE_A1_MOVEM_A7_TO_D0  
    
    
*********A1*********     
DECODE_A1_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #7,D5
    BCS     DISPLAY_A1_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A1_MOVEM_A7_TO_D0
DISPLAY_A1_MOVEM_A7_TO_D0
    MOVE.L  #a1_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A0_MOVEM_A7_TO_D0
NOT_DISPLAY_A1_MOVEM_A7_TO_D0
    BRA     DECODE_A0_MOVEM_A7_TO_D0  
    
    
*********A0*********    
DECODE_A0_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    BCS     DISPLAY_A0_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_A0_MOVEM_A7_TO_D0
DISPLAY_A0_MOVEM_A7_TO_D0
    MOVE.L  #a0_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D7_MOVEM_A7_TO_D0
NOT_DISPLAY_A0_MOVEM_A7_TO_D0
    BRA     DECODE_D7_MOVEM_A7_TO_D0      


*********D7*********
DECODE_D7_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #1,D5
    BCS     DISPLAY_D7_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D7_MOVEM_A7_TO_D0
DISPLAY_D7_MOVEM_A7_TO_D0
    MOVE.L  #d7_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D6_MOVEM_A7_TO_D0
NOT_DISPLAY_D7_MOVEM_A7_TO_D0
    BRA     DECODE_D6_MOVEM_A7_TO_D0       
    

*********D6*********
DECODE_D6_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #2,D5
    BCS     DISPLAY_D6_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D6_MOVEM_A7_TO_D0
DISPLAY_D6_MOVEM_A7_TO_D0
    MOVE.L  #d6_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D5_MOVEM_A7_TO_D0
NOT_DISPLAY_D6_MOVEM_A7_TO_D0
    BRA     DECODE_D5_MOVEM_A7_TO_D0    
    
    
*********D5*********
DECODE_D5_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #3,D5
    BCS     DISPLAY_D5_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D5_MOVEM_A7_TO_D0
DISPLAY_D5_MOVEM_A7_TO_D0
    MOVE.L  #d5_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D4_MOVEM_A7_TO_D0
NOT_DISPLAY_D5_MOVEM_A7_TO_D0
    BRA     DECODE_D4_MOVEM_A7_TO_D0    


*********D4*********
DECODE_D4_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #4,D5
    BCS     DISPLAY_D4_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D4_MOVEM_A7_TO_D0
DISPLAY_D4_MOVEM_A7_TO_D0
    MOVE.L  #d4_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D3_MOVEM_A7_TO_D0
NOT_DISPLAY_D4_MOVEM_A7_TO_D0
    BRA     DECODE_D3_MOVEM_A7_TO_D0    



*********D3*********
DECODE_D3_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #5,D5
    BCS     DISPLAY_D3_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D3_MOVEM_A7_TO_D0
DISPLAY_D3_MOVEM_A7_TO_D0
    MOVE.L  #d3_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D2_MOVEM_A7_TO_D0
NOT_DISPLAY_D3_MOVEM_A7_TO_D0
    BRA     DECODE_D2_MOVEM_A7_TO_D0    



*********D2*********
DECODE_D2_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #6,D5
    BCS     DISPLAY_D2_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D2_MOVEM_A7_TO_D0
DISPLAY_D2_MOVEM_A7_TO_D0
    MOVE.L  #d2_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D1_MOVEM_A7_TO_D0
NOT_DISPLAY_D2_MOVEM_A7_TO_D0
    BRA     DECODE_D1_MOVEM_A7_TO_D0        
    


*********D1*********
DECODE_D1_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #7,D5
    BCS     DISPLAY_D1_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D1_MOVEM_A7_TO_D0
DISPLAY_D1_MOVEM_A7_TO_D0
    MOVE.L  #d1_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D0_MOVEM_A7_TO_D0
NOT_DISPLAY_D1_MOVEM_A7_TO_D0
    BRA     DECODE_D0_MOVEM_A7_TO_D0 


*********D0*********
DECODE_D0_MOVEM_A7_TO_D0
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #8,D5
    BCS     DISPLAY_D0_MOVEM_A7_TO_D0
    BCC     NOT_DISPLAY_D0_MOVEM_A7_TO_D0
DISPLAY_D0_MOVEM_A7_TO_D0
    MOVE.L  #d0_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    SUB.L   #1,buf_end_addr
    BRA     CHECK_IF_DONE_ADDING_OPERANDS
NOT_DISPLAY_D0_MOVEM_A7_TO_D0
    SUB.L   #1,buf_end_addr
    BRA     CHECK_IF_DONE_ADDING_OPERANDS


    
    
    
    
    
    
    
* Register list mask correspondence for D0 - A7
* D0 D1 D2 D3 D4 D5 D6 D7 A0 A1 A2 A3 A4 A5 A6 A7
* 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
ADD_OPERAND_REG_LIST_D0_TO_A7     
*TODO: COMPLETE THIS SUBROUTINE.
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #1,D5
    BCS     DISPLAY_D0_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D0_MOVEM_D0_TO_A7      
DISPLAY_D0_MOVEM_D0_TO_A7
    MOVE.L  #d0_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D1_MOVEM_D0_TO_A7
NOT_DISPLAY_D0_MOVEM_D0_TO_A7
    BRA     DECODE_D1_MOVEM_D0_TO_A7




*********D1********* 
DECODE_D1_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #2,D5
    BCS     DISPLAY_D1_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D1_MOVEM_D0_TO_A7
DISPLAY_D1_MOVEM_D0_TO_A7
    MOVE.L  #d1_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D2_MOVEM_D0_TO_A7   
NOT_DISPLAY_D1_MOVEM_D0_TO_A7
    BRA     DECODE_D2_MOVEM_D0_TO_A7
        
        

*********D2********* 
DECODE_D2_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #3,D5
    BCS     DISPLAY_D2_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D2_MOVEM_D0_TO_A7
DISPLAY_D2_MOVEM_D0_TO_A7
    MOVE.L  #d2_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D3_MOVEM_D0_TO_A7
NOT_DISPLAY_D2_MOVEM_D0_TO_A7
    BRA     DECODE_D3_MOVEM_D0_TO_A7
    

*********D3********* 
DECODE_D3_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #4,D5
    BCS     DISPLAY_D3_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D3_MOVEM_D0_TO_A7
DISPLAY_D3_MOVEM_D0_TO_A7
    MOVE.L  #d3_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D4_MOVEM_D0_TO_A7
NOT_DISPLAY_D3_MOVEM_D0_TO_A7
    BRA     DECODE_D4_MOVEM_D0_TO_A7
    
    
*********D4*********     
DECODE_D4_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #5,D5
    BCS     DISPLAY_D4_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D4_MOVEM_D0_TO_A7
DISPLAY_D4_MOVEM_D0_TO_A7
    MOVE.L  #d4_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D5_MOVEM_D0_TO_A7
NOT_DISPLAY_D4_MOVEM_D0_TO_A7
    BRA     DECODE_D5_MOVEM_D0_TO_A7


*********D5********* 
DECODE_D5_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #6,D5
    BCS     DISPLAY_D5_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D5_MOVEM_D0_TO_A7
DISPLAY_D5_MOVEM_D0_TO_A7
    MOVE.L  #d5_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D6_MOVEM_D0_TO_A7
NOT_DISPLAY_D5_MOVEM_D0_TO_A7
    BRA     DECODE_D6_MOVEM_D0_TO_A7  
    
    
*********D6*********     
DECODE_D6_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #7,D5
    BCS     DISPLAY_D6_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D6_MOVEM_D0_TO_A7
DISPLAY_D6_MOVEM_D0_TO_A7
    MOVE.L  #d6_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_D7_MOVEM_D0_TO_A7
NOT_DISPLAY_D6_MOVEM_D0_TO_A7
    BRA     DECODE_D7_MOVEM_D0_TO_A7  
    
    
*********D7*********    
DECODE_D7_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    BCS     DISPLAY_D7_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_D7_MOVEM_D0_TO_A7
DISPLAY_D7_MOVEM_D0_TO_A7
    MOVE.L  #d7_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A0_MOVEM_D0_TO_A7
NOT_DISPLAY_D7_MOVEM_D0_TO_A7
    BRA     DECODE_A0_MOVEM_D0_TO_A7      


*********A0*********
DECODE_A0_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #1,D5
    BCS     DISPLAY_A0_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A0_MOVEM_D0_TO_A7
DISPLAY_A0_MOVEM_D0_TO_A7
    MOVE.L  #a0_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A1_MOVEM_D0_TO_A7
NOT_DISPLAY_A0_MOVEM_D0_TO_A7
    BRA     DECODE_A1_MOVEM_D0_TO_A7       
    

*********A1*********
DECODE_A1_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #2,D5
    BCS     DISPLAY_A1_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A1_MOVEM_D0_TO_A7
DISPLAY_A1_MOVEM_D0_TO_A7
    MOVE.L  #a1_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A2_MOVEM_D0_TO_A7
NOT_DISPLAY_A1_MOVEM_D0_TO_A7
    BRA     DECODE_A2_MOVEM_D0_TO_A7    
    
    
*********A2*********
DECODE_A2_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #3,D5
    BCS     DISPLAY_A2_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A2_MOVEM_D0_TO_A7
DISPLAY_A2_MOVEM_D0_TO_A7
    MOVE.L  #a2_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A3_MOVEM_D0_TO_A7
NOT_DISPLAY_A2_MOVEM_D0_TO_A7
    BRA     DECODE_A3_MOVEM_D0_TO_A7    


*********A3*********
DECODE_A3_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #4,D5
    BCS     DISPLAY_A3_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A3_MOVEM_D0_TO_A7
DISPLAY_A3_MOVEM_D0_TO_A7
    MOVE.L  #a3_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A4_MOVEM_D0_TO_A7
NOT_DISPLAY_A3_MOVEM_D0_TO_A7
    BRA     DECODE_A4_MOVEM_D0_TO_A7    



*********A4*********
DECODE_A4_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #5,D5
    BCS     DISPLAY_A4_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A4_MOVEM_D0_TO_A7
DISPLAY_A4_MOVEM_D0_TO_A7
    MOVE.L  #a4_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A5_MOVEM_D0_TO_A7
NOT_DISPLAY_A4_MOVEM_D0_TO_A7
    BRA     DECODE_A5_MOVEM_D0_TO_A7    



*********A5*********
DECODE_A5_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #6,D5
    BCS     DISPLAY_A5_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A5_MOVEM_D0_TO_A7
DISPLAY_A5_MOVEM_D0_TO_A7
    MOVE.L  #a5_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A6_MOVEM_D0_TO_A7
NOT_DISPLAY_A5_MOVEM_D0_TO_A7
    BRA     DECODE_A6_MOVEM_D0_TO_A7        
    


*********A6*********
DECODE_A6_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #7,D5
    BCS     DISPLAY_A6_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A6_MOVEM_D0_TO_A7
DISPLAY_A6_MOVEM_D0_TO_A7
    MOVE.L  #a6_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    BRA     DECODE_A7_MOVEM_D0_TO_A7
NOT_DISPLAY_A6_MOVEM_D0_TO_A7
    BRA     DECODE_A7_MOVEM_D0_TO_A7 


*********A7*********
DECODE_A7_MOVEM_D0_TO_A7
    CLR.L   D5
    MOVE.L  cur_oper_val,D5
    LSL.W   #8,D5
    LSL.W   #8,D5
    BCS     DISPLAY_A7_MOVEM_D0_TO_A7
    BCC     NOT_DISPLAY_A7_MOVEM_D0_TO_A7
DISPLAY_A7_MOVEM_D0_TO_A7
    MOVE.L  #a7_slash, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    SUB.L   #1,buf_end_addr
    BRA     CHECK_IF_DONE_ADDING_OPERANDS
NOT_DISPLAY_A7_MOVEM_D0_TO_A7
    SUB.L   #1,buf_end_addr
    BRA     CHECK_IF_DONE_ADDING_OPERANDS

    
    

    

ADD_REG_NUM:
    MOVE.L  cur_reg_num, D2

    CMP.L   #$0000, D2
    BEQ     ADD_REG_NUM_0
    
    CMP.L   #$0001, D2
    BEQ     ADD_REG_NUM_1
    
    CMP.L   #$0002, D2
    BEQ     ADD_REG_NUM_2
    
    CMP.L   #$0003, D2
    BEQ     ADD_REG_NUM_3
    
    CMP.L   #$0004, D2
    BEQ     ADD_REG_NUM_4
    
    CMP.L   #$0005, D2
    BEQ     ADD_REG_NUM_5
    
    CMP.L   #$0006, D2
    BEQ     ADD_REG_NUM_6
    
    CMP.L   #$0007, D2
    BEQ     ADD_REG_NUM_7 
    

ADD_REG_NUM_0:
    MOVE.L  #reg_0, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_1:
    MOVE.L  #reg_1, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_2:
    MOVE.L  #reg_2, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_3:
    MOVE.L  #reg_3, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_4:
    MOVE.L  #reg_4, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
  
ADD_REG_NUM_5:
    MOVE.L  #reg_5, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_6:
    MOVE.L  #reg_6, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
ADD_REG_NUM_7:
    MOVE.L  #reg_7, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    RTS     * Complementary to 'JSR   ADD_REG_NUM'
    
CHECK_IF_DONE_ADDING_OPERANDS:
    ADDI.B  #$01, cur_operand       * cur_operand holds either 1 or 2, corresponding to the current operand.
    MOVE.B  cur_operand, D4
    CMPI.B  #$3, D4                 * if we just finished adding operand 2, we're done.
    BEQ     DONE_ADDING_OPERANDS_TO_BUF
    BRA     ADD_OPERAND_2

DONE_ADDING_OPERANDS_TO_BUF:
    * JSR     DISP_LINE_BUF_CONTENTS   * No longer call this here. Call it in Decode.X68
    RTS 
    
***************************************************************************************************
* Add long value located at target_value_addr to buffer.
* Precondition: target_value_addr is the address of the long value to be added to buffer.
***************************************************************************************************
ADD_LONG_VALUE_TO_BUF:

    MOVEA.L target_value_addr, A1           * Copy address of target value into A1        
    MOVE.L (A1), upper_byte_old             * Copy the long value pointed at by the address in 
                                            *   A1, into uppder_byte_old

EXPAND_NIB_TO_BYTES_LONG:

    * Process nibble 1
    MOVE.B upper_byte_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble1_new   
                
    * Process nibble 4
    MOVE.B lower_byte_old, nibble4_new 
    ANDI.B  #%00001111, nibble4_new  

    * Process nibble 2
    ANDI.B  #%00001111, upper_byte_old
    MOVE.B  upper_byte_old, nibble2_new     

    * Process nibble 3
    MOVE.B lower_byte_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble3_new
               
    * Process nibble 5
    MOVE.B upper_byte_2_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble5_new 
                
    * Process nibble 8
    MOVE.B lower_byte_2_old, nibble8_new
    ANDI.B  #%00001111, nibble8_new   

    * Process nibble 6
    ANDI.B  #%00001111, upper_byte_2_old
    MOVE.B  upper_byte_2_old, nibble6_new   

    * Process nibble 7
    MOVE.B lower_byte_2_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble7_new                   
                
HEX_TO_ASCII_LONG:
    MOVEA.L #nibble1_new, A5  * address of data nibble of interest
    MOVE.L  #0, D4
    MOVE.L  #8, D5

HEX_TO_ASCII_LOOP_LONG:
    CMP.L   D4, D5
    BEQ     ADD_ASCII_LONG
    ADDI.B  #1, D4
    CMPI.B  #09, (A5)                       
    BGT     HEX_LETTER_TO_ASCII_LONG
    ADDI.B  #$30, (A5)
    ADDA.W  #$0001, A5          * increment address of data nibble of interest
    
    BRA HEX_TO_ASCII_LOOP_LONG
                
HEX_LETTER_TO_ASCII_LONG:
    ADDI.B  #$37, (A5)
    ADDA.W  #$0001, A5          * increment address of data nibble of interest
    BRA HEX_TO_ASCII_LOOP_LONG
                
ADD_ASCII_LONG:              
               
    MOVE.B  #$00, (A5)                      * Add null char at the end of data to be added to buf
    MOVE.L  #nibble1_new, target_str_addr   * Set target str addr as the addr of the new nibble 1
    JSR     ADD_TARG_STR_TO_BUF             * Add the target string to buffer
       
    RTS
    

***************************************************************************************************
* Add "\tDATA\t[word value of (undecodable) data located at cur addr]" to line buffer.
***************************************************************************************************  
ADD_DATA_TO_BUF:

    * Set buffer end position to buffer start position  + 8 bytes (in case more content has been
    * added to buffer besides cur addr, before the program detected the instruction as data.) We
    * will overwrite any such additional content in the buffer.
    MOVE.L  buf_start_addr, buf_end_addr
    ADDI.L  #8, buf_end_addr  
    
    MOVE.L  #tab, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  #data, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  #tab, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF
    
    MOVE.L  #dollar_sign, target_str_addr
    JSR     ADD_TARG_STR_TO_BUF

    MOVE.L  cur_addr, target_value_addr           * save cur addr as target value addr 
    JSR     ADD_WORD_VALUE_TO_BUF
    
    RTS
         
***************************************************************************************************
* Add word value located at target_value_addr to buffer.
***************************************************************************************************
       
ADD_WORD_VALUE_TO_BUF:

    MOVEA.L target_value_addr, A1           * Copy address of target value into A1        
    MOVE.L (A1), upper_byte_old             * Copy the long value pointed at by the address in 
                                            *    A1, into uppder_byte_old

EXPAND_NIB_TO_BYTES_WORD:

    * Process nibble 1
    MOVE.B upper_byte_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble1_new   
                
    * Process nibble 4
    MOVE.B lower_byte_old, nibble4_new 
    ANDI.B  #%00001111, nibble4_new  

    * Process nibble 2
    ANDI.B  #%00001111, upper_byte_old
    MOVE.B  upper_byte_old, nibble2_new     

    * Process nibble 3
    MOVE.B lower_byte_old, D3
    LSR.B   #4, D3
    MOVE.B  D3, nibble3_new  
                
HEX_TO_ASCII_WORD:
    MOVEA.L #nibble1_new, A5  * address of data nibble of interest
    MOVE.L  #0, D4
    MOVE.L  #4, D5              * for the HEX_TO_ASCII_LONG subroutine, this is #8 instead of #4.

HEX_TO_ASCII_LOOP_WORD:
    CMP.L   D4, D5
    BEQ     ADD_ASCII_WORD
    ADDI.B  #1, D4
    CMPI.B  #09, (A5)                       
    BGT     HEX_LETTER_TO_ASCII_WORD
    ADDI.B  #$30, (A5)
    ADDA.W  #$0001, A5          * increment address of data nibble of interest
    
    BRA HEX_TO_ASCII_LOOP_WORD
                
HEX_LETTER_TO_ASCII_WORD:
    ADDI.B  #$37, (A5)
    ADDA.W  #$0001, A5          * increment address of data nibble of interest
    BRA HEX_TO_ASCII_LOOP_WORD
                
ADD_ASCII_WORD:              
               
    MOVE.B  #$00, (A5)                       * Add null char at the end of data to be added to buf
    MOVE.L  #nibble1_new, target_str_addr    * Set target str addr as the addr of the new nibble 1
    JSR     ADD_TARG_STR_TO_BUF              * Add the target string to buffer
       
    RTS


***************************************************************************************************
* Add the null-terminated string located at target_str_addr to line buffer. Increment buf_end_addr 
* accordingly. 
***************************************************************************************************  

ADD_TARG_STR_TO_BUF:

    MOVEA.L target_str_addr, A1
    MOVEA.L buf_end_addr, A2
    MOVE.B  #0, D0
    MOVE.B  max_string_length, D1
    
ADD_TARG_STR_TO_BUF_LOOP:    
    CMP.B   D0, D1
    BEQ     ADD_TARG_STR_TO_BUF_LOOP_END    * Stop adding chars to buffer once we've added the 
                                            *   max number of chars.
    MOVE.B  (A1), D4
    CMP.B   #$00, D4            * check if current character at target_str_addr is null char  
    
    BEQ     ADD_TARG_STR_TO_BUF_LOOP_END

    MOVE.B  (A1)+, (A2)         * add 1 char (1 byte) to end of line buffer. increment addr in A1
    ADDQ.L  #1, A2              * increment address of end of line buffer

    BRA     ADD_TARG_STR_TO_BUF_LOOP

ADD_TARG_STR_TO_BUF_LOOP_END:  
    MOVE.L  A2, buf_end_addr    * update buf_end_addr value
    RTS
  

***************************************************************************************************
* Display contents of line buffer (the null-terminated string saved in the line buffer variable).
***************************************************************************************************  
DISP_LINE_BUF_CONTENTS:

    MOVE.L  buf_end_addr, D1                * D1 will store the length of line buffer in bytes
    SUB.L   buf_start_addr, D1
    
    MOVEA.L buf_start_addr, A1             

    MOVE.B  #0, D0
    TRAP    #15
    
    RTS


***************************************************************************************************
* Display exit message.
***************************************************************************************************  
DISP_EXIT_MSG:
    LEA     new_line, A1
    MOVE.L  #13, D0
    TRAP    #15
    
    LEA     exit_msg, A1
    MOVE.L  #13, D0
    TRAP    #15
    
    RTS
    
    
    
    
    
****************************************************************************************************




* Hex   Ascii
* 30    0
* 31    1
* 32    2
* 33    3
* 34    4
* 35    5
* 36    6
* 37    7
* 38    8
* 39    9
* 41    A
* 42    B



****************************************************************************************************
** Display "DATA\t" and word value of (undecodable) data located at current address.
****************************************************************************************************  
*DISP_DATA:
*    LEA     data,A1
*    MOVE.B  #14,D0
*    TRAP    #15  
*               
*    MOVEA.L cur_addr, A3
*    MOVE.W (A3), D2
*    MOVE.W  D2, temp_addr_for_value_to_display
*                
****************************************************************************************************
** Display word value located at temp_addr_for_value_to_display.
****************************************************************************************************
*DISP_WORD_VALUE:
*                                            
*EXPAND_NIBBLES_TO_BYTES_WORD:
*
*    * Process nibble 1
*    MOVE.B upper_byte_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble1_new_addr   
*                
*    * Process nibble 4
*    MOVE.B lower_byte_old_addr, nibble4_new_addr   
*    ANDI.B  #%00001111, nibble4_new_addr   
*
*    * Process nibble 2
*    ANDI.B  #%00001111, upper_byte_old_addr
*    MOVE.B  upper_byte_old_addr, nibble2_new_addr      
*
*    * Process nibble 3
*    MOVE.B lower_byte_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble3_new_addr               
*                
*HEX_TO_ASCII_WORD:
*    MOVEA.L #nibble1_new_addr, A5  * address of nibble of interest
*    MOVE.L  #0, D4
*    MOVE.L  #4, D5
*
*HEX_TO_ASCII_LOOP_WORD:
*
*    CMP.L   D4, D5
*    BEQ     DISP_ASCII_WORD
*    ADDI.B  #1, D4
*    CMPI.B  #09, (A5)                       
*    BGT     HEX_LETTER_TO_ASCII_WORD
*    ADDI.B  #$30, (A5)
*    ADDA.W  #$0001, A5          * increment address of nibble of interest
*
*    BRA HEX_TO_ASCII_LOOP_WORD
*                
*HEX_LETTER_TO_ASCII_WORD:
*    ADDI.B  #$37, (A5)
*    ADDA.W  #$0001, A5          * increment address of nibble of interest
*    BRA HEX_TO_ASCII_LOOP_WORD
*                
*DISP_ASCII_WORD:              
*    * Add null character at the end of the value to be displayed
*    MOVE.B  #$00, (A5)
*              
*    LEA     nibble1_new_addr, A1
*    MOVE.B  #13, D0
*    TRAP    #15
*
*    RTS
*     
****************************************************************************************************
** Display current address as a 32-bit (8-digit) hexadecimal number.
****************************************************************************************************                
*DISP_CUR_ADDR:
*
*    MOVE.L  cur_addr, temp_addr_for_value_to_display
*    JSR     DISP_LONG_VALUE       
*                
*    RTS              
 
 


****************************************************************************************************
** Display long value located at temp_addr_for_value_to_display
****************************************************************************************************
*       
*DISP_LONG_VALUE:
*     
*EXPAND_NIB_TO_BYTES_LONG:
*
*    MOVE.B upper_byte_old_addr, D3
*
*    MOVE.L  #0, D4
*    MOVE.L  #2, D5
*
*EXPAND_NIB_TO_BYTES_LOOP_LONG:  
*
*    * Process nibble 1
*    MOVE.B upper_byte_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble1_new_addr   
*                
*    * Process nibble 4
*    MOVE.B lower_byte_old_addr, nibble4_new_addr   
*    ANDI.B  #%00001111, nibble4_new_addr   
*
*    * Process nibble 2
*    ANDI.B  #%00001111, upper_byte_old_addr
*    MOVE.B  upper_byte_old_addr, nibble2_new_addr      
*
*    * Process nibble 3
*    MOVE.B lower_byte_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble3_new_addr   
*               
*    * Process nibble 5
*    MOVE.B upper_byte_2_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble5_new_addr   
*                
*    * Process nibble 8
*    MOVE.B lower_byte_2_old_addr, nibble8_new_addr   
*    ANDI.B  #%00001111, nibble8_new_addr   
*
*    * Process nibble 6
*    ANDI.B  #%00001111, upper_byte_2_old_addr
*    MOVE.B  upper_byte_2_old_addr, nibble6_new_addr      
*
*    * Process nibble 7
*    MOVE.B lower_byte_2_old_addr, D3
*    LSR.B   #4, D3
*    MOVE.B  D3, nibble7_new_addr                   
*                
*HEX_TO_ASCII_LONG:
*    MOVEA.L #nibble1_new_addr, A5  * address of data nibble of interest
*    MOVE.L  #0, D4
*    MOVE.L  #8, D5
*
*HEX_TO_ASCII_LOOP_LONG:
*    CMP.L   D4, D5
*    BEQ     DISP_ASCII_LONG
*    ADDI.B  #1, D4
*    CMPI.B  #09, (A5)                       
*    BGT     HEX_LETTER_TO_ASCII_LONG
*    ADDI.B  #$30, (A5)
*    ADDA.W  #$0001, A5          * increment address of data nibble of interest
*    
*    BRA HEX_TO_ASCII_LOOP_LONG
*                
*HEX_LETTER_TO_ASCII_LONG:
*    ADDI.B  #$37, (A5)
*    ADDA.W  #$0001, A5          * increment address of data nibble of interest
*    BRA HEX_TO_ASCII_LOOP_LONG
*                
*DISP_ASCII_LONG:              
*                
*    * Add null character at the end of the data to be displayed
*    MOVE.B  #$00, (A5)
*          
*    LEA     nibble1_new_addr, A1
*    MOVE.B  #14, D0
*    TRAP    #15
*                
*    LEA     tab, A1
*    MOVE.B  #14, D0
*    TRAP    #15
*                
*    RTS



























*
*
*<<<<<<< HEAD
*
*
*
*=======
*>>>>>>> 98af3056b5a9ead88da29f739b8b04e06bbe3795

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
