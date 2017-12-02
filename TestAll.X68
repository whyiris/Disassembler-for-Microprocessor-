*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $140
START:                  ; first instruction of program


*---------------------------------------------------------------------------------
* 0000 TEST CODE!
*------------------------------------------------
* Test for group of ADDI instructions
* ADDI.B #<data>,<ea>
* Range should be: -128<= #<data> <=127
    ADDI.B  #127,-(A0)
    ADDI.B  #-128,D0
    ADDI.B  #127,D0
    ADDI.B  #128,D0    *bug!!!! shouldn't work here
    ADDI.B  #255,D0    *bug!!!! shouldn't work here
*    ADDI.B  #256,D0    *not working
    ADDI.B  #127,(A0)
    ADDI.B  #127,(A0)+
    ADDI.B  #127,-(A0)
    ADDI.B  #127,$1000
    ADDI.B  #127,$8000
    
    
    DC.W	2949,0411,2848,7869


    ADDI.B  #1,D0       *bug!!!!
    ADDI.B  #8,D0       *bug!!!!
    ADDI.B  #9,D0

* ADDI.W #<data>,<ea>
* Range should be: -32768<= #<data> <=32767
    ADDI.W  #-32768,D0
    ADDI.W  #32767,D0
    DC.B    12
    ADDI.W  #32768,D0    *bug!!!!
    ADDI.W  #65535,D0    *bug!!!!
*    ADDI.W  #65536,D0    *not working!
    ADDI.W  #32767,(A0)
    ADDI.W  #32767,(A0)+

    DC.B    12

    ADDI.W  #32767,-(A0)
    ADDI.W  #32767,$1000

    DC.B    89
    ADDI.W  #32767,$8000
    ADDI.W  #9,D0




* ADDI.L #<data>,<ea>
* Range should be: -2147483648<= #<data> <=2147483647
    ADDI.L  #-2147483648,D0
    ADDI.L  #2147483647,D0
    ADDI.L  #2147483648,D0    *bug!!!!
    ADDI.L  #4294967295,D0    *bug!!!!
*    ADDI.L  #4294967296,D0    *not working!
    ADDI.L  #2147483647,(A0)
    
        DC.B    15
        DC.B    1 
        DC.B    90
    ADDI.L  #2147483647,(A0)+
    ADDI.L  #2147483647,-(A0)
    ADDI.L  #2147483647,$1000
    ADDI.L  #2147483647,$8000
    ADDI.L  #9,D0


*------------------------------------------------
* Test for group of SUBI instructions
* SUBI.B #<data>,<ea>
* Range should be: -128<= #<data> <=127
    SUBI.B  #-128,D0
    SUBI.B  #127,D0
    SUBI.B  #128,D0    *bug!!!! shouldn't work here
    SUBI.B  #255,D0    *bug!!!! shouldn't work here
*    SUBI.B  #256,D0    *not working
    SUBI.B  #127,(A0)
    SUBI.B  #127,(A0)+
    SUBI.B  #127,-(A0)
    
    DC.B    9
    DC.W    8732
    SUBI.B  #127,$1000
    SUBI.B  #127,$8000

    SUBI.B  #1,D0       *bug!!!!
    DC.W    10
    
    SUBI.B  #8,D0       *bug!!!!
    SUBI.B  #9,D0

* SUBI.W #<data>,<ea>
* Range should be: -32768<= #<data> <=32767
    SUBI.W  #-32768,D0
    SUBI.W  #32767,D0
    SUBI.W  #32768,D0    *bug!!!!
    SUBI.W  #65535,D0    *bug!!!!
*    SUBI.W  #65536,D0    *not working!
    SUBI.W  #32767,(A0)
    SUBI.W  #32767,(A0)+
    
    DC.L    9837
    DC.B    9
    SUBI.W  #32767,-(A0)
    SUBI.W  #32767,$1000
    SUBI.W  #32767,$8000
    SUBI.W  #9,D0


* SUBI.L #<data>,<ea>
* Range should be: -2147483648<= #<data> <=2147483647
    SUBI.L  #-2147483648,D0
    SUBI.L  #2147483647,D0
    SUBI.L  #2147483648,D0    *bug!!!!
    SUBI.L  #4294967295,D0    *bug!!!!
*    SUBI.L  #4294967296,D0    *not working!
    SUBI.L  #2147483647,(A0)
    SUBI.L  #2147483647,(A0)+
    SUBI.L  #2147483647,-(A0)
    SUBI.L  #2147483647,$1000
    SUBI.L  #2147483647,$8000
    SUBI.L  #9,D0


*---------------------------------------------------------------------------------
* 0001 TEST CODE!
*------------------------------------------------
* Test for group of MOVEM instructions
* MOVE.B <ea>,<ea>
    MOVE.B      D0,D1
