#
# board/chip specific options
#

TOOLCHAIN = arm-none-eabi-
FIXMATH_FLAGS = -DFIXMATH_NO_CACHE -DFIXMATH_NO_ROUNDING
F_CPU ?= 72000000
MCPU = cortex-m3
CORE = stm32f1
CORE_FLAGS = -mcpu=$(MCPU) -mthumb -mfloat-abi=soft
C_STD = c11
CXX_STD = gnu++11
C_DEFS = -DFABOOH -DF_CPU=$(F_CPU)
C_DEFS += -DSTM32 -DSTM32F1 -DSTM32F103C8Tx -DSTM32F103xB
C_DEFS += -I$(FBD)$(BOARDDIR)/CMSIS/core
C_DEFS += -I$(FBD)$(BOARDDIR)/CMSIS/device
CXX_DEFS = $(C_DEFS) 
AS_DEFS =
LD_SCRIPT = $(FBD)$(BOARDDIR)/stm32f103c8.ld
LD_FLAGS = -T$(LD_SCRIPT) -g -Wl,-Map=$(OUT_DIR_F)$(PROJECT).map,--cref,--no-warn-mismatch
LD_FLAGS += -Wl,--gc-sections -specs=nosys.specs -specs=nano.specs
OPTIMIZATION_FLAGS = -mslow-flash-data
LD_FLAGS += -nostartfiles
LD=$(CXX)
UPLOAD_VIA ?= bmp

ifeq ($(UPLOAD_VIA),bmp)
 BOOTLOADER = arm-none-eabi-gdb
 BL_COM ?= /dev/ttyACM0
 BL_ARGS = -ex 'target extended-remote $(BL_COM)'
 BL_ARGS += -ex 'mon swdp_scan' -ex 'attach 1' -ex 'load' -batch
 BL_ARGS += $(OUT_DIR)/$(PROJECT).elf
else
 BOOTLOADER = stm32flash
 BL_COM ?= /dev/ttyUSB0
 BL_ARGS = -w $(OUT_DIR)/$(PROJECT).hex $(BL_COM)
endif

