///|
/// 测试创建空多重集合
test "new empty multiset" {
  let ms = @Multiset.new()
  assert_true!(ms.is_empty())
  assert_eq!(ms.size(), 0)
  assert_eq!(ms.distinct_size(), 0)
}

///|
/// 测试从数组创建多重集合
test "from_array constructor" {
  let ms = @Multiset.from_array(["a", "b", "a", "c", "b", "a"])
  assert_eq!(ms.size(), 6)
  assert_eq!(ms.distinct_size(), 3)
  assert_eq!(ms.count("a"), 3)
  assert_eq!(ms.count("b"), 2)
  assert_eq!(ms.count("c"), 1)
}

///|
/// 测试添加元素
test "add elements" {
  let ms = @Multiset.new()
  ms.add("apple")
  assert_eq!(ms.count("apple"), 1)
  ms.add("apple")
  assert_eq!(ms.count("apple"), 2)
  ms.add_n("banana", 3)
  assert_eq!(ms.count("banana"), 3)
  assert_eq!(ms.size(), 5)
  assert_eq!(ms.distinct_size(), 2)
}

///|
/// 测试移除元素
test "remove elements" {
  let ms = @Multiset.new()
  ms.add_n("apple", 5)
  ms.remove("apple")
  assert_eq!(ms.count("apple"), 4)
  ms.remove_n("apple", 2)
  assert_eq!(ms.count("apple"), 2)

  // 移除不存在的元素应该无效
  ms.remove("orange")
  assert_eq!(ms.count("orange"), 0)

  // 完全移除元素
  ms.remove_all("apple")
  assert_false!(ms.contains("apple"))
  assert_eq!(ms.size(), 0)
}

///|
/// 测试元素计数查询
test "count elements" {
  let ms = @Multiset.new()

  // 空集合中元素计数为0
  assert_eq!(ms.count("apple"), 0)
  ms.add_n("apple", 3)
  assert_eq!(ms.count("apple"), 3)

  // contains测试
  assert_true!(ms.contains("apple"))
  assert_false!(ms.contains("banana"))
}

///|
/// 测试设置元素计数
test "set_count" {
  let ms = @Multiset.new()

  // 设置不存在元素的计数
  ms.set_count("apple", 5)
  assert_eq!(ms.count("apple"), 5)

  // 更新已存在元素的计数
  ms.set_count("apple", 3)
  assert_eq!(ms.count("apple"), 3)

  // 设置计数为0应移除元素
  ms.set_count("apple", 0)
  assert_false!(ms.contains("apple"))
}

///|
/// 测试清空多重集合
test "clear" {
  let ms = @Multiset.from_array(["a", "b", "a", "c"])
  assert_eq!(ms.size(), 4)
  ms.clear()
  assert_true!(ms.is_empty())
  assert_eq!(ms.size(), 0)
  assert_eq!(ms.distinct_size(), 0)
}
