#include "ARMv7AR.h"
#include "MemoryMap.h"

.text
    .code 32                                @ ARM 32비트 명령어 모드

    .global vector_start
    .global vector_end

    vector_start:                           @ 벡터 테이블 설정 (인터럽트 처리)
        LDR PC, reset_handler_addr          @ 리셋 헨들러로 이동
        LDR PC, undef_handler_addr
        LDR PC, svc_handler_addr
        LDR PC, pftch_abt_handler_addr
        LDR PC, data_abt_handler_addr
        B   .
        LDR PC, irq_handler_addr
        LDR PC, fiq_handler_addr

        reset_handler_addr:     .word reset_handler 
        undef_handler_addr:     .word dummy_handler
        svc_handler_addr:       .word dummy_handler
        pftch_abt_handler_addr: .word dummy_handler
        data_abt_handler_addr:  .word dummy_handler
        irq_handler_addr:       .word Irq_Handler
        fiq_handler_addr:       .word Fiq_Handler
    vector_end:

    reset_handler:                          @ 모드 별 스택 포인터 초기화 및 정의
        MRS r0, cpsr                        @ 현재 CPSR을 r0에 복사 (MRS == 복사)
        BIC r1, r0, #0x1F                   @ 현재 모드 지우기(하위 5비트 클리어, BIC == 비트 클리어)
        ORR r1, r1, #ARM_MODE_BIT_SVC       @ SVC 모드 비트를 설정
        MSR cpsr, r1                        @ CPSR에 SVC 모드 설정
        LDR sp, =SVC_STACK_TOP              @ SVC 모드 스택 포인터 설정

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_IRQ
        MSR cpsr, r1
        LDR sp, =IRQ_STACK_TOP

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_FIQ
        MSR cpsr, r1
        LDR sp, =FIQ_STACK_TOP

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_ABT
        MSR cpsr, r1
        LDR sp, =ABT_STACK_TOP

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_UND
        MSR cpsr, r1
        LDR sp, =UND_STACK_TOP

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_SYS
        MSR cpsr, r1
        LDR sp, =USRSYS_STACK_TOP

        BL main

    dummy_handler:
        B .                        @ 현재 위치로 점프 == 무한루프(B == 점프)
.end
