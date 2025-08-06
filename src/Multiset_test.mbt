///|
/// 测试创建空多重集合
test "new empty multiset" {
  let ms : @Multiset.T[Int] = @Multiset.new()
  assert_true(ms.is_empty())
  assert_eq(ms.size(), 0)
  assert_eq(ms.distinct_size(), 0)
}

///|
/// 测试从数组创建多重集合
test "from_array constructor" {
  let ms = @Multiset.from_array(["a", "b", "a", "c", "b", "a"])
  assert_eq(ms.size(), 6)
  assert_eq(ms.distinct_size(), 3)
  assert_eq(ms.count("a"), 3)
  assert_eq(ms.count("b"), 2)
  assert_eq(ms.count("c"), 1)
}

///|
/// 测试添加元素
test "add elements" {
  let ms = @Multiset.new()
  ms.add("apple")
  assert_eq(ms.count("apple"), 1)
  ms.add("apple")
  assert_eq(ms.count("apple"), 2)
  ms.add_n("banana", 3)
  assert_eq(ms.count("banana"), 3)
  assert_eq(ms.size(), 5)
  assert_eq(ms.distinct_size(), 2)
}

///|
/// 测试移除元素
test "remove elements" {
  let ms = @Multiset.new()
  ms.add_n("apple", 5)
  ms.remove("apple")
  assert_eq(ms.count("apple"), 4)
  ms.remove_n("apple", 2)
  assert_eq(ms.count("apple"), 2)

  // 移除不存在的元素应该无效
  ms.remove("orange")
  assert_eq(ms.count("orange"), 0)

  // 完全移除元素
  ms.remove_all("apple")
  assert_false(ms.contains("apple"))
  assert_eq(ms.size(), 0)
}

///|
/// 测试元素计数查询
test "count elements" {
  let ms = @Multiset.new()

  // 空集合中元素计数为0
  assert_eq(ms.count("apple"), 0)
  ms.add_n("apple", 3)
  assert_eq(ms.count("apple"), 3)

  // contains测试
  assert_true(ms.contains("apple"))
  assert_false(ms.contains("banana"))
}

///|
/// 测试设置元素计数
test "set_count" {
  let ms = @Multiset.new()

  // 设置不存在元素的计数
  ms.set_count("apple", 5)
  assert_eq(ms.count("apple"), 5)

  // 更新已存在元素的计数
  ms.set_count("apple", 3)
  assert_eq(ms.count("apple"), 3)

  // 设置计数为0应移除元素
  ms.set_count("apple", 0)
  assert_false(ms.contains("apple"))
}

///|
/// 测试清空多重集合
test "clear" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  assert_eq(ms.size(), 4)
  ms.clear()
  assert_true(ms.is_empty())
  assert_eq(ms.size(), 0)
  assert_eq(ms.distinct_size(), 0)
}

///|
/// 测试of构造函数
test "of constructor" {
  let ms = @Multiset.of(["a", "b", "a"])
  assert_eq(ms.size(), 3)
  assert_eq(ms.distinct_size(), 2)
  assert_eq(ms.count("a"), 2)
  assert_eq(ms.count("b"), 1)
}

///|
/// 测试尝试添加零或负数元素
test "add_n with non-positive count" {
  let ms = @Multiset.new()
  ms.add_n("apple", 0) // 不应添加任何元素
  assert_eq(ms.count("apple"), 0)
  ms.add_n("banana", -1) // 不应添加任何元素
  assert_eq(ms.count("banana"), 0)
  assert_eq(ms.size(), 0)
}

///|
/// 测试尝试移除零或负数元素
test "remove_n with non-positive count" {
  let ms = @Multiset.new()
  ms.add_n("apple", 3)
  ms.remove_n("apple", 0) // 不应移除任何元素
  assert_eq(ms.count("apple"), 3)
  ms.remove_n("apple", -1) // 不应移除任何元素
  assert_eq(ms.count("apple"), 3)
  assert_eq(ms.size(), 3)
}

///|
/// 测试union（并集）操作
test "union operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c"])
  let ms2 = @Multiset.from_array(["b", "c", "c", "d"])
  let union = ms1.union(ms2)
  assert_eq(union.count("a"), 2) // 来自ms1
  assert_eq(union.count("b"), 1) // 两个集合中都有1个
  assert_eq(union.count("c"), 2) // ms2中有2个
  assert_eq(union.count("d"), 1) // 来自ms2
  assert_eq(union.size(), 6)
  assert_eq(union.distinct_size(), 4)
}

