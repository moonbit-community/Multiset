///|
/// 创建一个新的空多重集合
///
/// 参数:
/// * `capacity` : 初始容量，默认为8
///
/// 返回一个新的空多重集合
pub fn[E] new(capacity~ : Int = 8) -> T[E] {
  { counts: @hashmap.new(capacity~), total_count: 0 }
}

///|
/// 从数组创建多重集合
///
/// 参数:
/// * `arr` : 包含元素的数组
///
/// 返回一个包含数组中所有元素的多重集合
pub fn[E : Hash + Eq] from_array(arr : Array[E]) -> T[E] {
  let ms = new()
  arr.each(fn(e) { ms.add(e) })
  ms
}

///|
/// 从固定数组创建多重集合
pub fn[E : Hash + Eq] of(arr : FixedArray[E]) -> T[E] {
  let ms = new()
  arr.each(fn(e) { ms.add(e) })
  ms
}

///|
/// 向多重集合中添加一个元素
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要添加的元素
pub fn[E : Hash + Eq] add(self : T[E], element : E) -> Unit {
  self.add_n(element, 1)
}

///|
/// 向多重集合中添加多个相同的元素
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要添加的元素
/// * `count` : 要添加的元素数量，必须是正数
pub fn[E : Hash + Eq] add_n(self : T[E], element : E, count : Int) -> Unit {
  if count <= 0 {
    return
  }
  match self.counts.get(element) {
    Some(current_count) => {
      let new_count = current_count + count
      self.counts.set(element, new_count)
    }
    None => self.counts.set(element, count)
  }
  self.total_count += count
}

///|
/// 从多重集合中移除一个元素的一个实例
/// 如果元素不在集合中，不做任何操作
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要移除的元素
pub fn[E : Hash + Eq] remove(self : T[E], element : E) -> Unit {
  self.remove_n(element, 1)
}

///|
/// 从多重集合中移除一个元素的多个实例
/// 如果元素不在集合中，不做任何操作
/// 如果移除数量大于元素的计数，则完全移除该元素
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要移除的元素
/// * `count` : 要移除的元素数量，必须是正数
pub fn[E : Hash + Eq] remove_n(self : T[E], element : E, count : Int) -> Unit {
  if count <= 0 {
    return
  }
  match self.counts.get(element) {
    Some(current_count) =>
      if current_count <= count {
        // 完全移除元素
        self.counts.remove(element)
        self.total_count -= current_count
      } else {
        // 减少计数
        let new_count = current_count - count
        self.counts.set(element, new_count)
        self.total_count -= count
      }
    None => () // 元素不存在，不做任何事
  }
}

///|
/// 移除多重集合中所有指定的元素
/// 如果元素不在集合中，不做任何操作
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要移除的元素
pub fn[E : Hash + Eq] remove_all(self : T[E], element : E) -> Unit {
  match self.counts.get(element) {
    Some(count) => {
      self.counts.remove(element)
      self.total_count = self.total_count - count
    }
    None => () // 元素不存在，不做任何事
  }
}

///|
/// 获取多重集合中元素的计数
/// 如果元素不在集合中，返回0
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要查询的元素
///
/// 返回元素在多重集合中的计数
pub fn[E : Hash + Eq] count(self : T[E], element : E) -> Int {
  match self.counts.get(element) {
    Some(count) => count
    None => 0
  }
}

///|
/// 检查多重集合中是否包含指定元素
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要检查的元素
///
/// 如果多重集合中包含至少一个指定元素实例，返回true
pub fn[E : Hash + Eq] contains(self : T[E], element : E) -> Bool {
  self.counts.contains(element)
}

///|
/// 获取多重集合中不同元素的数量
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回多重集合中不同元素的数量
pub fn[E] distinct_size(self : T[E]) -> Int {
  self.counts.size()
}

///|
/// 获取多重集合中元素的总数（所有计数的总和）
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回多重集合中元素的总数
pub fn[E] size(self : T[E]) -> Int {
  self.total_count
}

///|
/// 检查多重集合是否为空
///
/// 参数:
/// * `self` : 多重集合
///
/// 如果多重集合为空，返回true
pub fn[E] is_empty(self : T[E]) -> Bool {
  self.total_count == 0
}

///|
/// 清空多重集合
///
/// 参数:
/// * `self` : 多重集合
pub fn[E] clear(self : T[E]) -> Unit {
  self.counts.clear()
  self.total_count = 0
}

///|
/// 将多重集合转换为元素-计数对的数组
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回包含多重集合中所有元素及其计数的数组
pub fn[E] to_array(self : T[E]) -> Array[Entry[E]] {
  let result = []
  self.counts.each(fn(elem, count) {
    result.push(Entry::{ element: elem, count })
  })
  result
}

///|
/// 获取多重集合中的所有不同元素
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回包含多重集合中所有不同元素的数组
pub fn[E] elements(self : T[E]) -> Array[E] {
  let pairs = self.counts.to_array()
  let result = []
  pairs.each(fn(pair) {
    let (elem, _) = pair
    result.push(elem)
  })
  result
}