*    MOVE.W      A0,D1
    MOVE.B      (A1),D1
    MOVE.B      (A1)+,D1
    MOVE.B      -(A1),D1
    MOVE.B      $1000,D1
    DC.B        12
    MOVE.B      $8000,D1
    MOVE.B      #7,D1
    DC.L        20
    

    MOVE.B      D0,(A0)
*    MOVE.B      A0,(A0)
    MOVE.B      (A1),(A0)
    MOVE.B      (A1)+,(A0)
    MOVE.B      -(A1),(A0)
    DC.L        89989320
    DC.B        9
        
    DC.L        24
    MOVE.B      $1000,(A0)
    MOVE.B      $8000,(A0)
    MOVE.B      #7,(A0)


    MOVE.B      D0,(A0)+
*    MOVE.B      A0,(A0)+
    MOVE.B      (A1),(A0)+
    MOVE.B      (A1)+,(A0)+
    DC.W        732
    MOVE.B      -(A1),(A0)+
    MOVE.B      $1000,(A0)+
    MOVE.B      $8000,(A0)+
    MOVE.B      #7,(A0)+
    DC.W        8222
    
    
    MOVE.B      D0,-(A0)
*    MOVE.B      A0,-(A0)
    MOVE.B      (A1),-(A0)
    MOVE.B      (A1)+,-(A0)
    MOVE.B      -(A1),-(A0)
    MOVE.B      $1000,-(A0)
    MOVE.B      $8000,-(A0)
    MOVE.B      #7,-(A0)


    MOVE.B      D0,$1000
*    MOVE.B      A0,$1000
    MOVE.B      (A1),$1000
    MOVE.B      (A1)+,$1000
    MOVE.B      -(A1),$1000
    MOVE.B      $1000,$1000
    MOVE.B      $8000,$1000
    MOVE.B      #7,$1000
    

    MOVE.B      D0,$8000
*    MOVE.B      A0,$8000
    MOVE.B      (A1),$8000
    MOVE.B      (A1)+,$8000
    MOVE.B      -(A1),$8000
    MOVE.B      $1000,$8000
    MOVE.B      $8000,$8000
    MOVE.B      #7,$8000


*---------------------------------------------------------------------------------
* 0010 TEST CODE!
*------------------------------------------------
* Test for group of MOVE instructions
* MOVE.L <ea>,<ea>
    MOVE.L      D0,D1
    MOVE.L      A0,D1
    MOVE.L      (A1),D1
    MOVE.L      (A1)+,D1
    MOVE.L      -(A1),D1
    MOVE.L      $1000,D1
    MOVE.L      $8000,D1
    MOVE.L      #7,D1

    MOVE.L      D0,(A0)
    MOVE.L      A0,(A0)
    MOVE.L      (A1),(A0)
    MOVE.L      (A1)+,(A0)
    MOVE.L      -(A1),(A0)
    MOVE.L      $1000,(A0)
    MOVE.L      $8000,(A0)
    MOVE.L      #7,(A0)

    MOVE.L      D0,(A0)+
    MOVE.L      A0,(A0)+
    MOVE.L      (A1),(A0)+
    MOVE.L      (A1)+,(A0)+
    MOVE.L      -(A1),(A0)+
    MOVE.L      $1000,(A0)+
    MOVE.L      $8000,(A0)+
    MOVE.L      #7,(A0)+

    MOVE.L      D0,-(A0)
    MOVE.L      A0,-(A0)
    MOVE.L      (A1),-(A0)
    MOVE.L      (A1)+,-(A0)
    MOVE.L      -(A1),-(A0)
    MOVE.L      $1000,-(A0)
    MOVE.L      $8000,-(A0)
    MOVE.L      #7,-(A0)
    
    MOVE.L      D0,$1000
    MOVE.L      A0,$1000
    MOVE.L      (A1),$1000
    MOVE.L      (A1)+,$1000
    MOVE.L      -(A1),$1000
    MOVE.L      $1000,$1000
    DC.B        36
    MOVE.L      $8000,$1000
    MOVE.L      #7,$1000
    
    MOVE.L      D0,$8000
    MOVE.L      A0,$8000
    MOVE.L      (A1),$8000
    MOVE.L      (A1)+,$8000
    MOVE.L      -(A1),$8000
    MOVE.L      $1000,$8000
    MOVE.L      $8000,$8000
    MOVE.L      #7,$8000


*------------------------------------------------
* Test for group of MOVEA instructions
* MOVEA.L <ea>,An
    MOVEA.L     D1,A1
    MOVEA.L     A0,A1
    MOVEA.L     (A0),A1
    MOVEA.L     (A0)+,A1
    MOVEA.L     -(A0),A1
    MOVEA.L     $1000,A1
    MOVEA.L     $8000,A1
    MOVEA.L     #7,A1


