# Build a Node class. It should have an attribute for the data it stores as well
# as its left and right children. As a bonus, try including the Comparable
# module and compare nodes using their data attribute.

# Node for use in a binary search tree (BST)
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end
