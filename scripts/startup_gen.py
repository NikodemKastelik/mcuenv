import os
import re
import pathlib
from jinja2 import Environment, FileSystemLoader

HEADERS_PATH = "../cmsis/device"
TEMPLATES_PATH = "."
OUTPUT_PATH = "./generated"

STATE_OUT_ENUM = 0
STATE_IN_ENUM = 1
STATE_IN_IRQS = 2

def stm32_series_to_core(series):
    if series == "f0":
        return "cortex-m0"
    elif series == "f4":
        return "cortex-m4"
    else:
        return None

files = os.listdir(HEADERS_PATH)

state = STATE_OUT_ENUM
for file in files:
    if re.match("stm32[fh][0-9]{3}?x[0-9a-z].h", file) is not None:
        core = stm32_series_to_core(file[5:7])
        irq_names = []
        with open(os.path.join(HEADERS_PATH, file)) as fd:
            for line in fd:

                if state == STATE_OUT_ENUM:
                    if line.startswith("typedef enum"):
                        state = STATE_IN_ENUM

                elif state == STATE_IN_ENUM:
                    if "_IRQn" in line:
                        state = STATE_IN_IRQS

                    elif line.startswith("}"):
                        state = STATE_OUT_ENUM

                if state == STATE_IN_IRQS:
                    if line.startswith("}"):
                        state = STATE_OUT_ENUM
                        break
                    elif "_IRQn" in line:
                        splitted = line.split()
                        irq_name = splitted[0][:-5]
                        irq_num  = int(splitted[2].rstrip(","))
                        irq_names.append([irq_name, irq_num])

        irq_handlers = []
        irq_default_handlers = []

        irqn_cnt = -14
        for name, num in irq_names:
            while num != irqn_cnt:
                irq_handlers.append("0")
                irqn_cnt += 1
            handler_name = name + "_"
            if irqn_cnt >= 0:
                handler_name += "IRQ"
            handler_name += "Handler"
            irq_handlers.append(handler_name)
            irq_default_handlers.append(handler_name)
            irqn_cnt += 1

        env = Environment(loader=FileSystemLoader(TEMPLATES_PATH))
        template = env.get_template("startup_template")
        output_from_parsed_template = template.render(irq_handlers = irq_handlers,
                                                      irq_default_handlers = irq_default_handlers,
                                                      core = core)

        filename = os.path.join(OUTPUT_PATH, "startup_{}.S".format(file[:-2]))
        with open(filename, "w") as fd:
            fd.write(output_from_parsed_template)
