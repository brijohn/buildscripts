ENTRY("_start")
STARTUP("exword_crt0.o")
MEMORY
{
  rom (rx) : org = 0x70000080, len = 0x1FF80
  ram (w)  : org = 0x7400002c, len = 0x7FD4
}

SECTIONS
{
  .text :
  {
    _stext = .;
    *(.text)
    *(.text*)
    *(.rodata)
    *(.rodata*)
    _etext = .;
  } > rom
  .bss :
  {
    _sbss = .;
    *(.bss)
    *(COMMON)
    _ebss = .;
  } > ram
  .data :
  {
    _sdata = .;
    *(.data)
    _edata = .;
  } > ram AT>rom
  /DISCARD/ :
  { 
    *(.comment)
    *(.eh_frame)
  }
}

