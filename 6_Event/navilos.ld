ENTRY(vector_start)
SECTIONS
{
    . = 0X0;

    .text :
    {
        *(vector_start)
        *(.text .rodata)
    }
    .data :
    {
        *(.data)
    }
    .bss :
    {
        *(.bss)
    }
}