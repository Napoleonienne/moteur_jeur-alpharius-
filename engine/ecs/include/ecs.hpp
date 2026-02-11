#pragma once

#include <cstdint>
#include <bitset>
#include <vector>
#include <unordered_map>
#include <memory>
#include <typeindex>

namespace alpharius {
namespace ecs {

using Entity = std::uint32_t;
constexpr Entity MAX_ENTITIES = 4096;
constexpr std::uint8_t MAX_COMPONENTS = 64;

using ComponentMask = std::bitset<MAX_COMPONENTS>;

// Base class for all components
struct Component {};

// Component ID registry
class ComponentRegistry {
public:
    template <typename T>
    static std::uint8_t getId() {
        static std::uint8_t id = s_nextId++;
        return id;
    }

private:
    static std::uint8_t s_nextId;
};

// Entity manager: creates and destroys entities
class EntityManager {
public:
    EntityManager();

    Entity createEntity();
    void destroyEntity(Entity entity);
    std::uint32_t getEntityCount() const;

private:
    std::vector<Entity> m_availableEntities;
    std::uint32_t m_entityCount = 0;
};

// System base class
class System {
public:
    virtual ~System() = default;
    virtual void update(float dt) = 0;

    std::vector<Entity> m_entities;
};

} // namespace ecs
} // namespace alpharius
