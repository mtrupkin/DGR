****************************************
* Double Lo-Res Graphics
****************************************

                ORG $6000

PLOTX           EQU $FD                
PLOTY           EQU $FE
COLOR           EQU $FF 

TMP             EQU $E3
PTR             EQU $06
LOMEM           EQU $300

****************************************
* Routine Table
****************************************
                JMP EnableDGR
                JMP ClearDGR
                JMP PlotDGR
                JMP HLine
                JMP VLine
                JMP Test1
 
HLine           RTS 
VLine           RTS

Test1           LDA #$0F
                STA COLOR
:LOOP           JSR ClearDGR
                DEC COLOR
                BPL :LOOP
                RTS


****************************************
* Enable Double Lo-Res Mode
****************************************
EnableDGR       STA   $C050 ; GRAPHICS         
                STA   $C053 ; TEXT MIXED 
                STA   $C054 ; PAGE ONE         
                STA   $C056 ; LO-RES           
                STA   $C05E ; TURN ON DOUBLE RES     

* Copy text offsets to a low page memory

                LDX #0 ; LOAD TEXT OFFSETS 
:LOOP           LDA DATA1, X
                STA LOMEM, X
                LDA DATA1+1, X
                STA LOMEM+1, X
                INX
                INX
                CPX #40
                BNE :LOOP
    
                RTS

****************************************
* Plot
****************************************
PlotDGR         RTS
                
                LDA PLOTY
                LSR 
                TAX    
                LDA LOMEM, X
                STA $06
                LDA LOMEM+1, X
                STA $07

****************************************
* Clear Screen 
****************************************
ClearDGR        LDA #0
                STA $C054 ; MAIN MEM

                DupNibbleMem  COLOR
                CLR 

                LDA #0
                STA $C055 ; AUX MEM

                LDY COLOR
                LDA ColorTable, Y
                DupNibbleAcc                            
                CLR 
                RTS

****************************************
* Clear text memory page
****************************************
CLR             MAC
* X register contains current row 
                LDX #16
:ROW            DEX
                DEX            

                STA TMP ; SAVE ACC
                LDA LOMEM, X
                STA PTR
                LDA LOMEM+1, X
                STA PTR+1
                LDA TMP ; RESTORE ACC                

                LDY #120
* Skip last 4 text rows (mixed gr mode)
                CPX #8
                BMI :COL
                LDY #80

:COL            DEY
                STA (PTR), Y
                BNE :COL

                CPX #0
                BNE :ROW
                <<<

****************************************
* Clear Screen 2
****************************************
ClearDGR2       LDA #0
                STA $C054 ; MAIN MEM

                LDA COLOR
                DupNibbleMem  COLOR
                CLR2 

                LDA #0
                STA $C055 ; AUX MEM

                LDY COLOR
                LDA ColorTable, Y
                DupNibbleAcc                            
                CLR2 
                RTS

****************************************
* Clear text memory page
* X register contains current row
****************************************
CLR2            MAC
                LDX #20
:ROW            DEX
  
                PHA ; SAVE ACC
                LDA $300, X
                STA $06
                LDA $301, X
                STA $07
                PLA ; RESTORE ACC
            
                LDY #40

:COL            DEY
                STA ($06), Y
                BNE :COL
                CPX #0
                BNE :ROW
                <<<
****************************************
* Duplicate lo nibble to hi nibble
* accumulator 
****************************************
DupNibbleAcc    MAC 
                STA TMP
                ASL
                ASL
                ASL
                ASL
                ORA TMP
                <<<                

****************************************
* Duplicate lo nibble to hi nibble
* memory
****************************************
DupNibbleMem    MAC 
                LDA ]1
                ASL
                ASL
                ASL
                ASL
                ORA ]1
                <<<                                

DATA1           DA $0400, $0480, $0500, $0580, $0600
                DA $0680, $0700, $0780, $0428, $04A8 
                DA $0528, $05A8, $0628, $06A8, $0728 
                DA $07A8, $0450, $04D0, $0550, $05D0 
                DA $0650, $06D0, $0750, $07D0
            
ColorTable      DB 0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15
