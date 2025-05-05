#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir
   	for(int i = 0; i < N; i++) {
  		inputbuffer[i] = inputsignal[i];
  		outputsignal[i] = 0;
  	}
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();
   for (int n = 0; n < N; n++) {
		// ²¾°Ê inputbuffer
		// FIR convolution
		int acc = 0;
		for (int k = 0; k < N; k++) {
			acc += inputbuffer[n-k] * taps[k];
		}
		outputsignal[n] = acc;
   }
	//write down your fir
	return outputsignal;
 
}
		
