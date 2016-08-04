****************************************
* Double Lo-Res Graphics
****************************************
                ORG 	$6000

TEMP            EQU 	$E3 
COLOR           EQU 	$FF 

**************************************************
* Apple Standard Memory Locations
**************************************************
CLRLORES     	EQU 	$F832
LORES        	EQU 	$C050
TXTSET       	EQU 	$C051
MIXCLR       	EQU 	$C052
MIXSET       	EQU 	$C053
TXTPAGE1     	EQU 	$C054
TXTPAGE2     	EQU 	$C055
KEY          	EQU 	$C000
C80STOREOFF  	EQU 	$C000
C80STOREON   	EQU 	$C001
STROBE       	EQU 	$C010
SPEAKER      	EQU 	$C030
VBL          	EQU 	$C02E
RDVBLBAR     	EQU 	$C019       ;not VBL (VBL signal low	
RAMWRTAUX    	EQU 	$C005
RAMWRTMAIN   	EQU 	$C004
SETAN3       	EQU 	$C05E       ;Set annunciator-3 output to 0
SET80VID     	EQU 	$C00D 		;enable 80-column display mode (WR-only)

	
****************************************
* Routine Table
****************************************
                JMP 	EnableDGR
                JMP 	ClearDGR
                JMP 	PlotDGR
                JMP 	HLine
                JMP 	VLine
                JMP 	Test1
                JMP 	Test2
 
HLine           RTS 
VLine           RTS

Test1           LDA 	#$0F
                STA 	COLOR
                
:LOOP 			JSR 	VBlank
				JSR 	ClearDGR

				LDX 	#5 	
:PAUSE          JSR 	VBlank
				DEX	
	            BNE 	:PAUSE
                DEC 	COLOR
                BNE 	:LOOP
                RTS

Test2           JMP		Test1          

Test3           LDA 	#$05
                STA 	COLOR
                JSR 	VBlank
				JSR 	ClearDGR 
                RTS

****************************************
* Enable Double Lo-Res Mode
****************************************
EnableDGR       STA 	LORES 		; GRAPHICS         
				STA 	MIXSET 		; TEXT MIXED 
                STA 	SETAN3 		; TURN ON DOUBLE RES     
                STA 	SET80VID    ; ENABLE 80 COL DISPLAY 
                STA 	C80STOREON  ; enable aux/page1,2 mapping        

****************************************
* Plot
****************************************
PlotDGR         RTS
                
****************************************
* Clear Screen 
****************************************
ClearDGR        STA 	TXTPAGE1	; MAIN MEM
				DupNibbleMem COLOR
				ClearScreen                 
                LDY 	COLOR
                LDA 	ColorTable, Y
				STA 	TXTPAGE2	; AUX MEM
                DupNibbleAcc  
                ClearScreen 
                RTS

****************************************
* Clear text memory page
****************************************
ClearScreen     MAC
* X register contains current row 
                LDX 	#40 	
LOOP            DEX
                STA 	Lo01,x
                STA 	Lo02,x
                STA 	Lo03,x
                STA 	Lo04,x
                STA 	Lo05,x
                STA 	Lo06,x
                STA 	Lo07,x
                STA 	Lo08,x
                STA 	Lo09,x
                STA 	Lo10,x
                STA 	Lo11,x
                STA 	Lo12,x
                STA 	Lo13,x
                STA 	Lo14,x
                STA 	Lo15,x
                STA 	Lo16,x
                STA 	Lo17,x
                STA 	Lo18,x
                STA 	Lo19,x
                STA 	Lo20,x
                BNE 	LOOP
                <<<


****************************************
* Duplicate lo nibble to hi nibble
* accumulator 
****************************************
DupNibbleAcc    MAC 
                STA TEMP
                ASL
                ASL
                ASL
                ASL
                ORA TEMP
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

****************************************
* Wait for Vertical Blank 
****************************************
VBlank  		LDA 	#$7e
:vblActive      CMP 	RDVBLBAR 	; make sure we wait for the current one to stop
                BPL 	:vblActive 	; in case it got launched in rapid succession
:screenActive   CMP 	RDVBLBAR
                BMI 	:screenActive
                RTS                


**************************************************
* Lores/Text lines
**************************************************
Lo01            EQU 	$0400
Lo02            EQU 	$0480
Lo03            EQU 	$0500
Lo04            EQU 	$0580
Lo05            EQU 	$0600
Lo06            EQU 	$0680
Lo07            EQU 	$0700
Lo08            EQU 	$0780
Lo09            EQU 	$0428
Lo10            EQU 	$04A8
Lo11            EQU 	$0528
Lo12            EQU 	$05A8
Lo13            EQU 	$0628
Lo14            EQU 	$06A8
Lo15            EQU 	$0728
Lo16            EQU 	$07A8
Lo17            EQU 	$0450
Lo18            EQU 	$04D0
Lo19            EQU 	$0550
Lo20            EQU 	$05D0
* the "plus four" lines
Lo21            EQU 	$0650
Lo22            EQU 	$06D0
Lo23            EQU 	$0750
Lo24            EQU 	$07D0

LoLineTable     DA 		Lo01,Lo02,Lo03,Lo04,Lo05,Lo06
                DA 		Lo07,Lo08,Lo09,Lo10,Lo11,Lo12
                DA 		Lo13,Lo14,Lo15,Lo16,Lo17,Lo18
                DA 		Lo19,Lo20,Lo21,Lo22,Lo23,Lo24
            
ColorTable      DB 0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15


