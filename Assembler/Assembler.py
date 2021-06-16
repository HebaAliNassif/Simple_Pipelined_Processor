######################
# Read Assembly File #
######################

fileName = input("Please enter the assembly file name: ")
fileR = open(fileName, "r")

readInstructions = fileR.readlines()

instructionsOpcode = {
    "NOP" : "000000",
    "SETC": "000001",
    "CLRC": "000010",
    "NOT" :	"000011",
    "INC" :	"000100",
    "DEC" :	"000101",
    "OUT" :	"000110",
    "IN"  : "000111",
    
    "MOV" :	"001000",
    "ADD" :	"001001",
    "IADD":	"001010",
    "SUB" :	"001011",
    "AND" :	"001100",
    "OR"  :	"001101",
    "SHL" : "001110",
    "SHR" : "001111", 
    
    "PUSH": "010000",
    "POP" :	"010001",
    "LDM" : "010010",
    "LDD" : "010011",
    "STD" : "010100",
    
    "JZ"  : "010101",
    "JN"  : "010110",
    "JC"  : "010111",
    "JMP" :	"011000",
    "CALL": "011001",
    "RET" : "011010"
}

noOperandsInstructions = ["NOP" , "SETC" , "CLRC", "RET"]

oneOperandInstructions = ["NOT", "INC", "DEC", "OUT", "IN", "PUSH", "POP", "JZ", "JN", "JC", "JMP", "CALL"]

twoOperandsInstructions = ["MOV", "ADD", "IADD", "SUB", "AND", "OR", "SHL", "SHR", "LDM" , "LDD" , "STD"]

######################################
# Calculate Address for Instructions #
######################################

addresses = []                               
instructions = []                            
currentAddress = -1

for index, instruction in enumerate(readInstructions):         
    instruction = instruction.upper().replace("\n","").replace("\t","").replace(",", " ").replace("(", " ").replace(")", "")    # remove new lines, spaces, commas and brackets from instruction
    instructionsList = instruction.split("#")[0].split(" ")                    # split first at comment then split at spaces the instruction
    instructionsList = list(filter(lambda x: x != "", instructionsList))        # filter the comment section from the instruction      
    
    if(instructionsList):
       
        if(instructionsList[0] == ".ORG"):
            decimalAddress = int(instructionsList[1] , base=16)        # calculate address in decimal
            currentAddress = decimalAddress - 1
            continue
        
        currentAddress += 1
 
        instructions.append(instructionsList)
        addresses.append(currentAddress)
        ##currentAddress += 1
        #print(currentAddress)

        
        if(instructionsList[0]== "IADD" or instructionsList[0] == "LDM" or instructionsList[0] == "LDD" or instructionsList[0] == "STD" or instructionsList[0] == "SHL" or instructionsList[0] == "SHR"):    # handling two words instruction 
            currentAddress += 1
        

   
#################################
# Change Instructions to Opcode #
#################################

memory = ['0000000000000000'] * 2000

registers = {
   "R0" : "00000",
   "R1" : "00001",
   "R2" : "00010",
   "R3" : "00011",
   "R4" : "00100",
   "R5" : "00101",
   "R6" : "00110",
   "R7" : "00111"
}

for index, instruction in enumerate(instructions):
    code = ""
    if(instruction[0] in noOperandsInstructions):
        code += instructionsOpcode[instruction[0]]
        #print(code)
        code += "0000000000"
        #print(code)
        memory[addresses[index]] = code 
        #print(index)

    elif(instruction[0] in oneOperandInstructions):
        code += instructionsOpcode[instruction[0]]
        #print(code)
        code += "00000"
        #print(code)
        code += registers[instruction[1]]
        #print(code)
        memory[addresses[index]] = code 
        #print(index)  
        
        
    elif(instruction[0] in twoOperandsInstructions): 
         if(instruction[0]== "IADD" or instruction[0] == "LDM" or instruction[0] == "LDD" or instruction[0] == "STD"):
            if(instruction[0] == "IADD" or instruction[0] == "LDM"):
                code += instructionsOpcode[instruction[0]]
                #print(code)
                code += "00000"
                #print(code)
                code += registers[instruction[1]]
                #print(code)
                memory[addresses[index]] = code 
                immediateValue = "{0:0>16b}".format(int(instruction[2], 16))
                #print(immediateValue)
                memory[addresses[index]+1] = immediateValue
                
            elif(instruction[0] == "LDD" or instruction[0] == "STD"):               
                code += instructionsOpcode[instruction[0]]
                #print(code)                
                code += registers[instruction[3]]
                #print(code)                
                code += registers[instruction[1]]
                #print(code)                
                memory[addresses[index]] = code
                immediateValue = "{0:0>16b}".format(int(instruction[2], 16))
                #print(immediateValue)
                memory[addresses[index]+1] = immediateValue
                
         elif(instruction[0] == "SHL" or instruction[0] == "SHR"):
            code += instructionsOpcode[instruction[0]]
            #print(code)                
            code += "00000"
            #print(code)                
            code += registers[instruction[1]]
            #print(code)     
            memory[addresses[index]] = code
            immediateValue = "{0:0>16b}".format(int(instruction[2], 16))
            memory[addresses[index]+1] = immediateValue
            #print(immediateValue)                                
          
         else:
            code += instructionsOpcode[instruction[0]]
            code += registers[instruction[1]]
            code += registers[instruction[2]]
            memory[addresses[index]] = code
          
    else: # handling interrupt or reset
        code += "{0:0>16b}".format(int(instruction[0], 16))
        #print(code)                
        memory[addresses[index]] = code
    

    
    

#####################
# Write Memory File #
#####################

fileW = open('Memory.mem', "w")
fileW.write("// instance=/ram/ram\n")
fileW.write("// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1\n")

for index, element in enumerate(memory):
    fileW.write(str(index) + ": "+ element + "\n")

fileW.close()

print('Memory file Memory.mem was generated') 