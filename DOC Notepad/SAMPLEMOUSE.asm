TITLE SAMPLEMOUSE

INCLUDE IRVINE16.INC

.DATA
ESCKEY = 1Bh
GREETINGMSG BYTE "PRESS ESC TO QUITE", 0DH, 0AH, 0
STATUSLINE 	BYTE "LEFT BUTTON: "
			BYTE "MOUSE POSITION: ",0
BLANKS		BYTE "				   ",0
XCOORDINATE	WORD 0			;CURRENT X
YCOORDINATE	WORD 0			;CURRENT Y
XCLICK		WORD 0			;X-POS OF LAST BUTTON PRESS
YCLICK		WORD 0			;Y-POS OF LAST BUTTON PRESS

.CODE
MAIN PROC
			MOV				AX, @DATA
			MOV				DS, AX
			CALL			CLRSCR
			;HIDE THE TEXT CURSOR AND DISPLAY MOUSE.
			CALL			HIDECURSOR
			MOV				DX, OFFSET GREETINGMSG
			CALL			WRITESTRING
			CALL			SHOWMOUSEPOINTER
			
			;DISPLAY A STATUS LINE ON LINE 24.
			MOV				DH, 34
			MOV 			DL, 0
			CALL			GOTOXY
			MOV				DX, OFFSET STATUSLINE
			CALL			WRITESTRING
			
			;LOOP: SHOW MOUSE COORDINATE, CHECK FOR LEFT MOUSE
			;BUTTON CLICK, OR FOR A KEYPRESS(ESC KEY).
			
						MOV			DL, 46H
						MOV			DH, 02H
						CALL		GOTOXY
				MOV					AH, 09h
				MOV					AL, 'X'
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
			
			L1:
			; CALL			SETMOUSEPOSITION
			CALL			SHOWMOUSEPOSITION
			CALL			LEFTBUTTONCLICK		;CHECK FOR BUTTON CLICK
			MOV				AH, 11H				; KEY PRESSED ALREDY
			INT				16H
			
			JZ 				L2					; NO CONTINUE THE LOOP
			MOV				AH, 10H				; REMOVE KEY FROM BUFFER
			INT				16H
			CMP				AL, ESCKEY			;YES. IS IT THE ESC KEY PRESSED?
			JE				QUIT
			L2:
			JMP				L1
			
			;HIDE THE MOUSE, RESTORE THE NEXT CURSOR, CLEAR
			;THE SCREEN, AND DISPLAY "PRESS ANY KEY TO CONTINUE"
			
			QUIT:
			CALL			HIDEMOUSEPOINTER
			CALL			SHOWCURSOR
			CALL			CLRSCR
			CALL			WAITMSG
			EXIT
MAIN		ENDP

GETMOUSEPOSITION PROC
			
			PUSH			AX
			MOV				AX, 3		;(1 = RIGHT BUTTON DOWN, 2 = CENTER, 0= LEFT BUTTON)
			INT				33H				;CX = X-CORDINATE
			POP				AX				;DX = Y-CORDINATE
			RET
GETMOUSEPOSITION ENDP
HIDECURSOR	PROC
			
			MOV				AH, 3		;HIDE CURSOR
			INT				10H
			OR				CH, 30H		;SET UPPER ROW TO ILLEGAL VALUE
			MOV				AH, 1		; SET CURSOR SIZE
			INT				10H
			RET
HIDECURSOR	ENDP

SHOWCURSOR	PROC
			MOV				AH, 3		;GET CURSOR SIZE
			INT				10H
			MOV				AH, 1		;SET CURSOR SIZE
			MOV				CX, 0607H	;DEFULT SIZE
			INT				10H
			RET
SHOWCURSOR	ENDP

HIDEMOUSEPOINTER PROC
			PUSH			AX
			MOV				AX, 2
			INT				33H
			POP				AX
			RET
HIDEMOUSEPOINTER ENDP

SHOWMOUSEPOINTER PROC
			PUSH			AX
			MOV				AX, 1
			INT				33H
			POP				AX
			RET
SHOWMOUSEPOINTER ENDP

LEFTBUTTONCLICK PROC
			PUSHA
			MOV				AH, 0		;GET MOUSE STATUS
			MOV				AL, 5		;BUTTON PRESS INFORMATION
			MOV				BX, 0		;SPECIFY THE LEFT BUTTON
			INT				33H
			
			;EXIT PROC IF THE COORDINATE HAVE NOT CHANGED.
			CMP				CX, XCLICK
			JNE				LBC1
			CMP				DX, YCLICK
			JE				LBC_EXIT
			
			LBC1:
			; exit
			; SAVE THE MOUSE COORDINATES.
			MOV				XCLICK, CX
			MOV				YCLICK, DX
			
			; POSITION THE CURSOR, CLEAR THE OLD NUMBERS.
			MOV				DH, 24		;SCREEN ROW
			MOV				DL, 15		;SCREEN COLUMN
			CALL			GOTOXY
			; PUSH			DX
			; MOV				DX, OFFSET BLANKS
			; CALL			WRITESTRING
			; POP				DX
			
			; SHOW THE MOUSE CLICK COORDINATE
			CALL			GOTOXY
			MOV				AX, XCOORDINATE
			CALL			WRITEDEC
			MOV				DL, 20
			CALL			GOTOXY
			MOV				AX, YCOORDINATE
			CALL			WRITEDEC
			
			LBC_EXIT:
			POPA
			RET
LEFTBUTTONCLICK ENDP
SHOWMOUSEPOSITION PROC
			PUSHA
			CALL			GETMOUSEPOSITION
			CMP				CX, XCOORDINATE
			JNE				SMP1
			CMP				DX, YCOORDINATE
			JE				SMP_EXIT
			
			SMP1:
			MOV				XCOORDINATE, CX
			MOV				YCOORDINATE, DX
			
			MOV				DH, 24
			MOV				DL, 60
			CALL			GOTOXY
			; PUSH			DX
			; MOV				DX, OFFSET BLANKS
			; CALL			WRITESTRING
			; POP				DX
			
			CALL			GOTOXY
			MOV				AX, XCOORDINATE
			CALL			WRITEDEC
			MOV				DL, 65
			CALL			GOTOXY
			MOV				AX, YCOORDINATE
			CALL			WRITEDEC
			
			SMP_EXIT:
			POPA
RET
SHOWMOUSEPOSITION ENDP

SETMOUSEPOSITION PROC
			MOV				AX, 4
			INT				33H
			RET
SETMOUSEPOSITION ENDP

			END MAIN