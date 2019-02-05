#Vignere Cipher

.data
givenkey: .asciiz "The given key is:"
giventext:  .asciiz "\nThe given text is:"
encodetext: .asciiz "\nThe Encrypted text is:"
decodetext: .asciiz "\nThe Decrypted text is:"
array:  .space 404 #sets up array
.text

main:
move $s0,$a1 #stores program argument in s0
move $s1,$a1 #stores program argument in s1
lw $s0,($s0) #loads address of key into s1
#$s0 now contains address of Key String
la $a0,givenkey
li $v0,4
syscall
la $a0,($s0)
li $v0,4
syscall
#print out given key message and given key

addi $s1,$s1,4
lw $s1,($s1)
#$s1 now contains address of Text String


la $a0,giventext
li $v0,4
syscall
la $a0,($s1)
li $v0,4
syscall

jal encode
jal decode

li $v0,10
syscall

encode:
la $a0,encodetext #print out encodemsg
li $v0,4
syscall
move $s3,$s0
move $s4,$s1
encoder:
lb $t1,($s3)
bnez $t1,resetkey
move $s3,$s0
lb $t1,($s3)
#loops key
resetkey:

lb $t2,($s4)
beqz $t2,endencoder
add $t0,$t1,$t2
blt $t0,128,lessthan128
subi $t0,$t0,128
#check <128
lessthan128:
la $a0,($t0)
li $v0,11
syscall
#print out encoded character

sb $t0,array($s5)
addi $s5,$s5,1
#stores encrypted value into array

addi $s3,$s3,1
addi $s4,$s4,1
j encoder


endencoder:
jr $ra


decode:
la $a0,decodetext #print out encodemsg
li $v0,4
syscall
move $s5,$zero
move $s6,$s0
decoder:
lb $t1,($s6)
bnez $t1,resetkey2
move $s6,$s0
lb $t1,($s6)
#loops key
resetkey2:


lb $t2,array($s5)
beqz $t2,enddecoder

sub $t0,$t2,$t1
bgtz $t0,greaterthan0
addi $t0,$t0,128

greaterthan0:
la $a0,($t0)
li $v0,11
syscall
addi $s6,$s6,1
addi $s5,$s5,1
b decoder
enddecoder:

jr $ra
