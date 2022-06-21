# frozen_string_literal: true

require_relative './node'

# Build a binary search tree from an array.
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    formatted_array = array.uniq.sort

    if formatted_array.empty?
      nil
    else
      root = Node.new(formatted_array[formatted_array.count / 2])
      root.left = build_tree(formatted_array[0...formatted_array.count / 2])
      root.right = build_tree(formatted_array[formatted_array.count / 2 + 1..formatted_array.count])
      root
    end
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
