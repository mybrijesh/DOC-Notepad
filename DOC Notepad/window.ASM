TITLE window			(window.asm)
;Brijesh Patel
;Date Created:04/17/2012
;Date Last Modified: 04/17/2012
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

EXIT			MACRO
				MOV					AX, 4C00h
				INT					21h
				ENDM
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
				
DECCORSORDL		MACRO
				DEC					DL
				MOV					AH, 2
				INT					10h
				ENDM
				
ADVENCECUR		MACRO
				INC					DL
				MOV					AH, 2
				INT					10H
				ENDM
				
INCCORSORDH		MACRO
				INC					DH
				MOV					AH, 2
				INT					10h
				ENDM
				
DECCORSORDH		MACRO
				DEC					DH
				MOV					AH, 2
				INT					10h
				ENDM
				
SETCURPOS		MACRO				A:REQ, B:REQ
				MOV					DL, A
				MOV					DH, B
				MOV					AH, 2
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
				
				ADVENCECUR
				ENDM
PUTCHARM		MACRO				aCHAR:REQ
				MOV					AX, aCHAR
				PUSH				AX
				CALL				PUTCHAR
				GETCURPOS
				CURBOUNDRY
				ADVENCECUR
				ENDM
			
.DATA
APPLICATION		WINSCR				<11h,10h,02h,02h,17h,48h," BRIJESH PATEL ">
.CODE
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

EXCEPTIONKEY	PROC
				PUSH				BP
				MOV					BP, SP
				PUSH				AX
				PUSH				BX
				PUSH				CX
				PUSH				DX
				
				;LEFT ARROW 4B
				;RIGHT ARROW 4D
				;UPARROW 48
				;DOWNARROW 50

				POP					DX
				POP					CX
				POP					BX
				POP					AX
				POP					BP
				RET
EXCEPTIONKEY	ENDP
MAIN			PROC
				CALL				CLRSCR
				MOV					AX, @DATA
				MOV					DS, AX
				
				MOV					AX, OFFSET APPLICATION
				PUSH				AX
				CALL				MAKEWIN

				
				AGAIN:
				MOV					AH, 10h
				INT					16h
				CMP					AL, 18h
				JE					FINISH
				; PUSH				AX
				; CALL				PUTCHAR
				PUTCHARM			AX
				; ENDCORNER			AX
				JNE					AGAIN
				
				CALL				CLRSCR
				FINISH:
				EXIT
MAIN			ENDP
				END					MAIN