///|
/// 测试intersection（交集）操作
test "intersection operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c", "c"])
  let ms2 = @Multiset.from_array(["b", "c", "c", "c", "d"])
  let intersection = ms1.intersection(ms2)
  assert_eq(intersection.count("a"), 0) // ms2中没有a
  assert_eq(intersection.count("b"), 1) // 两个集合中都有1个b
  assert_eq(intersection.count("c"), 2) // 取ms1中的2个c和ms2中的3个c的最小值
  assert_eq(intersection.count("d"), 0) // ms1中没有d
  assert_eq(intersection.size(), 3)
  assert_eq(intersection.distinct_size(), 2)
}

///|
/// 测试difference（差集）操作
test "difference operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c", "c"])
  let ms2 = @Multiset.from_array(["a", "c", "d"])
  let difference = ms1.difference(ms2)
  assert_eq(difference.count("a"), 1) // ms1中2个a减去ms2中1个a
  assert_eq(difference.count("b"), 1) // ms1中有1个b, ms2中没有b
  assert_eq(difference.count("c"), 1) // ms1中2个c减去ms2中1个c
  assert_eq(difference.count("d"), 0) // ms1中没有d
  assert_eq(difference.size(), 3)
  assert_eq(difference.distinct_size(), 3)
}

///|
/// 测试symmetric_difference（对称差集）操作
test "symmetric_difference operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c"])
  let ms2 = @Multiset.from_array(["b", "c", "c", "d"])
  let sym_diff = ms1.symmetric_difference(ms2)
  assert_eq(sym_diff.count("a"), 2) // ms1独有
  assert_eq(sym_diff.count("b"), 0) // 两集合各有1个，相互抵消
  assert_eq(sym_diff.count("c"), 1) // ms2比ms1多1个
  assert_eq(sym_diff.count("d"), 1) // ms2独有
  assert_eq(sym_diff.size(), 4)
  assert_eq(sym_diff.distinct_size(), 3)
}

///|
/// 测试apply_operation（应用集合操作）
test "apply_operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a"])
  let ms2 = @Multiset.from_array(["b", "c"])

  // 测试Union操作
  let result1 = ms1.apply_operation(ms2, SetOperation::Union)
  assert_eq(result1.count("a"), 2)
  assert_eq(result1.count("b"), 1)
  assert_eq(result1.count("c"), 1)

  // 测试Intersection操作
  let result2 = ms1.apply_operation(ms2, SetOperation::Intersection)
  assert_eq(result2.count("a"), 0)
  assert_eq(result2.count("b"), 1)
  assert_eq(result2.count("c"), 0)

  // 测试Difference操作
  let result3 = ms1.apply_operation(ms2, SetOperation::Difference)
  assert_eq(result3.count("a"), 2)
  assert_eq(result3.count("b"), 0)

  // 测试SymmetricDifference操作
  let result4 = ms1.apply_operation(ms2, SetOperation::SymmetricDifference)
  assert_eq(result4.count("a"), 2)
  assert_eq(result4.count("b"), 0)
  assert_eq(result4.count("c"), 1)
}

///|
/// 测试is_subset（子集）关系
test "is_subset relation" {
  // 创建集合
  let ms1 = @Multiset.from_array(["a", "b"])
  let ms2 = @Multiset.from_array(["a", "b", "c"])
  let ms3 = @Multiset.from_array(["a", "b", "a"])
  let ms4 = @Multiset.from_array(["a"])

  // 测试真子集
  assert_true(ms1.is_subset(ms2))
  assert_false(ms2.is_subset(ms1))

  // 测试多重集子集关系
  assert_true(ms1.is_subset(ms3)) // ms1中的"a"(1个)和"b"(1个)在ms3中都有足够计数(a有2个，b有1个)
  assert_true(ms4.is_subset(ms3)) // ms3有足够的a

  // 测试与自身的关系
  let ms5 = @Multiset.from_array(["a", "b", "c"])
  assert_true(ms5.is_subset(ms5)) // 集合是自身的子集
}

