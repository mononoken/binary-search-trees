# frozen_string_literal: true

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

  def childs
    child_array = []
    child_array.push(@left) unless @left.nil?
    child_array.push(@right) unless @right.nil?
    child_array
  end

  def leaf?
    childs.empty?
  end
end
