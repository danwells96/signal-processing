/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.cpp
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C++ main file shows how to call  */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "systolicAverageMax.h"
#include "main.h"
#include "systolicAverageMax_terminate.h"
#include "systolicAverageMax_emxAPI.h"
#include "systolicAverageMax_initialize.h"

/* Function Declarations */
static emxArray_real_T *argInit_d27623x1_real_T();
static double argInit_real_T();
static void main_systolicAverageMax();

/* Function Definitions */
static emxArray_real_T *argInit_d27623x1_real_T()
{
  emxArray_real_T *result;
  static int iv0[1] = { 2 };

  int idx0;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(1, iv0);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result->data[idx0] = argInit_real_T();
  }

  return result;
}

static double argInit_real_T()
{
  return 0.0;
}

static void main_systolicAverageMax()
{
  emxArray_real_T *b_signal;
  double estimateValue;
  double val;

  /* Initialize function 'systolicAverageMax' input arguments. */
  /* Initialize function input argument 'signal'. */
  b_signal = argInit_d27623x1_real_T();

  /* Call the entry-point 'systolicAverageMax'. */
  systolicAverageMax(b_signal, &estimateValue, &val);
  emxDestroyArray_real_T(b_signal);
}

int main(int, const char * const [])
{
  /* Initialize the application.
     You do not need to do this more than one time. */
  systolicAverageMax_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_systolicAverageMax();

  /* Terminate the application.
     You do not need to do this more than one time. */
  systolicAverageMax_terminate();
  return 0;
}

/* End of code generation (main.cpp) */
