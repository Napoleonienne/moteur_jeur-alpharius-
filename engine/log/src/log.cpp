
#include <log.hpp>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>

namespace alpharius {
namespace system {

std::shared_ptr<spdlog::logger> log::s_CoreLogger;
std::shared_ptr<spdlog::logger> log::s_ClientLogger;

void log::init() {
    spdlog::set_pattern("[%Y-%m-%d %H:%M:%S] [%n] [%^%l%$] %v");

    s_CoreLogger = spdlog::stdout_color_mt("ALPHARIUS");
    s_CoreLogger->set_level(spdlog::level::trace);

    s_ClientLogger = spdlog::stdout_color_mt("APP");
    s_ClientLogger->set_level(spdlog::level::trace);
}

} // namespace system
} // namespace alpharius

