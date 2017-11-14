.text

la $a0, myWord
li $a1, 9

li $v0, 8
syscall


li $v0, 10
syscall


.data
myWord: .space 20