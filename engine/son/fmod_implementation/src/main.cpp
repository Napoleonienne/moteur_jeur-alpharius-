#include <iostream>
#include <fmod.hpp>
#include <fmod_common.h>
#include <fmod_errors.h>

FMOD_RESULT result;
FMOD::System *system = NULL;
result = FMOD::System_Create(&system);      // Create the main system object.





int main(){
   

    if (result != FMOD_OK)
{
    printf("FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
    exit(-1);
}
result = system->init(512, FMOD_INIT_NORMAL, 0);    // Initialize FMOD.
if (result != FMOD_OK)
{
    printf("FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
    exit(-1);
}



    return 0;
}