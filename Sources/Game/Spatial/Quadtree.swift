import Foundation

/// A quadtree for efficient spatial partitioning in 2D space.
public final class Quadtree<Element: Sendable>: @unchecked Sendable {
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
    public func insert(_ item: Item) -> Bool {
        guard bounds.contains(item.position) else { return false }

        if items.count < capacity {
            items.append(item)
            return true
        }

        if !divided {
            subdivide()
        }

        return northwest?.insert(item) == true ||
               northeast?.insert(item) == true ||
               southwest?.insert(item) == true ||
               southeast?.insert(item) == true
    }

    /// Queries items within a given range.
    public func query(in range: AABB) -> [Item] {
        var found: [Item] = []

        guard bounds.intersects(range) else { return found }

        for item in items where range.contains(item.position) {
            found.append(item)
        }

        if divided {
            found.append(contentsOf: northwest?.query(in: range) ?? [])
            found.append(contentsOf: northeast?.query(in: range) ?? [])
            found.append(contentsOf: southwest?.query(in: range) ?? [])
            found.append(contentsOf: southeast?.query(in: range) ?? [])
        }

        return found
    }

    /// Queries items within a given radius of a point.
    public func query(near point: Vec2, radius: Double) -> [Item] {
        let searchBounds = AABB(
            center: point,
            size: Vec2(x: radius * 2, y: radius * 2)
        )

        return query(in: searchBounds).filter { item in
            item.position.distanceSquared(to: point) <= radius * radius
        }
    }

    /// Finds the nearest item to a given point.
    public func nearest(to point: Vec2) -> Item? {
        var closest: Item?
        var closestDistance = Double.infinity

        findNearest(
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
    ) {
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
            northwest?.findNearest(to: point, closest: &closest, closestDistance: &closestDistance)
            northeast?.findNearest(to: point, closest: &closest, closestDistance: &closestDistance)
            southwest?.findNearest(to: point, closest: &closest, closestDistance: &closestDistance)
            southeast?.findNearest(to: point, closest: &closest, closestDistance: &closestDistance)
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

    private func subdivide() {
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
