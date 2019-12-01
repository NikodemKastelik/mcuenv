.syntax unified
.cpu    cortex-m0
.thumb

.global g_pfnVectors
.global Default_Handler

/**
 * @brief Symbol for determining address of .data section initial values block.
 */
.word _data_values_start

/**
 * @brief Symbol for determining start address of .data section.
 */
.word _data_start

/**
 * @brief Symbol for end address of .data section.
 */
.word _data_end

/**
 * @brief Symbol for determining start address of .bss section.
 */
.word _bss_start

/**
 * @brief Symbol for end address of .bss section.
 */
.word _bss_end

/**
 * @brief Application entry code.
 *
 * CPU starts execution from here just after reset. This routine prepares static
and global variables. Then jump to main() is performed and user application
begins execution.
 */
.section .text.Reset_Handler
.weak    Reset_Handler,
.type    Reset_Handler, %function
Reset_Handler:
    /* Set SP to the end of RAM. */
    ldr   r0, =_RAM_END
    mov   sp, r0

    /* Copy data segment initial values from Flash to RAM. */
    ldr   r0, =_data_start
    ldr   r1, =_data_end
    ldr   r2, =_data_values_start
    movs  r3, #0

    /* R1 contains bytes to copy. */
    subs  r1, r1, r0

    b     copy_data_check

copy_data_loop:
    ldr   r4, [r2, r3]
    str   r4, [r0, r3]
    adds  r3, #4

copy_data_check:
    cmp   r3, r1
    bcc   copy_data_loop

    /* Zero fill BSS section. */
    ldr   r0, =_bss_start
    ldr   r1, =_bss_end
    movs  r2, #0
    b     zero_bss_check

zero_bss_loop:
    str   r2, [r0]
    adds  r0, #4

zero_bss_check:
    cmp   r0, r1
    bcc   zero_bss_loop

/* Call user application main() */
    b     main

.size Reset_Handler, .-Reset_Handler

/**
 * @brief Function for catching default interrupts.
 *
 * Any interrupt handler not overriden explicitely will be trapped inside this function for debugger to examine.
 */
.section .text.Default_Handler,"ax",%progbits
Default_Handler:
    b   Default_Handler
.size     Default_Handler, .-Default_Handler

/**
 * @brief Vector table.
 */
.section .isr_vector,"a",%progbits
.type    g_pfnVectors, %object
.size    g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
    .word _RAM_END
    .word Reset_Handler
    .word NonMaskableInt_Handler
    .word HardFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word 0
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler
    .word WWDG_IRQHandler
    .word 0
    .word RTC_IRQHandler
    .word FLASH_IRQHandler
    .word RCC_IRQHandler
    .word EXTI0_1_IRQHandler
    .word EXTI2_3_IRQHandler
    .word EXTI4_15_IRQHandler
    .word 0
    .word DMA1_Channel1_IRQHandler
    .word DMA1_Channel2_3_IRQHandler
    .word DMA1_Channel4_5_IRQHandler
    .word ADC1_IRQHandler
    .word TIM1_BRK_UP_TRG_COM_IRQHandler
    .word TIM1_CC_IRQHandler
    .word 0
    .word TIM3_IRQHandler
    .word 0
    .word 0
    .word TIM14_IRQHandler
    .word 0
    .word TIM16_IRQHandler
    .word TIM17_IRQHandler
    .word I2C1_IRQHandler
    .word 0
    .word SPI1_IRQHandler
    .word 0
    .word USART1_IRQHandler

/**
 * @brief Weak aliases for interrupt handlers.
 *
 * Interrupt handlers points to Default_Hander by default. As they are weak
 * aliases, they can be overriden and therefore be used in user code.
 */

.weak      NonMaskableInt_Handler
.thumb_set NonMaskableInt_Handler,Default_Handler

.weak      HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler

.weak      SVC_Handler
.thumb_set SVC_Handler,Default_Handler

.weak      PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler

.weak      SysTick_Handler
.thumb_set SysTick_Handler,Default_Handler

.weak      WWDG_IRQHandler
.thumb_set WWDG_IRQHandler,Default_Handler

.weak      RTC_IRQHandler
.thumb_set RTC_IRQHandler,Default_Handler

.weak      FLASH_IRQHandler
.thumb_set FLASH_IRQHandler,Default_Handler

.weak      RCC_IRQHandler
.thumb_set RCC_IRQHandler,Default_Handler

.weak      EXTI0_1_IRQHandler
.thumb_set EXTI0_1_IRQHandler,Default_Handler

.weak      EXTI2_3_IRQHandler
.thumb_set EXTI2_3_IRQHandler,Default_Handler

.weak      EXTI4_15_IRQHandler
.thumb_set EXTI4_15_IRQHandler,Default_Handler

.weak      DMA1_Channel1_IRQHandler
.thumb_set DMA1_Channel1_IRQHandler,Default_Handler

.weak      DMA1_Channel2_3_IRQHandler
.thumb_set DMA1_Channel2_3_IRQHandler,Default_Handler

.weak      DMA1_Channel4_5_IRQHandler
.thumb_set DMA1_Channel4_5_IRQHandler,Default_Handler

.weak      ADC1_IRQHandler
.thumb_set ADC1_IRQHandler,Default_Handler

.weak      TIM1_BRK_UP_TRG_COM_IRQHandler
.thumb_set TIM1_BRK_UP_TRG_COM_IRQHandler,Default_Handler

.weak      TIM1_CC_IRQHandler
.thumb_set TIM1_CC_IRQHandler,Default_Handler

.weak      TIM3_IRQHandler
.thumb_set TIM3_IRQHandler,Default_Handler

.weak      TIM14_IRQHandler
.thumb_set TIM14_IRQHandler,Default_Handler

.weak      TIM16_IRQHandler
.thumb_set TIM16_IRQHandler,Default_Handler

.weak      TIM17_IRQHandler
.thumb_set TIM17_IRQHandler,Default_Handler

.weak      I2C1_IRQHandler
.thumb_set I2C1_IRQHandler,Default_Handler

.weak      SPI1_IRQHandler
.thumb_set SPI1_IRQHandler,Default_Handler

.weak      USART1_IRQHandler
.thumb_set USART1_IRQHandler,Default_Handler

