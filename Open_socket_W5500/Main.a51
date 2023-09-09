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
;Дальше передаем Control Phase. В нашем случае 0x00 (согласно стр. 29), 1 (т.е. write), 00.
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
;-------------------------------------------------------------


;2. Делаем общие настройки 1 сокета и некоторые настройки других сокетов.
;2.1. Настраиваем регистр S1_MR.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_MR
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV		A,		#01000010b
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short

;2.2. Настраиваем регистр S1_PORT.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_PORT
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV		A,		#0x08
	ACALL	SPI0_W
	
	MOV		A,		#0x34
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short

;2.3. Настраиваем регистр S1_TTL.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TTL
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV		A,		#0x01
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;2.4. Настраиваем регистр S1_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV		A,		#0x04
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;2.5. Настраиваем регистр S1_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV		A,		#0x02
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
;----------------------------------------------------------------

;3. А теперь настроим размеры буферов для остальных сокетов.
;3.1.1. Настраиваем регистр S0_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#00001100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.1.2. Настраиваем регистр S0_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#00001100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short

;3.2.1. Настраиваем регистр S2_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#01010100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.2.2. Настраиваем регистр S2_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#01010100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
	
;3.3.1. Настраиваем регистр S3_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#01101100b
	ACALL	SPI0_W

	MOV		A,		#0x04
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.3.2. Настраиваем регистр S3_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#01101100b
	ACALL	SPI0_W

	MOV		A,		#0x08
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
	
;3.4.1. Настраиваем регистр S4_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#10001100b
	ACALL	SPI0_W

	MOV		A,		#0x02
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.4.2. Настраиваем регистр S4_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#10001100b
	ACALL	SPI0_W

	MOV		A,		#0x02
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
	
;3.5.1. Настраиваем регистр S5_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#10101100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.5.2. Настраиваем регистр S5_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#10101100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short

;3.6.1. Настраиваем регистр S6_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#11001100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.6.2. Настраиваем регистр S6_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#11001100b
	ACALL	SPI0_W

	MOV		A,		#0x00
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
	
;3.7.1. Настраиваем регистр S7_RXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#11101100b
	ACALL	SPI0_W

	MOV		A,		#0x02
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
;3.7.2. Настраиваем регистр S7_TXBUF_SIZE.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_TXBUF_SIZE
	ACALL	SPI0_W

	MOV		A,		#11101100b
	ACALL	SPI0_W

	MOV		A,		#0x04
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short
;-----------------------------------------	
		
;Сделаем первую небольшую проверку.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_SR
	ACALL	SPI0_W

	MOV		A,		#00101000b
	ACALL	SPI0_W
	
	CLR		A
	ACALL	SPI0_R
	
	SETB	P0.3
	ACALL	Wait_short
;Как видим, сокет пока закрыт.

;Откроем сокет 1.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_CR
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W
	
	MOV		A,		#0x01
	ACALL	SPI0_W
	
	SETB	P0.3
	ACALL	Wait_short
	
	

Poll_Open:
;Теперь в статусе мы дожны увидеть 0x22.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_SR
	ACALL	SPI0_W

	MOV		A,		#00101000b
	ACALL	SPI0_W
	
	CLR		A
	ACALL	SPI0_R
	
	SETB	P0.3
	ACALL	Wait_short	
	
	CJNE	A,		#0x22,		Poll_Open
	
	MOV		DPH,	#0x00
	MOV		DPL,	#0x06



;Дождемся, пока на сокете 1 произойдет прерывание.
Wait_for_an_interrupt:
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#SIR
	ACALL	SPI0_W

	MOV		A,		#00000000b
	ACALL	SPI0_W

	CLR		A
	ACALL	SPI0_R
		
	SETB	P0.3
	ACALL	Wait_short
	
	JNB 	ACC.1,	Wait_for_an_interrupt	;	Переход, если бит равен нулю.

