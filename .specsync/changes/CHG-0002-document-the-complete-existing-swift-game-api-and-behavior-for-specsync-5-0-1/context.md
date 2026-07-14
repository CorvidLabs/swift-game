---
change: CHG-0002-document-the-complete-existing-swift-game-api-and-behavior-for-specsync-5-0-1
artifact: context
---

# Context

Swift Game already implements a broad public utility API across 35 source files and 3,352 lines, but adoption began without a canonical companion and with an advisory zero threshold. This documentation change records the existing contract at full coverage without modifying `Sources/`, `Tests/`, or `Package.swift`.

The companion separates executed evidence from source review: 157 deterministic tests cover the principal behavior across nine suites, while LootTable, SpatialHash, Scheduler, and TweenManager surfaces without direct tests are explicitly labeled source-reviewed.
