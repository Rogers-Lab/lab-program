##DNAmaker automatically creates DNA strands with given properties.
##The output of this script is a sequence of bases (ex: AACTTAGTC)
##strandSize sets how many bases you want in your DNA.
##wordSize sets how many bases per word you want
##no_gc sets conditions on the g and c bases.
##    0: No restrictions
##    1: No G bases
##    2: No C bases
##    3: No GC or CG pairs
##Set checkTriplets to 1 to not include triple bases (AAA, etc)

import random
import datetime

strandSize = int(input('Enter the number of bases in your sequence: '))
wordSize = int(input('Enter the number of bases per word (>3): '))
print('no_gc = 0, No restrictions. 1, no G bases. 2, no c bases. 3, no gc or cg pairs.')
no_gc = int(input('Enter a no_gc value: '))
totalStrandNumber = int(input('How many sequences with these settings do you want to generate?:'))
verbose = 0
checkTriplets = 1
strandNumber = 1
bungis=open(str(datetime.date.today())+'.txt', 'a')

#This function is used to randomly select a base
def getByte(randCheck):
    while randCheck[4] == 0:
        byte=''
        rbyte=random.randint(0,3)
        #randCheck ensures program does not keep selecting invalid bases
        if rbyte == 0 and randCheck[0] == 0: byte = 'A'
        if rbyte == 1 and randCheck[1] == 0: byte = 'T'
        if rbyte == 2 and randCheck[2] == 0: byte = 'C'
        if rbyte == 3 and randCheck[3] == 0: byte = 'G'
        if byte == 'A' or byte == 'T' or byte == 'C' or byte == 'G': return byte
        #If no bases are valid, stop the program and output what it can
        elif randCheck == [1,1,1,1,0]:
            byte = 'X'
            currentByteNumber = strandSize+1
            randCheck[4] = 1
            return byte

#Eliminate checked bases from being checked again to save computation time
def randEliminate(byte,randCheck):
    if byte == 'A': randCheck[0] = 1
    if byte == 'T': randCheck[1] = 1
    if byte == 'C': randCheck[2] = 1
    if byte == 'G': randCheck[3] = 1
    return randCheck

#Checks if new base is valid given no_gc value
def gcChecker(byte,DNA):
    if no_gc == 0:
        return 1
    if no_gc == 1:
        if byte == 'G':
            return 0
    if no_gc == 2:
        if byte == 'C':
            return 0
    if no_gc == 3:
        if byte == 'C' and DNA[-1] == 'G' or byte == 'G' and DNA[-1] == 'C':
            return 0
    return 1

#Checks if new base will form a triplet
def tripletChecker(byte,DNA):
    if DNA[-2] == DNA[-1] and DNA[-1] == byte: return 0
    else: return 1

#Checks if new base forms a word already in the sequence or forms a compliment word
def wordChecker(byte,DNA,compDNA):
    m = wordSize-1
    while m <= len(DNA)-1:
        #Checks every group of adjacent bases wordSize in length against the word that would be
        #created if the new base is added to the end of the sequence. Also checks compliment.
        if DNA[-wordSize+1:]+byte == DNA[m-wordSize+1:m+1] or DNA[-wordSize:]+byte == compDNA[m-wordSize+1:m+1]:
            return 0
        m += 1
    return 1

#Creates a complimentary DNA sequence as the DNA sequence is built.
# A <--> T, C <--> G, then flip sequence backwards.
#Ex: AACGT -> ACGTT
def compMaker(compDNA,byte):
    if byte == 'A': compDNA = 'T'+compDNA
    if byte == 'T': compDNA = 'A'+compDNA
    if byte == 'C': compDNA = 'G'+compDNA
    if byte == 'G': compDNA = 'C'+compDNA
    return compDNA


while strandNumber <= totalStrandNumber:
    #Do not touch
    randCheck = [0,0,0,0,0]
    #This block of code selects the first base. The first base only needs to see if gc is satisfied.
    compDNA = ''
    goodByte = 0
    while goodByte == 0:
        byte = getByte(randCheck)
        if gcChecker(byte,randCheck) == 1:
            DNA = byte
            compDNA = compMaker(compDNA,byte)
            goodByte = 1
        else: randCheck = randEliminate(byte,randCheck)

    #This block of code selects the second base. The second base only needs to see if gc is satisfied.
    randCheck = [0,0,0,0,0]
    goodByte = 0
    while goodByte == 0:
        byte = getByte(randCheck)
        if gcChecker(byte,DNA) == 1:
            DNA = DNA + byte
            compDNA = compMaker(compDNA,byte)
            goodByte = 1
        else: randCheck = randEliminate(byte,randCheck)

    #This block of code finishes the first word. The first word must satisfy gc and triplets.
    currentByteNumber = 2
    while currentByteNumber < wordSize:
        randCheck = [0,0,0,0,0]
        goodByte = 0
        while goodByte == 0:
            byte = getByte(randCheck)
            if gcChecker(byte,DNA) == 1:
                if tripletChecker(byte,DNA) == 1:
                    DNA = DNA + byte
                    compDNA = compMaker(compDNA,byte)
                    goodByte = 1
                    currentByteNumber += 1
                else: randCheck = randEliminate(byte,randCheck)
            else: randCheck = randEliminate(byte,randCheck)

    #This block of code creates all subsequent bases.
    while currentByteNumber < strandSize:
        randCheck = [0,0,0,0,0]
        goodByte = 0
        while goodByte == 0:
            byte = getByte(randCheck)
            if byte == 'X':
                currentByteNumber = strandSize+1
                break
            if gcChecker(byte,DNA) == 1:
                if tripletChecker(byte,DNA) == 1:
                    if wordChecker(byte,DNA,compDNA) == 1:
                        goodByte = 1
                        DNA = DNA + byte
                        compDNA = compMaker(compDNA,byte)
                        currentByteNumber += 1
                    else: randCheck = randEliminate(byte,randCheck)
                else: randCheck = randEliminate(byte,randCheck)
            else: randCheck = randEliminate(byte,randCheck)

    if verbose == 1:
        print('Your DNA sequence is:')
        print(DNA)
        print('')
        print('Your strand is ' + str(len(DNA)) + ' bases long.')
        if len(DNA) < strandSize: print('Though you suggested a sequence ' + str(strandSize) + ' bases long, the sequence had no valid base pairs once it reached this point and had to terminate.')
    bungis.write(DNA+'\n')
    strandNumber += 1
bungis.close()
input('Press enter to close program.')
#print("\033[1;32;40m Bright Green  \n")
