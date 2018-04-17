TITLE window			(window.asm)
;Brijesh Patel
;Date Created:04/17/2012
;Date Last Modified: 04/17/2012
INCLUDE IRVINE16.INC
.MODEL			SMALL
.STACK			100H
WINSCR			STRUCT
				FOREGROUNDCOLOR		BYTE 0
				BACKGROUNDCOLOR		BYTE 0
				UPPERROW			BYTE 0
				LEFTCOL				BYTE 0
				LOWERROW			BYTE 0
				RIGHTCOL			BYTE 0
				BANNER				BYTE 40 DUP (0)
				ADDRESS1			BYTE 0
				ADDRESS2			BYTE 0
WINSCR			ENDS
; MOUSE			STRUCT
				; XCOORDINATE			WORD ?
				; YCOORDINATE			WORD ?
				; XCLICK				WORD ?
				; YCLICK				WORD ?
; MOUSE			ENDS

; EXIT			MACRO
				; MOV					AX, 4C00h
				; INT					21h
				; ENDM
DRAWLINEHORM	MACRO				A:REQ, B:REQ, NUM:REQ
				MOV					DL, A
				MOV					DH, B
				MOV					AH, 2
				INT					10h
				MOV					CX, NUM
				CALL				DRAWLINEHOR
				ENDM
				
DRAWLINEVERM	MACRO				A:REQ, B:REQ, NUM:REQ
				MOV					DL, A
				MOV					DH, B
				MOV					AH, 2
				INT					10h
				MOV					CX, NUM
				CALL				DRAWLINEVER
				ENDM
				
GETCURPOS		MACRO
				MOV					AH, 3
				MOV					BH, 0
				INT					10h
				ENDM
				
LEFTARROW		MACRO
				DEC					DL
				MOV					AH, 2
				INT					10h
				ENDM
				
ADVENCECUR		MACRO
				INC					DL
				MOV					AH, 2
				INT					10H
				ENDM
				
DOWNARROW		MACRO
				INC					DH
				MOV					AH, 2
				INT					10h
				ENDM
				
UPARROW 		MACRO
				DEC					DH
				MOV					AH, 2
				INT					10h
				ENDM
				
SETCURPOS		MACRO				A:REQ, B:REQ
				MOV					AH, 2
				MOV					DL, A
				MOV					DH, B
				MOV					BH, 0
				INT					10h
				ENDM
; ENDCORNER		MACRO				bCHAR:REQ
				; MOV					AX, bCHAR
				; PUSH				AX
				; GETCURPOS
				; CMP					DX, 4716h
				; JE					DONTMOVE
				; JNE					KEEPGOING3
				
				; DONTMOVE:
				; SETCURPOS			47h, 16h
				; CALL				PUTCHAR
				; JMP					FINISH3
				
				; KEEPGOING3:	
				; CALL				PUTCHAR
				; CURBOUNDRY
				
				; FINISH3:
				; ENDM
CURBOUNDRY		MACRO
				CMP					DL, 47h
				JE					NEXTLINE
				JNE					ALLDONE
				NEXTLINE:
				INC					DH
				MOV					DL, 02h
				ALLDONE:
				ENDM
PUTCHARM		MACRO				aCHAR:REQ
				MOV					AX, aCHAR
				PUSH				AX
				CALL				PUTCHAR
				GETCURPOS
				CURBOUNDRY
				ADVENCECUR
				ENDM
				
GETMOUSEPOS		MACRO
				MOV					AX, 3
				INT					33H
				ENDM
			
.DATA
APPLICATION		WINSCR				<11h,10h,02h,02h,17h,48h," BRIJESH PATEL ">
; MOUSEAPP		MOUSE				<0,0,0,0>
				XCOORDINATE			WORD 0
				YCOORDINATE			WORD 0
				XCLICK				WORD 0
				YCLICK				WORD 0
.CODE

