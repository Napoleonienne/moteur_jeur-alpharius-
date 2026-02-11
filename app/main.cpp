#include <iostream>
#include <ecs.hpp>

int main(int, char**) {
    std::cout << "Alpharisus Engine v0.1.0\n";

    // Initialize ECS
    alpharius::ecs::EntityManager entityManager;
    auto entity1 = entityManager.createEntity();
    auto entity2 = entityManager.createEntity();

    std::cout << "Entities created: " << entityManager.getEntityCount() << "\n";

    entityManager.destroyEntity(entity1);
    std::cout << "After destroy, entities: " << entityManager.getEntityCount() << "\n";

    return 0;
}
