# Jak parsować instrukcje po wartości kod?


Jeśli kod jest z zakresu:

- **[0 (0x000), 16 383 (0x3FFF)]** i jego ostatnia 2 cyfry w reprezentacji heksadecymalnej to:
  - 00 - MOV
  - 01 - ignoruj
  - 02 - OR
  - 03 - ignoruj
  - 04 - ADD
  - 05 - SUB
  - 06 - ADC
  - 07 - SBB
  - 08 - XCHG (wielordzeniowa)
  - [09, FF] - ignoruj
- **[16 384 (0x4000), 18 431 (0x47FF)]** MOVI
- **[18 432 (0x4800), 22 527 (0x57FF)]** ignoruj
- **[22 528 (0x5800), 24 575 (0x5FFF)]** XORI
- **[24 576 (0x6000), 26 623 (0x67FF)]** ADDI
- **[26 624 (0x6800), 28 671 (0x6FFF)]** CMPI
- **[28 672 (0x7000), 28 672 (0x7000)]** ignoruj
- **[28 673 (0x7001), 30 465 (0x7701)]** RCR
- **[30 466 (0x7702), 32 767(0x7FFF)]** ignoruj
- **[32 768 (0x8000), 32 768 (0x8000)]** CLC
- **[32 769 (0x8001), 33 023 (0x8FFF)]** ignoruj
- **[33 024 (0x8100), 33 024 (0x8100)]** STC
- **[33 025 (0x8101), 49 151(0xBFFF)]** ignoruj
- **[49 152 (0xC000), 49 407 (0xC0FF)]** JMP
- **[49 408 (0xC100), 49 663 (0xC1FF)]** ignoruj
- **[49 664 (0xC200), 49 919 (0xC2FF)]** JNC
- **[49 920 (0xC300), 50 175 (0xC3FF)]** JC
- **[50 176 (0xC400), 50 431 (0xC4FF)]** JNZ
- **[50 432 (0xC500), 50 687 (0xC5FF)]** JZ
- **[50 688 (0xC600), 65 534 (0xFFFE)]** ignoruj
- **[65 535 (0xFFFF), 65 535 (0xFFFF)]** BRK

## Jak parsować instrukcje MOV, OR, ADD, SUB, ADC, SBB, XCHG
1. Patrzymy na ostatnie 2 cyfry w reprezentacji hex i upewniamy się, że są one poprawne.
2. Odejmujemy 2 ostatnie cyfry
3. Z pozostałej wartości obliczamy modulo 256 (0x100) - otrzymujemy arg1
4. Odejmujemy od liczby arg1, dzielimy przez 2048 (0x800) - otrzymujemy arg2

## Jak parsować instrukcje MOVI, XORI, ADDI, CMPI
1. Patrzymy na 2 ostatnie cyfry w rezprezntacji hex - otrzymujemy imm8
2. Odejmujemy imm8 oraz odpowiednią stałą (0x4000, 0x5800, 0x6000 albo 0x6800)
3. Dzielimy przez 256 (0x100) - otrzymujemy arg1

## Jak parsować instrukcje RCR
1. Upewniamy się, że ostatnie 2 cyfry w reprezentacji hex to 01
2. Odejmujemy 0x7001
3. Dzielimy przez 256 (0x100) - otrzymujemy arg1

## Jak parsować insturkcje JMP, JNC, JC, JNZ,JZ
1. Patrzymy na ostatnie 2 cyfry w reprezentcji hex - otrzymujemy imm8

## Disclaimer
Patrzenie na 2 ostatnie cyfry to np. obliczenie modulo 256 (0x100) albo jakiś inny sprytniejszy sposób który jest zaimplementowany w NASM.<br>
Każda cyfra ma 16 bitów więc ostatnie dwie mają łącznie 32, czyli zapewne da się to zrobić.