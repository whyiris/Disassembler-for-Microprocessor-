*--------------------------------------------------------------------------------------------------
* Title      : VariablesConstants
* Written by : Wai Kwan Shum, Zhiming Zhong, Hoi Yan Wu
* Date       : May 2017
* Description: The variables and constants for Disassembler program.
*              Disassembler disassembles machine code back to Assembly language code.
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------------------


***************************************************************************************
* Miscellaneous variables and constants
***************************************************************************************


stack                           EQU     $A000
        
shift                           EQU     12                   * Shift 12 bits 

cur_addr                        DS.L    1
end_addr                        DS.L    1

addr_of_starting_addr           EQU    $A000      * location where starting address user input is stored.
addr_of_ending_addr             EQU    $A008      * location where ending address user input is stored.
addr_of_input_addr_of_interest  DS.L    1  * location where starting/ending address user input is stored.


***************************************************************************************
* I/O
***************************************************************************************  
CR              EQU     $0D
LF              EQU     $0A
new_line        DC.B    CR,LF,0
tab             DC.B    '   ',0
data            DC.B    'DATA',0

welcome_msg     DC.B    'Welcome to the 0x3ace Disassembler.',CR,LF
                DC.B    'This program will decode the machine code from the given',CR,LF
                DC.B    'starting location (inclusive) to ending location (exclusive).',CR,LF,0
                
exit_msg        DC.B    'Exiting 0x3ace Disassembler.',CR,LF,0

prompt_start    DC.B    'Please enter the starting location as a 32-bit hexadecimal number.',CR,LF
                DC.B    '* Input must consist of 1 to 8 hex digits, inclusive.',CR,LF
                DC.B    '* Valid characters: 0-9, A-F, a-f.',CR,LF
                DC.B    '* Address must be even.',CR,LF
                DC.B    '* Starting location must be before ending location.',0
                
prompt_end      DC.B    'Please enter the ending location as a 32-bit hexadecimal number.',CR,LF
                DC.B    '* Input must consist of 1 to 8 hex digits, inclusive.',CR,LF
                DC.B    '* Valid characters: 0-9, A-F, a-f.',CR,LF
                DC.B    '* Address must be even.',CR,LF
                DC.B    '* Starting location must be before ending location.',0
   
input_error_msg DC.B    'Error: Invalid input.',0
input_was_valid DS.B    1       * Used in error checking of user input values
addr_of_last_byte_of_input  DC.L    1   * Used in input error checking, even vs odd
byte_of_interest    DS.B    1
heading         DC.B    'Address    Opcode Operands/Data',CR,LF
                DC.B    '-------    ------ -------------',0
                
                
continue_prompt DC.B    'Would you like to decode starting at a new location? (0==no, 1==yes)',0
continue_or_not DS.L    1
disp_next_set_of_lines_msg  DC.B    '[Press enter to display next screen of output.]',0
num_of_cur_disp_decoded_lines  DS.W    1    * The number of lines of decoded Assembly code currently 
                                            * displayed in console window in the current set of 
                                            * instructions (ranges between 0 and 20, inclusive).
max_num_of_decoded_lines_to_disp    DS.W    1     *maximum num of decoded lines to display at one time.   
                

***************************************************************************************
* Opcodes for buffer
***************************************************************************************                
move_str		DC.B    'MOVE',0
movea_str		DC.B	'MOVEA',0
moveq_str		DC.B	'MOVEQ',0
lea_str			DC.B	'LEA',0
nop_str         DC.B    'NOP',0
rts_str         DC.B    'RTS',0
jsr_str         DC.B    'JSR',0
movem_str       DC.B    'MOVEM',0
addq_str        DC.B    'ADDQ',0
addi_str        DC.B    'ADDI',0
subi_str        DC.B    'SUBI',0
divu_str        DC.B    'DIVU',0
or_str          DC.B    'OR',0

bhi_str         DC.B    'BHI',0
bls_str         DC.B    'BLS',0
bcs_str         DC.B    'BCS',0
bne_str         DC.B    'BNE',0
beq_str         DC.B    'BEQ',0
bvc_str         DC.B    'BVC',0
bvs_str         DC.B    'BVS',0 
bpl_str         DC.B    'BPL',0
bmi_str         DC.B    'BMI',0
bgt_str         DC.B    'BGT',0
ble_str         DC.B    'BLE',0


bcc_str         DC.B    'BCC',0
blt_str         DC.B    'BLT',0
bge_str         DC.B    'BGE',0
bra_str         DC.B    'BRA',0
sub_str         DC.B    'SUB',0
and_str         DC.B    'AND',0
muls_str        DC.B    'MULS',0
add_str         DC.B    'ADD',0
adda_str        DC.B    'ADDA',0
asr_str         DC.B    'ASR',0
asl_str         DC.B    'ASL',0
lsr_str         DC.B    'LSR',0
lsl_str         DC.B    'LSL',0
ror_str         DC.B    'ROR',0
rol_str         DC.B    'ROL',0

size_word_str 	DC.B    '.W',0
size_long_str	DC.B    '.L',0
size_byte_str	DC.B	'.B',0
size_none_str   DC.B	'',0


