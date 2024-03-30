import numpy as np
import binascii

MAX_SIZE = 524288  # RAM size
header_size = 151


def save_header(header):
    with open("mifs/header", "wb") as header_file:
        for i in header:
            header_file.write(i)


## Genera el archivo .mif para cargar los datos del audio en memoria
def generate_mif_file(audio_data_array):
    audio_length = len(audio_data_array)
    sigle_file_size = int(audio_length / 2)

    string_datos = "-- Audio Generado\n\n"
    string_datos += "WIDTH=" + str(8) + ";\n" + "DEPTH=" + str(MAX_SIZE) + ";\n\n"
    string_datos += "ADDRESS_RADIX=UNS;\nDATA_RADIX=HEX;\n\n"

    string_datos += "CONTENT BEGIN\n"
    string_datos += "   " + str(0) + " : " + str(hex(sigle_file_size)[5:]) + ";\n"
    string_datos += "   " + str(1) + " : " + str(hex(sigle_file_size)[3:5]) + ";\n"
    string_datos += (
        "   " + str(2) + " : " + "0" + str(hex(sigle_file_size)[2:3]) + ";\n"
    )

    for i in range(audio_length):
        string_datos += "   " + str(i + 3) + " : "
        string_datos += str(audio_data_array[i].hex()).upper() + ";\n"

    if audio_length < MAX_SIZE:
        string_datos += (
            "[" + str(audio_length + 3) + ".." + str(MAX_SIZE - 1) + "] : 00 ; \n"
        )

    string_datos += "END;\n"

    with open("mifs/audio_hex_data.mif", "w") as mif_file:
        mif_file.write(string_datos)


## Pasar a un array los datos de un archivo binario
def get_bytes_from_file(file_name):
    with open(file_name, "rb") as file_open:
        byte_array = []
        while True:
            value = file_open.read(1)
            if not value:
                break
            byte_array.append(value)
    return byte_array


def save_bytes_to_file(path, array):
    with open(path, "wb") as file_open:
        for y in array:
            file_open.write(y)


def parse_mif(filename):
    datos = []

    with open(filename, "r") as archivo:
        leyendo_contenido = False

        for linea in archivo:
            if "BEGIN" in linea:
                leyendo_contenido = True
                continue

            if leyendo_contenido and ":" in linea:
                # Separar la línea en dirección y datos
                partes = linea.split(":")
                dato = partes[1].split(";")[0].strip()
                dato = int(dato, 2)
                dato = dato.to_bytes(1, "little")

                index = partes[0].strip()
                if "[" in index:
                    index = index[1:-1].split("..")
                    for i in range(
                        int(index[1].lstrip("0"), 16)
                        - int(index[0].lstrip("0"), 16)
                        + 1
                    ):
                        datos.append(dato)
                else:
                    datos.append(dato)

            if "END" in linea:
                break

    return datos


def parse_mem(filename):
    datos = []
    with open(filename, "r") as archivo:
        for linea in archivo:
            if ":" in linea:
                # Separar la línea en dirección y datos
                partes = linea.split(":")
                dato = partes[1].strip()
                dato = int(dato, 16)
                dato = dato.to_bytes(1, "little")
                index = int(partes[0].strip())
                datos.append(dato)
    return datos


def get_audio_file_size(data):
    size = (
        binascii.hexlify(data[2]).decode("utf-8")
        + binascii.hexlify(data[1]).decode("utf-8")
        + binascii.hexlify(data[0]).decode("utf-8")
    )
    size = int(size, 16)
    return size


def save_wav(filename, data):
    size = get_audio_file_size(data)
    header = get_bytes_from_file("mifs/header")

    result_data = header
    for i in range(size * 2, size * 3):
        result_data.append(data[i])

    save_bytes_to_file(filename, result_data)


def generate_mif():
    normal = get_bytes_from_file("audio/Back_In_Black_7s.wav")
    reverb = get_bytes_from_file("audio/Reverb.wav")

    header = normal[0:header_size]
    save_header(header)
    normal = normal[header_size:]
    reverb = reverb[header_size:]

    generate_mif_file(normal + reverb)


def fpga_result(mif_file, wav_file):
    data = parse_mif(mif_file)
    save_wav(wav_file, data)


def simulation_result(mif_file, wav_file):
    data = parse_mem(mif_file)
    save_wav(wav_file, data)


# Tests

#generate_mif()

# FPGA results
#fpga_result("mifs/fpga_memory_dereverb.mif", "audio/ResultFPGA_Dereverb.wav")
fpga_result("mifs/fpga_memory_reverb.mif", "audio/ResultFPGA_Reverb.wav")

# Simulation results
#simulation_result("mifs/simulation_memory_reverb.mem", "audio/ResultSim_Reverb.wav")
#simulation_result("mifs/simulation_memory_dereverb.mem", "audio/ResultSim_DeReverb.wav")