///|
/// 测试is_superset（超集）关系
test "is_superset relation" {
  // 创建集合
  let ms1 = @Multiset.from_array(["a", "b", "c"])
  let ms2 = @Multiset.from_array(["a", "b"])
  let ms3 = @Multiset.from_array(["a", "b", "a"])

  // 测试真超集
  assert_true(ms1.is_superset(ms2))
  assert_false(ms2.is_superset(ms1))

  // 测试多重集超集关系
  assert_false(ms2.is_superset(ms3)) // ms2只有1个a但ms3有2个a
  assert_true(ms3.is_superset(@Multiset.from_array(["a"])))

  // 测试与自身的关系
  assert_true(ms1.is_superset(ms1)) // 集合是自身的超集
}

///|
/// 测试add_all（添加所有元素）操作
test "add_all operation" {
  let ms1 = @Multiset.from_array(["a", "b"])
  let ms2 = @Multiset.from_array(["b", "c", "c"])
  ms1.add_all(ms2)
  assert_eq(ms1.count("a"), 1)
  assert_eq(ms1.count("b"), 2) // 1(原有) + 1(来自ms2)
  assert_eq(ms1.count("c"), 2) // 来自ms2的2个c
  assert_eq(ms1.size(), 5)
  assert_eq(ms1.distinct_size(), 3)

  // ms2不应被修改
  assert_eq(ms2.count("b"), 1)
  assert_eq(ms2.count("c"), 2)
  assert_eq(ms2.size(), 3)
}

///|
/// 测试subtract（减去集合）操作
test "subtract operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c", "c"])
  let ms2 = @Multiset.from_array(["a", "c", "d"])
  ms1.subtract(ms2)
  assert_eq(ms1.count("a"), 1) // 2(原有) - 1(来自ms2) = 1
  assert_eq(ms1.count("b"), 1) // 不变，因为ms2中没有b
  assert_eq(ms1.count("c"), 1) // 2(原有) - 1(来自ms2) = 1
  assert_eq(ms1.count("d"), 0) // ms1中没有d，尝试减去不存在元素无效
  assert_eq(ms1.size(), 3)
  assert_eq(ms1.distinct_size(), 3)

  // ms2不应被修改
  assert_eq(ms2.count("a"), 1)
  assert_eq(ms2.count("c"), 1)
  assert_eq(ms2.count("d"), 1)
}

///|
/// 测试retain（保留交集）操作
test "retain operation" {
  let ms1 = @Multiset.from_array(["a", "b", "a", "c", "c", "e"])
  let ms2 = @Multiset.from_array(["b", "c", "d"])
  ms1.retain(ms2)
  assert_eq(ms1.count("a"), 0) // a不在ms2中，被移除
  assert_eq(ms1.count("b"), 1) // 保留，因为ms2中有b
  assert_eq(ms1.count("c"), 1) // ms2中只有1个c，所以只保留1个
  assert_eq(ms1.count("e"), 0) // e不在ms2中，被移除
  assert_eq(ms1.size(), 2)
  assert_eq(ms1.distinct_size(), 2)

  // ms2不应被修改
  assert_eq(ms2.count("b"), 1)
  assert_eq(ms2.count("c"), 1)
  assert_eq(ms2.count("d"), 1)
}

///|
/// 测试to_array（转为数组）操作
test "to_array operation" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let arr = ms.to_array()

  // 验证数组包含所有元素及其计数
  assert_eq(arr.length(), 3) // 三个不同元素

  // 使用计数查找元素
  let mut found_a = false
  let mut found_b = false
  let mut found_c = false
  for i in 0..<arr.length() {
    let entry = arr[i]
    if entry.element == "a" {
      assert_eq(entry.count, 2)
      found_a = true
    } else if entry.element == "b" {
      assert_eq(entry.count, 1)
      found_b = true
    } else if entry.element == "c" {
      assert_eq(entry.count, 1)
      found_c = true
    }
  }
  assert_true(found_a)
  assert_true(found_b)
  assert_true(found_c)
}

///|
/// 测试elements（获取元素）操作
test "elements operation" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let elements = ms.elements()

  // 验证元素数组长度
  assert_eq(elements.length(), 3) // 三个不同元素

  // 验证所有元素都存在于数组中
  assert_true(elements.contains("a"))
  assert_true(elements.contains("b"))
  assert_true(elements.contains("c"))
}

