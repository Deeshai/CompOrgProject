.data
userEntry_msg: .asciiz "Please enter a hexadecimal number of 8 characters or less:"
userError_msg: .asciiz "You have entered a hexadecmial number."
input: space 9

.text


main:
#Prompt for user entry
la $a0, userEntry_msg    #Loads userEntry_msg in $a0
li $v0, 4
syscall

la $a0, input            #Loads byte space into address.
li $a1, 9				 #Allot the byte space for string
li $v0, 8
syscall

add $t0, $zero, $a0		 #Copy the string address to register $t0