*---------------------------------------------------------------------------------
* 0011 TEST CODE!
*------------------------------------------------
* Test for group of MOVE instructions
* MOVE.W <ea>,<ea>
    MOVE.W      D0,D1
    MOVE.W      A0,D1
    MOVE.W      (A1),D1
    MOVE.W      (A1)+,D1
    MOVE.W      -(A1),D1
    MOVE.W      $1000,D1
    MOVE.W      $8000,D1
    MOVE.W      #7,D1

    MOVE.W      D0,(A0)
    MOVE.W      A0,(A0)
    MOVE.W      (A1),(A0)
    MOVE.W      (A1)+,(A0)
    MOVE.W      -(A1),(A0)
    MOVE.W      $1000,(A0)
    MOVE.W      $8000,(A0)
    MOVE.W      #7,(A0)

    MOVE.W      D0,(A0)+
    MOVE.W      A0,(A0)+
    MOVE.W      (A1),(A0)+
    MOVE.W      (A1)+,(A0)+
    MOVE.W      -(A1),(A0)+
    MOVE.W      $1000,(A0)+
    MOVE.W      $8000,(A0)+
    MOVE.W      #7,(A0)+
    
    MOVE.W      D0,-(A0)
    MOVE.W      A0,-(A0)
    MOVE.W      (A1),-(A0)
    MOVE.W      (A1)+,-(A0)
    MOVE.W      -(A1),-(A0)
    MOVE.W      $1000,-(A0)
    MOVE.W      $8000,-(A0)
    MOVE.W      #7,-(A0)

    MOVE.W      D0,$1000
    MOVE.W      A0,$1000
    MOVE.W      (A1),$1000
    MOVE.W      (A1)+,$1000
    MOVE.W      -(A1),$1000
    MOVE.W      $1000,$1000
    MOVE.W      $8000,$1000
    MOVE.W      #7,$1000
    
    MOVE.W      D0,$8000
    MOVE.W      A0,$8000
    MOVE.W      (A1),$8000
    MOVE.W      (A1)+,$8000
    MOVE.W      -(A1),$8000
    MOVE.W      $1000,$8000
    MOVE.W      $8000,$8000
    MOVE.W      #7,$8000


*------------------------------------------------
* Test for group of MOVEA instructions
* MOVEA.W <ea>,An
    MOVEA.W     D1,A1
    MOVEA.W     A0,A1
    MOVEA.W     (A0),A1
    MOVEA.W     (A0)+,A1
    MOVEA.W     -(A0),A1
    MOVEA.W     $1000,A1
    MOVEA.W     $8000,A1
    MOVEA.W     #7,A1


*---------------------------------------------------------------------------------
* 0100 TEST CODE!
*------------------------------------------------
* Test for group of MOVEM instructions
* MOVEM <list>,<ea>
        MOVEM.W D0,(A0)
        MOVEM.L D0,-(A0)

        MOVEM.W D0/D1/D2/D3/A0-A7,(A0)
        MOVEM.W D0-D3,(A0)
        MOVEM.W D0,$2000
        MOVEM.W D0,$A000
        MOVEM.L D0,(A0)
        MOVEM.L D0,-(A0)
        MOVEM.L D0/D1/D2/D3/A0-A7,-(A0)

        MOVEM.L D0-D3,(A0)
        MOVEM.L D0,$2000
        MOVEM.L D0,$A000
        MOVEM.L D0/A1/D2/A3/A0/A6,$2000
        MOVEM.L D0/D5/D4/D3/A0/A7,$A000

* MOVEM <ea>,<list> 
        MOVEM.W (A0),D0
        MOVEM.W (A0)+,D0

        MOVEM.W $2000,D0
        MOVEM.W $A000,D0

        MOVEM.L (A0),D0
        MOVEM.L (A0)+,D0
        MOVEM.L (A0)+,D0/A1-A3/D2-D4/A3/A0/A6
        MOVEM.L $2000,D0
        MOVEM.L $A000,D0
        MOVEM.L $2000,D0/A1-A3/D2-D4/A3/A0/A6
        MOVEM.L $A000,D0/A1/D2/A1-A4/A0/A6










*---------------------------------------------------------------------------------
* 0101 TEST CODE!
*------------------------------------------------
* Test for group of ADDQ instructions
* ADDQ.W #<data>,<ea>
    ADDQ.B  #1,D0
    ADDQ.B  #2,D0
    ADDQ.B  #3,D0
    ADDQ.B  #4,D0
    ADDQ.B  #5,D0
    ADDQ.B  #6,D0
    ADDQ.B  #7,D0
    ADDQ.B  #8,D0

