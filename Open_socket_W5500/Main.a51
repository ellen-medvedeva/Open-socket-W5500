$include (c8051F120.inc)
	
PIN_RSTN	EQU		P2.0
MR			EQU		0x0000
GAR1		EQU		0x0001

SUBR_ADRESS		EQU		0x0000
SHAR_ADRESS		EQU		0x0000
SIPR_ADRESS		EQU		0x0000
	
CSEG AT 0

	CLR EA					; ��������� ��� ����������
	MOV WDTCN,		#0xDE	; ��������� ��������� ������
	MOV WDTCN,		#0xAD	; ��������� ���������� ������
	MOV SFRPAGE,	#0x0F	; ������� �������� "F" 
	MOV SFRPGCN,	#0x00	; ��������� �������������� ������������ ������� ("SFRPGCN" ���. "F")
	MOV OSCICN,		#0x83	; ���������� ��������� ���������, ������� 24,5 M�� (OSCICN" ���. "F")
;---------------------------------------------------------------------------------------------

;0. ����������� ��� ����.
	MOV		SFRPAGE,	#0x00		;���. "0".
	
	MOV		SPI0CKR,	#1 			
	MOV		SPI0CFG,	#01000000b	;�������� ������� �����.
	MOV		SPI0CN,		#00000001b	;�������� ������ SPI0.
	
	MOV		SFRPAGE,	#0x0F		;���. "F".
	MOV		P0MDOUT,	#00001101b	;��� 3 ��� �������� NSS.
	MOV		P0,			#11111111b

	MOV		P2MDOUT,	#00000001b	;��� RSTN, ���� ��������� �����.
	MOV		P2,			#11111111b

;0. ���������� ���� � �������.
	MOV		XBR0,		#00000010b
	MOV		XBR2,		#01000000b
	
	MOV		SFRPAGE,	#0x00			
	MOV		R1,			#0x10

;� ��� �������, ������� ���� �� �������� ����� ����� ����������� ����������.
	CLR		PIN_RSTN
	ACALL	Wait_long
	SETB	PIN_RSTN

	ACALL	Wait_long		;������ ����, ���� ���������� ��������.


Loop:
	INC		R1
;1. ��������� �������� �����-������ �������� � �����-������ �������, � ����� ������� ���.
	;CLR		NSSMD0
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W
;����� ����� ������� ����� ������� MR. �� ����� �������� 0x0000.
	CLR		A
	ACALL	SPI0_W
;������ �������� Control Phase. � ����� ������ 0x00 (�������� ���. 20), 1 (�.�. write), 00.
	MOV		A,		#00000100b
	ACALL	SPI0_W
;�� � ���� ������.
	MOV		A,		R1
	ACALL	SPI0_W
	
	;SETB	NSSMD0
	SETB	P0.3
	ACALL	Wait_short
	
	
;2. � ������ ���������, ��� ����������. �.�. ��������� �� �������� MR �����.
	;CLR		NSSMD0
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W
	CLR		A
	ACALL	SPI0_W
	
	MOV		A,		#00000000b
	ACALL	SPI0_W
	
	ACALL	SPI0_R
	
	;SETB	NSSMD0
	SETB	P0.3
	ACALL	Wait_short

SJMP	Loop


SPI0_W:
		MOV		SPI0DAT,	A

poll_SPIF_w:
	JNB		SPIF,		poll_SPIF_w	
	CLR		SPIF
RET


SPI0_R:
	MOV		SPI0DAT,	A

poll_SPIF_r:
	JNB		SPIF,		poll_SPIF_r		
	CLR		SPIF

	MOV		A,			SPI0DAT
	ACALL	Wait_short
RET


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


END
