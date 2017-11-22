//
//  main.c
//  
//
//  Created by Earl Lawrence on 11/10/16.
//  Modified by Michal Vrastil on 22/11/17
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "emu.h"

extern const int nmode_cb; // number of modes, defined in emu.c

int main(int argc, char **argv) {
    
    // A main function to be used as an example.
    // Intensive use of the emulator should probably use something smarter.
    
    // Parameter order
    // '\omega_m'   '\omega_b'   '\sigma_8'   'h'   'n_s'   'w_0'   'fw'   '\omega_{\nu}'
    
    double xstar[9]; // = {0.1335, 0.02258, 0.8, 0.71, 0.963, -1.0, 0.0, 0.0, .75};
    double ystar[nmode_cb];
    double mode[nmode_cb];

    int i, j;
    FILE *infile;
    FILE *outfile;
    char instring[256];
    char outname[256];
    char *token;
    int good = 1;
    int ctr = 0;
    char ctrc[100];
    
    // Read inputs from a file
    // File should be space delimited with 9 numbers on each line
    // '\omega_m'   '\omega_b'   '\sigma_8'   'h'   'n_s'   'w_0'   'w_a'   '\omega_{\nu}'   'z'
    if((infile = fopen("xstar.dat","r"))==NULL) {
        printf("Cannot find inputs.\n");
        exit(1);
    }
    
    // Read in the inputs and emulate the results.
    while(good == 1) {
        
        // Read each line
        if(fgets(instring, 256, infile) != NULL) {
            token = strtok(instring, " ");
            
            // Parse each line, which is space delimited
            for(i=0; i<9; i++) {
                xstar[i] = atof(token);
                token = strtok(NULL, " ");
            }
            
            // Get the answer.
            emu_cb(xstar, ystar, mode);
            
            // output file name
            strcpy(outname, "EMU");
            sprintf(ctrc, "%i", ctr);
            strcat(outname, ctrc);
            strcat(outname, ".txt");
            
            // Open the output file
            if ((outfile = fopen(outname,"w"))==NULL) {
                printf("cannot open %s \n",outname);
                exit(1);
            }
            for(i=0; i<nmode_cb; i++) {
                fprintf(outfile, "%f %f \n", mode[i], ystar[i]);
            }
            fclose(outfile);
            
            ctr++;
        } else {
            good = 0;
        }
    }
    fclose(infile);
    
    /*
    emu(xstar, ystar);
    for(i=0; i<nmode_cb; i++) {
        printf("%f %f \n", mode[i], ystar[i]);
    }
    printf("\n");
    */
}