*    ADDQ.B  #1,A1  *not working for Addr register
    ADDQ.B  #1,(A1)
    ADDQ.B  #1,(A1)+
    ADDQ.B  #1,-(A1)
    ADDQ.B  #1,$1000
    ADDQ.B  #1,$8000

    
    ADDQ.W  #1,D0
    ADDQ.W  #8,D0
    ADDQ.W  #1,A1
    ADDQ.W  #1,(A1)
    ADDQ.W  #1,(A1)+
    ADDQ.W  #1,-(A1)
    ADDQ.W  #1,$1000
    ADDQ.W  #1,$8000
    

    ADDQ.L  #1,D0
    ADDQ.L  #8,D0
    ADDQ.L  #1,A1
    ADDQ.L  #1,(A1)
    ADDQ.L  #1,(A1)+
    ADDQ.L  #1,-(A1)
    ADDQ.L  #1,$1000
    ADDQ.L  #1,$8000





*---------------------------------------------------------------------------------
* 0110 TEST CODE!
*------------------------------------------------
label1      EQU     $700
label2      EQU     $1000
label3      EQU     $2000
* Put program code here
    BCC     label
    BCC     label1
    BCC     label2
    BCC     label3
    BCS     label 
    BEQ     label
    BGE     label
    BGT     label
    BHI     label
    BLE     label
    BLS     label
    BLT     label
    BMI     label
    BNE     label
    BPL     label
    BVC     label
    BVS     label
    BRA     label

label    

*---------------------------------------------------------------------------------
* 0111 TEST CODE!
*------------------------------------------------
* Test for group of MOVEQ instructions
* MOVEQ
    MOVEQ   #1,D0
    MOVEQ   #1,D1
    MOVEQ   #1,D2
    MOVEQ   #1,D3
    MOVEQ   #1,D4
    MOVEQ   #1,D5
    MOVEQ   #2,D0
    MOVEQ   #8,D0
    MOVEQ   #-8,D0
    MOVEQ   #127,D0
    
    MOVEQ   #128,D0     *bug!!! should be out of range
    MOVEQ   #129,D0     *bug!!! should be out of range
    MOVEQ   #-128,D0
    MOVEQ   #-1,D0
    MOVEQ   #-2,D0
    MOVEQ   #-4,D0
    MOVEQ   #-16,D0
    MOVEQ   #-32,D0
    MOVEQ   #-64,D0
*    MOVEQ   #-129,D0    *error!!! out of range





*---------------------------------------------------------------------------------
* 1000 TEST CODE!
*------------------------------------------------
* Test for group of DIVU instructions
* DIVU.W
    MOVE.W  #32,D0
    MOVE.W  #2,D1
    DIVU.W  D1,D0

    MOVE.W  #2,D0
    DIVU.W  (A1),D0

    MOVE.W  #2,D0
    DIVU.W  (A1)+,D0

    MOVE.W  #2,D0
    DIVU.W  -(A1),D0

    MOVE.W  #2,D0
    DIVU.W  $1000,D0

    MOVE.W  #2,D0
    DIVU.W  $8000,D0

    MOVE.W  #2,D0
    DIVU.W  #10,D0


*------------------------------------------------
* Test for group of OR instructions
* OR.B <ea>,Dn
    CLR     D0
    CLR     D1
    MOVE.B  #%1011, D0
    MOVE.B  #%0100,D1
    
    OR.B    D0,D1
    OR.B    (A1),D0
    OR.B    (A1)+,D0
    OR.B    -(A1),D0
    OR.B    $1000,D0
    OR.B    $8000,D0
    OR.B    #127,D0
    OR.B    #128,D0     *bug
    OR.B    #-128,D0
    OR.B    #-1,D0
    OR.B    #255,D0     *bug
    

* OR.W <ea>,Dn
    OR.W    D0,D1
    OR.W    (A1),D0
    OR.W    (A1)+,D0
    OR.W    -(A1),D0
    OR.W    $1000,D0
    OR.W    $8000,D0
    OR.W    #$FFFF,D0
    OR.W    #$FF,D0
    OR.W    #$0,D0
    OR.W    #$8000,D0
    

* OR.L <ea>,Dn    
    OR.L    D0,D1
    OR.L    (A1),D0
    OR.L    (A1)+,D0
    OR.L    -(A1),D0
    OR.L    $1000,D0
    OR.L    $8000,D0
    OR.L    #$FFFFFFFF,D0
    OR.L    #$10000000,D0     *bug
    OR.L    #$0,D0
    OR.L    #$9000,D0
    
    