;Обнуляем флажок.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#SIR
	ACALL	SPI0_W

	MOV		A,		#00000100b
	ACALL	SPI0_W

	MOV		A,		#00000000b
	ACALL	SPI0_W
		
	SETB	P0.3
	ACALL	Wait_short

;Проверяем, что флажок обнулился.
Flag_clearance_check:
	JB 		ACC.1,	Flag_clearance_check		;	Переход, если бит равен единице.

;Переходим в буфер RX сокета 1 и считываем сначала длину сообщения.
	CLR		P0.3
	ACALL	Wait_short
	
	MOV		A,		DPH
	ACALL	SPI0_W

	MOV		A,		DPL
	ACALL	SPI0_W


;Вот это важный шаг, только пока непонятно, куда его поставить.
	MOV 	A, 		DPL
	CLR 	C
	ADDC 	A, 		0x21
	MOV 	DPL,	 A

	MOV 	A, 		DPH
	ADDC 	A, 		0x20
	MOV 	DPH,	 A	
	
	
	
	MOV		A,		#00111000b
	ACALL	SPI0_W

	CLR		A
	ACALL	SPI0_R
	MOV		0x20,	A
	
	CLR		A
	ACALL	SPI0_R
	MOV		0x21,	A

	SETB	P0.3
	ACALL	Wait_short
	

;Пока с длиной ничего не случилось, меняем указатель чтения.
;Сначала читаем текущее значение.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RX_RD
	ACALL	SPI0_W

	MOV		A,		#00101000b
	ACALL	SPI0_W

	CLR		A
	ACALL	SPI0_R
	MOV		0x22,	A
	
	CLR		A
	ACALL	SPI0_R
	MOV		0x23,	A

	SETB	P0.3
	ACALL	Wait_short

;Складываем текущее значение регистра с длинной сообщения.
	MOV 	A, 		0x23
	CLR 	C
	ADDC 	A, 		0x21
	MOV 	0x23,	 A

	MOV 	A, 		0x22
	ADDC 	A, 		0x20
	MOV 	0x22,	 A

;Записываем получившееся число обратно в регистр.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_RX_RD
	ACALL	SPI0_W

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV 	A,	 0x22
	ACALL	SPI0_W
	
	MOV 	A,	 0x23
	ACALL	SPI0_W

	SETB	P0.3
	ACALL	Wait_short
	

;А теперь считываем сами данные.
	CLR		P0.3
	ACALL	Wait_short
	
	MOV		R3,		#2
Inc_len:
	MOV 	A, 		DPL
	CLR 	C
	ADDC 	A, 		#1
	MOV 	DPL,	 A

	MOV 	A, 		DPH
	SUBB 	A, 		#0
	MOV 	DPH,	 A
	DJNZ	R3,		Inc_len
	
	MOV		A,		DPH
	ACALL	SPI0_W
	
	MOV		A,		DPL
	ACALL	SPI0_W

	MOV		A,		#00111000b
	ACALL	SPI0_W

Data_reading:
	CLR		A
	ACALL	SPI0_R
	
	MOV		R3,		A
;Декремент длинны сообщения.
	MOV 	A, 		0x21
	CLR 	C
	SUBB 	A, 		#1
	MOV 	0x21,	 A

	MOV 	A, 		0x20
	SUBB 	A, 		#0
	MOV 	0x20,	A

;Сообщение закончилось?
	MOV		A,		0x20
	ORL		A,		0x21

	JNZ		Data_reading
	
	SETB	P0.3
	ACALL	Wait_short

;Даем команду, что прием данных закончен. Т.е. передадим в S1_CR команду RECV.
	CLR		P0.3
	ACALL	Wait_short
	
	CLR		A
	ACALL	SPI0_W

	MOV		A,		#S1_CR

	MOV		A,		#00101100b
	ACALL	SPI0_W

	MOV 	A,	 	#0x40
	ACALL	SPI0_W

	SETB	P0.3
	ACALL	Wait_short
	
	LJMP	Wait_for_an_interrupt
	
	
	
	SJMP	$
	
	
$include (My_library_for_W5500.inc)

END
