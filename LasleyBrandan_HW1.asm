# Student Name:                             Brandan Tyler Lasley
# Student ID:                               1214587374 
# Class #:                                  74300
# Assignment                                1

.data 
val1:   .word       0                       # 0x00000000
val2:   .word       0                       # 0x00000004
val3:   .word       0                       # 0x00000008
val4:   .word       0                       # 0x0000000C
class:  .asciiz     "CSE/EEE230\n"          # 0x00000010
prompt: .asciiz     "Enter a number: "      # 0x0000001C
_name:  .asciiz     "Brandan Lasley\n"      # 0x0000002D -- Newline at 0x0000003B

.text 
.globl main 
main:
    lui  $t0, 0x1001                        # set base address
    addi $a0, $t0, 0x10                     # set address of string class
    addi $v0, $0, 4                         # set command to print string class
    syscall                                 # print string class
    
    addi $t1, $0, 1                         # set constant 1
    sw $t1, 0($t0)                          # store value in first word
    addi $t1, $t1, 1                        # increment value
    sw $t1, 4($t0)                          # store value in second word
    addi $t2, $0, 3                         # set 3 to t2 for subtraction 
    sub $t1, $t1, $t2                       # subtract 3 from second word
    sw $t1, 8($t0)                          # store value in third word 

    # New code begins here.
    addi $s0, $0, 10                        # set s0 to 10

    # Print Prompt
    addi $a0, $t0, 0x1C                     # set address of string prompt
    addi $v0, $0, 4                         # set command to print string prompt
    syscall                                 # print string prompt

    # Input
    addi $v0, $0, 5                         # set read int command
    syscall                                 # get int from keyboard
    add $s1, $0, $v0                        # store returned int into $s1

    # Print Prompt
    addi $a0, $t0, 0x1C                     # set address of string prompt
    addi $v0, $0, 4                         # set command to print string prompt
    syscall                                 # print string prompt

    # Input
    addi $v0, $0, 5                         # set read int command
    syscall                                 # get int from keyboard
    add $s2, $0, $v0                        # store returned int into $s1

    # Calculate ($s0 - $s1) + $s2
    sub $t3, $s0, $s1                       # $s0 - $s1 result stored in $t3
    add $t3, $t3, $s2                       # $t3 = $t3 + $s2
    sw  $t3, 12($t0)                        # store value in fourth word 

    # Print _name
    addi $a0, $t0, 0x2D                     # set address of string _name
    addi $v0, $0, 4                         # set command to print string _name
    syscall                                 # print string _name

    # Print val4
    lw   $a0, 12($t0)                       # load value of integer val4
    addi $v0, $0, 1                         # set command to print integer val4
    syscall                                 # print integer val4

    # Print newline
    addi $a0, $t0, 0x3B                     # set address of string newline
    addi $v0, $0, 4                         # set command to print string newline
    syscall                                 # call print string    

    # Swap
    add $t3, $0, $s1                        # Put value of $s1 into $t3
    add $s1, $0, $s2                        # Copy value of $s2 into $s1
    add $s2, $0, $t3                        # Copy value of $t3 into $s1

    # Convert reg to neg
    add $t3, $0, $s0                        # Set $t3 to negative $s0 (aka 10)
    sub  $s0, $s0, $t3                      # Subtract $s0 by $t3
    sub  $s0, $s0, $t3                      # Subtract $s0 by $t3 

    # Print Value $s1
    add $a0, $0, $s0                        # load value of integer $s1
    addi $v0, $0, 1                         # set command to print integer $s1
    syscall                                 # call print integer    

    # Print newline
    addi $a0, $t0, 0x3B                     # set address of string newline
    addi $v0, $0, 4                         # set command to print string newline
    syscall                                 # call print string

    # Print Values $s2
    add $a0, $0, $s1                        # load value of integer $s1
    addi $v0, $0, 1                         # set command to print integer $s1
    syscall                                 # call print integer    

    # Print newline
    addi $a0, $t0, 0x3B                     # set address of string newline
    addi $v0, $0, 4                         # set command to print string newline
    syscall                                 # call print string                

    # Print Values $s3
    add $a0, $0, $s2                        # load value of integer $s1
    addi $v0, $0, 1                         # set command to print integer $s1
    syscall                                 # call print integer        
    
# end of program
addi $v0, $0, 10                            # set command to stop program
syscall                                     # stop