*------------------------------------------------
* Test for group of OR instructions
* OR Dn,<ea>

* OR.B Dn,<ea>
    OR.B    D3,(A1)
    OR.B    D3,(A1)+
    OR.B    D3,-(A1)
    OR.B    D3,$1000
    OR.B    D3,$8000
    
* OR.W Dn,<ea>
    OR.W    D3,(A1)
    OR.W    D3,(A1)+
    OR.W    D3,-(A1)
    OR.W    D3,$1000
    OR.W    D3,$8000

* OR.L Dn,<ea>    
    OR.L    D3,(A1)
    OR.L    D3,(A1)+
    OR.L    D3,-(A1)
    OR.L    D3,$1000
    OR.L    D3,$8000


*---------------------------------------------------------------------------------
* 1001 TEST CODE!
*------------------------------------------------
* Test for group of SUB instructions
* SUB.B <ea>,Dn
    SUB.B   D1,D0
*    SUB.B   A1,D0
    SUB.B   (A1),D0
    SUB.B   (A1)+,D0
    SUB.B   -(A1),D0
    SUB.B   $1000,D0
    SUB.B   $8000,D0
    SUB.B   #127,D0
    SUB.B   #-128,D0
    SUB.B   #255,D0     *bug!!
    SUB.B   #0,D0
    
* SUB.W <ea>,Dn
    SUB.W   D1,D0
    SUB.W   A1,D0
    SUB.W   (A1),D0
    SUB.W   (A1)+,D0
    SUB.W   -(A1),D0
    SUB.W   $1000,D0
    SUB.W   $8000,D0
    SUB.W   #$FFFF,D0
    SUB.W   #$0,D0
    SUB.W   #$10,D0     *bug!!
    SUB.W   #$80,D0

* SUB.L <ea>,Dn
    SUB.L   D1,D0
    SUB.L   A1,D0
    SUB.L   (A1),D0
    SUB.L   (A1)+,D0
    SUB.L   -(A1),D0
    SUB.L   $1000,D0
    SUB.L   $8000,D0
    SUB.L   #$FFFFFFFF,D0
    SUB.L   #$0,D0
    SUB.L   #$10,D0     *bug!!
    SUB.L   #$80,D0


*------------------------------------------------
* Test for group of SUB instructions
* SUB.B Dn,<ea>
    SUB.B   D0,(A1)
    SUB.B   D0,(A1)+
    SUB.B   D0,-(A1)
    SUB.B   D0,$1000
    SUB.B   D0,$8000
    

* SUB.W Dn,<ea>
    SUB.W   D0,(A1)
    SUB.W   D0,(A1)+
    SUB.W   D0,-(A1)
    SUB.W   D0,$1000
    SUB.W   D0,$8000
    

* SUB.L Dn,<ea>
    SUB.L   D0,(A1)
    SUB.L   D0,(A1)+
    SUB.L   D0,-(A1)
    SUB.L   D0,$1000
    SUB.L   D0,$8000
   



*---------------------------------------------------------------------------------
* 1100 TEST CODE!
*------------------------------------------------
* Test for group of MULS instructions
* MULS <ea>,Dn
    MULS.W  D1,D0
    MULS.W  (A1),D0
    MULS.W  (A1)+,D0
    MULS.W  -(A1),D0
    MULS.W  $1000,D0
    MULS.W  $8000,D0
    MULS.W  #$FFFF,D0
    MULS.W  #$0,D0


*------------------------------------------------
* Test for group of AND instructions
* AND <ea>,Dn

* AND.B <ea>,Dn
    AND.B   D0,D1
    AND.B   (A1),D1
    AND.B   (A1)+,D1
    AND.B   -(A1),D1
    AND.B   $1000,D1
    AND.B   $8000,D1
    AND.B   #$FF,D1
    AND.B   #$0,D1

* AND.W <ea>,Dn
    AND.W   D0,D1
    AND.W   (A1),D1
    AND.W   (A1)+,D1
    AND.W   -(A1),D1
    AND.W   $1000,D1
    AND.W   $8000,D1
    AND.W   #$FFFF,D1
    AND.W   #$0,D1
    AND.W   #$10,D1

* AND.L <ea>,Dn
    AND.L   D0,D1
    AND.L   (A1),D1
    AND.L   (A1)+,D1
    AND.L   -(A1),D1
    AND.L   $1000,D1
    AND.L   $8000,D1
    AND.L   #$FFFFFFFF,D1
    AND.L   #$10,D1
    AND.L   #$0,D1


* AND   Dn,<ea>
* AND.B Dn,<ea>
    AND.B   D1,(A1)
    AND.B   D1,(A1)+
    AND.B   D1,-(A1)
    AND.B   D1,$1000
    AND.B   D1,$8000


