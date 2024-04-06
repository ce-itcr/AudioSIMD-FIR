code = open("codigo2.txt")
limpio = open("limpio.txt", "w")
ensamblador = open("ensamblador.txt", "w")
codigohexadecimal = open("../Procesador/simulation/modelsim/instructions.dat", "w")
addrlabel = []

def linea_no_vacia(linea):
    linea_sin_espacios = linea.strip()
    # Devuelve True si la línea no está en blanco y False si está en blanco
    return bool(linea_sin_espacios)


def decimal_a_binario(
    numero, select
):  # select=1 rellena ceros hasta 15, otro numero rellena hasta 5
    # Convierte a binario y elimina el prefijo '0b'
    binario = bin(numero)[2:]

    if select == 1:
        binario_con_ceros = binario.zfill(15)
    else:
        # Asegura que el binario tenga al menos 5 dígitos
        binario_con_ceros = binario.zfill(5)

    return binario_con_ceros


def hexadecimal_a_binario(hexadecimal):
    decimal = int(hexadecimal, 16)  # Convierte de hexadecimal a decimal
    binario = decimal_a_binario(decimal, 1)
    return binario


def int_to_20_bit_string(n):
    if n < 0:
        n = (1 << 20) + n
    binary_string = bin(n)[2:]
    binary_string = binary_string.zfill(20)
    return binary_string


# Example usage:
signed_integer = -12345
bit_string = int_to_20_bit_string(signed_integer)
print(bit_string)


def descomp(line, select):
    descomp = []
    word = ""
    for char in line:
        if char.lower() != " " and char.lower() != "\n":
            word = word + char
        else:
            descomp.append(word)
            word = ""

    if descomp[0] != "set":
        if select == 3:
            # quita el "X" del x8
            descomp[1] = descomp[1][1:]
            descomp[2] = descomp[2][1:]
            descomp[3] = descomp[3][1:]
        else:
            descomp[1] = descomp[1][1:]
            descomp[2] = descomp[2][1:]

    else:
        # quita el "X" del x8
        descomp[1] = descomp[1][1:]

    return descomp


def aritmetic(parameter):  # falta slr y sll
    parameter = descomp(parameter, 3)
    inst = "000"
    if parameter[0].lower() == "add":
        inst = inst + "0000"
    if parameter[0].lower() == "sub":
        inst = inst + "0001"
    if parameter[0].lower() == "mul":
        inst = inst + "0010"
    if parameter[0].lower() == "slr":
        inst = inst + "0011"
    if parameter[0].lower() == "sll":
        inst = inst + "0100"
    if parameter[0].lower() == "sar":
        inst = inst + "0101"
    if parameter[0].lower() == "mvv":
        inst = inst + "1000"
    if parameter[0].lower() == "svr":
        inst = inst + "1001"
    if parameter[0].lower() == "svl":
        inst = inst + "1010"
    if parameter[0].lower() == "sva":
        inst = inst + "1011"

    inst = (
        inst
        + str(decimal_a_binario(int(parameter[1]), 0))
        + str(decimal_a_binario(int(parameter[2]), 0))
        + str(decimal_a_binario(int(parameter[3]), 0))
    )

    # rellena la instruccion con 0s

    for i in range(10):
        inst += "0"

    inst += "\n"
    return inst


def arit_imm(parameter):
    inst = "001"
    parameter = descomp(parameter, 1)
    if parameter[0].lower() == "set":
        inst += "0000"
        if "x" in parameter[2]:
            parameter[2] = parameter[2][1:]
            inst = (
                inst
                + str(decimal_a_binario(int(parameter[1]), 0))
                + str(decimal_a_binario(int(parameter[2]), 0))
            )
            for i in range(15):
                inst += "0"
        else:
            inst = (
                inst
                + str(decimal_a_binario(int(parameter[1]), 0))
                + "00000"
                + str(decimal_a_binario(int(parameter[2]), 1))
            )
    if parameter[0].lower() == "addi":
        inst += "0000"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )
    if parameter[0].lower() == "subi":
        inst += "0001"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )
    if parameter[0].lower() == "muli":
        inst += "0010"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )
    if parameter[0].lower() == "slri":
        inst += "0011"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )
    if parameter[0].lower() == "slli":
        inst += "0100"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )
    if parameter[0].lower() == "sari":
        inst += "0101"
        inst = (
            inst
            + str(decimal_a_binario(int(parameter[1]), 0))
            + str(decimal_a_binario(int(parameter[2]), 0))
            + str(decimal_a_binario(int(parameter[3]), 1))
        )

    inst += "\n"
    return inst