///|
/// 获取多重集合中的所有元素计数
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回包含多重集合中所有元素计数的数组
pub fn[E] counts(self : T[E]) -> Array[Int] {
  let pairs = self.counts.to_array()
  let result = []
  pairs.each(fn(pair) {
    let (_, count) = pair
    result.push(count)
  })
  result
}

///|
/// 对多重集合中的每个元素执行指定操作
///
/// 参数:
/// * `self` : 多重集合
/// * `f` : 要执行的操作，接收元素和其计数
pub fn[E] each(self : T[E], f : (E, Int) -> Unit) -> Unit {
  self.counts.each(f)
}

///|
/// 设置元素的计数
/// 如果计数为0，则移除元素
/// 如果计数为负数，则抛出错误
///
/// 参数:
/// * `self` : 多重集合
/// * `element` : 要设置计数的元素
/// * `count` : 新的计数值，必须是非负数
pub fn[E : Hash + Eq] set_count(self : T[E], element : E, count : Int) -> Unit {
  if count < 0 {
    abort("Count cannot be negative")
  }
  match self.counts.get(element) {
    Some(old_count) =>
      if count == 0 {
        // 移除元素
        self.counts.remove(element)
        self.total_count -= old_count
      } else {
        // 更新计数
        self.counts.set(element, count)
        self.total_count = self.total_count - old_count + count
      }
    None =>
      if count > 0 {
        // 添加元素
        self.counts.set(element, count)
        self.total_count += count
      }
  }
}

///|
/// 检查是否为另一个多重集合的子集
///
/// 参数:
/// * `self` : 多重集合
/// * `other` : 另一个多重集合
///
/// 如果self是other的子集，返回true
pub fn[E : Hash + Eq] is_subset(self : T[E], other : T[E]) -> Bool {
  if self.total_count > other.total_count {
    return false
  }
  let mut is_subset = true
  self.each(fn(elem, count) {
    let other_count = other.count(elem)
    if other_count < count {
      is_subset = false
    }
  })
  is_subset
}

///|
/// 检查是否为另一个多重集合的超集
///
/// 参数:
/// * `self` : 多重集合
/// * `other` : 另一个多重集合
///
/// 如果self是other的超集，返回true
pub fn[E : Hash + Eq] is_superset(self : T[E], other : T[E]) -> Bool {
  other.is_subset(self)
}

///|
/// 返回两个多重集合的并集（取每个元素在两个集合中的最大计数）
///
/// 参数:
/// * `self` : 第一个多重集合
/// * `other` : 第二个多重集合
///
/// 返回一个新的多重集合，表示两个集合的并集
pub fn[E : Hash + Eq] union(self : T[E], other : T[E]) -> T[E] {
  let result = new()

  // 添加self中的所有元素
  self.each(fn(elem, count) { result.add_n(elem, count) })

  // 添加other中的元素，如果计数更大则更新
  other.each(fn(elem, count) {
    let self_count = self.count(elem)
    if count > self_count {
      // 只添加差额部分
      result.add_n(elem, count - self_count)
    }
  })
  result
}

///|
/// 返回两个多重集合的交集（取每个元素在两个集合中的最小计数）
///
/// 参数:
/// * `self` : 第一个多重集合
/// * `other` : 第二个多重集合
///
/// 返回一个新的多重集合，表示两个集合的交集
pub fn[E : Hash + Eq] intersection(self : T[E], other : T[E]) -> T[E] {
  let result = new()

  // 添加在两个集合中都存在的元素，取最小计数
  self.each(fn(elem, self_count) {
    let other_count = other.count(elem)
    if other_count > 0 {
      let min_count = if self_count < other_count {
        self_count
      } else {
        other_count
      }
      result.add_n(elem, min_count)
    }
  })
  result
}

///|
/// 返回两个多重集合的差集（从第一个集合中减去第二个集合的元素）
///
/// 参数:
/// * `self` : 第一个多重集合
/// * `other` : 第二个多重集合
///
/// 返回一个新的多重集合，表示两个集合的差集
pub fn[E : Hash + Eq] difference(self : T[E], other : T[E]) -> T[E] {
  let result = new()

  // 添加self中的元素，减去other中的计数
  self.each(fn(elem, self_count) {
    let other_count = other.count(elem)
    let diff = self_count - other_count
    if diff > 0 {
      result.add_n(elem, diff)
    }
  })
  result
}

///|
/// 返回两个多重集合的对称差集（包含只在其中一个集合中出现的元素）
///
/// 参数:
/// * `self` : 第一个多重集合
/// * `other` : 第二个多重集合
///
/// 返回一个新的多重集合，表示两个集合的对称差集
pub fn[E : Hash + Eq] symmetric_difference(self : T[E], other : T[E]) -> T[E] {
  let result = new()

  // 添加self中比other多的元素
  self.each(fn(elem, self_count) {
    let other_count = other.count(elem)
    let diff = self_count - other_count
    if diff > 0 {
      result.add_n(elem, diff)
    }
  })

  // 添加other中比self多的元素
  other.each(fn(elem, other_count) {
    let self_count = self.count(elem)
    let diff = other_count - self_count
    if diff > 0 {
      result.add_n(elem, diff)
    }
  })
  result
}

