import re
import os

HEADERS_PATH = "../cmsis/device/"

files = os.listdir(HEADERS_PATH)
mcu_symbols = []
for file in files:
    if re.match("stm32[fh][0-9]xx.h", file) is not None:
        mcu_series = file[5].upper() + file[6]
        regexpr = "#(?:if|elif) defined\(STM32{}[0-9][0-9]x[0-9A-Za-z]\)".format(mcu_series)
        with open(HEADERS_PATH + file, "r") as fd:
            for line in fd:
                if re.match(regexpr, line) is not None:
                    this_symbol_idx = line.find("(") + 1
                    this_symbol = line[this_symbol_idx:-2]
                    mcu_symbols.append("    \"" + this_symbol + "\"")

[print(symbol) for symbol in mcu_symbols]
