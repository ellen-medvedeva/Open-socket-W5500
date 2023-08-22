$include (c8051F120.inc)
	
PIN_RSTN	EQU		P2.0
MR			EQU		0x0000
GAR1		EQU		0x0001

SUBR_ADRESS		EQU		0x0000
SHAR_ADRESS		EQU		0x0000
SIPR_ADRESS		EQU		0x0000
	
CSEG AT 0

	CLR EA					; Запретить все прерывания
	MOV WDTCN,		#0xDE	; Отключить строковый таймер
	MOV WDTCN,		#0xAD	; Отключить сторожевой таймер
	MOV SFRPAGE,	#0x0F	; Выбрать страницу "F" 
	MOV SFRPGCN,	#0x00	; Запретить автоматическое переключение страниц ("SFRPGCN" стр. "F")
	MOV OSCICN,		#0x83	; Внутренний генератор включения, частота 24,5 MГц (OSCICN" стр. "F")
;---------------------------------------------------------------------------------------------

;0. Настраиваем все пины.
	MOV		SFRPAGE,	#0x00		;Стр. "0".
	
	MOV		SPI0CKR,	#1 			
	MOV		SPI0CFG,	#01000000b	;Включаем ведущий режим.
	MOV		SPI0CN,		#00000001b	;Включаем модуль SPI0.
	
	MOV		SFRPAGE,	#0x0F		;Стр. "F".
	MOV		P0MDOUT,	#00001101b	;Тут 3 пин является NSS.
	MOV		P0,			#11111111b

	MOV		P2MDOUT,	#00000001b	;Пин RSTN, пока непонятно зачем.
	MOV		P2,			#11111111b

;0. Подключаем пины к матрице.
	MOV		XBR0,		#00000010b
	MOV		XBR2,		#01000000b
	
	MOV		SFRPAGE,	#0x00			
	MOV		R1,			#0x10

;Я так понимаю, неплохо было бы сбросить перед всеми процедурами контроллер.
	CLR		PIN_RSTN
	ACALL	Wait_long
	SETB	PIN_RSTN

	ACALL	Wait_long		;Теперь ждем, пока напряжение появится.


Loop:
	INC		R1
;1. Попробуем записать какое-нибудь значение в какой-нибудь регистр, а потом считать его.
	;CLR		NSSMD0
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W
;Пусть нашей жертвой будет регистр MR. Он имеет смещение 0x0000.
	CLR		A
	ACALL	SPI0_W
;Дальше передаем Control Phase. В нашем случае 0x00 (согласно стр. 20), 1 (т.е. write), 00.
	MOV		A,		#00000100b
	ACALL	SPI0_W
;Ну и сами данные.
	MOV		A,		R1
	ACALL	SPI0_W
	
	;SETB	NSSMD0
	SETB	P0.3
	ACALL	Wait_short
	
	
;2. А теперь посмотрим, что получилось. Т.е. прочитаем из регистра MR число.
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
