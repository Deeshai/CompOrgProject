# Deeshai Escoffery - 11/15/2017
# Hexadecimal to Decimal Converter

#Begin

.data
	error_msg: .asciiz "Invalid hexadecimal number"    #error message for invalid hexadecimal
	output_line: .asciiz "\n"			  #stores new line for output
	input: .space 9					#space for characters (8 + 1)
	
.text

main:
	addi $t8, $zero, 16		#set base to 16
	addi $t4, $zero, 0		#initializes string length to 0.
	
	la $a0, input			#load string in $a0.
	li $v0, 4			#load string syscall command.
	syscall
	
	la $a0, input			#load byte into address.
	li $a1, 9			#Assign byte space for string.
	li $v0, 8			#Load print syscall command.
	syscall
	
	add $t0, $zero, $a0		#Copy string address to register $t0.
	
loop_string_length:			#Finds Length of string entered.
	
	lb $t2, 0($t0)			#Load character at $t0 into $t2
	
	beq $t2, 10, exit_loop_string_length	#If new line exit loop.
	beq $t2, 0, exit_loop_string_length	#If null exit loop.
	
	addi $t4, $t4, 1			#Increment length.
	addi $t0, $t0, 1			#Increment starting point of $t0 by 1
	
	j loop_string_length			#Starting loop over.
	
exit_loop_string_length:
	
	add $t0, $zero, $a0			#Copy string address to register $t0.
	add $t5, $zero, 0			#Initialize index tracker.
	
loop:
	
	lb $t2, 0($t0)				#Load character at $t0 to $t2.
	
	sub $t6, $t4, $t5			#Power = length - index
	addi $t6, $t6, -1			#Power = power - 1
	
	beq $t2, 10, end_loop			#If new line end loop.
	beq $t2, 0, end_loop			#If null end loop.
	
check_lower_maximum:

	blt $t2, 103, check_lower_minimum		#If within max then jump to check if it is in the min.
	j invalid_hex				#If outside then it is invalid.
	
check_lower_minimum:

	bgt $t2, 96, store_lower_value		#If withn min then jump to store decimal value.
	j check_upper_maximum			#If less than min then check if uppercase.
	
store_lower_value:

	addi $t3, $t2, -87			#Store decimal in $t3.
	j increment				#Jump to next character.
	
check_upper_maximum:
	
	blt $t2, 71, check_upper_minimum		#If withn min then jump to store decimal value.
	j invalid_hex				#If outside then it is invalid
	
check_upper_minimum:

	bgt $t2, 64, store_upper_value		#If withn min then jump to store decimal value.
	j check_number_maximum				#If less than min then check if number.
	
store_upper_value:

	addi $t3, $t2, -55			#Store decimal in $t3.
	j increment				#Jump to next character.
	
check_number_maximum:

	blt $t2, 58, check_number_minimum		#If within max then check min.
	j invalid_hex				#If outside of max then invalid.
	
check_number_minimum:

	bgt $t2, 47, store_num_value		#If within min then jump to store decimal value.
	j invalid_hex				#If outside of min then invalid.				
		
store_num_value:
	
	addi $t3, $t2, -48			#Store decimal in $t3.
	j increment				#Jump to next character.
	
increment:

	addi $t7, $zero, 1			#Intitializes exponent to 1.
	
loop_char_exponent:					#Calculates character exponent.

	beq $t6, $zero, calc_value			#If power is 1 then exit loop.
	mult $t8, $t7					#Exponent * base.
	mflo $t7					#Update exponent.
	
	addi $t6, $t6, -1				#Decrement the power.
	j loop_char_exponent				#Jump to start of loop until end of string.
	
calc_value:						#Calculating current value.

	mult $t3, $t7					#Decimal * exponent.
	mflo $t9					#Update sum.
	add $s0, $s0, $t9				#Current value + sum.
	
	addi $t5, $t5, 1				#Increment the index.
	addi $t0, $t0, 1				#Increment the character.
	j loop						#Jump to loop.
	
end_loop:						#End loop.

	j valid_hex					#Jump to valid.
	
end_program:

	li $v0, 10					#End program.
	syscall
	
valid_hex:							#Print the decimal of the converted hexadecimal.

	la $a0, output_line				#Load output in $a0.
	li $v0, 4					#Load print string syscall command.
	syscall
	
	addi $t1, $zero, 10000				#Store constant 10000 in register $t1.
	divu $s0, $t1					#Decimal/10000
	mflo $s1					#Store quotient in register $s1.
	mfhi $s2					#Store remainder in register $s2.
	
	beq $s1, $zero, rem_only			#If quotient is 0 then print the remainder.
	
	add $a0, $zero, $s1				#Load sum in syscall argument.
	li $v0, 1					#Load print integer syscall command.
	syscall
	
rem_only:

	add $a0, $zero, $s2				#Load sum in syscall argument.
	li $v0, 1					#Load print integer syscall command.
	syscall
	
	j end_program					#Jump to end program.
	
invalid_hex: 						#Print invalid erro messag.

	la $a0, error_msg				#Load error_msg in syscall argument.
	li $v0, 4					#Load print string syscall command.
	syscall
	j end_program					#Jump to end program
	
#End
