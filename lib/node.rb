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

  def leaf?
    @left.nil? && @right.nil?
  end

  def childs
    if leaf?
      0
    elsif @left.nil? || @right.nil?
      1
    else
      2
    end
  end
end
