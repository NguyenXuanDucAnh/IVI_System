/*
 * scan_matrix.c
 *
 *  Created on: Nov 15, 2025
 *      Author: admin
 */
#include "main.h"
#include "scan_matrix.h"

#include <string.h>

uint8_t list_button_is_press [MAX_NUM_BUTTON] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

// define pin output
#define PORT_ROW_1 GPIOA
#define PORT_ROW_2 GPIOA // if have more port for row, let change it
#define PIN_OUT_ROW_1 GPIO_PIN_1
#define PIN_OUT_ROW_2 GPIO_PIN_2
#define PIN_OUT_ROW_3 GPIO_PIN_3
#define PIN_OUT_ROW_4 GPIO_PIN_4

// define pin input
#define PORT_COLLUM_1 GPIOA
#define PORT_COLLUM_2 GPIOB
#define PIN_IN_COLLUM_1 GPIO_PIN_5
#define PIN_IN_COLLUM_2 GPIO_PIN_6
#define PIN_IN_COLLUM_3 GPIO_PIN_7
#define PIN_IN_COLLUM_4 GPIO_PIN_0

/**
 * Function set all pin to defaut status
 */
void Set_Default_Status ()
{
	  HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_1, 1);
	  HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_2, 1);
	  HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_3, 1);
	  HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_4, 1);

}


void Scan_Button_Is_Pressed (uint8_t * list_button_RET)
{
//	static int collum_index = 1;

	for (int collum_index = 1; collum_index <= 4; collum_index++)
	{
		Set_Default_Status ();

		switch (collum_index)
		{
			case 1:
			{
				Scan_Row_1();
				break;
			}
			case 2:
			{
				Scan_Row_2();
				break;
			}
			case 3:
			{
				Scan_Row_3();
				break;
			}
			case 4:
			{
				Scan_Row_4();
				break;
			}
		}
	}

	memcpy (list_button_RET, list_button_is_press, MAX_NUM_BUTTON);
}

void Scan_Row_1 ()
{
	HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_1, 0);

	// scan button in collum 1 and row 1
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 0)
	{
		list_button_is_press[Button_13] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 1)
	{
		list_button_is_press[Button_13] = 0;
	}

	// scan button in collum 2 and row 1
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 0)
	{
		list_button_is_press[Button_14] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 1)
	{
		list_button_is_press[Button_14] = 0;
	}
	// scan button in collum 3 and row 1
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 0)
	{
		list_button_is_press[Button_15] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 1)
	{
		list_button_is_press[Button_15] = 0;
	}
	// scan button in collum 4 and row 1
	if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 0)
	{
		list_button_is_press[Button_16] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 1)
	{
		list_button_is_press[Button_16] = 0;
	}
}
void Scan_Row_2 ()
{
	HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_2, 0);

	// scan button in collum 1 and row 2
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 0)
	{
		list_button_is_press[Button_9] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 1)
	{
		list_button_is_press[Button_9] = 0;
	}

	// scan button in collum 2 and row 2
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 0)
	{
		list_button_is_press[Button_10] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 1)
	{
		list_button_is_press[Button_10] = 0;
	}
	// scan button in collum 3 and row 2
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 0)
	{
		list_button_is_press[Button_11] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 1)
	{
		list_button_is_press[Button_11] = 0;
	}
	// scan button in collum 4 and row 2
	if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 0)
	{
		list_button_is_press[Button_12] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 1)
	{
		list_button_is_press[Button_12] = 0;
	}
}
void Scan_Row_3 ()
{
	HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_3, 0);

	// scan button in collum 1 and row 3
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 0)
	{
		list_button_is_press[Button_5] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 1)
	{
		list_button_is_press[Button_5] = 0;
	}

	// scan button in collum 2 and row 3
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 0)
	{
		list_button_is_press[Button_6] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 1)
	{
		list_button_is_press[Button_6] = 0;
	}
	// scan button in collum 3 and row 3
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 0)
	{
		list_button_is_press[Button_7] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 1)
	{
		list_button_is_press[Button_7] = 0;
	}
	// scan button in collum 4 and row 3
	if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 0)
	{
		list_button_is_press[Button_8] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 1)
	{
		list_button_is_press[Button_8] = 0;
	}
}
void Scan_Row_4 ()
{
	HAL_GPIO_WritePin (PORT_ROW_1, PIN_OUT_ROW_4, 0);

	// scan button in collum 1 and row 4
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 0)
	{
		list_button_is_press[Button_1] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_1) == 1)
	{
		list_button_is_press[Button_1] = 0;
	}

	// scan button in collum 2 and row 4
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 0)
	{
		list_button_is_press[Button_2] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_2) == 1)
	{
		list_button_is_press[Button_2] = 0;
	}
	// scan button in collum 3 and row 4
	if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 0)
	{
		list_button_is_press[Button_3] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_1, PIN_IN_COLLUM_3) == 1)
	{
		list_button_is_press[Button_3] = 0;
	}
	// scan button in collum 4 and row 4
	if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 0)
	{
		list_button_is_press[Button_4] = 1;
	}
	else if (HAL_GPIO_ReadPin (PORT_COLLUM_2, PIN_IN_COLLUM_4) == 1)
	{
		list_button_is_press[Button_4] = 0;
	}
}

/*#EOF*/
