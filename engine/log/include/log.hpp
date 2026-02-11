#pragma once

#include <spdlog/spdlog.h>
#include <memory>

namespace alpharius {
namespace system {

class log {
public:
    static void init();

    static std::shared_ptr<spdlog::logger>& GetCoreLogger() { return s_CoreLogger; }
    static std::shared_ptr<spdlog::logger>& GetClientLogger() { return s_ClientLogger; }

private:
    static std::shared_ptr<spdlog::logger> s_CoreLogger;
    static std::shared_ptr<spdlog::logger> s_ClientLogger;
};

} // namespace system
} // namespace alpharius

// Core log macros (engine internals)
#define AL_CORE_TRACE(...)    ::alpharius::system::log::GetCoreLogger()->trace(__VA_ARGS__)
#define AL_CORE_INFO(...)     ::alpharius::system::log::GetCoreLogger()->info(__VA_ARGS__)
#define AL_CORE_WARN(...)     ::alpharius::system::log::GetCoreLogger()->warn(__VA_ARGS__)
#define AL_CORE_ERROR(...)    ::alpharius::system::log::GetCoreLogger()->error(__VA_ARGS__)
#define AL_CORE_CRITICAL(...) ::alpharius::system::log::GetCoreLogger()->critical(__VA_ARGS__)

// Client log macros (application layer)
#define AL_TRACE(...)         ::alpharius::system::log::GetClientLogger()->trace(__VA_ARGS__)
#define AL_INFO(...)          ::alpharius::system::log::GetClientLogger()->info(__VA_ARGS__)
#define AL_WARN(...)          ::alpharius::system::log::GetClientLogger()->warn(__VA_ARGS__)
#define AL_ERROR(...)         ::alpharius::system::log::GetClientLogger()->error(__VA_ARGS__)
#define AL_CRITICAL(...)      ::alpharius::system::log::GetClientLogger()->critical(__VA_ARGS__)