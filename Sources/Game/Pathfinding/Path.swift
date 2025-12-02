import Foundation

/// Represents a path found by a pathfinding algorithm.
public struct Path<Node: Sendable>: Sendable {
    /// The nodes in the path from start to goal.
    public let nodes: [Node]

    /// The total cost of the path.
    public let cost: Double

    public init(nodes: [Node], cost: Double) {
        self.nodes = nodes
        self.cost = cost
    }

    /// Whether a valid path was found.
    public var found: Bool {
        !nodes.isEmpty
    }

    /// The number of steps in the path.
    public var length: Int {
        nodes.count
    }

    /// The starting node of the path.
    public var start: Node? {
        nodes.first
    }

    /// The goal node of the path.
    public var goal: Node? {
        nodes.last
    }

    /// An empty path representing failure to find a route.
    public static var notFound: Path {
        Path(nodes: [], cost: .infinity)
    }
}

// MARK: - Equatable

extension Path: Equatable where Node: Equatable {
    public static func == (lhs: Path<Node>, rhs: Path<Node>) -> Bool {
        lhs.nodes == rhs.nodes && lhs.cost == rhs.cost
    }
}

// MARK: - Collection

extension Path: Collection {
    public var startIndex: Int { nodes.startIndex }
    public var endIndex: Int { nodes.endIndex }

    public subscript(position: Int) -> Node {
        nodes[position]
    }

    public func index(after i: Int) -> Int {
        nodes.index(after: i)
    }
}
