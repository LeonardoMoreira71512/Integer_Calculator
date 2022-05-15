.include "iomacros.inc"

.data
	str: .space 30
	printError: .ascii "error"
	
.text
	gets(str, 30)	
	
	la a0, str #pointer para o início da string
	li a1, 48 #a1 -> subtração do ascii para int
	li a7, 57 #a7 = 57(Ascii) = 9 -> vou usar para saber se um caracter é inválido ou não
	li a3, '\n' # a3 = \n
	li s6, '\0' #s6 = \0
	li a5, 32 # a5 = space
	li a4, 1  # a4 = 1 -> para a primeira conversão do dígito (10^0)
	li a6, 10 # a6 = 10 -> para o expoente de base 10
	li s0, 43 # s0 = "+"
	li s1, 45 # s1 = "-"
	li s2, 42 # s2 = "*"
	li s3, 47 # s3 = "/"
	li s4, 37 # s4 = "%"
	li s5, 0 # s5 = 0 -> vou usar para saber se a string é válida
		
	strTraverse:
	lb a2, (a0) #a2 vai guardar o valor de a0
	beq a2,  a3, convertLastDigitRight #if a2 == \n ent chegou ao final da string, pode fazer a conversão do operando
	addi a0, a0, 1 #se não chegou ao fim, continua a percorrer a string
	j strTraverse
	
	convertLastDigitRight: #vai fazer a conversão do segundo operando
	addi a0, a0, -1  #a0 aponta para a ultima letra agora
	lb t1, (a0)  #guarda o valor de a0 em t1, ou seja o ultimo dígito está em t1
	beq t1, a5, resetPotencia#if t1 == space ent dou reset na potencia
	blt t1, a1, erro #  if t1 < 0 dá print da msg do erro
	bgt t1, a7, erro # if t1 > 9 dá print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtração do último dígito (t1) com o 48(a1)
	mul t3, t2, a4 #agr meto em t3 o resultado da multiplicação do t2 com o a4 que será o 10^0, ou seja, a conversão acaba aqui
	mul a4, a4, a6 #agr incremento o expoente, para o próximo dígito já ser 10^1
	j getRightOperand
	
	getRightOperand:
	addi a0, a0, -1 #pointer
	lb t1, (a0) #insiro em t1 o valor para o qual o pointer está a apontar
	beq t1, a5, resetPotencia#if t1 == space ent dou reset na potencia
	beq t1, s1, negativeRightOperand #if t1 = " - " ent vai converter o numero negativo
	blt t1, a1, erro #  if t1 < 0 dá print da msg do erro
	bgt t1, a7, erro # if t1 > 9 dá print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtração do último dígito (t1) com o 48(a1)
	mul t4, t2, a4 #agr meto em t4 o resultado da multiplicação do t2 com as potências do 10
	add t3, t3, t4 #faco a soma dos 2 dígitos e meto em t3
	mul a4, a4, a6 #incremento a potência
	j getRightOperand
	
	negativeRightOperand:
	sub t6, t3, t3 #subtrai o número já convertido a 0 e mete em t6
	sub t3, t6, t3 #subtraio ao t6(0) o número t3 para agr ficar negativo e meto em t3
	j getRightOperand
	
	resetPotencia:
	li a4, 1
	j findOperator
	
	findOperator:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, findOperator #if t1 = space ent continua a percorrer a string até encontrar um operador
	beq t1, s0, sum #t1 == "+" faz a soma 
	beq t1, s1, sub #t1 == " - " faz a subtração
	beq t1, s2, mul # t1 == " * " faz a multiplicação
	beq t1, s3, div # t1 == " / " faz a divisão
	beq t1, s4, remainder # t1 == " % " faz o resto da divisão
	
	sum:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, convertLastDigitLeft #se souber que é um space ent continua a decrementar o pointer até encontrar o dígito
	j erro
	
	sub:
	addi a0, a0, -1 #após encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer até encontrar o dígito
	j erro
	
	mul:
	addi a0, a0, -1 #após encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer até encontrar o dígito
	j erro
	
	div:
	addi a0, a0, -1 #após encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer até encontrar o dígito
	j erro
	
	remainder:
	addi a0, a0, -1 #após encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer até encontrar o dígito
	j erro
	
	convertLastDigitLeft:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, convertLastDigitLeft
	blt t1, a1, erro #  if t1 < 0 dá print da msg do erro
	bgt t1, a7, erro # if t1 > 9 dá print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtração do último dígito (t1) com o 48(a1)
	mul t4, t2, a4 #agr meto em t4 o resultado da multiplicação do t2 com o a4 que será o 10^0, ou seja a conversão acaba aqui
	mul a4, a4, a6 #agr incremento o expoente, para o próximo dígito já ser 10^1
	j getLeftOperand
	
	getLeftOperand:
	addi a0, a0, -1
	lb t1, (a0)
	beqz t1, decideOperator #quando chega ao final da string dá print
	beq t1, s1, negativeLeftOperand #if t1 = " - " ent vai converter o numero negativo
	blt t1, s1, erro #  if t1 < 0 dá print da msg do erro
	bgt t1, a7, erro # if t1 > 9 dá print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtração do último dígito (t1) com o 48(a1)
	mul t5, t2, a4 #agr meto em t4 o resultado da multiplicação do t2 com o a4 que será o 10^0, ou seja, a conversão acaba aqui
	add t4, t4, t5 #faco a soma dos 2 dígitos
	mul a4, a4, a6 #incremento a potência
	j getLeftOperand
	
	negativeLeftOperand:
	sub t6, t4, t4 #subtrai o número já convertido a 0 e mete em t6
	sub t4, t6, t4 #subtraio ao t6(0) o número t3 para agr ficar negativo e meto em t3
	j getLeftOperand
	
	decideOperator:
	addi a0, a0, 2 #vou saltar 2 posições para não guardar o sinal negativo e ir para a subtração em vez da multiplicação
	lb t1, (a0)
	j finalOperation
	
	finalOperation:
	addi a0, a0, 1
	lb t1, (a0)
	beq t1, s0, sumOperands
	beq t1, s1, subOperands
	beq t1, s2, mulOperands
	beq t1, s3, divOperands
	beq t1, s4 remainderOperands
	j finalOperation
	
	sumOperands:
	add t5, t4, t3 #meto em t5 a soma dos 2 operandos, um está no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	subOperands:
	sub t5, t4, t3 #meto em t5 a soma dos 2 operandos, um está no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	mulOperands:
	mul t5, t4, t3 #meto em t5 a soma dos 2 operandos, um está no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	divOperands:
	div t5, t4, t3 #meto em t5 a soma dos 2 operandos, um está no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	remainderOperands:
	rem t5, t4, t3 #meto em t5 a soma dos 2 operandos, um está no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	erro:
	puts(printError)
	putcharl('\n')
	exit(0)
	
	print:
	puts(str)
	putcharl('\n')
	exit(0)
	
