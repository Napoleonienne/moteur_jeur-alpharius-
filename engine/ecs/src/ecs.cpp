#include <ecs.hpp>

namespace alpharius {
namespace ecs {

std::uint8_t ComponentRegistry::s_nextId = 0;

EntityManager::EntityManager() {
    for (Entity e = 0; e < MAX_ENTITIES; ++e) {
        m_availableEntities.push_back(e);
    }
}

Entity EntityManager::createEntity() {
    Entity id = m_availableEntities.back();
    m_availableEntities.pop_back();
    ++m_entityCount;
    return id;
}

void EntityManager::destroyEntity(Entity entity) {
    m_availableEntities.push_back(entity);
    --m_entityCount;
}

std::uint32_t EntityManager::getEntityCount() const {
    return m_entityCount;
}

} // namespace ecs
} // namespace alpharius
