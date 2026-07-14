---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-game
artifact: testing
---

# Testing

- Run the native Fledge lane, build the complete package, and pass all 157 tests on macOS.
- Require strict SpecSync validation at 35/35 files and 3,352/3,352 lines.
- Confirm all four agents and healthy Trust configuration.
- Audit exact-head hosted Trust and CodeQL while preserving Ubuntu, macOS, and DocC workflows.
- Confirm `Sources/`, `Tests/`, and `Package.swift` have no migration diff.
