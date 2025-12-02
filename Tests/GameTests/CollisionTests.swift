import Testing
@testable import Game

@Suite("Collision Tests")
struct CollisionTests {
    // MARK: - AABB Tests

    @Test("AABB creation and properties")
    func aabbCreationAndProperties() {
        let aabb = AABB(x: 0, y: 0, width: 10, height: 20)

        #expect(aabb.width == 10)
        #expect(aabb.height == 20)
        #expect(aabb.center == Vec2(x: 5, y: 10))
        #expect(aabb.size == Vec2(x: 10, y: 20))
        #expect(aabb.extents == Vec2(x: 5, y: 10))
    }

    @Test("AABB from center and size")
    func aabbFromCenterAndSize() {
        let aabb = AABB(center: Vec2(x: 5, y: 5), size: Vec2(x: 4, y: 6))

        #expect(aabb.min == Vec2(x: 3, y: 2))
        #expect(aabb.max == Vec2(x: 7, y: 8))
    }

    @Test("AABB contains point")
    func aabbContainsPoint() {
        let aabb = AABB(x: 0, y: 0, width: 10, height: 10)

        #expect(aabb.contains(Vec2(x: 5, y: 5)))
        #expect(aabb.contains(Vec2(x: 0, y: 0)))
        #expect(aabb.contains(Vec2(x: 10, y: 10)))
        #expect(!aabb.contains(Vec2(x: -1, y: 5)))
        #expect(!aabb.contains(Vec2(x: 11, y: 5)))
    }

    @Test("AABB intersection")
    func aabbIntersection() {
        let aabb1 = AABB(x: 0, y: 0, width: 10, height: 10)
        let aabb2 = AABB(x: 5, y: 5, width: 10, height: 10)
        let aabb3 = AABB(x: 20, y: 20, width: 10, height: 10)

        #expect(aabb1.intersects(aabb2))
        #expect(aabb2.intersects(aabb1))
        #expect(!aabb1.intersects(aabb3))
    }

    @Test("AABB containment")
    func aabbContainment() {
        let outer = AABB(x: 0, y: 0, width: 20, height: 20)
        let inner = AABB(x: 5, y: 5, width: 5, height: 5)
        let partial = AABB(x: 15, y: 15, width: 10, height: 10)

        #expect(outer.contains(inner))
        #expect(!inner.contains(outer))
        #expect(!outer.contains(partial))
    }

    @Test("AABB union and intersection")
    func aabbUnionAndIntersection() {
        let aabb1 = AABB(x: 0, y: 0, width: 10, height: 10)
        let aabb2 = AABB(x: 5, y: 5, width: 10, height: 10)

        let union = aabb1.union(with: aabb2)
        #expect(union.min == Vec2(x: 0, y: 0))
        #expect(union.max == Vec2(x: 15, y: 15))

        let intersection = aabb1.intersection(with: aabb2)
        #expect(intersection != nil)
        #expect(intersection?.min == Vec2(x: 5, y: 5))
        #expect(intersection?.max == Vec2(x: 10, y: 10))
    }

    @Test("AABB closest point")
    func aabbClosestPoint() {
        let aabb = AABB(x: 0, y: 0, width: 10, height: 10)

        let closest1 = aabb.closestPoint(to: Vec2(x: 5, y: 5))
        #expect(closest1 == Vec2(x: 5, y: 5))

        let closest2 = aabb.closestPoint(to: Vec2(x: -5, y: 5))
        #expect(closest2 == Vec2(x: 0, y: 5))

        let closest3 = aabb.closestPoint(to: Vec2(x: 15, y: 15))
        #expect(closest3 == Vec2(x: 10, y: 10))
    }

    @Test("AABB expanded")
    func aabbExpanded() {
        let aabb = AABB(x: 0, y: 0, width: 10, height: 10)
        let expanded = aabb.expanded(by: 5)

        #expect(expanded.min == Vec2(x: -5, y: -5))
        #expect(expanded.max == Vec2(x: 15, y: 15))
    }

