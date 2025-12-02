import Foundation

/// A protocol for graphs that support pathfinding.
public protocol Graph: Sendable {
    associatedtype Node: Hashable & Sendable

    /// Returns the neighbors of a given node.
    func neighbors(of node: Node) -> [Node]

    /// Returns the cost to move from one node to another.
    func cost(from: Node, to: Node) -> Double
}
