## 
# Laboratorio 1 - Baskhara
# /Version 
# /Authors

##
# Macros
##

.eqv A $f0
.eqv B $f2
.eqv C $f4
.eqv u1 $a0
.eqv u2 $a1
.eqv u3 $a2
 

mtc1 u1, A
cvt.d.w A, A
sw A, 0($sp)

mtc1 u2, B
cvt.d.w B, B
mtc1 u2, C
cvt.d.w C, C

if B*B>4*A*C