    @Test("AABB collision result")
    func aabbCollisionResult() {
        let aabb1 = AABB(x: 0, y: 0, width: 10, height: 10)
        let aabb2 = AABB(x: 8, y: 0, width: 10, height: 10)

        let result = aabb1.collisionResult(with: aabb2)
        #expect(result.collided)
        #expect(result.depth == 2)

        let noCollision = AABB(x: 20, y: 20, width: 10, height: 10)
        let result2 = aabb1.collisionResult(with: noCollision)
        #expect(!result2.collided)
    }

    // MARK: - Circle Tests

    @Test("Circle creation and properties")
    func circleCreationAndProperties() {
        let circle = Circle(x: 5, y: 5, radius: 10)

        #expect(circle.center == Vec2(x: 5, y: 5))
        #expect(circle.radius == 10)
        #expect(circle.diameter == 20)
        #expect(abs(circle.area - (.pi * 100)) < 0.0001)
    }

    @Test("Circle contains point")
    func circleContainsPoint() {
        let circle = Circle(center: Vec2(x: 0, y: 0), radius: 5)

        #expect(circle.contains(Vec2(x: 0, y: 0)))
        #expect(circle.contains(Vec2(x: 3, y: 4)))
        #expect(circle.contains(Vec2(x: 5, y: 0)))
        #expect(!circle.contains(Vec2(x: 6, y: 0)))
    }

    @Test("Circle intersection with circle")
    func circleIntersectionWithCircle() {
        let circle1 = Circle(center: Vec2(x: 0, y: 0), radius: 5)
        let circle2 = Circle(center: Vec2(x: 8, y: 0), radius: 5)
        let circle3 = Circle(center: Vec2(x: 20, y: 0), radius: 5)

        #expect(circle1.intersects(circle2))
        #expect(!circle1.intersects(circle3))
    }

    @Test("Circle containment")
    func circleContainment() {
        let outer = Circle(center: Vec2(x: 0, y: 0), radius: 10)
        let inner = Circle(center: Vec2(x: 0, y: 0), radius: 5)

        #expect(outer.contains(inner))
        #expect(!inner.contains(outer))
    }

    @Test("Circle collision with circle")
    func circleCollisionWithCircle() {
        let circle1 = Circle(center: Vec2(x: 0, y: 0), radius: 5)
        let circle2 = Circle(center: Vec2(x: 8, y: 0), radius: 5)

        let result = circle1.collisionResult(with: circle2)
        #expect(result.collided)
        #expect(result.depth == 2)

        let noCollision = Circle(center: Vec2(x: 20, y: 0), radius: 5)
        let result2 = circle1.collisionResult(with: noCollision)
        #expect(!result2.collided)
    }

    @Test("Circle intersection with AABB")
    func circleIntersectionWithAABB() {
        let circle = Circle(center: Vec2(x: 5, y: 5), radius: 3)
        let aabb1 = AABB(x: 0, y: 0, width: 10, height: 10)
        let aabb2 = AABB(x: 20, y: 20, width: 10, height: 10)

        #expect(circle.intersects(aabb1))
        #expect(!circle.intersects(aabb2))
    }

    @Test("Circle collision with AABB")
    func circleCollisionWithAABB() {
        let circle = Circle(center: Vec2(x: 12, y: 5), radius: 3)
        let aabb = AABB(x: 0, y: 0, width: 10, height: 10)

        let result = circle.collisionResult(with: aabb)
        #expect(result.collided)
        #expect(result.depth != nil)

        let noCollision = AABB(x: 20, y: 20, width: 10, height: 10)
        let result2 = circle.collisionResult(with: noCollision)
        #expect(!result2.collided)
    }

    @Test("Circle closest point")
    func circleClosestPoint() {
        let circle = Circle(center: Vec2(x: 0, y: 0), radius: 5)
        let point = Vec2(x: 10, y: 0)

        let closest = circle.closestPoint(to: point)
        #expect(abs(closest.x - 5) < 0.0001)
        #expect(abs(closest.y) < 0.0001)
    }

    // MARK: - Ray Tests

