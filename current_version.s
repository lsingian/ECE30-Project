#Test cases to consider:
#The list only has 0 or 1 length
#Duplicate numbers in the list
#Negative numbers in the list
#Order of the stack

######################
#                    #
# Project Submission #
#                    #
######################

# Partner1: (Eric Brown), (A13764939)
# Partner2: (Lawrence Singian), (A13225295)



.data
array:	.word 5, 8, 1, 9, 3, 4, 2, 6

init:	.asciiz "The initial array is: "
final:	.asciiz "The sorted array is: "
comma:	.asciiz ", "
newline:.asciiz "\n"

.text
.globl main

########################
#        main          #
########################

main:
	# Print the array
	la $a0,array
	la $a1,init
	li $a2,8
	jal printList

	# Quicksort
	la $a0,array
	li $a1,2
	li $a2,6
	jal medianOfThree

	# Print the sorted array
	la $a0,array
	la $a1,final
	li $a2,8
	jal printList


exit:	li $v0,10
	syscall


#########################
#        swap          #
########################
swap:
	# a0: base address
	# a1: index 1
	# a2: index 2
	# Swap the elements at the given indices in the list

	### INSERT YOUR CODE HERE

#save t0 and t1 before call

#don't worry about return address
	addi $sp, $sp, -20 #make space on stack
	sw $s0, 20($sp) #storing values/organization
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $fp, 4($sp)
	addi $fp, $fp, -20

#body of swap function

#loading value from x[lo]
	sll $a1, $a1, 2 #multiply index by offset constant 4
	add $t0, $a1, $a0 #address of x[lo] is now stored in t0 : x[lo] = *x[0]+offset
	lw $s1, 0($t0) #our actual value from x[lo] is now stored in s1

#repeating above for x[hi]

	sll $a2, $a2, 2
	add $t1, $a2, $a0 #store the address of x[hi0] at t1 temporarily
	lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]


	addi $s0, $s2, 0 #temp variable for hi value
	addi $s2, $s1, 0  #storing low value in high value register
	addi $s1, $s0, 0  #storing hi value into low register
	sw $s1, 0($t0) #saving hi value into low address
	sw $s2, 0($t1) #saving low value into high address

#more organization
	lw $s0, 20($sp) #storing values/organization
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $fp, 4($sp)
	addi $sp, $sp, 20
# return to caller
	jr $ra


	########################
	#   medianOfThree      #
	########################
	medianOfThree:

		### INSERT YOUR CODE HERE

		#orgaizational calle business

	addi $sp , $sp, -60 #tbd how far to increment the stack pointer
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $fp, 4($sp)
	addi $fp, $fp, -60


	#calculating midpoint value

	add $s0, $a1, $a2 #s0 = lo+hi
	li $t0, 2
	div $s0, $t0 #(lo+hi)/2
	mflo $s0 #loads value into register srl didn't seem to work


	#now we will worry about getting values from our indexed addresses
	#at least for the first conditional

	#loading value from x[lo]

	sll $t0, $a1, 2
	add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
	lw $s1, 0($t1) #our actual value from x[lo] is now stored in s1

	#repeating above for x[hi]

	sll $t0, $a2, 2 #this time we use the index for x[high]/ ie the right value
	add $t1, $t0, $a0
	lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]


	#repeat for x[mid]

	sll $t0, $s0, 2
	add $t1, $t0, $a0
	lw $s3, 0($t1) #load to s3 the value stored in memory x[mid]

	# so now we have :
	#val x[lo] stored in s1
	#val x[hi] stored in s2
	#val x[mid] stored in s3

	###############################################################################
	# if(x[lo]>x[hi]) swap(x,lo,hi)
	slt $t2, $s2, $s1 #evaluate x[hi] <x[lo]
	addi $t2, $t2, -1 #so if x[hi]<x[lo] t2 = 0 else t2 = -1

	#the reason I did this was because we have a pseduo instruction that will evaluate
	#then jump and link to our swap function so it saves time for us

	#orgaizational for caller before call

	sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	sw $t1, 32($sp)
	sw $t2, 36($sp)

	sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	sw $a1 , 44($sp)
	sw $a2 , 48($sp)

	sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

	#inputs to the swap function are already set because they are the same as for
	#Median of Three

	#jump to swap(x,lo,hi)
	bgezal $t2 swap #branch on greater than or equal to zero and link

	#return from calle orgaizational; mostly useless but will we get docked without it

	lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	lw $a1 , 44($sp)
	lw $a2 , 48($sp)


	################################################################################
	# if(x[mid]>x[hi]) swap(x,mid,hi)

	#need to reload the value at x[hi] since things have now been swapped

	sll $t0, $a2, 2 #this time we use the index for x[high]/ ie the right value
	add $t1, $t0, $a0
	lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]

	#mid is still the same value as before

	slt $t2, $s2, $s3 #compare x[hi]<x[mid]
	addi $t2, $t2, -1 #same trick as before

	#caller responsibilities
	sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	sw $t1, 32($sp)
	sw $t2, 36($sp)

	sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	sw $a1 , 44($sp)
	sw $a2 , 48($sp)

	sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

	#this time we do need to change some things around when passing to swap
	#$a0 is still the first address of the array
	addi $a1, $s0, 0 #passing midpoint index to a1
	#a2 is still holding our hi index values

	bgezal $t2, swap #same jump trick as previously described

	#return from calle orgaizational; mostly useless but will we get docked without it

	lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	lw $t1, 32($sp)
	lw $t2, 36($sp)

	lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	lw $a1 , 44($sp)
	lw $a2 , 48($sp)
	###############################################################################
	#if(x[lo]>x[mid]) swap(x,lo,mid)

	#reloading values from x[lo] and x[mid] into s1 and s3 respectively
	sll $t0, $a1, 2 #multiply index by 4
	add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
	lw $s1, 0($t1) #our actual value from x[lo] is now stored in s1

	sll $t0 $s0, 2 #this time we use the index for x[mid] that we stored in $s0
	add $t1, $t0, $a0
	lw $s3, 0($t1) #load to s3 the value stored in memory x[mid]


	slt $t2, $s3, $s1 #comparing x[mid]<x[lo]
	addi $t2, $t2, -1

	#caller responsibilities
	sw $t0 ,28($sp) #not sure that we actually care about the t vals; just following convention
	sw $t1 ,32($sp)
	sw $t2 ,36($sp)

	sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	sw $a1 , 44($sp)
	sw $a2 , 48($sp)

	sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

	#updating parameters passed to swap
	addi $a2, $s0, 0 #passing midpoint index to a2
	#a1 should still be the index of x[lo]

	bgezal $t2, swap #same jump trick as previously described

	#caller return responsibilities
	lw $t0 ,28($sp) #not sure that we actually care about the t vals; just following convention
	lw $t1 ,32($sp)
	lw $t2 ,36($sp)

	lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	lw $a1 , 44($sp)
	lw $a2 , 48($sp)
	###############################################################################
	#swap(x,lo,mid).

	#caller responsibilities
	sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	sw $t1, 32($sp)
	sw $t2, 36($sp)

	sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	sw $a1 , 44($sp)
	sw $a2 , 48($sp)

	sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

	#updating parameters passed to swap
	addi $a2, $s0, 0 #passing midpoint index to a2
	#a1 should still be the index of x[lo]

	jal		swap				# jump to swap and save position to $ra


	#caller return responsibilities
	lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
	lw $t1, 32($sp)
	lw $t2, 36($sp)

	lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
	lw $a1 , 44($sp)
	lw $a2 , 48($sp)

	#calle return responsibilities
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $ra, 24($sp)
	lw $fp, 4($sp)
	addi $sp, $sp, 24 #move the stacker pointer to pop it off
		# return to caller
		jr $ra