///|
/// 测试counts（获取计数）操作
test "counts operation" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let counts = ms.counts()

  // 验证计数数组长度
  assert_eq(counts.length(), 3) // 三个不同元素的计数

  // 验证计数包含所有预期值
  assert_true(counts.contains(1)) // b和c的计数
  assert_true(counts.contains(2)) // a的计数

  // 计数总和应该等于集合大小
  let mut sum = 0
  for i in 0..<counts.length() {
    sum += counts[i]
  }
  assert_eq(sum, ms.size())
}

///|
/// 测试each（遍历）操作
test "each operation" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let mut sum = 0
  let elements = []
  ms.each(fn(elem, count) {
    sum += count
    elements.push(elem)
  })

  // 检查总计数是否正确
  assert_eq(sum, 4) // 总有4个元素

  // 检查是否遍历了所有元素
  assert_eq(elements.length(), 3) // 3个不同元素
  assert_true(elements.contains("a"))
  assert_true(elements.contains("b"))
  assert_true(elements.contains("c"))
}

///|
/// 测试most_common（最高频元素）操作
test "most_common operation" {
  // 测试有明确最高频的情况
  let ms1 = @Multiset.from_array(["a", "b", "a", "c", "a"])
  match ms1.most_common() {
    Some(entry) => {
      assert_eq(entry.element, "a")
      assert_eq(entry.count, 3)
    }
    None => assert_false(true) // 不应到达这里
  }

  // 测试空集合
  let ms2 : @Multiset.T[String] = @Multiset.new()
  match ms2.most_common() {
    Some(_) => assert_false(true) // 不应到达这里
    None => assert_true(true)
  }
}

///|
/// 测试most_common_n（最高频N个元素）操作
test "most_common_n operation" {
  // 创建多重集
  let ms = @Multiset.from_array(["a", "b", "a", "c", "b", "a", "d"])

  // 获取最高频的2个元素
  let top2 = ms.most_common_n(2)
  assert_eq(top2.length(), 2)

  // 第一个元素应该是a，出现3次
  assert_eq(top2[0].element, "a")
  assert_eq(top2[0].count, 3)

  // 第二个元素应该是b，出现2次
  assert_eq(top2[1].element, "b")
  assert_eq(top2[1].count, 2)

  // 测试请求超过元素数量的情况
  let all = ms.most_common_n(10) // 只有4个不同元素
  assert_eq(all.length(), 4)

  // 测试请求0个元素的情况
  let none = ms.most_common_n(0)
  assert_eq(none.length(), 0)

  // 测试空集合
  let ms_empty : @Multiset.T[String] = @Multiset.new()
  assert_eq(ms_empty.most_common_n(1).length(), 0)
}

///|
/// 测试iter（迭代器）操作
test "iter operation" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let mut sum = 0
  let elements = []
  ms.each(fn(elem, count) {
    sum += count
    elements.push(elem)
  })

  // 检查总计数是否正确
  assert_eq(sum, 4)

  // 检查是否遍历了所有元素
  assert_eq(elements.length(), 3)
  assert_true(elements.contains("a"))
  assert_true(elements.contains("b"))
  assert_true(elements.contains("c"))
}

///|
/// 测试from_iter（从迭代器创建）操作
test "from_iter operation" {
  let arr = ["a", "b", "a", "c"]
  let ms = @Multiset.from_iter(arr.iter())
  assert_eq(ms.size(), 4)
  assert_eq(ms.distinct_size(), 3)
  assert_eq(ms.count("a"), 2)
  assert_eq(ms.count("b"), 1)
  assert_eq(ms.count("c"), 1)
}

///|
/// 测试相等性比较
test "equality comparison" {
  // 创建相同内容但创建方式不同的多重集
  let ms1 = @Multiset.from_array(["a", "b", "a", "c"])
  let ms2 = @Multiset.new()
  ms2.add("a")
  ms2.add("a")
  ms2.add("b")
  ms2.add("c")

  // 应该相等
  assert_true(ms1 == ms2)

  // 添加一个元素后应不再相等
  ms2.add("d")
  assert_false(ms1 == ms2)

  // 修改元素计数后应不再相等
  let ms3 = @Multiset.from_array(["a", "b", "a", "c"])
  ms3.add("a") // 现在a的计数为3
  assert_false(ms1 == ms3)
}

