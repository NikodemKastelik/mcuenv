/**
 * @brief Execution entry point.
 */
ENTRY(Reset_Handler)

/**
 * @brief Memory definition.
 */

_RAM_BASE = ${RAM_BASE};
_RAM_SIZE = ${RAM_SIZE};
_RAM_END  = ${RAM_BASE} + ${RAM_SIZE};

_FLASH_BASE = ${FLASH_BASE};
_FLASH_SIZE = ${FLASH_SIZE};

MEMORY
{
    RAM (xrw): ORIGIN = _RAM_BASE,   LENGTH = _RAM_SIZE
    ROM (rx) : ORIGIN = _FLASH_BASE, LENGTH = _FLASH_SIZE
}

/**
 * @brief Sections definition.
 */
SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } >ROM

    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } >ROM

    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } >ROM

    _data_values_start = LOADADDR(.data);

    .data :
    {
        . = ALIGN(4);
        _data_start = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _data_end = .;
    } >RAM AT> ROM

    . = ALIGN(4);
    .bss :
    {
        _bss_start = .;
        *(.bss)
        *(.bss*)
        _bss_end = .;
    } >RAM
}
