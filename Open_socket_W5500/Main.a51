$include (c8051F120.inc)
	
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

;00. Я так понимаю, неплохо было бы сбросить перед всеми процедурами контроллер.
	CLR		PIN_RSTN
	ACALL	Wait_long
	SETB	PIN_RSTN

	ACALL	Wait_long		;Теперь ждем, пока напряжение появится.


;1. Будем настраивать Common Register Block.
;1.1. Настраиваем регистр MR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W
;Пусть нашей жертвой будет регистр MR. Он имеет смещение 0x0000.
	MOV		A,		#MR
	ACALL	SPI0_W
;Дальше передаем Control Phase. В нашем случае 0x00 (согласно стр. 20), 1 (т.е. write), 00.
	MOV		A,		#00000100b
	ACALL	SPI0_W
;Ну и сами данные.
	MOV		A,		#10000000b
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short

;1.2. Настраиваем регистр GAR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#GAR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0xC0
	ACALL	SPI0_W
	
	MOV		A,		#0xA8
	ACALL	SPI0_W
	
	MOV		A,		#0x14
	ACALL	SPI0_W
	
	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short


;1.3. Настраиваем регистр SUBR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#SUBR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0xFF
	ACALL	SPI0_W
	
	MOV		A,		#0xFF
	ACALL	SPI0_W
	
	MOV		A,		#0xFF
	ACALL	SPI0_W
	
	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short


;1.4. Настраиваем регистр SHAR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#SHAR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0x70
	ACALL	SPI0_W
	
	MOV		A,		#0xFF
	ACALL	SPI0_W
	
	MOV		A,		#0x76
	ACALL	SPI0_W
	
	MOV		A,		#0x1C
	ACALL	SPI0_W
	
	MOV		A,		#0xC0
	ACALL	SPI0_W
	
	MOV		A,		#0x67
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short


;1.5. Настраиваем регистр SIPR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#SIPR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0xC0
	ACALL	SPI0_W
	
	MOV		A,		#0xA8
	ACALL	SPI0_W
	
	MOV		A,		#0x14
	ACALL	SPI0_W
	
	MOV		A,		#0x01
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short


;1.6. Настраиваем регистр RTR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#RTR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0x07
	ACALL	SPI0_W
	
	MOV		A,		#0xD0
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short


;1.7. Настраиваем регистр RCR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#RCR1
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#0x0A
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short



;Прочитаем что-нибудь:
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W
	
	MOV		A,		#0x0B
	ACALL	SPI0_W

	MOV		A,		#00000000b
	ACALL	SPI0_W

	CLR		A
	ACALL	SPI0_R
	
	SETB	P0.3
	ACALL	Wait_short


$include (My_library_for_W5500.inc)

END
