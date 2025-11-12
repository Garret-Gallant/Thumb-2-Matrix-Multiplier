		AREA    ARRAYS, DATA, READWRITE

A       DCD     1, 2, 3, 4, 5, 6, 7, 8
        DCD     9, 10, 11, 12, 13, 14, 15, 16
        DCD     17, 18, 19, 20, 21, 22, 23, 24
        DCD     25, 26, 27, 28, 29, 30, 31, 32
        DCD     33, 34, 35, 36, 37, 38, 39, 40
        DCD     41, 42, 43, 44, 45, 46, 47, 48
        DCD     49, 50, 51, 52, 53, 54, 55, 56
        DCD     57, 58, 59, 60, 61, 62, 63, 64

B       DCD     1, 0, 0, 0, 0, 0, 0, 0
        DCD     0, 1, 0, 0, 0, 0, 0, 0
        DCD     0, 0, 1, 0, 0, 0, 0, 0
        DCD     0, 0, 0, 1, 0, 0, 0, 0
        DCD     0, 0, 0, 0, 1, 0, 0, 0
        DCD     0, 0, 0, 0, 0, 1, 0, 0
        DCD     0, 0, 0, 0, 0, 0, 1, 0
        DCD     0, 0, 0, 0, 0, 0, 0, 1

C       SPACE   256  ; 8x8x4

        AREA    Phase4, CODE, READONLY
        ENTRY
        EXPORT  main

main
        LDR     R0, =A
        LDR     R1, =B
        LDR     R2, =C

        MOV     R4, #8          ; i counter

I_loop
        SUBS    R4, R4, #1
        BMI     done

        LSL     R5, R4, #5      ; row offset for A
        LSL     R6, R4, #5      ; row offset for C

        MOV     R7, #8          ; j counter

J_loop
        SUBS    R7, R7, #1
        BMI     I_loop

        LSL     R8, R7, #2      ; column offset
        MOV     R9, #8          ; k counter
        MOV     R10, #0         ; accumulator

K_loop
        SUBS    R9, R9, #1
        BMI     store_result

        ; load A[i,k]
        ADD     R11, R0, R5
        LSL     R12, R9, #2
        ADD     R11, R11, R12
        LDR     R12, [R11]

        ; load B[k,j]
        LSL     R12, R9, #5
        ADD     R11, R1, R12
        ADD     R11, R11, R8
        LDR     R12, [R11]

        ; multiply and accumulate
        MUL     R12, R12, R12
        ADD     R10, R10, R12

        B       K_loop

store_result
        ADD     R11, R2, R6
        ADD     R11, R11, R8
        STR     R10, [R11]

        B       J_loop

done
        B       done
        END
