# Multiset - 多重集合库

[English](https://github.com/moonbit-community/Multiset/blob/main/README.md) | [简体中文](https://github.com/moonbit-community/Multiset/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/moonbit-community/Multiset/ci.yml)](https://github.com/moonbit-community/Multiset/actions) [![codecov](https://codecov.io/gh/moonbit-community/Multiset/branch/main/graph/badge.svg)](https://codecov.io/gh/moonbit-community/Multiset)

Multiset（多重集合）是一种允许元素重复出现的集合数据结构。与普通集合不同，Multiset不仅记录元素是否存在，还记录每个元素出现的次数（频率）。这个库提供了一个高效、易用的Multiset实现，适用于MoonBit语言。

## 🚀 特性

- ✨ 支持元素的动态添加、删除、查询和更新操作
- 📊 提供高效的频率统计与计数功能
- 🔀 支持集合操作（并集、交集、差集、对称差集）
- 📦 支持批量操作（批量添加与删除）
- 📚 提供直观的API和完整的文档
- 🧪 全面的测试覆盖

## 📥 安装与依赖

本项目使用MoonBit的包管理系统来管理依赖。项目依赖已在`moon.mod.json`文件中声明。

### 🛠️ 开发者使用指南

1. **克隆项目**
   ```bash
   git clone https://github.com/moonbit-community/Multiset.git
   cd Multiset
   ```

2. **安装依赖**
   ```bash
   moon pkg install
   ```

3. **构建项目**
   ```bash
   moon build
   ```

4. **运行测试**
   ```bash
   moon test
   ```
   
   > 注意：测试运行时会有一个预期的失败测试（`set_count with negative value`）。这是正常现象，因为该测试是专门用来验证当`set_count`函数接收负值时会触发`abort`操作。

### 📦 作为依赖使用

如果您想在自己的项目中使用Multiset库，请在您项目的`moon.mod.json`文件中添加依赖：

```json
{
  "dependencies": {
    "moonbit-community/Multiset": "0.1.0"
  }
}
```

然后运行：

```bash
moon pkg install
```

## 🚀 使用方法

### 🔨 创建多重集合

```moonbit
// 创建空的多重集合
let ms = @Multiset.new()

// 从数组创建多重集合
let ms1 = @Multiset.from_array(["a", "b", "a", "c"])

// 从固定数组创建多重集合
let ms2 = @Multiset.of(["a", "b", "a"])

// 从迭代器创建多重集合
let arr = ["a", "b", "a", "c"]
let ms3 = @Multiset.from_iter(arr.iter())
```

### ⚙️ 基本操作

```moonbit
// 添加元素
ms.add("apple")                // 添加一个元素
ms.add_n("banana", 3)          // 添加多个相同元素

// 移除元素
ms.remove("apple")             // 移除一个元素
ms.remove_n("banana", 2)       // 移除多个相同元素
ms.remove_all("cherry")        // 移除所有指定元素

// 查询元素
let count = ms.count("apple")  // 获取元素计数
let contains = ms.contains("apple")  // 检查是否包含元素

// 更新元素
ms.set_count("apple", 5)       // 设置元素的计数

// 获取集合信息
let size = ms.size()           // 获取元素总数
let distinct = ms.distinct_size()  // 获取不同元素的数量
let is_empty = ms.is_empty()   // 检查集合是否为空

// 清空集合
ms.clear()
```

### 🔀 集合操作

```moonbit
// 集合操作（返回新集合）
let union = ms1.union(ms2)                 // 并集
let intersection = ms1.intersection(ms2)   // 交集
let difference = ms1.difference(ms2)       // 差集
let sym_diff = ms1.symmetric_difference(ms2)  // 对称差集

// 集合关系
let is_subset = ms1.is_subset(ms2)         // 判断是否为子集
let is_superset = ms1.is_superset(ms2)     // 判断是否为超集

// 原地修改操作
ms1.add_all(ms2)                // 添加另一个集合的所有元素
ms1.subtract(ms2)               // 减去另一个集合的元素
ms1.retain(ms2)                 // 保留与另一个集合的交集
```

### 📊 统计与转换

```moonbit
// 获取所有元素及其计数
let entries = ms.to_array()

// 获取所有元素
let elements = ms.elements()

// 获取所有计数
let counts = ms.counts()

// 获取最高频元素
match ms.most_common() {
  Some(entry) => {
    // 使用entry.element和entry.count
  }
  None => {
    // 集合为空
  }
}

// 获取最高频的n个元素
let top_n = ms.most_common_n(3)

// 遍历集合
ms.each(fn(elem, count) {
  // 处理每个元素和其计数
})

// 使用迭代器
for elem, count in ms.iter() {
  // 处理每个元素和其计数
}
```

## ⏱️ 复杂度分析

### 构造函数

| 操作 | 时间复杂度 | 空间复杂度 | 描述 |
|-----|-----------|-----------|-----|
| `new()` | O(1) | O(1) | 创建空多重集合 |
| `from_array(arr)` | O(n) | O(n) | 从数组创建多重集合，n为数组长度 |
| `of(arr)` | O(n) | O(n) | 从固定数组创建多重集合，n为数组长度 |
| `from_iter(iter)` | O(n) | O(n) | 从迭代器创建多重集合，n为迭代器元素个数 |

### 基本操作

| 操作 | 时间复杂度 | 空间复杂度 | 描述 |
|-----|-----------|-----------|-----|
| `add(element)` | O(1) 平均 | O(1) | 添加一个元素 |
| `add_n(element, count)` | O(1) 平均 | O(1) | 添加多个相同元素 |
| `remove(element)` | O(1) 平均 | O(1) | 移除一个元素 |
| `remove_n(element, count)` | O(1) 平均 | O(1) | 移除多个相同元素 |
| `remove_all(element)` | O(1) 平均 | O(1) | 移除所有指定元素 |
| `count(element)` | O(1) 平均 | O(1) | 获取元素计数 |
| `contains(element)` | O(1) 平均 | O(1) | 检查是否包含元素 |
| `set_count(element, count)` | O(1) 平均 | O(1) | 设置元素的计数 |
| `size()` | O(1) | O(1) | 获取元素总数 |
| `distinct_size()` | O(1) | O(1) | 获取不同元素的数量 |
| `is_empty()` | O(1) | O(1) | 检查集合是否为空 |
| `clear()` | O(n) | O(1) | 清空集合，n为不同元素的数量 |

### 集合操作

| 操作 | 时间复杂度 | 空间复杂度 | 描述 |
|-----|-----------|-----------|-----|
| `union(other)` | O(n+m) | O(n+m) | 并集，n和m为两个集合中不同元素的数量 |
| `intersection(other)` | O(n) | O(min(n,m)) | 交集，n为当前集合中不同元素的数量 |
| `difference(other)` | O(n) | O(n) | 差集，n为当前集合中不同元素的数量 |
| `symmetric_difference(other)` | O(n+m) | O(n+m) | 对称差集，n和m为两个集合中不同元素的数量 |
| `is_subset(other)` | O(n) | O(1) | 判断是否为子集，n为当前集合中不同元素的数量 |
| `is_superset(other)` | O(m) | O(1) | 判断是否为超集，m为other集合中不同元素的数量 |
| `add_all(other)` | O(m) | O(1) | 添加另一个集合的所有元素，m为other集合中不同元素的数量 |
| `subtract(other)` | O(m) | O(1) | 减去另一个集合的元素，m为other集合中不同元素的数量 |
| `retain(other)` | O(n) | O(n) | 保留与另一个集合的交集，n为当前集合中不同元素的数量 |

### 统计与转换

| 操作 | 时间复杂度 | 空间复杂度 | 描述 |
|-----|-----------|-----------|-----|
| `to_array()` | O(n) | O(n) | 转换为元素-计数对的数组，n为不同元素的数量 |
| `elements()` | O(n) | O(n) | 获取所有不同元素的数组，n为不同元素的数量 |
| `counts()` | O(n) | O(n) | 获取所有元素计数的数组，n为不同元素的数量 |
| `most_common()` | O(n) | O(1) | 获取最高频元素，n为不同元素的数量 |
| `most_common_n(n)` | O(k log k) | O(k) | 获取最高频的k个元素，k为不同元素的数量，包含排序 |
| `each(f)` | O(n) | O(1) | 遍历所有元素及其计数，n为不同元素的数量 |
| `iter()` | O(1) | O(1) | 返回迭代器 |

## ⚠️ 注意事项

1. 哈希表操作的时间复杂度标记为"平均O(1)"，在最坏情况下可能为O(n)
2. 集合操作会创建新的Multiset对象，如果需要原地修改，请使用`add_all`、`subtract`或`retain`
3. 使用`set_count`传入负值会导致程序终止（abort）

## 📁 项目结构

```
Multiset/
├── src/                # 源代码目录
│   ├── Multiset.mbt    # 多重集合实现
│   └── types.mbt       # 类型定义
├── tests/              # 测试文件
├── moon.mod.json       # 项目配置和依赖声明
└── README.md           # 项目文档
```

本项目使用MoonBit的包管理系统管理依赖，主要依赖于：
- `moonbitlang/core`: MoonBit语言的核心库

## 👥 贡献指南

欢迎对Multiset库进行贡献！以下是参与贡献的步骤：

1. Fork本仓库
2. 创建您的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启一个Pull Request

在提交代码前，请确保：
- 所有测试都能通过 (`moon test`，注意：`set_count with negative value`测试预期会失败，这是正常现象)
- 代码覆盖率保持在较高水平 (`moon coverage report`)
- 代码风格符合项目规范

## 📜 许可证

本项目使用Apache-2.0许可证。详情请参阅LICENSE文件。

## 📢 联系方式

如有问题或建议，请通过以下方式联系：
- 提交GitHub Issue

👋 如果您喜欢这个项目，请给它一个⭐！祝编码愉快！🚀 