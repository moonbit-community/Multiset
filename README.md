# Multiset - Multiset Library

[English](https://github.com/moonbit-community/Multiset/blob/main/README.md) | [简体中文](https://github.com/moonbit-community/Multiset/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/moonbit-community/Multiset/ci.yml)](https://github.com/moonbit-community/Multiset/actions) [![codecov](https://codecov.io/gh/moonbit-community/Multiset/branch/main/graph/badge.svg)](https://codecov.io/gh/moonbit-community/Multiset)

A Multiset (also known as a bag) is a collection data structure that allows elements to appear multiple times. Unlike regular sets, a Multiset not only records whether an element exists but also keeps track of how many times each element occurs (frequency). This library provides an efficient and easy-to-use Multiset implementation for the MoonBit language.

## 🚀 Features

- ✨ Support for dynamic element addition, removal, query, and update operations
- 📊 Efficient frequency statistics and counting functionality
- 🔀 Support for set operations (union, intersection, difference, symmetric difference)
- 📦 Support for batch operations (bulk add and remove)
- 📚 Intuitive API with comprehensive documentation
- 🧪 Extensive test coverage

## 📥 Installation and Dependencies

This project uses MoonBit's package management system to manage dependencies. Project dependencies are declared in the `moon.mod.json` file.

### 🛠️ Developer Guide

1. **Clone the repository**
   ```bash
   git clone https://github.com/moonbit-community/Multiset.git
   cd Multiset
   ```

2. **Install dependencies**
   ```bash
   moon pkg install
   ```

3. **Build the project**
   ```bash
   moon build
   ```

4. **Run tests**
   ```bash
   moon test
   ```
   
   > Note: There will be one expected test failure (`set_count with negative value`). This is normal behavior as the test is specifically designed to verify that the `set_count` function triggers an `abort` operation when it receives a negative value.

### 📦 Using as a Dependency

If you want to use the Multiset library in your own project, add the dependency to your project's `moon.mod.json` file:

```json
{
  "dependencies": {
    "moonbit-community/Multiset": "0.1.0"
  }
}
```

Then run:

```bash
moon pkg install
```

## 🚀 Usage

### 🔨 Creating Multisets

```moonbit
// Create an empty multiset
let ms = @Multiset.new()

// Create a multiset from an array
let ms1 = @Multiset.from_array(["a", "b", "a", "c"])

// Create a multiset from a fixed array
let ms2 = @Multiset.of(["a", "b", "a"])

// Create a multiset from an iterator
let arr = ["a", "b", "a", "c"]
let ms3 = @Multiset.from_iter(arr.iter())
```

### ⚙️ Basic Operations

```moonbit
// Add elements
ms.add("apple")                // Add one element
ms.add_n("banana", 3)          // Add multiple identical elements

// Remove elements
ms.remove("apple")             // Remove one element
ms.remove_n("banana", 2)       // Remove multiple identical elements
ms.remove_all("cherry")        // Remove all specified elements

// Query elements
let count = ms.count("apple")  // Get element count
let contains = ms.contains("apple")  // Check if element exists

// Update elements
ms.set_count("apple", 5)       // Set element count

// Get collection information
let size = ms.size()           // Get total element count
let distinct = ms.distinct_size()  // Get count of distinct elements
let is_empty = ms.is_empty()   // Check if collection is empty

// Clear collection
ms.clear()
```

### 🔀 Set Operations

```moonbit
// Set operations (returns new collections)
let union = ms1.union(ms2)                 // Union
let intersection = ms1.intersection(ms2)   // Intersection
let difference = ms1.difference(ms2)       // Difference
let sym_diff = ms1.symmetric_difference(ms2)  // Symmetric difference

// Set relationships
let is_subset = ms1.is_subset(ms2)         // Check if subset
let is_superset = ms1.is_superset(ms2)     // Check if superset

// In-place modification operations
ms1.add_all(ms2)                // Add all elements from another multiset
ms1.subtract(ms2)               // Subtract elements from another multiset
ms1.retain(ms2)                 // Retain only elements in the intersection
```

### 📊 Statistics and Conversions

```moonbit
// Get all elements and their counts
let entries = ms.to_array()

// Get all elements
let elements = ms.elements()

// Get all counts
let counts = ms.counts()

// Get most frequent element
match ms.most_common() {
  Some(entry) => {
    // Use entry.element and entry.count
  }
  None => {
    // Collection is empty
  }
}

// Get top n most frequent elements
let top_n = ms.most_common_n(3)

// Iterate over the collection
ms.each(fn(elem, count) {
  // Process each element and its count
})

// Use iterator
for elem, count in ms.iter() {
  // Process each element and its count
}
```

## ⏱️ Complexity Analysis

### Constructors

| Operation | Time Complexity | Space Complexity | Description |
|-----|-----------|-----------|-----|
| `new()` | O(1) | O(1) | Create an empty multiset |
| `from_array(arr)` | O(n) | O(n) | Create a multiset from an array, n is array length |
| `of(arr)` | O(n) | O(n) | Create a multiset from a fixed array, n is array length |
| `from_iter(iter)` | O(n) | O(n) | Create a multiset from an iterator, n is iterator element count |

### Basic Operations

| Operation | Time Complexity | Space Complexity | Description |
|-----|-----------|-----------|-----|
| `add(element)` | O(1) average | O(1) | Add one element |
| `add_n(element, count)` | O(1) average | O(1) | Add multiple identical elements |
| `remove(element)` | O(1) average | O(1) | Remove one element |
| `remove_n(element, count)` | O(1) average | O(1) | Remove multiple identical elements |
| `remove_all(element)` | O(1) average | O(1) | Remove all specified elements |
| `count(element)` | O(1) average | O(1) | Get element count |
| `contains(element)` | O(1) average | O(1) | Check if element exists |
| `set_count(element, count)` | O(1) average | O(1) | Set element count |
| `size()` | O(1) | O(1) | Get total element count |
| `distinct_size()` | O(1) | O(1) | Get count of distinct elements |
| `is_empty()` | O(1) | O(1) | Check if collection is empty |
| `clear()` | O(n) | O(1) | Clear collection, n is count of distinct elements |

### Set Operations

| Operation | Time Complexity | Space Complexity | Description |
|-----|-----------|-----------|-----|
| `union(other)` | O(n+m) | O(n+m) | Union, n and m are counts of distinct elements in both sets |
| `intersection(other)` | O(n) | O(min(n,m)) | Intersection, n is count of distinct elements in current set |
| `difference(other)` | O(n) | O(n) | Difference, n is count of distinct elements in current set |
| `symmetric_difference(other)` | O(n+m) | O(n+m) | Symmetric difference, n and m are counts of distinct elements in both sets |
| `is_subset(other)` | O(n) | O(1) | Check if subset, n is count of distinct elements in current set |
| `is_superset(other)` | O(m) | O(1) | Check if superset, m is count of distinct elements in other set |
| `add_all(other)` | O(m) | O(1) | Add all elements from another set, m is count of distinct elements in other set |
| `subtract(other)` | O(m) | O(1) | Subtract elements from another set, m is count of distinct elements in other set |
| `retain(other)` | O(n) | O(n) | Retain intersection with another set, n is count of distinct elements in current set |

### Statistics and Conversions

| Operation | Time Complexity | Space Complexity | Description |
|-----|-----------|-----------|-----|
| `to_array()` | O(n) | O(n) | Convert to array of element-count pairs, n is count of distinct elements |
| `elements()` | O(n) | O(n) | Get array of all distinct elements, n is count of distinct elements |
| `counts()` | O(n) | O(n) | Get array of all element counts, n is count of distinct elements |
| `most_common()` | O(n) | O(1) | Get most frequent element, n is count of distinct elements |
| `most_common_n(n)` | O(k log k) | O(k) | Get top k most frequent elements, k is count of distinct elements, includes sorting |
| `each(f)` | O(n) | O(1) | Iterate over all elements and their counts, n is count of distinct elements |
| `iter()` | O(1) | O(1) | Return iterator |

## ⚠️ Notes

1. Hash table operations are marked as "O(1) average" but may be O(n) in worst case
2. Set operations create new Multiset objects; use `add_all`, `subtract`, or `retain` for in-place modification
3. Using `set_count` with a negative value will cause the program to abort

## 📁 Project Structure

```
Multiset/
├── src/                # Source code directory
│   ├── Multiset.mbt    # Multiset implementation
│   └── types.mbt       # Type definitions
├── tests/              # Test files
├── moon.mod.json       # Project configuration and dependency declaration
└── README.md           # Project documentation
```

This project uses MoonBit's package management system to manage dependencies, primarily:
- `moonbitlang/core`: MoonBit language core library

## 👥 Contributing

Contributions to the Multiset library are welcome! Here's how to contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Before submitting code, please ensure:
- All tests pass (`moon test`, note: the `set_count with negative value` test is expected to fail, which is normal behavior)
- Code coverage remains high (`moon coverage report`)
- Code style conforms to project standards

## 📜 License

This project is licensed under the Apache-2.0 License. See the LICENSE file for details.

## 📢 Contact

For questions or suggestions, please contact:
- Submit a GitHub Issue

👋 If you like this project, please give it a star! Happy coding! 🚀