# frozen_string_literal: true

require_relative './node'

require 'pry-byebug'

# Build a binary search tree from an array.
class Tree
  attr_reader :array, :root

  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  def build_tree(array)
    return nil if array.empty?

    root = Node.new(array[array.count / 2])
    root.left = build_tree(array[0...array.count / 2])
    root.right = build_tree(array[array.count / 2 + 1..array.count])
    root
  end

  def insert(value, pointer = root)
    return nil if value == pointer.data

    if value < pointer.data
      pointer.left.nil? ? pointer.left = Node.new(value) : insert(value, pointer.left)
    else
      pointer.right.nil? ? pointer.right = Node.new(value) : insert(value, pointer.right)
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

  def find(value, pointer = root)
    return "'#{value}' not found in list." if pointer.nil?

    if value == pointer.data
      pointer
    else
      value < pointer.data ? find(value, pointer.left) : find(value, pointer.right)
    end
  end

  def find_parent(value, pointer = @root, parent = nil)
    return "'#{value}' not found in list." if pointer.nil?

    if value == pointer.data
      parent
    else
      value < pointer.data ? find_parent(value, pointer.left, pointer) : find_parent(value, pointer.right, pointer)
    end
  end

  def find_next_biggest(pointer = @root)
    return nil if pointer.right.nil?

    pointer = pointer.right
    pointer = pointer.left until pointer.left.nil?
    pointer
  end

  def level_order
    pointer = @root
    queue = []
    queue.push(pointer)

    level_order_values = []

    until queue.empty?
      pointer = queue.shift
      level_order_values.push(pointer.data) unless pointer.nil?

      yield pointer if block_given?

      queue.push(pointer.left) unless pointer.left.nil?
      queue.push(pointer.right) unless pointer.right.nil?
    end
    level_order_values
  end

  def level_order_recursive(pointer = @root, queue = [pointer], level_order_values = [], &block)
    if queue.empty?
      level_order_values
    else
      pointer = queue.shift
      block.call(pointer) if block_given?
      
      level_order_values.push(pointer.data)

      queue.push(pointer.left) unless pointer.left.nil?
      queue.push(pointer.right) unless pointer.right.nil?
      level_order_recursive(pointer, queue, level_order_values, &block)
      level_order_values
    end
  end

  # root left right
  def preorder(pointer = @root, preorder_list = [], &block)
    if pointer.nil?
      nil
    else
      block.call pointer if block_given?
      preorder_list.push(pointer)

      preorder(pointer.left, preorder_list, &block)
      preorder(pointer.right, preorder_list, &block)

      preorder_list
    end
  end

  # left root right
  def inorder(pointer = @root, inorder_list = [], &block)
    if pointer.nil?
      nil
    else
      inorder(pointer.left, inorder_list, &block)

      block.call pointer if block_given?
      inorder_list.push(pointer)

      inorder(pointer.right, inorder_list, &block)

      inorder_list
    end
  end

  # left right root
  def postorder(pointer = @root, postorder_list = [], &block)
    if pointer.nil?
      nil
    else
      postorder(pointer.left, postorder_list, &block)
      postorder(pointer.right, postorder_list, &block)

      block.call pointer if block_given?
      postorder_list.push(pointer)
      postorder_list
    end
  end

  def find_leafs(node)
    preorder(node).filter { |node| node.leaf? }
  end

  def height(node = root)
    return "'#{node}' not found in list." unless node.instance_of?(Node)

    find_leafs(node).map { |leaf| depth(leaf, node)}.max
  end

  def depth(node, pointer = root, counter = 0)
    return "'#{node.data}' not found in list." if pointer.nil?

    if node == pointer
      counter
    else
      counter += 1
      node < pointer ? depth(node, pointer.left, counter) : depth(node, pointer.right, counter)
    end
  end

  def balanced?
    preorder(root).all? do |node|
      if node.left.nil? && node.right.nil?
        true
      elsif node.left.nil?
        height(node.right) == 0
      elsif node.right.nil?
        height(node.left) == 0
      else
        height(node.left) - height(node.right) <= 1
      end
    end
  end

  # Tip: You’ll want to use a traversal method to provide a new array to the #build_tree method.
  def rebalance
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test.find(1)
