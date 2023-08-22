
PIN_RSTN	EQU		P2.0
MR			EQU		0x00
GAR1		EQU		0x01
SUBR1		EQU		0x05
SHAR1		EQU		0x09
SIPR1		EQU		0x0F
RTR1		EQU		0x19
RCR1		EQU		0x1B

SUBR_ADRESS		EQU		0x0000
SHAR_ADRESS		EQU		0x0000
SIPR_ADRESS		EQU		0x0000
	
	
	
	
Wait_short:
	MOV		R0,			#100
	Wait_sh:
		DJNZ	R0,			Wait_sh
RET

Wait_long:
	MOV		R0,		#0
	MOV		R1,		#0
	
	Wait_ln:
		DJNZ	R0,		Wait_ln
		DJNZ	R1,		Wait_ln
RET


SPI0_R:
	MOV		SPI0DAT,	A

poll_SPIF_r:
	JNB		SPIF,		poll_SPIF_r		
	CLR		SPIF

	MOV		A,			SPI0DAT
	ACALL	Wait_short
RET

SPI0_W:
	MOV		SPI0DAT,	A

poll_SPIF_w:
	JNB		SPIF,		poll_SPIF_w	
	CLR		SPIF
RET



