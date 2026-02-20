#include <minimp3.h>
#include <print>
#include <sndfile.h>






int main(){


    SF_INFO sfinfo;
    sfinfo.format = 0; 

    SNDFILE* file = sf_open("musique_du_futur.ogg", SFM_READ, &sfinfo);

    if (!file) {
        std::println("Erreur : %s\n", sf_strerror(NULL));
    }




}