INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
inputStr BYTE 256 DUP(0)
upperStr BYTE 256 DUP(0)
inputLen DWORD ?

; Alphabet Morse Code
mA BYTE ".-",0
mB BYTE "-...",0
mC BYTE "-.-.",0
mD BYTE "-..",0
mE BYTE ".",0
mF BYTE "..-.",0
mG BYTE "--.",0
mH BYTE "....",0
mI BYTE "..",0
mJ BYTE ".---",0
mK BYTE "-.-",0
mL BYTE ".-..",0
mM BYTE "--",0
mN BYTE "-.",0
mO BYTE "---",0
mP BYTE ".--.",0
mQ BYTE "--.-",0
mR BYTE ".-.",0
mS BYTE "...",0
mT BYTE "-",0
mU BYTE "..-",0
mV BYTE "...-",0
mW BYTE ".--",0
mX BYTE "-..-",0
mY BYTE "-.--",0
mZ BYTE "--..",0

alphabetTable DWORD OFFSET mA, OFFSET mB, OFFSET mC, OFFSET mD, OFFSET mE
              DWORD OFFSET mF, OFFSET mG, OFFSET mH, OFFSET mI, OFFSET mJ
              DWORD OFFSET mK, OFFSET mL, OFFSET mM, OFFSET mN, OFFSET mO
              DWORD OFFSET mP, OFFSET mQ, OFFSET mR, OFFSET mS, OFFSET mT
              DWORD OFFSET mU, OFFSET mV, OFFSET mW, OFFSET mX, OFFSET mY
              DWORD OFFSET mZ

; Numerals Morse Code
m0 BYTE "-----",0
m1 BYTE ".----",0
m2 BYTE "..---",0
m3 BYTE "...--",0
m4 BYTE "....-",0
m5 BYTE ".....",0
m6 BYTE "-....",0
m7 BYTE "--...",0
m8 BYTE "---..",0
m9 BYTE "----.",0

numberTable DWORD OFFSET m0, OFFSET m1, OFFSET m2, OFFSET m3, OFFSET m4
            DWORD OFFSET m5, OFFSET m6, OFFSET m7, OFFSET m8, OFFSET m9

; Punctuation Morse Code
mPeriod BYTE ".-.-.-",0
mComma BYTE "--..--",0
mQuestion BYTE "..--..",0
mParentheses BYTE "-.--.-",0
mApostrophe BYTE ".----.",0
mSemicolon BYTE "-.-.-.",0
mColon BYTE "---...",0
mQuote BYTE ".-..-.",0
mHyphen BYTE "-....-",0
mSlash BYTE "-..-.",0
mDollar BYTE "...-..-",0

mSpace BYTE "/ ",0
mError BYTE "@ ",0
oneSpace BYTE " ",0

.code
main PROC

AgainLoop:

    mWrite "This is a Morse Code Translator!"
    call Crlf

    mWrite "Please enter your string:"
    call Crlf

    mov edx, OFFSET inputStr
    mov ecx, SIZEOF inputStr
    call ReadString
    mov inputLen, eax

    mov eax, OFFSET inputStr
    mov ecx, inputLen
    mov edx, OFFSET upperStr
    call lowertoCap

    mWrite "Morse Code:"
    call Crlf

    mov eax, OFFSET upperStr
    mov ecx, inputLen
    call MorseTran

    call Crlf
    call Crlf

    mWrite "Would you like to proceed another translation (y/n)? "
    call ReadChar
    call WriteChar
    call Crlf

    cmp al, 'y'
    je AgainLoop

    cmp al, 'Y'
    je AgainLoop

    exit

main ENDP

; lowertoCap
; EAX = input string OFFSET
; ECX = input string length
; EDX = output string OFFSET
lowertoCap PROC USES esi edi eax ecx

    mov esi, eax
    mov edi, edx

LowerLoop:
    cmp ecx, 0
    je LowerDone

    mov al, [esi]

    cmp al, 'a'
    jb StoreChar

    cmp al, 'z'
    ja StoreChar

    sub al, 32

StoreChar:
    mov [edi], al

    inc esi
    inc edi
    dec ecx
    jmp LowerLoop

LowerDone:
    mov BYTE PTR [edi], 0
    ret

lowertoCap ENDP

; MorseTran
; EAX = input string OFFSET
; ECX = input string length
MorseTran PROC USES esi ecx eax

    mov esi, eax

MorseLoop:
    cmp ecx, 0
    je MorseDone

    mov al, [esi]

    push ecx
    call PrintMorse
    pop ecx

    inc esi
    dec ecx
    jmp MorseLoop

MorseDone:
    ret

MorseTran ENDP

; PrintMorse
; AL = character
PrintMorse PROC USES eax ebx edx

    cmp al, ' '
    je PrintSpace

    cmp al, 'A'
    jb CheckNumber

    cmp al, 'Z'
    ja CheckNumber

    movzx ebx, al
    sub ebx, 'A'
    shl ebx, 2
    mov edx, alphabetTable[ebx]
    call PrintToken
    jmp PrintDone

CheckNumber:

    cmp al, '0'
    jb CheckPunctuation

    cmp al, '9'
    ja CheckPunctuation

    movzx ebx, al
    sub ebx, '0'
    shl ebx, 2
    mov edx, numberTable[ebx]
    call PrintToken
    jmp PrintDone

CheckPunctuation:

    cmp al, '.'
    je PrintPeriod

    cmp al, ','
    je PrintComma

    cmp al, '?'
    je PrintQuestion

    cmp al, '('
    je PrintParentheses

    cmp al, ')'
    je PrintParentheses

    cmp al, 39
    je PrintApostrophe

    cmp al, ';'
    je PrintSemicolon

    cmp al, ':'
    je PrintColon

    cmp al, 34
    je PrintQuote

    cmp al, '-'
    je PrintHyphen

    cmp al, '/'
    je PrintSlash

    cmp al, '$'
    je PrintDollar

    jmp PrintError

PrintSpace:
    mov edx, OFFSET mSpace
    call WriteString
    jmp PrintDone

PrintPeriod:
    mov edx, OFFSET mPeriod
    call PrintToken
    jmp PrintDone

PrintComma:
    mov edx, OFFSET mComma
    call PrintToken
    jmp PrintDone

PrintQuestion:
    mov edx, OFFSET mQuestion
    call PrintToken
    jmp PrintDone

PrintParentheses:
    mov edx, OFFSET mParentheses
    call PrintToken
    jmp PrintDone

PrintApostrophe:
    mov edx, OFFSET mApostrophe
    call PrintToken
    jmp PrintDone

PrintSemicolon:
    mov edx, OFFSET mSemicolon
    call PrintToken
    jmp PrintDone

PrintColon:
    mov edx, OFFSET mColon
    call PrintToken
    jmp PrintDone

PrintQuote:
    mov edx, OFFSET mQuote
    call PrintToken
    jmp PrintDone

PrintHyphen:
    mov edx, OFFSET mHyphen
    call PrintToken
    jmp PrintDone

PrintSlash:
    mov edx, OFFSET mSlash
    call PrintToken
    jmp PrintDone

PrintDollar:
    mov edx, OFFSET mDollar
    call PrintToken
    jmp PrintDone

PrintError:
    mov edx, OFFSET mError
    call WriteString
    jmp PrintDone

PrintDone:
    ret

PrintMorse ENDP

; PrintToken
; EDX = Morse Code string OFFSET
PrintToken PROC USES edx

    call WriteString

    mov edx, OFFSET oneSpace
    call WriteString

    ret

PrintToken ENDP

END main