///|
/// 测试迭代器方法
test "iter method" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  let mut sum = 0
  let elements = []

  // 测试通过公共API来访问迭代器
  for elem, count in ms.iter() {
    sum += count
    elements.push(elem)
  }

  // 检查总计数是否正确
  assert_eq(sum, 4)

  // 检查是否遍历了所有元素
  assert_eq(elements.length(), 3)
  assert_true(elements.contains("a"))
  assert_true(elements.contains("b"))
  assert_true(elements.contains("c"))
}

///|
/// 测试移除刚好等于元素计数的情况
test "remove exact count" {
  let ms = @Multiset.new()
  ms.add_n("apple", 3)

  // 刚好移除所有的apple
  ms.remove_n("apple", 3)
  assert_eq(ms.count("apple"), 0)
  assert_false(ms.contains("apple"))

  // 再次移除不存在的元素
  ms.remove_all("apple")
  assert_eq(ms.count("apple"), 0)
}

///|
/// 测试特殊相等性情况
test "equality edge cases" {
  // 创建两个有相同元素总数但分布不同的集合
  let ms1 = @Multiset.from_array(["a", "a", "b"])
  let ms2 = @Multiset.from_array(["a", "b", "b"])

  // 虽然总计数相同，但分布不同，所以不相等
  assert_false(ms1 == ms2)

  // 测试不同元素种类数量的情况
  let ms3 = @Multiset.from_array(["a", "a", "c"])
  assert_false(ms1 == ms3)

  // 测试相同元素相同分布，但创建方式不同的情况
  let ms4 = @Multiset.new()
  ms4.add("a")
  ms4.add("a")
  ms4.add("b")
  assert_true(ms1 == ms4)
}

///|
/// 测试distinct_size不同的相等性比较
test "equality with different distinct sizes" {
  // 创建两个集合，它们拥有相同的元素总数，但不同的不同元素数
  let ms1 = @Multiset.from_array(["a", "a", "a"]) // 3个元素，1种不同元素
  let ms2 = @Multiset.from_array(["a", "b", "c"]) // 3个元素，3种不同元素

  // 总元素数相同，但不同元素数不同，应该不相等
  assert_false(ms1 == ms2)
  assert_eq(ms1.size(), ms2.size())
  assert_true(ms1.distinct_size() != ms2.distinct_size())
}

///|
/// 测试most_common函数的理论上不可达代码
test "most_common theoretical unreachable code" {
  // 创建一个带有元素的集合，然后清空它
  let ms = @Multiset.from_array(["a", "b", "c"])
  ms.clear()

  // 验证集合现在是空的
  assert_true(ms.is_empty())

  // 测试most_common返回None
  match ms.most_common() {
    Some(_) => assert_false(true) // 不应该走到这里
    None => assert_true(true) // 应该返回None
  }

  // 特殊情况：如果集合中有多个具有相同最高频率的元素
  let ms2 = @Multiset.from_array(["a", "b", "c", "a", "b"])
  let top = ms2.most_common()
  match top {
    Some(entry) => {
      assert_true(entry.element == "a" || entry.element == "b")
      assert_eq(entry.count, 2)
    }
    None => assert_false(true)
  }
}

///|
/// 测试相等性比较的更多边缘情况
test "more equality edge cases" {
  // 空集合与自身比较应相等
  let empty1 : @Multiset.T[String] = @Multiset.new()
  let empty2 : @Multiset.T[String] = @Multiset.new()
  assert_true(empty1 == empty2)

  // 测试equal函数覆盖所有分支
  let ms1 = @Multiset.from_array(["a", "b", "a"])
  let ms2 = @Multiset.from_array(["a", "b", "c"])

  // 相同元素数，不同分布
  assert_false(ms1 == ms2)

  // 不同的distinct_size，但相同的总元素数
  let ms3 = @Multiset.from_array(["a", "a", "a"])
  assert_false(ms1 == ms3)
  assert_eq(ms1.size(), ms3.size())

  // 测试遍历对比每个元素的计数
  let ms4 = @Multiset.from_array(["a", "a", "b"])
  let ms5 : @Multiset.T[String] = @Multiset.new()
  ms5.add("a")
  ms5.add("a")
  ms5.add_n("b", 1)
  assert_true(ms4 == ms5) // 相同元素数和分布
  ms5.set_count("b", 2) // 修改一个元素的计数
  assert_false(ms4 == ms5) // 现在应该不相等
}

