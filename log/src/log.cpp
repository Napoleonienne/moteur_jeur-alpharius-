
#include <log.hpp>
#include <spdlog/spdlog.h>
#include <spdlog/async.h>


namespace alpharius {
namespace system{

void log::init() {
    // Initialize spdlog here
    spdlog::set_level(spdlog::level::info); // Set global log level to info
    spdlog::set_pattern("[%Y-%m-%d %H:%M:%S] [%l] %v"); // Set log pattern
};





}
}




