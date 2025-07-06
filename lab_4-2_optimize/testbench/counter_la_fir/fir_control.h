#ifndef FIR_CONTROL_H
#define FIR_CONTROL_H
#define N 11
void config_set(int data_len);
void tap_write(void);
void fir_work(int data_len);

// 將這些改為 extern
#endif
