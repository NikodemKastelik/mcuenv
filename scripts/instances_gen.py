import re
import os
from jinja2 import Environment, FileSystemLoader

HEADERS_PATH = "../cmsis/device"
TEMPLATES_PATH = "."
OUTPUT_PATH = "./generated"

def filename_to_define_convert(filename):
    define = filename.rstrip(".h").upper()
    define = define.replace("X", "x")
    return define

files = os.listdir(HEADERS_PATH)
mcus = []

for file in files:
    if re.match("stm32[fh][0-9]{3}?x[0-9a-z].h", file) is not None:
        define = filename_to_define_convert(file)
        symbols_and_masks = []
        buses = []
        with open(os.path.join(HEADERS_PATH, file)) as fd:
            for line in fd:

                if re.match("#define RCC_A[HP]B[1-9]?ENR_[A-Z0-9]+_Pos", line) is not None:
                    splitted_by_space = line.split(" ")
                    instance_symbol = splitted_by_space[1]

                    bus_reg = instance_symbol.split("_")[1]
                    bus_symbol = "HAL_RCC_BUS_" + bus_reg.rstrip("ENR")

                    if not bus_symbol in buses:
                        buses.append(bus_symbol)

                    periph_name = "HAL_RCC_" + instance_symbol.split("_")[2]
                    periph_name = periph_name[:-2]
                    symbols_and_masks.append([periph_name, instance_symbol, bus_symbol])
        mcus.append([define, buses, symbols_and_masks])

env = Environment(loader=FileSystemLoader(TEMPLATES_PATH))
template = env.get_template('instances_template')
output_from_parsed_template = template.render(mcus = mcus)

filename = os.path.join(OUTPUT_PATH, "hal_instances.h")
with open(filename, "w") as fd:
    fd.write(output_from_parsed_template)
