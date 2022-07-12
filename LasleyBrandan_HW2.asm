# Student Name:     Brandan Tyler Lasley
# Student ID:       1214587374 
# Class #:          74300
# Assignment        2

.data 
prompt: .asciiz     "Enter a number from 1 to 5: "              # 0x00000000
prompt2: .asciiz    "Input is out of range\n"                   # 0x0000001D
_name:  .asciiz     "Brandan Lasley\n"                          # 0x00000034
exitstr:  .asciiz   "program complete\n"                        # 0x00000044
fstr:  .asciiz      "Enter the first number: "                  # 0x00000056
sstr:  .asciiz      "Enter the second number: "                 # 0x0000006F
absstr:  .asciiz    "Absolute value of the difference = "       # 0x00000089
sumstr:  .asciiz    "Sum of the values = "                      # 0x000000AD
sumerrstr:  .asciiz "Sum of values cannot be determined"        # 0x000000C2
newline: .asciiz    "\n"                                        # 0x000000E5  
.text 
.globl main 
main:
    lui  $s1, 0x1001                                            # set base address
    # Print name
    addi $a0, $s1, 0x34                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
prompt_loop:
    # Print prompt
    addi $a0, $s1, 0x00                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    # Input
    addi $v0, $0, 5                                             # set read int command
    syscall                                                     # get int from keyboard
    
    slti $t0, $v0, 6                                            # $t1 = $v0 < 6;
    slt  $t1, $zero, $v0                                        # $t1 = $v0 > 0;
    beq  $t0, $zero, error                                      # if ($t0 == zero) goto error
    beq  $t1, $zero, error                                      # if ($t1 == zero) goto error
    j valid                                                     # else goto valid
error:
    # Print error
    addi $a0, $s1, 0x1D                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    j prompt_loop                                               # There was an error, go back to the top of the loop,
valid:
    addi $s2, $v0, -1                                           # Subtract 1 because we start at 0.
    add $s3, $zero, $zero                                       # init $s3 to zero. 
startwhile:
    slt  $t3, $s2, $s3                                          # $s3 = $s2 < $s3;
    bne $t3, $zero, endwhile                                    # if ($s3 == 0) goto endwhile 
    
    # Print prompt
    addi $a0, $s1, 0x56                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    # Input
    addi $v0, $0, 5                                             # set read int command
    syscall                                                     # get int from keyboard
    add $t0, $zero, $v0                                         # move result of $v0 to $t0
    
    # Print prompt
    addi $a0, $s1, 0x6F                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print

    # Input
    addi $v0, $0, 5                                             # set read int command
    syscall                                                     # get int from keyboard
    add $t1, $zero, $v0                                         # move result of $v0 to $t0
    
    sub $t3, $t0, $t1                                           # General sub $t0 - $t1
    
    # Check if $t3 < 0
    slt  $t4, $zero, $t3                                        # $t4 = ($t3 < 0);
    beq  $t4, $zero, abst3                                      # if (!$t4) goto abst3
    j t3pos                                                     # elseif ($t4) goto t3pos
abst3:
    sub $t3, $zero, $t3                                         # Zero subtracted from a negative number is positive.
t3pos:
    # Print prompt
    addi $a0, $s1, 0x89                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    # Print Values $t3
    add $a0, $0, $t3                                            # load value of integer $t3
    addi $v0, $0, 1                                             # set command to print integer $t3
    syscall                                                     # call print integer    
    
    # Newline print
    addi $a0, $s1, 0xE5                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    beq $t0, $t1, skiploop                                      # if the inputs are equal skip the range sum.
    slt $t3, $t1, $t2                                           # $t3 = $t1 < $t2;
    bne $t3, $zero, fail                                        # if ($t3) goto fail
    add $t4, $zero, $t0                                         # Init $t4 to $t0 which is the first input.
top:
    addi $t4, $t4, 1                                            # t4++;
    add  $t0, $t0, $t4                                          # $t0 = $t0 + $t4
    bne  $t4, $t1, top                                          # if ($t4 != $t1) goto top // $t1 being the second input.
skiploop:
    # Print result
    addi $a0, $s1, 0xAD                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    # Print Values $t0
    add $a0, $0, $t0                                            # load value of integer $t0
    addi $v0, $0, 1                                             # set command to print integer $t0
    syscall                                                     # call print integer    
    j pass                                                      # We succeeded! Jump to the end of this while loop.
    
    #   if ($t0 <= $t1) 
    #   {
    #       Print the sum of the integers from the first integer THROUGH the second integer.
    #   } else {
    #       print an error message
    #   }
fail:
    # Print Error
    addi $a0, $s1, 0xC2                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
pass:
    # Newline print
    addi $a0, $s1, 0xE5                                         # set address of string
    addi $v0, $0, 4                                             # set command to print string
    syscall                                                     # call print
    
    addi $s3, $s3, 1                                            # $s3++;
    j startwhile                                                # Jump back to the start of the for loop.
endwhile:
    
# Print program complete
addi $a0, $s1, 0x44                                             # set address of string
addi $v0, $0, 4                                                 # set command to print string
syscall                                                         # Syscall to print string

# end of program
addi $v0, $0, 10                                                # set command to stop program
syscall                                                         # stop