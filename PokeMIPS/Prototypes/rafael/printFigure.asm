##
# Constants
##
.eqv	SCREEN_DIM_Y	256	# tamanho coluna
.eqv	SCREEN_DIM_X	512	# tamanho linha
.eqv	SCREEN_PIXEL0	0Xff000000

# Colors
.eqv	COLOR_BLUE	0x0000FF
.eqv	COLOR_GREEN	0x00FF00
.eqv	COLOR_RED	0xFF0000
.eqv	NO_COLOR	0x0F0F0F # my INVISIBLE ink

##
# Macros
##
.macro print_figure %x,%y,%width,%height,%imageAddress
	addi 	$a0,$0,%x			# X left top corner
	addi	$a1,$0,%y	# Y left top corner
	la	$v0,%imageAddress		# Color
	
	addi	$a2,$0,%width    	# width
	addi	$a3,$0,%height		# height
	jal	draw_figure
.end_macro

.macro print_rectangle %x,%y,%width,%height,%color
    addi    $a0,$0,%x           # X left top corner
    addi    $a1,$0,%y   # Y left top corner
    addi    $v0,$0,%color       # Color
    
    addi    $a2,$0,%width       # width
    addi    $a3,$0,%height      # height
    jal draw_rectangle
.end_macro

.data

POKEMON: 0x0000FF,0x0000FF,0x0000FF,0x0000FF

.text

main:
	print_rectangle 10,10,10,10,COLOR_BLUE
endmain:
	addi 	$v0,$0,10
	syscall

##
# Print a rectangle on the screen
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $s0 x temp position
# $s1 y temp position
# $s2 color
# $t3 counter
# $t4 address to print
# $t7 temporary
# $s3 x end position
# $s4 y end position
#
#
# @TODO Verify bug : it dont't work well with some jump instruction before
#
##
draw_rectangle:
    addi $sp, $sp, -52
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $t3, 32($sp)
    sw $t4, 36($sp)
    sw $t7, 48($sp)
    sw $s3, 52($sp)
    sw $s4, 56($sp)

draw_rectangle.init:
    add   $s0,$0,$a0  # Start x
    add   $s1,$0,$a1  # Start y
    add   $s3,$s0,$a2 # end x
    add   $s4,$s1,$a3 # end y
    add   $s2,$0,$v0  # color

draw_rectangle.loopY: 
draw_rectangle.loopX:

    # Calculate Pixel's Adress:
    addi  $t3,$0,SCREEN_DIM_X
    mul   $t3,$t3,$s0
    add   $t3,$t3,$s1   # X*SCREEN_X + Y
    sll   $t4,$t3,2
    add   $t4,$t4,SCREEN_PIXEL0

draw_rectangle.drawPixel:
    sw    $s2,0($t4)    # Draw a pixel

draw_rectangle.nextPixel:
    addi  $s0,$s0,1 # X++
    slt   $t7,$s0,$s3   # lim x
    bne   $t7,$0,draw_rectangle.loopX
end.draw_rectangle.loopX:
    add   $s0,$0,$a0    # X = X0
    addi  $s1,$s1,1 # Y++
    slt   $t7,$s1,$s4   # lim y
    bne   $t7,$0,draw_rectangle.loopY
end.draw_rectangle.loopY:
end.draw_rectangle:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $t3, 32($sp)
    lw $t4, 36($sp)
    lw $t7, 48($sp)
    lw $s3, 52($sp)
    lw $s4, 56($sp)

    addi $sp, $sp, 52
    add  $v0,$0,$0
    jr  $ra

##
# Print a figure on the screen
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $s0 x temp position
# $s1 y temp position
# $s2 color
# $t3 counter
# $t4 address to print
# $t7 temporary
# $s3 x end position
# $s4 y end position
#
#
# @TODO Verify bug : it dont't work well with some jump instruction before
#
##
draw_figure:
    addi $sp, $sp, -52
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $t3, 32($sp)
    sw $t4, 36($sp)
    sw $t7, 48($sp)
    sw $s3, 52($sp)
    sw $s4, 56($sp)

draw_figure.init:
	add   $s0,$0,$a0  # Start x
	add   $s1,$0,$a1  # Start y
	add   $s3,$s0,$a2 # end x
	add   $s4,$s1,$a3 # end y
	add   $s2,$0,$v0  # address colors

draw_figure.loopY: 
draw_figure.loopX:
#	slt   $t7,$s0,$0
#	bne   $t7,$0,draw_figure.nextPixel
#	slt   $t7,$s1,$0
#	bne   $t7,$0,draw_figure.nextPixel
#	slti  $t7,$s0,SCREEN_X
#	beq   $t7,$0,draw_figure.nextPixel
#	slti  $t7,$s1,SCREEN_Y
#	beq   $t7,$0,draw_figure.nextPixel

	# Calculate Pixel's Adress:
	addi  $t3,$0,SCREEN_DIM_X
	mul   $t3,$t3,$s0
	add   $t3,$t3,$s1	# X*SCREEN_X + Y
	sll   $t4,$t3,2
	add   $t4,$t4,SCREEN_PIXEL0

	lw    $t7,0($s2)
	addi  $t8,$0,NO_COLOR
	beq   $t7,$t8,draw_figure.nextPixel

draw_figure.drawPixel:
	sw    $t7,0($t4)	# Draw a pixel

draw_figure.nextPixel:
	addi   $s2,$s2,4
	addi  $s0,$s0,1	# X++
	slt   $t7,$s0,$s3	# lim x
	bne   $t7,$0,draw_figure.loopX
end.draw_figure.loopX:
	add   $s0,$0,$a0	# X = X0
	addi  $s1,$s1,1	# Y++
	slt   $t7,$s1,$s4	# lim y
	bne   $t7,$0,draw_figure.loopY
end.draw_figure.loopY:
end.draw_figure:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $t3, 32($sp)
    lw $t4, 36($sp)
    lw $t7, 48($sp)
    lw $s3, 52($sp)
    lw $s4, 56($sp)

    addi $sp, $sp, 52
    add	 $v0,$0,$0
    jr	$ra
