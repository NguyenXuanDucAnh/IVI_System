/*
 * app_run.c
 *
 *  Created on: Nov 16, 2025
 *      Author: admin
 */
#include "main.h"

#include "scan_matrix.h"
#include "stdbool.h"

// init peripheral
extern TIM_HandleTypeDef htim4;
extern UART_HandleTypeDef huart1;

uint16_t speed = 0;
uint8_t temperature = 25;
uint16_t RPM = 1000;

uint8_t list_button_is_pressed_user [MAX_NUM_BUTTON];
bool is_left_xinhan = true;
bool is_right_xinhan = true;
bool seat_belt_is_ok = false;

//int check = 0;
//void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
//{
//	if (GPIO_Pin == GPIO_PIN_10 && check == 0)
//	{
//		check = 1;
//		if (HAL_GPIO_ReadPin (GPIOB, GPIO_PIN_11) == HAL_GPIO_ReadPin (GPIOB, GPIO_PIN_10))
//		{
//			speed ++;
//			if (speed > 350)
//			{
//				speed = 350;
//			}
//		}
//		else if (HAL_GPIO_ReadPin (GPIOB, GPIO_PIN_11) != HAL_GPIO_ReadPin (GPIOB, GPIO_PIN_10))
//		{
//			speed --;
//			if (speed > 350) // tranh truong hop speed < 0 thi se la 65535
//			{
//				speed = 0;
//			}
//		}
//		check = 0;
//	}
//
//}

/*
 * Define du lieu truyen di:
 * Frame chung ==> 					### ID ban tin | bit cao | bit thap | ###
 * Truyen du lieu toc do: 			0x01 bit_h bit_l
 * Truyen du lieu RPM:				0x02 bit_h bit_l
 * Truyen du lieu nhiet do:			0x03 bit_h bit_l
 * * Truyen du lieu xinhan:			0x04 bit_h bit_l ==> 0x00 => tat den, 0x01 => xinhan trai, 0x02 => xinhan phai, 0x03 => den hazard (nhay ca hai den xinhan)
 * * Truyen du lieu seatbel:		0x05 bit_h bit_l ==> 0x00 => seatbel ok, 0x01=> seatbel NC (no connect)
 * * Truyen du lieu den pha/cos:	0x06 bit_h bit_l ==> 0x00 => tat den, 0x01 => den cos, 0x02 => den pha
 * * Truyen du lieu cap so:			0x07 bit_h bit_l ==> 0x00: so N, 0x01: so P, 0x02: so D, 0x03: so R
 * * Truyen du lieu ODO:			0x08 bit_h bit_l
 * * Truyen du lieu RANGE:			0x09 bit_h bit_l
 */

void Create_Buf_RPM_SPEED_TEMP (uint8_t * buf, uint8_t * ID_Frame)
{
	buf[0] = '#';
	buf[1] = '#';
	buf[2] = '#';

	buf[6] = '#';
	buf[7] = '#';
	buf[8] = '#';
	buf[9] = '\n';
	switch (*ID_Frame)
	{
		case 0x01:
		{

		  buf[3] = (*ID_Frame);
		  buf[4] = (speed>>8) & 0xff;
		  buf[5] = speed & 0xff;

		  (*ID_Frame)++;
		  break;
		}
		case 0x03:
		{
			static int count_time =0;
			count_time++;
			if (count_time > 10)
			{
				count_time=0;

				temperature ++;
				if(temperature > 50)
				{
				  temperature = 25;
				}

			}
			buf[3] = (*ID_Frame);
			buf[4] = (temperature>>8) & 0xff;
			buf[5] = temperature & 0xff;

			(*ID_Frame)++;
			break;

		}
		case 0x02:
		{

		  buf[3] = (*ID_Frame);
		  buf[4] = (RPM>>8) & 0xff;
		  buf[5] = RPM & 0xff;

		  (*ID_Frame)++;
		  break;

		}
		/* * * Truyen du lieu xinhan: 0x04 bit_h bit_l ==> 0x00 => tat den, 0x01 => xinhan trai, 0x02 => xinhan phai, 0x03 => den hazard (nhay ca hai den xinhan)*/
		case 0x04:
		{
		  buf[3] = (*ID_Frame);
		  buf[4] = 0x00;

		  int status = 0x00;
		  if (is_left_xinhan == true && is_right_xinhan == false)
		  {
			  status = 0x01;
		  }
		  else if (is_left_xinhan == false && is_right_xinhan == true)
		  {
			  status = 0x02;
		  }
		  else if (is_left_xinhan == true && is_right_xinhan == true)
		  {
			  status = 0x03;
		  }
		  buf[5] = status;

		  (*ID_Frame)++;
		  break;

		}
		/*** dữ liệu seatbelt***/
		case 0x05:
		{
		  buf[3] = (*ID_Frame);
		  buf[4] = 0x00;

		  int status = 0x00;
		  if (seat_belt_is_ok == false)
		  {
			  status = 0x01;
		  }
		  buf[5] = status;

		  (*ID_Frame)++;
		  break;

		}
		default:
		{
			(*ID_Frame) = 0x01;
			break;
		}

	}
}


