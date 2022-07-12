.data
numbers: .space 80	#declare 80 bytes of storage to hold array of 20 integers
prompt:  .asciiz "How many values to read? "
space:   .asciiz " "
	
	.text
	.globl main
main:
	
#read data into array
	lui $a0, 0x1001	#put address of array into parameter $a0
	jal readData	#call readdata function
	ori $s0, $v0, 0	#save number of integers read into $s0

#print array
	lui $a0, 0x1001	#put address of array into parameter $a0
	ori $a1, $s0, 0	#put count into parameter	
	jal print		#call print function

#sort array
	lui $a0, 0x1001	#put address of array into parameter $a0
	ori $a1, $s0, 0	#put count into parameter	
	jal sort		#call sort function

#print array
	lui $a0, 0x1001	#put address of array into parameter $a0
	ori $a1, $s0, 0	#put count into parameter	
	jal print		#call print function
#exit	
	ori $v0, $0, 10	#set command to end program
	syscall		#end program

#function swap is called by sort
#$a0 holds address of one integer
#$a1 holds address of another integer
swap:
	lw $t0, 0($a0)	#get first value
	lw $t1, 0($a1)	#get second value
	sw $t0, 0($a1)	#store first value
	sw $t1, 0($a0)  #store second value
	jr   $ra

readData:
    # Get number of promps
    # Print result
    addi $a0, $a0, 0x50                                             # set address of string
    addi $v0, $0, 4                                                 # set command to print string
    syscall   # Syscall
    
    addi $a0, $a0, -0x50    # Subtract the str ptr from $a0
        
    # Input
    addi $v0, $0, 5                                                 # set read int command
    syscall                                                         # get int from keyboard
    add $t0, $v0, $0 # Store result
    add $t1, $0, $0 # init $t1 to zero
    # while ($t1 < $t0)
top_while:
    slt $t3, $t1, $t0                                               # $t3 = $t1 < $t0;
    beq $t3, $zero, end_while                                       # if ($t3 == 0) goto endwhile 

    # Input
    addi $v0, $0, 5                                                 # set read int command
    syscall                                                         # get int from keyboard
    sw $v0, 0($a0) # Save $v0 to address of $a0
    
    addi $a0, $a0, 4                                                # 4 bytes
    addi $t1, $t1, 1 # $t1++
    j top_while # Jump to top of while loop
end_while:
    add $v0, $0, $t0 # Return $t0
    jr $ra # Return
    
print:
    add $t4, $a0, $0 # Init to a0
    add $t5, $t4, $0 # Init to t4
    add $t0, $a1, $0# Init to a1
    add $t1, $0, $0 # Init to zero
    # while ($t1 < $t0)
top_while2:
    slt $t3, $t1, $t0                                               # $t3 = $t1 < $t0;
    beq $t3, $zero, end_while2                                      # if ($t3 != 0) goto endwhile 

    # Input
    lw $a0, 0($t5)  # Load $t5 to $a0
    addi $v0, $0, 1                                                 # set print int command
    syscall                                                         # get int from keyboard
    
    # Print space
    add $a0, $t4, $0            # $a0 = $t4
    addi $a0, $a0, 0x6A                                             # set address of string
    addi $v0, $0, 4                                                 # set command to print string
    syscall # Syscall   

    addi $t5, $t5, 4                                                # 4 bytes
    addi $t1, $t1, 1 # $t1++
    j top_while2 # Jump to the top of while loop
end_while2:
    add $v0, $0, $t0 # Return $t0
    jr $ra # Return
    
sort:
    addi $sp, $sp, -12 # allocate space
    sw $ra, 0($sp) # Save RA
    sw $s0, 4($sp) # Save s0
    sw $s1, 8($sp) # Save s1
    add $t9, $0, $a0 # $t9 = $a0
    addi $t0, $a1, -1 # #t0 = $a1 - 1
    addi $t1, $0, 1 #$t1++ 
    
    add $t7, $0, $a0 # init $t8 to $a0
    add $t8, $0, $a0 # init $t8 to $a0
    add $t4, $0, $0 # init $t4 to zero
    
dumb_loop:
    slt $t3, $t4, $t0                                               # $t3 = $t1 < $t0;
    beq $t3, $zero, end_dumb_loop                                   # if ($t3 == 0) goto end_dumb_loop 
    addi $t8, $t8, 4 # add 4 to $t8
    addi $t4, $t4, 1 # add 1 to $t4
    j dumb_loop # Jump back to the top of the loop
end_dumb_loop:
    
start_for_1:
    beq $t0, $0, end_for_1
    addi $t1, $0, 1 # init $t1 to 1.
    start_for_2: 
        slt $t3, $t1, $t0 # $t3 = $t0 < $t3
        beq $t0, $t1, end_for_2 # if ($t0 == $t1) goto end_for_2
        beq $t3, $0,  end_for_2 # if ($t0 == $t1) goto end_for_2
        
        lw $t3, 0($t8) # Load word from address $t8 to $t3
        lw $t4, 0($t7)# Load word from address $t7 to $t4
        
        slt $t9, $t4, $t3                                               # $t9 = $t4 < $t3;
        bne $t9, $zero, skip                                            # if ($t9 == 0) goto skip 
        
        add $s0, $0, $t0 # Save $t0 to $s0
        add $s1, $0, $t1 # Save $t1 to $s1
        
        add $a0, $t8, $0 # Save $t8 address to $a0
        add $a1, $t7, $0# Save $t7 address to $a0
        jal swap								                        #call swap function
        
        add $t0, $0, $s0 # Restore  $t0 from $s0
        add $t1, $0, $s1 # Restore $t1 from $s1
skip:
        addi $t7, $t7, 4    # Add 4 to t7
        addi $t1, $t1, 1    # Add 1 to $t1
        j start_for_2 # Jump to the start of for loop 2
    end_for_2:
    addi $t8, $t8, -4                                               # Subtract 4 from $t8
    addi $t0, $t0, -1                                               # Subtract 1 from $t0
    j start_for_1 # Jump to the start of for loop 1
end_for_1:


    lw $ra, 0($sp)                                                   # Restore $ra from stack
    lw $s0, 4($sp)                                                   # Restore $s0 from stack                                             
    lw $s1, 8($sp)                                                   # Restore $s1 from stack
    addi $sp, $sp, 12                                                # deallocate space
    jr $ra   # Return