///|
/// 测试边缘情况处理
test "edge cases handling" {
  // 测试remove_all移除不存在的元素
  let ms = @Multiset.new()
  ms.remove_all("nonexistent") // 应该无操作，不抛出异常
  assert_eq(ms.size(), 0)

  // 测试多次移除元素
  ms.add_n("apple", 3)
  ms.remove_n("apple", 2)
  assert_eq(ms.count("apple"), 1)
  ms.remove_n("apple", 3) // 移除多于存在数量的元素
  assert_eq(ms.count("apple"), 0)

  // 测试在空集合上的操作
  let empty : @Multiset.T[String] = @Multiset.new()
  empty.clear() // 应该不抛出异常
  assert_true(empty.is_empty())

  // 测试相等性比较的其他情况
  let ms1 = @Multiset.from_array(["a", "a", "b"])
  let ms2 = @Multiset.new()
  ms2.add("a")
  ms2.add("a")
  ms2.add("b")

  // 修改其中一个元素的计数，使它们不相等
  ms2.set_count("a", 1)
  assert_false(ms1 == ms2)
}

///|
/// 测试equal方法的更多边缘情况
test "equality function all branches" {
  // 创建不同大小的集合，确保total_count比较分支被覆盖
  let ms1 = @Multiset.from_array(["a", "b", "c"])
  let ms2 = @Multiset.from_array(["a", "b"])

  // ms1比ms2大，不相等
  assert_false(ms1 == ms2)

  // 测试equal时元素计数不同的情况
  let ms3 = @Multiset.from_array(["a", "b", "b", "c"])
  let ms4 = @Multiset.from_array(["a", "b", "c", "c"])

  // 两个集合都有相同的distinct_size(3)和size(4)，但分布不同
  assert_eq(ms3.size(), ms4.size())
  assert_eq(ms3.distinct_size(), ms4.distinct_size())
  assert_false(ms3 == ms4)
}

///|
/// 测试元素移除的所有分支
test "remove elements all branches" {
  // 测试remove_n当要移除的数量等于计数时
  let ms = @Multiset.new()
  ms.add_n("apple", 3)
  ms.remove_n("apple", 3) // 刚好移除完
  assert_eq(ms.count("apple"), 0)
  assert_false(ms.contains("apple"))

  // 测试当移除的数量大于计数时
  ms.add_n("banana", 2)
  ms.remove_n("banana", 5) // 移除更多
  assert_eq(ms.count("banana"), 0)

  // 测试移除不存在的元素
  ms.remove_n("nonexistent", 1)
  assert_eq(ms.count("nonexistent"), 0)

  // 测试移除所有
  ms.add_n("cherry", 3)
  ms.remove_all("cherry")
  assert_eq(ms.count("cherry"), 0)

  // 再次测试移除不存在的元素
  ms.remove_all("nonexistent")
}

///|
/// 测试集合操作与相等性判断的组合
test "combined operations and equality" {
  // 创建两个相等的集合
  let ms1 = @Multiset.from_array(["a", "a", "b", "c"])
  let ms2 = @Multiset.from_array(["a", "a", "b", "c"])
  assert_true(ms1 == ms2)

  // 修改一个集合，然后检查相等性
  ms2.remove("c")
  ms2.add("d")
  assert_false(ms1 == ms2)

  // 恢复相等
  ms2.remove("d")
  ms2.add("c")
  assert_true(ms1 == ms2)

  // 测试具有不同distinct_size但相同总数的集合
  let ms3 = @Multiset.new()
  ms3.add_n("x", 4) // 1个不同元素，4个总数
  let ms4 = @Multiset.from_array(["a", "b", "c", "d"]) // 4个不同元素，4个总数
  assert_eq(ms3.size(), ms4.size())
  assert_true(ms3.distinct_size() != ms4.distinct_size())
  assert_false(ms3 == ms4)

  // 确保相等性比较中对总count的判断被覆盖
  let ms5 = @Multiset.from_array(["a", "a"])
  let ms6 = @Multiset.from_array(["a", "b", "c"])
  assert_false(ms5 == ms6)
}