void Xinhan_Task(bool is_left, bool is_right)
{
	if (is_left == true)
	{
		  HAL_GPIO_TogglePin (XINHAN_LEFT_GPIO_Port, XINHAN_LEFT_Pin);
	}
	else if (is_left == false)
	{
		  HAL_GPIO_WritePin (XINHAN_LEFT_GPIO_Port, XINHAN_LEFT_Pin, 0);
	}


	if (is_right == true)
	{
		HAL_GPIO_TogglePin (XINHAN_RIGHT_GPIO_Port, XINHAN_RIGHT_Pin);
	}
	else if (is_left == false)
	{
		  HAL_GPIO_WritePin (XINHAN_RIGHT_GPIO_Port, XINHAN_RIGHT_Pin, 0);
	}
}



void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{

  if (htim->Instance == TIM4)
  {
	  is_left_xinhan = false;
	  is_right_xinhan = false;
	  seat_belt_is_ok = true;

	  Scan_Button_Is_Pressed(list_button_is_pressed_user);

	  if (list_button_is_pressed_user[Button_13] == 1)
	  {
		  is_left_xinhan = true;
	  }

	  if (list_button_is_pressed_user[Button_1] == 1)
	  {
		  is_right_xinhan = true;
	  }

	  if (list_button_is_pressed_user[Button_9] == 1)
	  {
		  is_right_xinhan = true;
		  is_left_xinhan = true;
	  }

	  if (list_button_is_pressed_user[Button_5] == 1)
	  {
		  seat_belt_is_ok = false;
	  }

	  Xinhan_Task (is_left_xinhan, is_right_xinhan);
  }
}

extern ADC_HandleTypeDef hadc1;
#define MAX_SAMPLE_ADC 10
#define NUM_ADC_CHANNEL_IN_USE 1
typedef struct {
	uint32_t ADC_value_sum;
	uint32_t ADC_Value_read;
	uint32_t ADC_Value_in_use;
	bool flag_adc_is_used ;
	uint8_t adc_count_sample;
} adc_t;

adc_t adc_0_channel;

void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{
  if (hadc->Instance == hadc1.Instance)
  {


	  HAL_ADC_Stop_DMA (&hadc1);
	  adc_0_channel.adc_count_sample ++;
	  adc_0_channel.ADC_value_sum += adc_0_channel.ADC_Value_read;

	  if (adc_0_channel.adc_count_sample == MAX_SAMPLE_ADC)
	  {
		  adc_0_channel.ADC_Value_in_use = adc_0_channel.ADC_value_sum/MAX_SAMPLE_ADC;

			// tiến hành tính toán tốc độ theo như ADC đo vào
			float temp_value = (float)adc_0_channel.ADC_Value_in_use/4095;

			speed = (uint16_t)(temp_value* 320);
			RPM = adc_0_channel.ADC_Value_in_use*10;

			// reset các giá trị để tiếp tục lân đo tiếp theo
			adc_0_channel.ADC_value_sum = 0;
			adc_0_channel.ADC_Value_read = 0;
			adc_0_channel.adc_count_sample  = 0;
	  }

  }
}


void setup(void)
{
	// init timer interrupt
	HAL_TIM_Base_Start_IT(&htim4);
	// Start DMA ADC
	HAL_ADC_Start_DMA(&hadc1, &adc_0_channel.ADC_Value_read, NUM_ADC_CHANNEL_IN_USE);
}


void loop (void)
{
	uint8_t buf [10];
	uint8_t ID_Frame = 0x00;


	while (1)
	{
		/* USER CODE END WHILE */

		/* USER CODE BEGIN 3 */
		HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
		Create_Buf_RPM_SPEED_TEMP (buf, &ID_Frame);
		HAL_UART_Transmit(&huart1, buf, 10, 1000);

		// thực hiện gọi lại ADC DMA
		HAL_ADC_Start_DMA(&hadc1, &adc_0_channel.ADC_Value_read, NUM_ADC_CHANNEL_IN_USE);
		HAL_Delay(10);
	}
}
