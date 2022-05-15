.include "iomacros.inc"

.data
	str: .space 30
	printError: .ascii "error"
	
.text
	gets(str, 30)	
	
	la a0, str #pointer para o in�cio da string
	li a1, 48 #a1 -> subtra��o do ascii para int
	li a7, 57 #a7 = 57(Ascii) = 9 -> vou usar para saber se um caracter � inv�lido ou n�o
	li a3, '\n' # a3 = \n
	li s6, '\0' #s6 = \0
	li a5, 32 # a5 = space
	li a4, 1  # a4 = 1 -> para a primeira convers�o do d�gito (10^0)
	li a6, 10 # a6 = 10 -> para o expoente de base 10
	li s0, 43 # s0 = "+"
	li s1, 45 # s1 = "-"
	li s2, 42 # s2 = "*"
	li s3, 47 # s3 = "/"
	li s4, 37 # s4 = "%"
	li s5, 0 # s5 = 0 -> vou usar para saber se a string � v�lida
		
	strTraverse:
	lb a2, (a0) #a2 vai guardar o valor de a0
	beq a2,  a3, convertLastDigitRight #if a2 == \n ent chegou ao final da string, pode fazer a convers�o do operando
	addi a0, a0, 1 #se n�o chegou ao fim, continua a percorrer a string
	j strTraverse
	
	convertLastDigitRight: #vai fazer a convers�o do segundo operando
	addi a0, a0, -1  #a0 aponta para a ultima letra agora
	lb t1, (a0)  #guarda o valor de a0 em t1, ou seja o ultimo d�gito est� em t1
	beq t1, a5, resetPotencia#if t1 == space ent dou reset na potencia
	blt t1, a1, erro #  if t1 < 0 d� print da msg do erro
	bgt t1, a7, erro # if t1 > 9 d� print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtra��o do �ltimo d�gito (t1) com o 48(a1)
	mul t3, t2, a4 #agr meto em t3 o resultado da multiplica��o do t2 com o a4 que ser� o 10^0, ou seja, a convers�o acaba aqui
	mul a4, a4, a6 #agr incremento o expoente, para o pr�ximo d�gito j� ser 10^1
	j getRightOperand
	
	getRightOperand:
	addi a0, a0, -1 #pointer
	lb t1, (a0) #insiro em t1 o valor para o qual o pointer est� a apontar
	beq t1, a5, resetPotencia#if t1 == space ent dou reset na potencia
	beq t1, s1, negativeRightOperand #if t1 = " - " ent vai converter o numero negativo
	blt t1, a1, erro #  if t1 < 0 d� print da msg do erro
	bgt t1, a7, erro # if t1 > 9 d� print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtra��o do �ltimo d�gito (t1) com o 48(a1)
	mul t4, t2, a4 #agr meto em t4 o resultado da multiplica��o do t2 com as pot�ncias do 10
	add t3, t3, t4 #faco a soma dos 2 d�gitos e meto em t3
	mul a4, a4, a6 #incremento a pot�ncia
	j getRightOperand
	
	negativeRightOperand:
	sub t6, t3, t3 #subtrai o n�mero j� convertido a 0 e mete em t6
	sub t3, t6, t3 #subtraio ao t6(0) o n�mero t3 para agr ficar negativo e meto em t3
	j getRightOperand
	
	resetPotencia:
	li a4, 1
	j findOperator
	
	findOperator:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, findOperator #if t1 = space ent continua a percorrer a string at� encontrar um operador
	beq t1, s0, sum #t1 == "+" faz a soma 
	beq t1, s1, sub #t1 == " - " faz a subtra��o
	beq t1, s2, mul # t1 == " * " faz a multiplica��o
	beq t1, s3, div # t1 == " / " faz a divis�o
	beq t1, s4, remainder # t1 == " % " faz o resto da divis�o
	
	sum:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, convertLastDigitLeft #se souber que � um space ent continua a decrementar o pointer at� encontrar o d�gito
	j erro
	
	sub:
	addi a0, a0, -1 #ap�s encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer at� encontrar o d�gito
	j erro
	
	mul:
	addi a0, a0, -1 #ap�s encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer at� encontrar o d�gito
	j erro
	
	div:
	addi a0, a0, -1 #ap�s encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer at� encontrar o d�gito
	j erro
	
	remainder:
	addi a0, a0, -1 #ap�s encontrar o sinal "+" decrementa o pointer -1
	lb t1, (a0) #guardo em t1 o valor do pointer a0
	beq t1, a5, convertLastDigitLeft #if t1  == space ent decrementa outra vez o pointer at� encontrar o d�gito
	j erro
	
	convertLastDigitLeft:
	addi a0, a0, -1
	lb t1, (a0)
	beq t1, a5, convertLastDigitLeft
	blt t1, a1, erro #  if t1 < 0 d� print da msg do erro
	bgt t1, a7, erro # if t1 > 9 d� print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtra��o do �ltimo d�gito (t1) com o 48(a1)
	mul t4, t2, a4 #agr meto em t4 o resultado da multiplica��o do t2 com o a4 que ser� o 10^0, ou seja a convers�o acaba aqui
	mul a4, a4, a6 #agr incremento o expoente, para o pr�ximo d�gito j� ser 10^1
	j getLeftOperand
	
	getLeftOperand:
	addi a0, a0, -1
	lb t1, (a0)
	beqz t1, decideOperator #quando chega ao final da string d� print
	beq t1, s1, negativeLeftOperand #if t1 = " - " ent vai converter o numero negativo
	blt t1, s1, erro #  if t1 < 0 d� print da msg do erro
	bgt t1, a7, erro # if t1 > 9 d� print da msg do erro
	sub t2 ,t1, a1 #meto em t2 a subtra��o do �ltimo d�gito (t1) com o 48(a1)
	mul t5, t2, a4 #agr meto em t4 o resultado da multiplica��o do t2 com o a4 que ser� o 10^0, ou seja, a convers�o acaba aqui
	add t4, t4, t5 #faco a soma dos 2 d�gitos
	mul a4, a4, a6 #incremento a pot�ncia
	j getLeftOperand
	
	negativeLeftOperand:
	sub t6, t4, t4 #subtrai o n�mero j� convertido a 0 e mete em t6
	sub t4, t6, t4 #subtraio ao t6(0) o n�mero t3 para agr ficar negativo e meto em t3
	j getLeftOperand
	
	decideOperator:
	addi a0, a0, 2 #vou saltar 2 posi��es para n�o guardar o sinal negativo e ir para a subtra��o em vez da multiplica��o
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
	add t5, t4, t3 #meto em t5 a soma dos 2 operandos, um est� no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	subOperands:
	sub t5, t4, t3 #meto em t5 a soma dos 2 operandos, um est� no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	mulOperands:
	mul t5, t4, t3 #meto em t5 a soma dos 2 operandos, um est� no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	divOperands:
	div t5, t4, t3 #meto em t5 a soma dos 2 operandos, um est� no t3, outro no t4
	putint(t5)
	putcharl('\n')
	exit(0)
	
	remainderOperands:
	rem t5, t4, t3 #meto em t5 a soma dos 2 operandos, um est� no t3, outro no t4
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
	