///|
/// 对两个多重集合执行指定的集合操作
///
/// 参数:
/// * `self` : 第一个多重集合
/// * `other` : 第二个多重集合
/// * `op` : 要执行的集合操作
///
/// 返回一个新的多重集合，表示操作结果
pub fn[E : Hash + Eq] apply_operation(
  self : T[E],
  other : T[E],
  op : SetOperation,
) -> T[E] {
  match op {
    SetOperation::Union => self.union(other)
    SetOperation::Intersection => self.intersection(other)
    SetOperation::Difference => self.difference(other)
    SetOperation::SymmetricDifference => self.symmetric_difference(other)
  }
}

///|
/// 将另一个多重集合中的所有元素添加到当前集合（原地修改）
///
/// 参数:
/// * `self` : 多重集合
/// * `other` : 要添加的多重集合
pub fn[E : Hash + Eq] add_all(self : T[E], other : T[E]) -> Unit {
  other.each(fn(elem, count) { self.add_n(elem, count) })
}

///|
/// 从当前集合中减去另一个多重集合中的元素（原地修改）
///
/// 参数:
/// * `self` : 多重集合
/// * `other` : 要减去的多重集合
pub fn[E : Hash + Eq] subtract(self : T[E], other : T[E]) -> Unit {
  other.each(fn(elem, count) { self.remove_n(elem, count) })
}

///|
/// 保留当前集合与另一个多重集合的交集（原地修改）
///
/// 参数:
/// * `self` : 多重集合
/// * `other` : 另一个多重集合
pub fn[E : Hash + Eq] retain(self : T[E], other : T[E]) -> Unit {
  let elements_to_process = self.elements()
  elements_to_process.each(fn(elem) {
    let self_count = self.count(elem)
    let other_count = other.count(elem)
    if other_count == 0 {
      // 元素不在other中，完全移除
      self.remove_all(elem)
    } else if other_count < self_count {
      // 减少计数到other中的计数
      self.set_count(elem, other_count)
    }
    // 如果other_count >= self_count，则保持不变
  })
}

///|
/// 返回迭代器，用于遍历多重集合中的元素及其计数
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回一个迭代器，产生(元素, 计数)对
pub fn[E] iter(self : T[E]) -> Iter2[E, Int] {
  self.counts.iter2()
}

///|
/// 从迭代器创建多重集合
///
/// 参数:
/// * `iter` : 产生元素的迭代器
///
/// 返回一个包含迭代器中所有元素的多重集合
pub fn[E : Hash + Eq] from_iter(iter : Iter[E]) -> T[E] {
  let ms = new()
  iter.each(fn(e) { ms.add(e) })
  ms
}

///|
/// 获取多重集合中出现频率最高的元素
/// 如果多个元素具有相同的最高频率，返回其中任意一个
/// 如果集合为空，返回None
///
/// 参数:
/// * `self` : 多重集合
///
/// 返回一个包含最高频元素及其计数的可选值
pub fn[E] most_common(self : T[E]) -> Entry[E]? {
  if self.is_empty() {
    return None
  }
  let mut max_element : E? = None
  let mut max_count = 0
  self.each(fn(elem, count) {
    if count > max_count {
      max_element = Some(elem)
      max_count = count
    }
  })
  match max_element {
    Some(elem) => Some(Entry::{ element: elem, count: max_count })
    None => None // 理论上不会到这里，因为之前已经检查了是否为空
  }
}

///|
/// 获取多重集合中出现频率最高的n个元素
///
/// 参数:
/// * `self` : 多重集合
/// * `n` : 要返回的元素数量
///
/// 返回一个包含最高频n个元素及其计数的数组，按频率降序排列
pub fn[E] most_common_n(self : T[E], n : Int) -> Array[Entry[E]] {
  if n <= 0 || self.is_empty() {
    return []
  }

  // 获取所有元素及其计数
  let entries = self.to_array()

  // 按计数降序排序
  entries.sort_by(fn(a, b) {
    if a.count > b.count {
      -1
    } else if a.count < b.count {
      1
    } else {
      0
    }
  })

  // 取前n个（或少于n个，如果集合大小小于n）
  let limit = if n < entries.length() { n } else { entries.length() }
  let result = []
  for i in 0..<limit {
    result.push(entries[i])
  }
  result
}

///|
/// 实现多重集合的Eq trait
pub impl[E : Eq + Hash] Eq for T[E] with op_equal(self, other) {
  if self.total_count != other.total_count {
    return false
  }
  if self.distinct_size() != other.distinct_size() {
    return false
  }
  let mut equal = true
  self.each(fn(elem, count) { if other.count(elem) != count { equal = false } })
  equal
}