HIDEMOUSEPOINTER PROC
				PUSH				AX
				MOV					AX, 2
				INT					33H
				POP					AX
				RET
HIDEMOUSEPOINTER ENDP
SHOWMOUSEPOINTER PROC
				PUSH				AX
				MOV					AX, 1
				INT					33H
				POP					AX
				RET
SHOWMOUSEPOINTER ENDP


CLRSCR			PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				
				MOV					AX, 0600h
				MOV					CX, 0
				MOV					DX, 184Fh
				MOV					BH, 7
				INT					10h
				MOV					AH, 2
				MOV					BH, 0
				MOV					DX, 0
				INT					10h
				
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					2
CLRSCR			ENDP
MAKEWIN			PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				PUSH				SI
				
				MOV					SI, [BP+4]
				MOV					AX, 0600h
				MOV					BH, (WINSCR PTR[SI]).BACKGROUNDCOLOR
				MOV					CH, (WINSCR PTR[SI]).UPPERROW
				MOV					CL, (WINSCR PTR[SI]).LEFTCOL
				MOV					DH, (WINSCR PTR[SI]).LOWERROW
				MOV					DL, (WINSCR PTR[SI]).RIGHTCOL
				INT					10h
				PUSH				CX
				CALL				CURPOS
				DRAWLINEHORM		02h, 02h, 47h				
				DRAWLINEHORM		02h, 17h, 47h
				DRAWLINEVERM		02h, 02h, 15h
				DRAWLINEVERM		48h, 02h, 15h
				CALL				BORDER
				
				ADD                 SI,6
				push				SI
				call printbanner
				
				SETCURPOS			03h, 03h
				POP					SI
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					2
MAKEWIN			ENDP
CURPOS			PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				
				MOV					AH, 02h
				MOV					BH, 0
				MOV					DX, [BP+4]
				INT					10h
				
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					2
CURPOS			ENDP
DRAWLINEVER		PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				DX
				
				VER:
				PUSH				CX
				MOV					AH, 9
				MOV					AL, 0B3h
				MOV					BH, 0
				MOV					BL, 017h
				MOV					CX, 1
				INT					10h
				
				INC					DH
				MOV					AH, 2
				INT					10h
				POP					CX
				LOOP 				VER
				
				POP					DX
				POP					AX
				POP					BP
				RET
DRAWLINEVER		ENDP
DRAWLINEHOR		PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				DX
				
				MOV					AH, 9
				MOV					AL, 0C4h
				MOV					BH, 0
				MOV					BL, 017h
				INT					10h
				
				POP					DX
				POP					AX
				POP					BP
				RET
DRAWLINEHOR		ENDP
BORDER			PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				
				
				SETCURPOS			02h, 02h
				MOV					AH, 09h
				MOV					AL, 0DAh
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			02h,17h
				MOV					AH, 09h
				MOV					AL, 0C0h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			48h,17h
				MOV					AH, 09h
				MOV					AL, 0D9h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			48h,02h
				MOV					AH, 09h
				MOV					AL, 0BFh
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			47h,02h
				MOV					AH, 09h
				MOV					AL, 0C3h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			46h,02h
				MOV					AH, 09h
				MOV					AL, 'X'
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			45h,02h
				MOV					AH, 09h
				MOV					AL, 0B4h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			03h,02h
				MOV					AH, 09h
				MOV					AL, 0B4h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				SETCURPOS			13h,02h
				MOV					AH, 09h
				MOV					AL, 0C3h
				MOV					BH, 0
				MOV					BL, 017H
				MOV					CX, 1
				INT					10h
				
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					
BORDER			ENDP
PRINTBANNER		PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				PUSH				SI
				
				SETCURPOS			04h,02h
				
				mov					si, 0
				mov					si, [bp+4]
				TRYAGAIN:
				mov					al, [si]
				cmp					al, 0
				je					ALLWELL
				PUTCHARM			AX
				inc 				si
				mov 				ax, 0
				jmp 				TRYAGAIN
				ALLWELL:
				
				POP					SI
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					2
PRINTBANNER		ENDP
PUTCHAR			PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX

				MOV					AH, 09h
				MOV					AL, [BP+4]
				MOV					BH, 0
				MOV					BL, 017h
				MOV					CX, 1
				INT					10h
				
				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET					2
