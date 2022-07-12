.data
numbers:        .space 40
myname:         .asciiz "Brandan Lasley\n"
prompt:         .asciiz "Enter a number "
avgres:         .asciiz "The average is "
responsep1:     .asciiz "\nThere are "
responsep2:     .asciiz " numbers greater than or equal to the average."

.text
.globl main
main:
    lui $s0, 0x1001                         # Load 0x1001 to upper of $s0
    
    # Print result
    addi $a0, $s0, 0x28                     # set address of string
    addi $v0, $0, 4                         # set command to print string
    syscall                                 # Syscall
    
	add $a0, $0, $s0                        #put address of array into parameter $a0
	jal readData	                        #call readdata function
	ori $a1, $v0, 0	                        #save number of integers read into $s1
    
	add $a0, $0, $s0                        #put address of array into parameter $a0
	jal count	                            #call count function
  
	ori $v0, $0, 10	                        #set command to end program
	syscall		                            #end program

count:
    addi $sp, $sp, -4                       # allocate space
    sw $ra, 0($sp)                          # Save RA
    # $a0 = address of numbers
    # $a1 = count
    add $t7, $0, $a0
    
	jal average	                            #call average function
    
    # Print result
    addi $a0, $t7, 0x48                     # set address of string
    addi $v0, $0, 4                         # set command to print string
    syscall                                 # Syscall

    mov.s $f12, $f0                         # $f12 = $f0
    addi $v0, $0, 2                         # set command to float
    syscall                                 # Syscall
    add $t8, $0, $0                         # Init to zero
    add $t0, $0, $0                         # Init to zero
    add $a0, $0, $t7
top_count_loop:
    slt $t3, $t0, $a1                       # $t3 = $t0 < $a1;
    beq $t3, $zero, end_count_loop          # if ($t3 == 0) goto end_avg_loop 
    
    lw $v0, 0($a0)                          # Load $v0 from address of $a0

    #########################
    # $f0 contains avg
    # $v0 contains current val
    # $f1 will be tmp val
    # $t8 will be result
    # if ($f1 > $f0) then jump!
    mtc1 $v0, $f1                           # Move reg to coprocessor
    cvt.s.w $f1, $f1                        # Convert 
    
    c.lt.s $f1, $f0                         # $f1 < $f0
    bc1t nope                               # if ($f1 >= $f0) jump to nope.
    addi $t8, $t8, 1                        # $t8++
    #########################
    
nope:
    addi $a0, $a0, 4                        # 4 bytes
    addi $t0, $t0, 1                        # $t0++
    j top_count_loop                        # Jump back to top
end_count_loop:
    # Print result
    addi $a0, $t7, 0x58                     # set address of string
    addi $v0, $0, 4                         # set command to print string
    syscall                                 # Syscall
    
    # Print Values $s2
    add $a0, $0, $t8                        # load value of integer $t8
    addi $v0, $0, 1                         # set command to print integer $t8
    syscall                                 # call print integer
    
    # Print result
    addi $a0, $t7, 0x64                     # set address of string
    addi $v0, $0, 4                         # set command to print string
    syscall  
    
    lw $ra, 0($sp)                          # load RA
    addi $sp, $sp, 4                        # deallocate space
    jr $ra                                  # Return    
average:
    # $a0 = address of numbers
    # $a1 = count
    # $f0 = avg (result/return)
    # avg = sum(all numbers)/count
    
    # $t0 will be tmp count starting at zero to $a1
    # $t1 will be sum of all numbers
    add $t1, $0, $0                         # Init to zero
    add $t0, $0, $0                         # Init to zero
    beq $a1, $zero, end_avg_loop            # if ($a1 == 0) goto weird_condition 
top_avg_loop:
    slt $t3, $t0, $a1                       # $t3 = $t0 < $a1;
    beq $t3, $zero, end_avg_loop            # if ($t3 == 0) goto end_avg_loop 
    
    lw $v0, 0($a0)                          # Load $v0 from address of $a0
    add $t1, $t1, $v0                       # $t1 = $t1 + $v0 
    
    addi $a0, $a0, 4                        # 4 bytes
    addi $t0, $t0, 1                        # $t0++
    j top_avg_loop                          # Jump back to top
end_avg_loop:
    mtc1 $t1, $f0                           # Move reg to coprocessor
    mtc1 $a1, $f1                           # Move reg to coprocessor
    cvt.s.w $f0, $f0                        # Convert 
    cvt.s.w $f1, $f1                        # Convert 
    
    div.s $f0,$f0,$f1                       # $f0 = $f0 / $f1
    jr $ra
weird_condition:
    mtc1 $0, $f0                            # Move reg to coprocessor
    jr $ra                                  # Return
readData:
    addi $t9, $a0, 0x38                     # set address of string
    add  $t8, $0, $a0                       # $t8 = $a0
    addi $t0, $0, 10                        # Store result
    add $t1, $0, $0                         # init $t1 to zero
    # while ($t1 < $t0)
top_while:
    slt $t3, $t1, $t0                       # $t3 = $t1 < $t0;
    beq $t3, $zero, end_while               # if ($t3 == 0) goto endwhile 

    # Print prompt
    add $a0, $0, $t9                        # set address of string
    addi $v0, $0, 4                         # set command to print string
    syscall                                 # Syscall
    
    # Input
    addi $v0, $0, 5                         # set read int command
    syscall                                 # get int from keyboard
    beq $v0, $zero, end_while               # if ($v0 == 0) goto endwhile 
    sw $v0, 0($t8)                          # Save $v0 to address of $a0
    
    addi $t8, $t8, 4                        # 4 bytes
    addi $t1, $t1, 1                        # $t1++
    j top_while                             # Jump to top of while loop
end_while:
    add $v0, $0, $t1                        # Return $t1  
    jr $ra                                  # Return    