def comp(parameter):
    inst = "010000100000"
    parameter = descomp(parameter, 2)
    inst = (
        inst
        + str(decimal_a_binario(int(parameter[1]), 0))
        + str(decimal_a_binario(int(parameter[2]), 0))
    )
    for i in range(10):
        inst += "0"
    inst += "\n"
    return inst


def jumps(parameter, count):
    global addrlabel
    inst = "011"
    if parameter[0:2].lower() == "j ":
        inst = inst + "0000"
        label = parameter[2:6].rstrip()
    if parameter[0:3].lower() == "jeq":
        inst = inst + "0001"
        label = parameter[4 : len(parameter) - 1].rstrip()

    if parameter[0:4].lower() == "jneq":
        inst = inst + "0010"
        label = parameter[5 : len(parameter) - 1].rstrip()

    if parameter[0:3].lower() == "jgt":
        inst = inst + "0011"
        label = parameter[4 : len(parameter) - 1].rstrip()

    if parameter[0:3].lower() == "jge":
        inst = inst + "0100"
        label = parameter[4 : len(parameter) - 1].rstrip()

    if parameter[0:3].lower() == "jlt":
        inst = inst + "0101"
        label = parameter[4 : len(parameter) - 1].rstrip()

    if parameter[0:3].lower() == "jle":
        inst = inst + "0110"
        label = parameter[4 : len(parameter) - 1].rstrip()

    inst += "00000"

    for info_label in addrlabel:
        if info_label[0] == label:
            # imm = dir_etiqueta - (dir_instruc + 2)
            print(info_label[1])
            print(count)
            imm = info_label[1] - (count + 2)
            print(imm)
            binario = bin(imm)[2:]
            binario = int_to_20_bit_string(imm)
            print(bit_string)
            inst += binario
            print("label encontrado")
            break

    return inst


def memOp(parameter):
    inst = ""
    parameter = descomp(parameter, 1)
    if parameter[0].lower() == "lw":
        inst = "1000000"
    if parameter[0].lower() == "sw":
        inst = "1010000"

    if parameter[0].lower() == "lv":
        inst = "1001000"
    if parameter[0].lower() == "sv":
        inst = "1011000"

    inst = (
        inst
        + str(decimal_a_binario(int(parameter[1]), 0))
        + str(decimal_a_binario(int(parameter[2]), 0))
    )

    print(parameter)
    if parameter[3][0] != "x":
        inst += str(decimal_a_binario(int(parameter[3][0:]), 1))
    else:
        for i in range(15):
            inst += "0"

    inst += "\n"

    return inst


def traslate(c_code):
    binario = ""
    for line in c_code:
        command = line[0:4]
        if (
            command.lower() == "add "
            or command.lower() == "sub "
            or command.lower() == "mul "
            or command.lower() == "slr "
            or command.lower() == "sll "
            or command.lower() == "sar "
            or command.lower() == "mvv "
            or command.lower() == "svr "
            or command.lower() == "svl "
            or command.lower() == "sva "
        ):
            binario += aritmetic(line)
        elif (
            command.lower() == "addi"
            or command.lower() == "slri"
            or command.lower() == "slli"
            or command.lower() == "set "
        ):
            binario += arit_imm(line)

        elif command.lower() == "comp":
            binario += comp(line)
        elif (
            line[0].lower() == "j"
            or command.lower() == "jeq "
            or command.lower() == "jneq"
            or command.lower() == "jgt "
            or command.lower() == "jge "
            or command.lower() == "jlt "
            or command.lower() == "jle "
        ):
            binario += jumps(line)  # , addrlabel)
        elif (line[0:2].lower() == "lw" or line[0:2].lower() == "sw" 
              or line[0:2].lower() == "lv" or line[0:2].lower() == "sv"):
            binario += memOp(line)
    return binario


