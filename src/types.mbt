///|
/// 多重集合中的元素及其计数
pub(all) struct Entry[E] {
  /// 元素值
  element : E
  /// 该元素在集合中出现的次数
  count : Int
} derive(Show)

///|
/// 多重集合操作枚举
pub(all) enum SetOperation {
  /// 并集：取两个集合的所有元素，计数取最大值
  Union
  /// 交集：取两个集合共有的元素，计数取最小值
  Intersection
  /// 差集：从第一个集合中减去第二个集合的元素
  Difference
  /// 对称差集：取两个集合中互不包含的元素
  SymmetricDifference
}

///|
pub(all) struct T[E] {
  /// 存储元素及其计数的哈希表
  mut counts : @hashmap.T[E, Int]
  /// 所有元素计数的总和
  mut total_count : Int
} derive(Show)
