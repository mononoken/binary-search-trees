# frozen_string_literal: true

require_relative './node'

# Build a binary search tree from an array.
class Tree
  attr_reader :array, :root

  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  # Refactor
  def build_tree(array)
    return nil if array.empty?

    midpoint, left_array, right_array = split_array(array)

    root = Node.new(midpoint)
    root.left = build_tree(left_array)
    root.right = build_tree(right_array)
    root
  end

  def split_array(array)
    midpoint = array[array.count / 2]
    left_array = array.partition { |num| num < midpoint }[0]
    right_array = array.partition { |num| num > midpoint }[0]

    [midpoint, left_array, right_array]
  end

  def insert(value, pointer = root)
    return nil if value == pointer.data

    if value < pointer.data
      pointer.left.nil? ? pointer.left = Node.new(value) : insert(value, pointer.left)
    else
      pointer.right.nil? ? pointer.right = Node.new(value) : insert(value, pointer.right)
    end
  end

  def delete(value, pointer = root)
    return pointer if pointer.nil?

    if value < pointer.data
      pointer.left = delete(value, pointer.left)
    elsif value > pointer.data
      pointer.right = delete(value, pointer.right)
    else
      case pointer.childs.count
      when 0
        pointer = nil
      when 1
        return pointer.right if pointer.left.nil?
        return pointer.left if pointer.right.nil?
      when 2
        next_biggest_value = find_next_biggest(pointer).data
        pointer.data = next_biggest_value
        pointer.right = delete(next_biggest_value, pointer.right)
      end
    end
    pointer
  end

  def find(value, pointer = root)
    return "'#{value}' not found in list." if pointer.nil?

    if value == pointer.data
      pointer
    else
      value < pointer.data ? find(value, pointer.left) : find(value, pointer.right)
    end
  end

  def find_next_biggest(pointer = root)
    return nil if pointer.right.nil?

    pointer = pointer.right
    pointer = pointer.left until pointer.left.nil?
    pointer
  end

  def level_order
    pointer = root
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

  def level_order_recursive(pointer = root, queue = [pointer], level_order_values = [], &block)
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
  def preorder(pointer = root, preorder_list = [], &block)
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
  def inorder(pointer = root, inorder_list = [], &block)
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
  def postorder(pointer = root, postorder_list = [], &block)
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

  def find_leafs(pointer = root)
    preorder(pointer).filter { |node| node.leaf? }
  end

  def height(pointer = root)
    return "'#{pointer}' not found in list." unless pointer.instance_of?(Node)

    find_leafs(pointer).map { |leaf| depth(leaf, pointer)}.max
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

  def rebalance
    @root = build_tree(inorder(root).map(&:data))
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

puts 'Initialize tree'
test = Tree.new(Array.new(15) { rand(1..100) })
test.pretty_print
puts "Is balanced?: #{test.balanced?}"
p test.preorder.map(&:data)
p test.inorder.map(&:data)
p test.postorder.map(&:data)

puts 'Insert 8 nodes'
8.times do
  test.insert(rand(100..300))
end
test.pretty_print
puts "Is balanced?: #{test.balanced?}"

puts 'Rebalance tree'
test.rebalance
test.pretty_print
puts "Is balanced?: #{test.balanced?}"
p test.preorder.map(&:data)
p test.inorder.map(&:data)
p test.postorder.map(&:data)