* AND.W Dn,<ea>
    AND.W   D1,(A1)
    AND.W   D1,(A1)+
    AND.W   D1,-(A1)
    AND.W   D1,$1000
    AND.W   D1,$8000


* AND.L Dn,<ea>
    AND.L   D1,(A1)
    AND.L   D1,(A1)+
    AND.L   D1,-(A1)
    AND.L   D1,$1000
    AND.L   D1,$8000



*---------------------------------------------------------------------------------
* 1101 TEST CODE!
*------------------------------------------------
* Test for group of ADD instructions
* ADD <ea>,Dn
* ADD.B <ea>,Dn
    ADD.B   D1,D0
*    ADD.B   A3,D0          *should be error!!!
    ADD.B   (A3),D0
    ADD.B   (A3)+,D0
    ADD.B   -(A3),D0
    ADD.B   $1000,D0
    ADD.B   $8000,D0
    ADD.B   #$FF,D0
    ADD.B   #$0,D0


* ADD.W <ea>,Dn
    ADD.W   D1,D0
    ADD.W   A3,D0
    ADD.W   (A3),D0
    ADD.W   (A3)+,D0
    ADD.W   -(A3),D0
    ADD.W   $1000,D0
    ADD.W   $8000,D0
    ADD.W   #$FF,D0
    ADD.W   #$0,D0
    ADD.W   #$FFFF,D0


* ADD.L <ea>,Dn
    ADD.L   D1,D0
    ADD.L   A3,D0
    ADD.L   (A3),D0
    ADD.L   (A3)+,D0
    ADD.L   -(A3),D0
    ADD.L   $1000,D0
    ADD.L   $8000,D0
    ADD.L   #$FF,D0
    ADD.L   #$0,D0
    ADD.L   #$FFFFFFFF,D0
    ADD.L   #$100,D0
    
    

* ADD Dn,<ea>
* ADD.B Dn,<ea>
    ADD.B   D0,(A3)
    ADD.B   D0,(A3)+
    ADD.B   D0,-(A3)
    ADD.B   D0,$1000
    ADD.B   D0,$8000     


* ADD.W Dn,<ea>
    ADD.W   D0,(A3)
    ADD.W   D0,(A3)+
    ADD.W   D0,-(A3)
    ADD.W   D0,$1000
    ADD.W   D0,$8000     

* ADD.L Dn,<ea>
    ADD.L   D0,(A3)
    ADD.L   D0,(A3)+
    ADD.L   D0,-(A3)
    ADD.L   D0,$1000
    ADD.L   D0,$8000     
    
*------------------------------------------------
* Test for group of ADDA instructions
* ADDA <ea>,An
* ADDA.W <ea>,An
    ADDA.W  D5,A3
    ADDA.W  A7,A3
    ADDA.W  (A7),A3
    ADDA.W  (A7)+,A3
    ADDA.W  -(A7),A3
    ADDA.W  $1000,A3
    ADDA.W  $8000,A3
    ADDA.W  #$10,A3
    ADDA.W  #$FFFF,A3
    ADDA.W  #$0,A3


* ADDA.L <ea>,An
    ADDA.L  D5,A3
    ADDA.L  A7,A3
    ADDA.L  (A7),A3
    ADDA.L  (A7)+,A3
    ADDA.L  -(A7),A3
    ADDA.L  $1000,A3
    ADDA.L  $8000,A3
    ADDA.L  #$10,A3
    ADDA.L  #$FFFFFFFF,A3
    ADDA.L  #$0,A3


*---------------------------------------------------------------------------------
* 1110 TEST CODE!
* ASL   Dn,Dn
* ASL   #<data>,Dn
* ASL.W <ea>  
    ASL.B   D0,D1
    ASL.B   D7,D1
    ASL.B   #8,D1
    ASL.B   #1,D1
*    ASL.B   $8000
*    ASL.B   $1000
*    ASL.B   (A1)
*    ASL.B   (A1)+
*    ASL.B   -(A1)
    

    ASL.W   D0,D1
    ASL.W   D7,D1
    ASL.W   #8,D1
    ASL.W   #1,D1
    ASL.W   $8000
    ASL.W   $1000
    ASL.W   (A1)
    ASL.W   (A1)+
    ASL.W   -(A1)

    ASL.L   D0,D1
    ASL.L   D7,D1
    ASL.L   #8,D1
    ASL.L   #1,D1
*    ASL.L   $8000
*    ASL.L   $1000
*    ASL.L   (A1)
*    ASL.L   (A1)+
*    ASL.L   -(A1)


*************************************
* ASR   Dn,Dn
* ASR   #<data>,Dn
* ASR.W <ea>
  
    ASR.B   D0,D1
    ASR.B   D7,D1
    ASR.B   #8,D1
    ASR.B   #1,D1
