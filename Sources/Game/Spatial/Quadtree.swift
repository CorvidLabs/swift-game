import Foundation

/// A quadtree for efficient spatial partitioning in 2D space.
public actor Quadtree<Element: Sendable> {
    /// An item stored in the quadtree with its position.
    public struct Item: Sendable {
        public let position: Vec2
        public let element: Element

        public init(position: Vec2, element: Element) {
            self.position = position
            self.element = element
        }
    }

    private let bounds: AABB
    private let capacity: Int
    private var items: [Item] = []
    private var divided: Bool = false

    private var northwest: Quadtree?
    private var northeast: Quadtree?
    private var southwest: Quadtree?
    private var southeast: Quadtree?

    /// Creates a quadtree with the given bounds and capacity per node.
    public init(bounds: AABB, capacity: Int = 4) {
        self.bounds = bounds
        self.capacity = capacity
    }

    /// Inserts an item into the quadtree.
    public func insert(_ item: Item) async -> Bool {
        guard bounds.contains(item.position) else { return false }

        if items.count < capacity {
            items.append(item)
            return true
        }

        if !divided {
            await subdivide()
        }

        if await northwest?.insert(item) == true { return true }
        if await northeast?.insert(item) == true { return true }
        if await southwest?.insert(item) == true { return true }
        if await southeast?.insert(item) == true { return true }

        return false
    }

    /// Queries items within a given range.
    public func query(in range: AABB) async -> [Item] {
        var found: [Item] = []

        guard bounds.intersects(range) else { return found }

        for item in items where range.contains(item.position) {
            found.append(item)
        }

        if divided {
            if let nw = northwest { found.append(contentsOf: await nw.query(in: range)) }
            if let ne = northeast { found.append(contentsOf: await ne.query(in: range)) }
            if let sw = southwest { found.append(contentsOf: await sw.query(in: range)) }
            if let se = southeast { found.append(contentsOf: await se.query(in: range)) }
        }

        return found
    }

    /// Queries items within a given radius of a point.
    public func query(near point: Vec2, radius: Double) async -> [Item] {
        let searchBounds = AABB(
            center: point,
            size: Vec2(x: radius * 2, y: radius * 2)
        )

        return await query(in: searchBounds).filter { item in
            item.position.distanceSquared(to: point) <= radius * radius
        }
    }

    /// Finds the nearest item to a given point.
    public func nearest(to point: Vec2) async -> Item? {
        var closest: Item?
        var closestDistance = Double.infinity

        await findNearest(
            to: point,
            closest: &closest,
            closestDistance: &closestDistance
        )

        return closest
    }

    private func findNearest(
        to point: Vec2,
        closest: inout Item?,
        closestDistance: inout Double
    ) async {
        guard bounds.closestPoint(to: point).distanceSquared(to: point) < closestDistance * closestDistance else {
            return
        }

        for item in items {
            let distance = item.position.distanceSquared(to: point)
            if distance < closestDistance * closestDistance {
                closestDistance = sqrt(distance)
                closest = item
            }
        }

        if divided {
            if let nw = northwest { await nw.findNearest(to: point, closest: &closest, closestDistance: &closestDistance) }
            if let ne = northeast { await ne.findNearest(to: point, closest: &closest, closestDistance: &closestDistance) }
            if let sw = southwest { await sw.findNearest(to: point, closest: &closest, closestDistance: &closestDistance) }
            if let se = southeast { await se.findNearest(to: point, closest: &closest, closestDistance: &closestDistance) }
        }
    }

    /// Removes all items from the quadtree.
    public func clear() {
        items.removeAll()
        divided = false
        northwest = nil
        northeast = nil
        southwest = nil
        southeast = nil
    }

    private func subdivide() async {
        let center = bounds.center
        let halfSize = bounds.size / 2

        northwest = Quadtree(
            bounds: AABB(center: center + Vec2(x: -halfSize.x / 2, y: halfSize.y / 2), size: halfSize),
            capacity: capacity
        )
        northeast = Quadtree(
            bounds: AABB(center: center + Vec2(x: halfSize.x / 2, y: halfSize.y / 2), size: halfSize),
            capacity: capacity
        )
        southwest = Quadtree(
            bounds: AABB(center: center + Vec2(x: -halfSize.x / 2, y: -halfSize.y / 2), size: halfSize),
            capacity: capacity
        )
        southeast = Quadtree(
            bounds: AABB(center: center + Vec2(x: halfSize.x / 2, y: -halfSize.y / 2), size: halfSize),
            capacity: capacity
        )

        divided = true
    }
}
