*--------------------------------------------------------------------------------------
* Title      : Disassembler
* Written by : Hoi Yan Wu, Wai Kwan Shum, Zhiming Zhong
*              Includes code reused and modified from the following source:
*                 "Addendum, Some Additional Thoughts on the 68K Disassembler Project." 
*                 Canvas.uw.edu. N.p., n.d. Web. 23 Apr. 2017. 
*                 <https://canvas.uw.edu/courses/1158864/pages/addendum>.
* Date       : April 27, 2017
* Description: Disassembles machine code back to Assembly language code.
*              Team 0x3ace, CSS422B Spring 2017
*              Professor Yang Peng 
*--------------------------------------------------------------------------------------
   


***************************************************************************************
* Program starts here
***************************************************************************************

                ORG     $1000

MAIN            LEA     stack,SP            *Load the SP
                JSR     INTROIO
                
DECODE_NEXT_SET_OF_INSTR:
                JSR     PROMPT
                JSR     CHECK_IF_START_ADDR_LT_END_ADDR
                *JSR     CLEAR_THE_SCREEN
                JSR     DISP_HEADING
                JSR     DECODE_FIRST_INSTR
REACHED_END_ADDR:
                JSR     PROMPT_TO_CONTINUE
                
                CLR     D3
                MOVE.B  continue_or_not, D3
                CMP.L   #$0031, D3                * #$31  == '1' in ASCII
                BEQ     DECODE_NEXT_SET_OF_INSTR
                
                JSR     DISP_EXIT_MSG
                BRA     DONE


     
***************************************************************************************
* Includes
*************************************************************************************** 
    INCLUDE 'IO.X68'
    INCLUDE 'Decode.X68'
    INCLUDE 'EA_addi_subi.X68'
    INCLUDE 'EA_addq.X68'
    INCLUDE 'EA_bcc_bra.X68'
    INCLUDE 'EA_jsr.X68'
    INCLUDE 'EA_asr_asl_lsr_lsl_ror_rol.X68'
    INCLUDE 'EA_move.X68'
    INCLUDE 'EA_movea_lea_adda.X68'
    INCLUDE 'EA_movem.X68'
    INCLUDE 'EA_moveq.X68'
    INCLUDE 'EA_muls_divu_and_or_add_sub.X68'
    INCLUDE 'VariablesConstants.X68'
    

DONE            
               END   MAIN















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
