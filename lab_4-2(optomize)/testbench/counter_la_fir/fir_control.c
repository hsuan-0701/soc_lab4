#include "fir_control.h"
#include <defs.h>
#include "data.h"  


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

void __attribute__ ( ( section ( ".mprjram" ) ) ) fir_work(int data_len){
	int a = 0;
//*   run fir	   *// 
	int x[30]={66280,
    -21168,
    82307,
    -65322,
    -62691,
    -48793,
    3228,
    94958,
    -63698,
    -42053,
    32885,
    86613,
    -95825,
    84933,
    89576,
    35702,
    75598,
    -949,
    -60181,
    -89142,
    -73195,
    83703,
    -86019,
    -37533,
    -45145,
    94371,
    24754,
    -1096,
    -90377,
    -28889
	};
	if(reg_fir_control == 4) reg_fir_control = 1; 
	else reg_mprj_datal = 0xABFF0000;
   	reg_fir_x = 0;
   	reg_fir_x = 1;
   	reg_fir_x = 2;
  reg_mprj_datal = 0xAB430000;
	for(int i=3 ; i < data_len ; i++){
			reg_mprj_datal = reg_fir_y ;
      //a = a+1;
			reg_fir_x = i;
   	}
   reg_mprj_datal = 0xAB470000;
}
