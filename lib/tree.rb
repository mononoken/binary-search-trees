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

  # FIX_ME: This method appears to work, but it sometimes returns nil and sometimes returns the new node.
  def insert(value, node = @root, parent_node = nil)
    if node.nil?
      parent_node.left = Node.new(value) if value < parent_node.data
      parent_node.right = Node.new(value) if value > parent_node.data
    else
      return nil if value == node.data

      insert(value, node.left, node) if value < node.data
      insert(value, node.right, node) if value > node.data
    end
  end

  def delete(value)
  end

  def find(value, node = @root)
    return "'#{value}' not found in list." if node.nil?

    if value == node.data
      node
    else
      find(value, node.left) if value < node.data
      find(value, node.right) if value > node.data
    end
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
