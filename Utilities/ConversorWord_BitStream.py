#!/usr/bin/python

import sys, getopt

##
# Conversor from asm mips words to binary big endian
# @author Rafael
# @version 0.01
##

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
       opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
       print 'test.py -i <inputfile> -o <outputfile>'
       sys.exit(2)
    for opt, arg in opts:
       if opt == '-h':
          print 'test.py -i <inputfile> -o <outputfile>'
          sys.exit()
       elif opt in ("-i", "--ifile"):
          inputfile = arg
       elif opt in ("-o", "--ofile"):
          outputfile = arg
    print 'Processing file "', inputfile,'"'

    # Read File
    mFile = open(inputfile,'r')        # Open File
    fileData = '\n'+mFile.read()             # Read File

    # Break into substrings
    vectorLines =  ''.join(fileData.split())
    vectorLines = vectorLines.split(".word 0x")
    newVectorLine = vectorLines

    # take each substring and invert number
    # and Glue Everithing together
    for i in range(len(vectorLines)):
        line = vectorLines[i]            # Get each substring
        newVectorLine[i] = ''
        if(line.find(':')==-1):            # Check if is label
            # Change to bigendian
            newline = str(chr(int(line[6:8],16))) + str(chr(int(line[4:6],16)))+str(chr(int(line[2:4],16)))+str(chr(int(line[0:2],16)))
            newVectorLine[i] = newline

    # Make a new file
    mNewFile = open(outputfile,'w')
    mNewFile.write(''.join(newVectorLine))
    mNewFile.close()
    mFile.close()
    print 'Output file is "', outputfile,'"'

if __name__ == "__main__":
   main(sys.argv[1:])