*    ASR.B   $8000
*    ASR.B   $1000
*    ASR.B   (A1)
*    ASR.B   (A1)+
*    ASR.B   -(A1)
    

    ASR.W   D0,D1
    ASR.W   D7,D1
    ASR.W   #$8,D1
    ASR.W   #1,D1
    ASR.W   $8000
    ASR.W   $1000
    ASR.W   (A1)
    ASR.W   (A1)+
    ASR.W   -(A1)
    
    ASR.L   D0,D1
    ASR.L   D7,D1
    ASR.L   #8,D1
    ASR.L   #1,D1
*    ASR.L   $8000
*    ASR.L   $1000
*    ASR.L   (A1)
*    ASR.L   (A1)+
*    ASR.L   -(A1)

*************************************
* LSL   Dn,Dn
* LSL   #<data>,Dn
* LSL.W <ea> 

    LSL.B   D0,D1
    LSL.B   D7,D1
    LSL.B   #8,D1
    LSL.B   #1,D1
*    LSL.B   $8000
*    LSL.B   $1000
*    LSL.B   (A1)
*    LSL.B   (A1)+
*    LSL.B   -(A1)
    

    LSL.W   D0,D1
    LSL.W   D7,D1
    LSL.W   #$8,D1
    LSL.W   #1,D1
    LSL.W   $8000
    LSL.W   $1000
    LSL.W   (A1)
    LSL.W   (A1)+
    LSL.W   -(A1)
    
    LSL.L   D0,D1
    LSL.L   D7,D1
    LSL.L   #8,D1
    LSL.L   #1,D1
*    LSL.L   $8000
*    LSL.L   $1000
*    LSL.L   (A1)
*    LSL.L   (A1)+
*    LSL.L   -(A1)



*************************************
* LSR   Dn,Dn
* LSR   #<data>,Dn
* LSR.W <ea> 
  
    LSR.B   D0,D1
    LSR.B   D7,D1
    LSR.B   #8,D1
    LSR.B   #1,D1
*    LSR.B   $8000
*    LSR.B   $1000
*    LSR.B   (A1)
*    LSR.B   (A1)+
*    LSR.B   -(A1)
    

    LSR.W   D0,D1
    LSR.W   D7,D1
    LSR.W   #$8,D1
    LSR.W   #1,D1
    LSR.W   $8000
    LSR.W   $1000
    LSR.W   (A1)
    LSR.W   (A1)+
    LSR.W   -(A1)
    
    LSR.L   D0,D1
    LSR.L   D7,D1
    LSR.L   #8,D1
    LSR.L   #1,D1
*    LSR.L   $8000
*    LSR.L   $1000
*    LSR.L   (A1)
*    LSR.L   (A1)+
*    LSR.L   -(A1)
    
     



*******************************
* ROL Dn,Dn
* ROL #<data>,Dn
* ROL.W <ea>
    ROL.B   D0,D1
    ROL.B   D7,D1
    ROL.B   #8,D1
    ROL.B   #1,D1
*    ROL.B   $8000
*    ROL.B   $1000
*    ROL.B   (A1)
*    ROL.B   (A1)+
*    ROL.B   -(A1)


    ROL.W   D0,D1
    ROL.W   D7,D1
    ROL.W   #8,D1
    ROL.W   #1,D1
    ROL.W   $8000
    ROL.W   $1000
    ROL.W   (A1)
    ROL.W   (A1)+
    ROL.W   -(A1)


    ROL.L   D0,D1
    ROL.L   D7,D1
    ROL.L   #8,D1
    ROL.L   #1,D1
*    ROL.L   $8000
*    ROL.L   $1000
*    ROL.L   (A1)
*    ROL.L   (A1)+
*    ROL.L   -(A1)


*******************************
* ROR Dn,Dn
* ROR #<data>,Dn
* ROR.W <ea>
    ROR.B   D0,D1
    ROR.B   D7,D1
    ROR.B   #8,D1
    ROR.B   #1,D1
*    ROR.B   $8000
*    ROR.B   $1000
*    ROR.B   (A1)
*    ROR.B   (A1)+
*    ROR.B   -(A1)


    ROR.W   D0,D1
    ROR.W   D7,D1
    ROR.W   #8,D1
    ROR.W   #1,D1
    ROR.W   $8000
    ROR.W   $1000
    ROR.W   (A1)
    ROR.W   (A1)+
    ROR.W   -(A1)

    ROR.L   D0,D1
    ROR.L   D7,D1
    ROR.L   #8,D1
    ROR.L   #1,D1