PUTCHAR			ENDP

; EXCEPTIONKEY	PROC
				; PUSH				BP
				; MOV					BP, SP
				; PUSH				AX
				; PUSH				BX
				; PUSH				CX
				; PUSH				DX
				
				; LEFT ARROW 4B
				; RIGHT ARROW 4D
				; UPARROW 48
				; DOWNARROW 50

				; POP					DX
				; POP					CX
				; POP					BX
				; POP					AX
				; POP					BP
				; RET
; EXCEPTIONKEY	ENDP
LEFTBUTTONCLICK	PROC
				PUSH				BP
				MOV					BP, SP
				
				; MOV					SI, [BP+4]
				MOV					AH, 0		;GET MOUSE STATUS
				MOV					AL, 5		;BUTTON PRESS INFORMATION
				MOV					BX, 0		;SPECIFY THE LEFT BUTTON
				INT					33H
				MOV					XCLICK, CX
				MOV					YCLICK, DX
				;EXIT PROC IF THE COORDINATE HAVE NOT CHANGED.
				CMP					CX,	XCLICK
				JNE					MOVE
				CMP					DX, YCLICK
				JE					FINISHMOUSE
				
				MOVE:
				MOV					XCLICK, CX
				MOV					YCLICK, DX
	
				FINISHMOUSE:
				
				; CMP					CX, 4602H
				; JE					MOUSELINE
				; JNE					DONTGO
				; MOUSELINE:
				; MOV					AX, 3
				; INT					33H
				; TEST				BX, 1
				; JNE					SKIP
				; JZ					KEEPMOVING
				; SKIP:
				; EXIT
			
			MOV				AX, XCOORDINATE
			CALL			WRITEDEC
			MOV				DL, 20
			CALL			GOTOXY
			MOV				AX, YCOORDINATE
			CALL			WRITEDEC
			
				
				
				KEEPMOVING:
				; DONTGO:
				
				
			
				POP					BP
				RET					
LEFTBUTTONCLICK	ENDP
MOUSEBOUNDRY	PROC
				
				MOV					AX, 8
				INT					33H
				MOV					CX, 02h	;Y-RANGE (100 TO 200)
				MOV					DX, 16h
				INT					33H
				
				MOV					AX, 7
				MOV					CX, 02h ;X-RANGE(100 TO 200)
				MOV					DX, 46h
				INT					33H
				RET
MOUSEBOUNDRY	ENDP
MAIN			PROC
				CALL				CLRSCR
				MOV					AX, @DATA
				MOV					DS, AX
				
				MOV					AX, OFFSET APPLICATION
				PUSH				AX
				CALL				MAKEWIN
				CALL				SHOWMOUSEPOINTER
				; MOV				SI, OFFSET MOUSEAPP
				; PUSH				SI
				L1:
			
				CALL				LEFTBUTTONCLICK		;CHECK FOR BUTTON CLICK
				MOV					AH, 11H				; KEY PRESSED ALREDY
				INT					16H
				
				JZ 					L2					; NO CONTINUE THE LOOP
				MOV					AH, 10H				; REMOVE KEY FROM BUFFER
				INT					16H
				PUTCHARM			AX
				CMP					AL, 18h			;YES. IS IT THE ESC KEY PRESSED?
				JE					QUIT
				GETMOUSEPOS
				CMP					DX, 4602H
				JE					QUIT
				L2:
				JMP					L1
				QUIT:
			
				; CALL				CLRSCR
				FINISH:
				EXIT
MAIN			ENDP
				END					MAIN
