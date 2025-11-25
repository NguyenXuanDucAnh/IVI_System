################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Scan_matrix_button/scan_matrix.c 

OBJS += \
./Scan_matrix_button/scan_matrix.o 

C_DEPS += \
./Scan_matrix_button/scan_matrix.d 


# Each subdirectory must supply rules for building sources it contributes
Scan_matrix_button/%.o Scan_matrix_button/%.su Scan_matrix_button/%.cyclo: ../Scan_matrix_button/%.c Scan_matrix_button/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -IC:/Users/admin/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/STM32F1xx_HAL_Driver/Inc -IC:/Users/admin/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -IC:/Users/admin/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/CMSIS/Device/ST/STM32F1xx/Include -IC:/Users/admin/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/CMSIS/Include -I"/home/admin1/Desktop/STM32Project/IVI_ECU_AUTOMOTIVE_SIMULATOR/Scan_matrix_button" -I/home/admin1/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/STM32F1xx_HAL_Driver/Inc -I/home/admin1/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I/home/admin1/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/CMSIS/Device/ST/STM32F1xx/Include -I/home/admin1/STM32Cube/Repository/STM32Cube_FW_F1_V1.8.6/Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Scan_matrix_button

clean-Scan_matrix_button:
	-$(RM) ./Scan_matrix_button/scan_matrix.cyclo ./Scan_matrix_button/scan_matrix.d ./Scan_matrix_button/scan_matrix.o ./Scan_matrix_button/scan_matrix.su

.PHONY: clean-Scan_matrix_button