*    ROR.L   $8000
*    ROR.L   $1000
*    ROR.L   (A1)
*    ROR.L   (A1)+
*    ROR.L   -(A1)





*---------------------------------------------------------------------------------
* Codes that shouldn't work starts here!!

* ASL and ASR
    DC.W    $E0C3   * ASR D3
    DC.W    $E1C3   * ASL D3
    DC.W    $E0CB   * ASR A3
    DC.W    $E1CB   * ASL A3
*    DC.W    $E0FC   * ASR #1234
*    DC.W    $E1FC   * ASL #1234
* LSR and LSL
    DC.W    $E2C3   * LSR D3
    DC.W    $E3C3   * LSL D3
    DC.W    $E2CB   * LSR A3
    DC.W    $E3CB   * LSL A3
*    DC.W    $E2FC   * LSR #1234
*    DC.W    $E3FC   * LSL #1234

* ROR and ROL
    DC.W    $E6C3   * ROR D3
    DC.W    $E7C3   * ROL D3
    DC.W    $E6CB   * ROR A3
    DC.W    $E7CB   * ROL A3
*    DC.W    $E6FC   * ROR #1234
*    DC.W    $E7FC   * ROL #1234

* BCC
    DC.W    $6204   * BHI 00000100 (original: 0110 0010 0000 0100)
    DC.W    $62C0   * BHI 11000000, should be valid (original: 0110 0010 1100 0000)
    
* LEA
    DC.W    $49DB   * LEA (A3)+,A4
    DC.W    $4BE2   * LEA -(A2),A5
    DC.W    $4DC0   * LEA D0,A6

* AND
    DC.W    $C24B   * AND.W A3,D1
    DC.W    $C343   * AND.W D1,D3
    DC.W    $C34B   * AND.W D1,A3
    DC.W    $C37C   * AND.W D1,#1234

* OR
    DC.W    $820B   * OR.B A3,D1
    DC.W    $824B   * OR.W A3,D1
    DC.W    $828B   * OR.L A3,D1
    
    DC.W    $8303   * OR.B D1,D3
    DC.W    $830B   * OR.B D1,A3
    DC.W    $833C   * OR.B D1,#1   
    
* JSR
    DC.W    $4E82   * JSR D2
    DC.W    $4E8B   * JSR A3
    DC.W    $4E9A   * JSR (A2)+
    DC.W    $4EA2   * JSR -(A2)
    DC.W    $4EBB   * JSR #3
* SUB
    DC.W    $930B   * SUB.B A3,D1 (Byte is not allowed for An)
    DC.W    $920B   * SUB.B D1,A3
    DC.W    $923C   * SUB.B D1,#1234
    
* SUBI
    DC.W    $044B   *SUBI.W #1234,A3
    DC.W    $047C   *SUBI.W #1234,#5678
    
    
* MULS
    DC.W    $C5CB   * MULS.W A3,D2

* DIVU
    DC.W    $88CB   * DIVU.W A3,D4

* MOVE
    DC.W    $1642   * MOVE.B D2,A3
    DC.W    $1853   * MOVE.B (A3),A4
    DC.W    $1865   * MOVE.B -(A5),A4
    DC.W    $1878   * MOVE.B $1234,A4
    DC.W    $1C79   * MOVE.B $8000,A6
    
    DC.W    $120B   * MOVE.B A3,D1 (Byte is not allowed for An as source)
    DC.W    $124B   * MOVE.B A3,A1
    DC.W    $128B   * MOVE.B A3,(A1)
    DC.W    $12CB   * MOVE.B A3,(A1)+
    DC.W    $130B   * MOVE.B A3,-(A1)
    DC.W    $11CB   * MOVE.B A3,$1000
    DC.W    $13CB   * MOVE.B A3,$8000

* MOVEM
    DC.W    $4883   * MOVEM.W D0/D1,D3
    DC.W    $488B   * MOVEM.W D0/D1,A3
    DC.W    $489B   * MOVEM.W D0/D1,(A3)+
    
    DC.W    $4C83   * MOVEM.W D3,D0/D1
    DC.W    $4C8B   * MOVEM.W A3,D0/D1
    DC.W    $4CA3   * MOVEM.W -(A3),D0/D1

* ADD
    DC.W    $D60B   * ADD.B A3,D3
    DC.W    $D742   * ADD.W D3,D2
    DC.W    $D74A   * ADD.W D3,A2
    DC.W    $D77C   * ADD.W D3,#3

*ADDI
    DC.W    $064B   * ADDI.W #1234,A3
    DC.W    $067C   * ADDI.W #1234,#5678    

* ADDQ
    DC.W    $560B   * ADDQ.B #3,A3 (only W and L are allowed for An)
    DC.W    $567C   * ADDQ.W #3,#1234




    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
