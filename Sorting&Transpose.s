 
.text
	main :
		addi $t0, $zero, -4   # t0 = - 4 so to be equal to zero in while loop
		
		while :
			addi $t0, $t0 , 4 # offset increment
			beq $t0, 4096, init_trans # 4096 = (32x32) x 4 bytes 
			lw $t5, A($t0) 
			lw $t6, B($t0)
			bge $t5, $t6, while   # if A[i,j] > B [i,j] then do nothing
			sw $t6, A($t0)
			sw $t5, B($t0)
			j while
			
	init_trans : 
	# Initizialing values to 0
		addi $t0,$zero,32 # how many elements must read at the current row
		addi $t1,$zero,0 # row pointer
		addi $t2,$zero,0 # column pointer
		addi $t3,$zero,0 # how many elements must jump in current row (Acounter)
		addi $t4,$zero,0 # column elements counter (Ecounter)
		j transpose
		
	change_column_row :
		# Resets & changes column according to t3
		addi $t3,$t3,4  # (Acounter ++) 
		addi $t4,$zero,0 # Resets element counter
		add $t1,$t1,$t3 # Sets row "pointer" to prevent reverting the previous changes
		addi $t0,$t0,-1 # Reduce the elements we have to read per row (ERcounter)
		addi $t2,$t1,0 # Sets column pointer [i] = [j] 
		
	transpose :
		#beq $t3 ,128 ,L1 # (Remove comments for print)
		beq $t3 ,128 ,exit # if we must jump all 128 bytes (=4 x 32 elements) we've finished
		# Change row element with the column one,accordingly
		lw $t5 ,A($t1) 
		lw $t6 ,A($t2)
		sw $t6 ,A($t1)
		sw $t5 ,A($t2)
		
		addi $t4,$t4,1 # column_counter++
		addi $t1,$t1,4 # access next element in row
		beq $t4 ,$t0 ,change_column_row #if (column_counter == ERcounter) change pointers
		addi $t2,$t2,128 # access next element in column
		j transpose
	
	L1 :	
		addi $t1,$zero,0
		addi $t2,$zero,128
	
	print:
			beq $t1 ,4096 ,exit  # 32 x 32 x 4
			lw $t5,A($t1)
			# Prints A's current number
			li $v0 ,1
			move $a0,$t5
			syscall
			
			# Prints space (32 = ASCII code for space)
			li $v0, 11 	 # syscall number for printing character
			li $a0, 32
			syscall
			
			# Updates offset
			addi $t1, $t1 , 4
			
			beq $t1,$t2,printLINE # Print new Line for better matrix visualization
			
			j print

	printLINE:# Prints new line
			add $t2,$t2,128 
			li $v0, 4
			la $a0, newLine
			syscall
			j print
			
	exit :
	# Terminates program
		li $v0,10
		syscall
		
.data

	newLine :	.asciiz "\n"
	space     : 	.asciiz " "
	A:	 	
			 .word 3:32
			 .word 0:32
			 .word 14:32
			 .word 34:32
			 .word 54:32
			 .word 41:32
			 .word 4:32
			 .word 4:32
			 .word 4:32
			 .word 14:32
			 .word 40:32
			 .word 49:32
			 .word 74:32
			 .word 84:32
			 .word 49:32
			 .word 45:32
			 .word 44:32
			 .word 41:32
			 .word 43:32
			 .word 41:32
			 .word 40:32
			 .word 4:32
			 .word 4:32
			 .word 14:32
			 .word 24:32
			 .word 34:32
			 .word 44:32
			 .word 44:32
			 .word 45:32
			 .word 64:32
			 .word 45:32
			 .word 44:32	
			 
	 B:	
			.word 3:32
			 .word 0:32
			 .word 4:32
			 .word 6:32
			 .word 5:32
			 .word 4:32
			 .word 3:32
			 .word 1:32
			 .word 3:32
			 .word 2:32
			 .word 0:32
			 .word 46:32
			 .word 48:32
			 .word 4:32
			 .word 4:32
			 .word 69:32
			 .word 78:32
			 .word 12:32
			 .word 21:32
			 .word 0:32
			 .word 4:32
			 .word 4:32
			 .word 45:32
			 .word 68:32
			 .word 1:32
			 .word 10:32
			 .word 41:32
			 .word 42:32
			 .word 43:32
			 .word 41:32
			 .word 14:32