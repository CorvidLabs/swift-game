import Foundation

/// The ECS world that manages entities and their components.
public actor World {
    private var entities: Set<Entity> = []
    private var components: [String: [Entity: any Component]] = [:]

    /// Creates a new ECS world.
    public init() {}

    /// Creates a new entity.
    @discardableResult
    public func createEntity() -> Entity {
        let entity = Entity.create()
        entities.insert(entity)
        return entity
    }

    /// Destroys an entity and removes all its components.
    public func destroyEntity(_ entity: Entity) {
        entities.remove(entity)
        for key in components.keys {
            components[key]?[entity] = nil
        }
    }

    /// Checks if an entity exists in the world.
    public func hasEntity(_ entity: Entity) -> Bool {
        entities.contains(entity)
    }

    /// Adds a component to an entity.
    public func addComponent<T: Component>(_ component: T, to entity: Entity) {
        let key = String(describing: T.self)
        if components[key] == nil {
            components[key] = [:]
        }
        components[key]?[entity] = component
    }

    /// Removes a component from an entity.
    public func removeComponent<T: Component>(_: T.Type, from entity: Entity) {
        let key = String(describing: T.self)
        components[key]?[entity] = nil
    }

    /// Gets a component from an entity.
    public func getComponent<T: Component>(_: T.Type, from entity: Entity) -> T? {
        let key = String(describing: T.self)
        return components[key]?[entity] as? T
    }

    /// Checks if an entity has a component.
    public func hasComponent<T: Component>(_: T.Type, on entity: Entity) -> Bool {
        getComponent(T.self, from: entity) != nil
    }

    /// Updates a component on an entity using a closure.
    public func updateComponent<T: Component>(
        _: T.Type,
        on entity: Entity,
        update: (inout T) -> Void
    ) {
        guard var component = getComponent(T.self, from: entity) else { return }
        update(&component)
        addComponent(component, to: entity)
    }

    /// Returns all entities that have a specific component.
    public func entitiesWith<T: Component>(_: T.Type) -> [Entity] {
        let key = String(describing: T.self)
        guard let componentMap = components[key] else { return [] }
        return Array(componentMap.keys)
    }

    /// Returns all entities that have all specified components.
    public func entitiesWithAll<T1: Component, T2: Component>(
        _: T1.Type,
        _: T2.Type
    ) -> [Entity] {
        let entities1 = Set(entitiesWith(T1.self))
        let entities2 = Set(entitiesWith(T2.self))
        return Array(entities1.intersection(entities2))
    }

    /// Returns all entities that have all three specified components.
    public func entitiesWithAll<T1: Component, T2: Component, T3: Component>(
        _: T1.Type,
        _: T2.Type,
        _: T3.Type
    ) -> [Entity] {
        let entities1 = Set(entitiesWith(T1.self))
        let entities2 = Set(entitiesWith(T2.self))
        let entities3 = Set(entitiesWith(T3.self))
        return Array(entities1.intersection(entities2).intersection(entities3))
    }

    /// Queries entities with a specific component and provides the component.
    public func query<T: Component>(
        _: T.Type,
        forEach: (Entity, T) -> Void
    ) {
        let key = String(describing: T.self)
        guard let componentMap = components[key] else { return }

        for (entity, component) in componentMap {
            if let typedComponent = component as? T {
                forEach(entity, typedComponent)
            }
        }
    }

    /// Queries entities with two components.
    public func query<T1: Component, T2: Component>(
        _: T1.Type,
        _: T2.Type,
        forEach: (Entity, T1, T2) -> Void
    ) {
        for entity in entitiesWithAll(T1.self, T2.self) {
            guard let c1 = getComponent(T1.self, from: entity),
                  let c2 = getComponent(T2.self, from: entity) else {
                continue
            }
            forEach(entity, c1, c2)
        }
    }

    /// Returns the total number of entities.
    public var entityCount: Int {
        entities.count
    }

    /// Removes all entities and components.
    public func clear() {
        entities.removeAll()
        components.removeAll()
    }
}
