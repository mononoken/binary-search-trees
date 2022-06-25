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

  # FIX_ME: Returns nil and not the node when node is not the newest highest value.
  def insert(value, node = @root, parent_node = nil)
    if node.nil?
      parent_node.left = Node.new(value) if value < parent_node.data
      parent_node.right = Node.new(value) if value > parent_node.data
    else
      return nil if value == node.data

      inserted = insert(value, node.left, node) if value < node.data
      inserted = insert(value, node.right, node) if value > node.data
      # DON'T PANIC
      # Looks like method traverses right fist when inserting to the left. This may be causing the nil issue.
      puts "value: #{value} node: #{node} node.data: #{node.data}"
      inserted
    end
  end

  def delete(value, node = @root, parent_node = nil)
    if node.data == value
      case node.childs.count
      when 0
        parent_node.left = nil if parent_node.left == node
        parent_node.right = nil if parent_node.right == node
      when 1
        parent_node.left = node.childs[0] if parent_node.left == node
        parent_node.right = node.childs[0] if parent_node.right == node
      when 2
        next_biggest_node = find_next_biggest(node)
        parent_next_biggest_node = find_parent(next_biggest_node.data)
        node.data = next_biggest_node.data
        parent_next_biggest_node.left = nil if parent_next_biggest_node.left == next_biggest_node
        parent_next_biggest_node.right = nil if parent_next_biggest_node.right == next_biggest_node
      end
    else
      return nil if node.nil?

      delete(value, node.left, node) if value < node.data
      delete(value, node.right, node) if value > node.data
    end
  end

  def find(value, node = @root)
    return "'#{value}' not found in list." if node.nil?

    if value == node.data
      node
    else
      found = find(value, node.left) if value < node.data
      found = find(value, node.right) if value > node.data
      found
    end
  end

  def find_parent(value, node = @root, parent_node = nil)
    return "'#{value}' not found in list." if node.nil?

    if value == node.data
      parent_node
    else
      found = find_parent(value, node.left, node) if value < node.data
      found = find_parent(value, node.right, node) if value > node.data
      found
    end
  end

  def find_next_biggest(root = @root)
    next_node = root.right
    next_node = next_node.left until next_node.left.nil?
    next_node
  end

  def level_order
    pointer = @root
    queue = []
    queue.push(pointer)

    level_order_array = []

    until queue.empty?
      pointer = queue.shift
      level_order_array.push(pointer.data) unless pointer.nil?

      yield pointer if block_given?

      queue.push(pointer.left) unless pointer.left.nil?
      queue.push(pointer.right) unless pointer.right.nil?
    end
    level_order_array unless block_given?
  end

  def level_order_recursion(node = @root)
    if node.nil?
      return #something
    else
      nil
    end
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
