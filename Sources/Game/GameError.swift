import Foundation

/// Errors that can occur in the Game framework.
public enum GameError: Error, Sendable, CustomStringConvertible {
    case invalidInput(String)
    case invalidRange(String)
    case invalidConfiguration(String)
    case invalidState(String)
    case pathfindingFailed(String)
    case invalidDiceNotation(String)
    case entityNotFound(String)
    case componentNotFound(String)
    case outOfBounds(String)
    case computationFailed(String)

    public var description: String {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .invalidRange(let message):
            return "Invalid range: \(message)"
        case .invalidConfiguration(let message):
            return "Invalid configuration: \(message)"
        case .invalidState(let message):
            return "Invalid state: \(message)"
        case .pathfindingFailed(let message):
            return "Pathfinding failed: \(message)"
        case .invalidDiceNotation(let message):
            return "Invalid dice notation: \(message)"
        case .entityNotFound(let message):
            return "Entity not found: \(message)"
        case .componentNotFound(let message):
            return "Component not found: \(message)"
        case .outOfBounds(let message):
            return "Out of bounds: \(message)"
        case .computationFailed(let message):
            return "Computation failed: \(message)"
        }
    }
}
