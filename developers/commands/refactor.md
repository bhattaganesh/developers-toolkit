---
description: Guided refactoring — identifies type, reads code and tests, performs refactoring, updates references, verifies tests pass
---

# Refactor

Perform a guided refactoring with safety checks at each step.

## Instructions

1. **Identify refactoring type** — Ask the user what they want to refactor and classify the type:
   - **Extract** — Pull code into a new method, class, or component
   - **Rename** — Rename a variable, method, class, or file
   - **Move** — Relocate code to a different file, directory, or namespace
   - **Split** — Break a large class/file into smaller, focused pieces
   - **Convert pattern** — Change from one pattern to another (e.g., callback to promise, inheritance to composition)

2. **Read target code and tests** — Before making any changes:
   - Read the file(s) to be refactored
   - Find and read all related test files
   - Identify all callers and references using Grep
   - Note the current public API/interface that must be preserved

3. **Perform refactoring** — Execute the refactoring while:
   - Maintaining the existing public API and interface contracts
   - Preserving all existing behavior (no functional changes)
   - Following project code standards (WPCS for PHP, project conventions for JS)
   - Making one logical change at a time

4. **Update references** — After the core refactoring:
   - Update all import paths and namespace references
   - Update any configuration files that reference moved/renamed items
   - Update type hints and docblocks if applicable
   - Search for string references (e.g., class names in config files)

5. **Verify tests pass** — Run the existing test suite to confirm nothing broke:
   - Run `php wp test` (or appropriate test command)
   - If tests fail, fix the refactoring (not the tests) unless the test was testing implementation details
   - Report results to the user before considering the refactoring complete


