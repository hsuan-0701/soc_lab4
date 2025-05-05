#include "fir_control.h"
#include <defs.h>


void __attribute__ ( ( section ( ".mprjram" ) ) ) config_set(int data_len ) {
	//initial your fir
	reg_fir_config_tap_num = N ;
	reg_fir_config_data_len = data_len ;
}

void __attribute__ ( ( section ( ".mprjram" ) ) ) tap_write(void){
	int taps[N]  = { -6, 1, -7, 7, -1, -8, 3, 7, -10, -6, 8 };
	// tap parameter write
	for(int i=0 ; i<N ;i++){
	 reg_fir_coeff(i) = taps[i] ;
	}
}
