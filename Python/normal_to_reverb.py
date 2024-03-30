import audio_to_mif as atb


array = atb.get_bytes_from_file("audio/Welcome_to_the_Jungle_7s.wav")
header = array[0:151]
array = array[151:]

numbers = []
for x in array:
    numbers.append(int.from_bytes(x, byteorder="little", signed=True))


# Constantes
alpha = 0.6
one_minus_alpha = 0.4
k = int(0.5 * 22050)
size = len(numbers)


# Inicio
result = []

for n in range(size):
    y = one_minus_alpha * numbers[n]
    if n >= k:
        y += alpha * result[n - k]
    if y > 127:
        y = 127
    if y < -127:
        y = -127
    result.append(y)

for n in range(size):
    result[n] = (int(result[n])).to_bytes(1, "little", signed=True)

result = header + result

atb.save_bytes_to_file("audio/Reverb.wav", result)