    @Test("Ray creation")
    func rayCreation() {
        let ray = Ray(origin: Vec2(x: 0, y: 0), direction: Vec2(x: 1, y: 0))

        #expect(ray.origin == Vec2.zero)
        #expect(abs(ray.direction.magnitude - 1.0) < 0.0001)
    }

    @Test("Ray towards target")
    func rayTowardsTarget() {
        let ray = Ray.towards(origin: Vec2(x: 0, y: 0), target: Vec2(x: 10, y: 0))

        #expect(ray.origin == Vec2.zero)
        #expect(abs(ray.direction.x - 1.0) < 0.0001)
        #expect(abs(ray.direction.y) < 0.0001)
    }

    @Test("Ray point at distance")
    func rayPointAtDistance() {
        let ray = Ray(origin: Vec2(x: 0, y: 0), direction: Vec2(x: 1, y: 0))
        let point = ray.point(at: 10)

        #expect(abs(point.x - 10) < 0.0001)
        #expect(abs(point.y) < 0.0001)
    }

    @Test("Ray cast against circle")
    func rayCastAgainstCircle() {
        let ray = Ray(origin: Vec2(x: 0, y: 0), direction: Vec2(x: 1, y: 0))
        let circle = Circle(center: Vec2(x: 10, y: 0), radius: 2)

        let distance = ray.cast(circle: circle)
        #expect(distance != nil)
        #expect(abs(distance! - 8) < 0.0001)

        let missCircle = Circle(center: Vec2(x: 10, y: 10), radius: 2)
        let missDistance = ray.cast(circle: missCircle)
        #expect(missDistance == nil)
    }

    @Test("Ray cast against AABB")
    func rayCastAgainstAABB() {
        let ray = Ray(origin: Vec2(x: 0, y: 5), direction: Vec2(x: 1, y: 0))
        let aabb = AABB(x: 10, y: 0, width: 10, height: 10)

        let distance = ray.cast(aabb: aabb)
        #expect(distance != nil)
        #expect(abs(distance! - 10) < 0.0001)

        let missAABB = AABB(x: 10, y: 20, width: 10, height: 10)
        let missDistance = ray.cast(aabb: missAABB)
        #expect(missDistance == nil)
    }

    // MARK: - Raycast Tests

    @Test("Raycast against circle")
    func raycastAgainstCircle() {
        let ray = Ray(origin: Vec2(x: 0, y: 0), direction: Vec2(x: 1, y: 0))
        let circle = Circle(center: Vec2(x: 10, y: 0), radius: 2)

        let hit = Raycast.cast(ray: ray, circle: circle)
        #expect(hit.hit)
        #expect(hit.distance != nil)
        #expect(hit.point != nil)
        #expect(hit.normal != nil)

        let missCircle = Circle(center: Vec2(x: 10, y: 10), radius: 2)
        let miss = Raycast.cast(ray: ray, circle: missCircle)
        #expect(!miss.hit)
    }

    @Test("Raycast against AABB")
    func raycastAgainstAABB() {
        let ray = Ray(origin: Vec2(x: 0, y: 5), direction: Vec2(x: 1, y: 0))
        let aabb = AABB(x: 10, y: 0, width: 10, height: 10)

        let hit = Raycast.cast(ray: ray, aabb: aabb)
        #expect(hit.hit)
        #expect(hit.distance != nil)
        #expect(hit.point != nil)
        #expect(hit.normal != nil)

        let missAABB = AABB(x: 10, y: 20, width: 10, height: 10)
        let miss = Raycast.cast(ray: ray, aabb: missAABB)
        #expect(!miss.hit)
    }

    @Test("Raycast multiple circles")
    func raycastMultipleCircles() {
        let ray = Ray(origin: Vec2(x: 0, y: 0), direction: Vec2(x: 1, y: 0))
        let circles = [
            Circle(center: Vec2(x: 10, y: 0), radius: 2),
            Circle(center: Vec2(x: 20, y: 0), radius: 2),
            Circle(center: Vec2(x: 5, y: 0), radius: 1)
        ]

        let hit = Raycast.cast(ray: ray, circles: circles)
        #expect(hit.hit)
        #expect(hit.distance != nil)
        #expect(hit.distance! < 5)
    }
}
