#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Occupied registers $t1,$t2,$t3.
#############################################################
########  SIMPLE UNOPTIMIZED BUBBLE SORT    ###################
move $t6,$zero #counter for outer loop
move $s5,$t1 #bound for counters to avoid array overflow
loop2: beq $t6,$t1,copy
	move $t7,$zero #counter for inner loop
	addi $s5,$s5,-1 
	move $s1,$t2 #init memory address iterator for every loop
	loop3: beq $t7,$s5,loop3end
		lw $s3,0($s1)
		lw $s4,4($s1)
		#if M[i] < M[i+1] $t4 is 1
		slt $t4,$s3,$s4
		beq $t4,$zero,swap 
		bne $t4,$zero,inc
		#swap procedure
		swap: sw $s3,4($s1)
		      sw $s4,0($s1)
		      j inc
		#add 1 to inner loop counter      
		inc: addi $t7,$t7,1
		#increase address of term1		
		addi $s1,$s1,4   
		j loop3
	loop3end: addi $t6,$t6,1
		  j loop2	
copy: move $t6,$zero 
      move $s1,$t2
      move $s2,$t3	
      loop4: beq $t6,$t1,proceed
             lw $s3,($s1) #word at address $s1
             sw $s3,($s2) #copy
             addi $s1,$s1,4 #increase address of term in X-array (during iteration)  
             addi $s2,$s2,4 #increase corresp. address in Y-array
             addi $t6,$t6,1 
             j loop4
proceed:move $s5,$zero #just a filler label   
##########################################################
#############################################################

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra
