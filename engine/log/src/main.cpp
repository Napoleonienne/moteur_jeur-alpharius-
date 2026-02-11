#include "log.hpp"

int main()
{
    alpharius::system::log::init();

    AL_CORE_INFO("Welcome to Alpharius Engine!");
    AL_CORE_ERROR("Some error message with arg: {}", 1);
    AL_CORE_WARN("Easy padding in numbers like {:08d}", 12);
    AL_CORE_CRITICAL("Support for int: {0:d};  hex: {0:x};  oct: {0:o}; bin: {0:b}", 42);

    AL_INFO("Application layer initialized");
    AL_TRACE("Trace message from application");

    return 0;
}