def traslateline(line, count):
    newline = ""
    command = line[0:4]
    if (
        command.lower() == "add "
        or command.lower() == "sub "
        or command.lower() == "mul "
        or command.lower() == "slr "
        or command.lower() == "sll "
        or command.lower() == "sar "
        or command.lower() == "mvv "
        or command.lower() == "svr "
        or command.lower() == "svl "
        or command.lower() == "sva "
    ):
        newline = aritmetic(line)
    elif (
        command.lower() == "addi"
        or command.lower() == "subi"
        or command.lower() == "muli"
        or command.lower() == "slri"
        or command.lower() == "slli"
        or command.lower() == "set "
        or command.lower() == "sari"
    ):
        newline = arit_imm(line)
    elif command.lower() == "comp":
        newline = comp(line)
    elif (
        line[0].lower() == "j"
        or command.lower() == "jeq "
        or command.lower() == "jneq"
        or command.lower() == "jgt "
        or command.lower() == "jge "
        or command.lower() == "jlt "
        or command.lower() == "jle "
    ):
        newline = jumps(line, count)
    elif (line[0:2].lower() == "lw" or line[0:2].lower() == "sw"
          or line[0:2].lower() == "lv" or line[0:2].lower() == "sv"):
        newline = memOp(line)
    return newline


def bin_to_hex(inBin):
    hexa = []
    for n in inBin:
        dec = int("0b" + n, 2)
        hexadec = hex(dec)[2:].upper()
        hexa.append(hexadec)
        codigohexadecimal.write(hexadec + "\n")
    return hexa


def clean():
    ensam = []
    i = 0
    lines = code.readlines()
    while i < len(lines):
        line = lines[i]
        if linea_no_vacia(line) and "//" not in line[4:7] and "//" not in line[0:4]:
            ensam.append(line)
            # with open('limpio.txt', 'a') as archivo:
            limpio.write(line)
        i += 1
    return ensam


def read(ensam):
    newensam = []
    i = 0
    cont = 0
    lines = code.readlines()
    while i < len(ensam):
        line = ensam[i]

        if line[len(line) - 2 : len(line) - 1] == ":":  # loop
            cont += 1
            # nameloop=line[0:len(line)-2].rstrip()
            # addrlabel.append([nameloop,i-len(addrlabel)])
            codeloop = []
            i += 1
            line = ensam[i]
            while line[0:4] == "    " and i < len(ensam):
                newensam.append(
                    traslateline(line[4 : len(line) - 1], i - cont).rstrip()
                )
                ensamblador.write(line)
                i += 1
                if i < len(ensam):
                    line = ensam[i]

            i -= 1
        else:
            print(line.rstrip())
            newensam.append(traslateline(line.rstrip(), i))
            ensamblador.write(line)
        i += 1
    return newensam


def getlabeladdres(ensam):
    i = 0
    lines = code.readlines()
    while i < len(ensam):
        line = ensam[i]

        if line[len(line) - 2 : len(line) - 1] == ":":  # loop
            nameloop = line[0 : len(line) - 2].rstrip()
            addrlabel.append([nameloop, i - len(addrlabel)])
        i += 1


codigolimpio = clean()
getlabeladdres(codigolimpio)
ensamb = read(codigolimpio)
# binario= traslate(ensamb)
print(addrlabel)
print(ensamb)
print(bin_to_hex(ensamb))

code.close()
limpio.close()
ensamblador.close()
codigohexadecimal.close()
