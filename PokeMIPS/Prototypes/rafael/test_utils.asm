##
# PokeMIPS - Test Utils
# "Test Routine for Utils"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

.include utils.s

.data
MSG1:  .asciiz "Hello PokeMIPS!"

.text
main:
    

end.main:
    drawtextbox 20,10,MSG1
    
    j    end.main