temp_addr_for_value_to_display  EQU  $A100  * $A100 will hold the temp address for various 
                                            * values to be displayed. (e.g. current address, undecodable data)
upper_byte_old                  EQU  $A100
lower_byte_old                  EQU  $A101
nibble1_new                     EQU  $A110
nibble2_new                     EQU  $A111
nibble3_new                     EQU  $A112
nibble4_new                     EQU  $A113

upper_byte_2_old                EQU  $A102
lower_byte_2_old                EQU  $A103
nibble5_new                     EQU  $A114
nibble6_new                     EQU  $A115
nibble7_new                     EQU  $A116
nibble8_new                     EQU  $A117
                            
bytes_of_input_start_addr       DC.W    1   * To allow for calibration following the receipt of input
bytes_of_input_end_addr         DC.W    1   * To allow for calibration following the receipt of input

max_string_length               EQU $40     * max # of chars in a string to add to buffer. 0x40 == 64_10

target_str_addr                 DC.L    1           * Save the address of the target string to be added to buffer to this variable..
target_value_addr               DC.L    $00009F00   * Save the address of the target word/long value to be added to buffer to this variable..

line_buffer                     DS.B    255 * Line buffer for one line to be displayed as output. 
                                            *   Format: [Current address]  [opcode]  [operand(s) if any]

buf_start_addr                  DS.L    1   * Address of line buffer start position.
buf_end_addr                    DS.L    1   * Current address of end of line buffer. (This is where the next char should be appended.
  
* For display of operands
cur_operand         DC.B    1   
operand_separator   DC.B    ', ',0

d0_slash            DC.B    'D0/',0
d1_slash            DC.B    'D1/',0
d2_slash            DC.B    'D2/',0
d3_slash            DC.B    'D3/',0
d4_slash            DC.B    'D4/',0
d5_slash            DC.B    'D5/',0
d6_slash            DC.B    'D6/',0
d7_slash            DC.B    'D7/',0
  

a0_slash            DC.B    'A0/',0
a1_slash            DC.B    'A1/',0
a2_slash            DC.B    'A2/',0
a3_slash            DC.B    'A3/',0
a4_slash            DC.B    'A4/',0
a5_slash            DC.B    'A5/',0
a6_slash            DC.B    'A6/',0
a7_slash            DC.B    'A7/',0


d                   DC.B    'D',0 
a                   DC.B    'A',0
left_paren          DC.B    '(',0
right_paren         DC.B    ')',0
left_paren_decr     DC.B    '-(',0
right_paren_incr    DC.B    ')+',0
dollar_sign         DC.B    '$',0
pound_sign          DC.B    '#',0
reg_0               DC.B    '0',0
reg_1               DC.B    '1',0
reg_2               DC.B    '2',0
reg_3               DC.B    '3',0
reg_4               DC.B    '4',0
reg_5               DC.B    '5',0
reg_6               DC.B    '6',0
reg_7               DC.B    '7',0
* Remove. For testing.**********************************
some_operand1       DC.B    'operand 1',0
some_operand2       DC.B    'operand 2',0
********************************************************  

***************************************************************************************
* EA
***************************************************************************************  
size			DC.B	1   * Size of the operands of the current instruction being 
                            *   decoded. $01(.B), $02(.W), or $04(.L)
                            *   Set to $FF if no size.
cur_oper_type   DS.W    1   * Will be set to either the value of oper1type or oper2type                   
oper1type   	DS.W	1   * "Type code" of operand 1. (See operand type code table.)
oper2type   	DS.W   	1   * "Type code" of operand 2. (See operand type code table.)



    * Operand type code table:
    * Operand type  Operand type code
    * ------------  -----------------
    * Dn                  $0000 = #%000
    * An                  $0001 = #%001
    * (An)                $0002 = #%010
    * (An)+               $0003 = #%011
    * -(An)               $0006 = #%110
    * (xxx).W             $0007 = #%111 = 111 + 000
    * (xxx).L             $0008 = #%1000 = 111 + 001
    * #<data>             $000B = #%1011 = 111 + 100
    * no operand          $FFFF   

cur_oper_val    DS.L    1   * Will be set to either the value of oper1val or oper2val
oper1val 	    DS.L	1   * Value of operand 1.
                            * E.g. for data register 3,    oper1val = $00000003
                            * E.g. for address $00001234 , oper1val = $00001234
                            * Note: Set entire 4 bits. (include leading 0's)

oper2val  	    DS.L   	1   * Value of operand 2. (See comment for oper1val.)

cur_reg_num     DS.L    1   * For use in IO, displaying operands.


extension_bytes DS.W 1      * extension words associated with current instruction being
                            *   decoded, measured in bytes. 
                            *   This number is added to cur_addr at beginning of 
                            *   DECODE_NEXT_INSTR to get to the addr of next instruc.
                            *   E.g for instruc with operand 1 type (xxx).L and operand 2
                            *   type (xxx).W, extension_bytes = 4 + 2 = 6
                            
                            
                                                 
                            
                            
                            
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
