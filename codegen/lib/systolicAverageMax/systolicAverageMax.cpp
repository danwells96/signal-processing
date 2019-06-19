/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * systolicAverageMax.cpp
 *
 * Code generation for function 'systolicAverageMax'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "systolicAverageMax.h"

/* Function Definitions */
void systolicAverageMax(const emxArray_real_T *b_signal, double *estimateValue,
  double *val)
{
  int n;
  int idx;
  int k;
  boolean_T exitg1;
  double ex;
  int i0;
  n = b_signal->size[0];
  if (b_signal->size[0] <= 2) {
    if (b_signal->size[0] == 1) {
      idx = 1;
    } else if ((b_signal->data[0] < b_signal->data[1]) || (rtIsNaN
                (b_signal->data[0]) && (!rtIsNaN(b_signal->data[1])))) {
      idx = 2;
    } else {
      idx = 1;
    }
  } else {
    if (!rtIsNaN(b_signal->data[0])) {
      idx = 1;
    } else {
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= b_signal->size[0])) {
        if (!rtIsNaN(b_signal->data[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      idx = 1;
    } else {
      ex = b_signal->data[idx - 1];
      i0 = idx + 1;
      for (k = i0; k <= n; k++) {
        if (ex < b_signal->data[k - 1]) {
          ex = b_signal->data[k - 1];
          idx = k;
        }
      }
    }
  }

  *val = idx;

  /* If max index is not first or last value */
  if ((idx < b_signal->size[0]) && (idx > 1)) {
    *estimateValue = ((b_signal->data[idx - 2] + b_signal->data[idx - 1]) +
                      b_signal->data[idx]) / 3.0;

    /* If max index is last value */
  } else if (idx > 1) {
    *estimateValue = ((b_signal->data[idx - 3] + b_signal->data[idx - 2]) +
                      b_signal->data[idx - 1]) / 3.0;

    /* If max index is first value */
  } else {
    *estimateValue = ((b_signal->data[0] + b_signal->data[1]) + b_signal->data[2])
      / 3.0;
  }
}

/* End of code generation (systolicAverageMax.cpp) */