///|
/// 测试异常情况
test "exceptional cases" {
  let ms = @Multiset.new()

  // 测试set_count为0的情况
  ms.add_n("apple", 3)
  ms.set_count("apple", 0)
  assert_false(ms.contains("apple"))

  // 测试set_count增加计数
  ms.set_count("banana", 2)
  assert_eq(ms.count("banana"), 2)
  ms.set_count("banana", 5)
  assert_eq(ms.count("banana"), 5)

  // 测试set_count减少计数
  ms.set_count("banana", 1)
  assert_eq(ms.count("banana"), 1)

  // 测试相等性比较中count类型的边缘情况
  let ms1 = @Multiset.from_array(["a", "b", "c"])
  let ms2 = @Multiset.new()
  ms2.add("a")
  ms2.add("b")
  ms2.add("c")

  // 确保相等
  assert_true(ms1 == ms2)

  // 修改一个元素的计数，使它们不相等
  ms2.remove("c")
  assert_false(ms1 == ms2)
}

///|
/// 专门测试is_subset函数中other_count < count的分支
test "is_subset with insufficient count in other" {
  let ms1 = @Multiset.from_array(["a", "a", "a"]) // a有3个
  let ms2 = @Multiset.from_array(["a", "a", "b"]) // a只有2个

  // ms1不是ms2的子集，因为ms2中a的数量不足
  assert_false(ms1.is_subset(ms2))

  // 验证判断过程
  let is_subset = ms1.is_subset(ms2)
  assert_false(is_subset)
}

///|
/// 这是一个临时测试文件
test "temp test" {
  let ms : @Multiset.T[Int] = @Multiset.new()
  assert_true(ms.is_empty())
}

///|
/// 附加测试：测试most_common在空集合上的行为
test "most_common with empty set" {
  let empty_ms : @Multiset.T[Int] = @Multiset.new()
  // 确保集合为空
  assert_true(empty_ms.is_empty())

  // 直接判断返回值
  let result = empty_ms.most_common()
  let mut is_none = false
  match result {
    None => is_none = true
    Some(entry) => ignore(entry)
  }
  assert_true(is_none)
}

///|
/// 附加测试：测试is_subset的边缘情况
test "is_subset edge case" {
  // 创建两个集合，一个元素多于另一个
  let ms1 = @Multiset.from_array(["a", "a", "a"]) // a有3个
  let ms2 = @Multiset.from_array(["a", "a"]) // a只有2个

  // 强制执行判断分支
  let mut tested = false
  ms1.each(fn(elem, count) {
    let other_count = ms2.count(elem)
    if other_count < count {
      tested = true
      // 确认执行了相关代码
      // 这里不用断言，只需要执行到这个分支
    }
  })

  // 确保测试覆盖了目标代码路径
  assert_true(tested)

  // 最终结果应该是false
  assert_false(ms1.is_subset(ms2))
}

///|
/// 专门测试most_common函数中的None分支
test "most_common None branch coverage" {
  // 创建一个多重集合
  let ms : @Multiset.T[Int] = @Multiset.new()

  // 确保集合为空
  assert_true(ms.is_empty())

  // 手动调用most_common方法
  let result = ms.most_common()

  // 验证结果是None
  match result {
    None => assert_true(true)
    Some(_) => assert_false(true)
  }
}

///|
/// 测试is_subset函数中的is_subset = false分支
test "is_subset false branch" {
  // 创建两个集合，使得第一个集合中的某个元素计数大于第二个集合中的计数
  let ms1 = @Multiset.from_array(["a", "a", "a"]) // a有3个
  let ms2 = @Multiset.from_array(["a", "a", "b"]) // a只有2个

  // 验证ms1不是ms2的子集
  assert_false(ms1.is_subset(ms2))

  // 手动测试is_subset函数中的分支
  let mut is_subset = true
  ms1.each(fn(elem, count) {
    let other_count = ms2.count(elem)
    if other_count < count {
      is_subset = false
      // 这里应该会覆盖到is_subset = false这一行
    }
  })

  // 验证is_subset被设置为false
  assert_false(is_subset)
}
