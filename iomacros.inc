#get integer into register %x
.macro getint(%x)
li a7,5 # get integer into a0
ecall
add %x,zero,a0 # copy a0 value to register %x
.end_macro

#print integer in register %x
.macro putint(%x)
add a0,zero,%x # copy %x register value to a0
li a7,1 # print integer in a0
ecall
.end_macro

#print character in register %x
.macro putchar(%x)
add a0,zero,%x # copy %x register value to a0
li a7,11 # print character in a0
ecall
.end_macro

#print literal character %c
.macro putcharl(%c)
li a0,%c # load a0 register with character %c
li a7,11 # print character in a0
ecall
.end_macro

#exit program with code %code
.macro exit(%code)
li a0,%code
li a7,93
ecall
.end_macro

.macro gets (%addr,%n) #Gets a string from stdin, with at most n characters and stores it at address %addr
la a0, %addr # a0, address to store the string
li a1, %n # a1, maximum number of chars
li a7, 8
ecall 
.end_macro 

.macro getchar (%reg) #Gets a character from stdin and copies it to register %reg
li a7, 12 
ecall
add %reg, zero, a0 
.end_macro 

.macro puts (%addr) #Prints in console the ASCIIZ string stored at address %addr
la a0, %addr
li a7, 4
ecall
.end_macro 

.macro putintln (%reg) #Prints in console the value of register %reg, followed by a
#newline character
putint(%reg)
putcharl('\n')
.end_macro 

.macro traverse(%idx, %n, %size, %data, %body)
mul %n, %n, %size # convert to bytes
add %n, %idx, %n # set end
trav_loop:
lw %data, (%idx)
beq %idx, %n, trav_end
%body ()
addi %idx, %idx, %size # prev/next element
j trav_loop
trav_end:
.end_macro

.macro strcnt_body()
bne a4, a5, scntb1 # newline
addi a1, a1, 1 # inc lines
addi a2, a2, 1 # inc words
j scntb2
scntb1:
bne a4, a6, scntb2 # space
addi a2, a2, 1 # inc words
scntb2:
.end_macro

# ----------		Increment the ASCII of all characters in a string in a0 by the value in a1		------------------ #
# ----------		uses: a0, a1, a2		----------#

# -----------------	 •travestr() leaves in a2 the current character ASCII code 	--------------------
# -----------------	 •add a1 to ASCII code in a2						--------------------
# -----------------	 •store it back into string current position (a0) 			--------------------

.macro travstr(%idx, %data, %body)
travstr_loop:
	lb %data, (%idx) #guarda o valor do index de idx em data
	beqz %data, travstr_end #end at null character
	
	%body()
	
	addi %idx, %idx, 1 #else, avança 1 em 1 até ao caracter nulo (\0)
 	j travstr_loop
travstr_end:
.end_macro

.macro strincasc_body()
	add a2, a2, a1 #
	sb a2, (a0)
.end_macro