########################
#      quickSort       #
########################
quickSort:
	# a0: base address
	# a1: left  = first index to be sorted
	# a2: right = last index to be sorted
	# Sort the list using recursive quick sort using the above functions

	#organizational tasks

	#median of three pivot; first set of inputs should already be set and
  #have been passed to quicksort on call

  sub $t0, $a2, $a1 #a2-a1 = numElements in list
  slti $t1, $t0, 2 #if a2-a1 < <2 set a flag
  bnez $t1, quickSortEnd #return to caller if elements less than 2, ie sorted already

  #if we have a valid list then we can jump to median of three
  #pre call organization; is this necesarry because our function is meant to
  #overwrite these value entirely
  sw $a0, offset($sp)
  sw $a1, offset($sp)
  sw $a2, offset($sp)

  jal medianOfThree

  sll $s0, $a1, 2 #multiply a2 by 4 to get offset to load value there
  add $t0, $a0, $s0 #we are now finding the address of x[first]
  lw $a3, 0($t0) #loading value from x[first] to $a3 which is the pivot and upcoming argument

  #pre partion call organization
  sw $a0, offset($sp)
  sw $a1, offset($sp)
  sw $a2, offset($sp)
  sw $a3, offset($sp)
  #preparing input arguments to partition
  #a0 is still a0 from last argument
  addi $a1, $a1, 1 #partion element 2 is first + 1
  #a2 is not touched
  #a3 is set above and ready to go

  #partition
	jal partition

  #return from call organization
  lw $a0, offset($sp)
  lw $a1, offset($sp)
  lw $a2, offset($sp)
  lw $a3, offset($sp)

  addi $s0, $v0, -1 #index = partition return value -1

  sw $a2, offset($sp) #save last because we need to call swap with index as a2
  addi $a2, $s0, 0 #load index into swap's 3rd parameter

  jal swap

  #post call organization
  lw $a2 , offset($sp)

	#recursion conditions until finished

  #left partition

  #precall organization
  #a0 is still a0
  #a1 is still a1
  sw $a2, offset($sp)
  addi $a2, $s0, -1 #making quicksort param2 = index-1
	jal quickSort

  #post call organization
  lw $a2, offset($sp)

  #right partition
  #a0 is still a0
  #a2 is still a2
  sw $a1, offset($sp)
  addi $a1, $s0, 1 #making quicksort param1 = index+1
  jal quickSort

  # return to caller
  quickSortEnd:
  jr $ra




########################
#      printList       #
########################
printList:
	# a0: base address
	# a1: message to be printed
	# a2: length of the array
	add $t0,$a0,$0
	add $t1,$a2,$0

	li $v0,4
	add $a0,$a1,$0
	syscall			#Print message


next:
	lw $a0,0($t0)
	li $v0,1
	syscall			#Print int

	addi $t1,$t1,-1
	bgt $t1,$0,pnext
	li $v0,4		# if end of list
	la $a0,newline		# Print newline
	syscall
	jr $ra
pnext:	addi $t0,$t0,4
	li $v0,4
	la $a0,comma
	syscall			# Print comma
	j next
