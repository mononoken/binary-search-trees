# frozen_string_literal: true

require_relative './node'
require_relative './pointer'

require 'pry-byebug'

# Build a binary search tree from an array.
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  # DON'T PANIC.
  # Are these trees actually balanced? I think so, and the video is wrong... gm8DUJJhmY4
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
  # def insert(value, node = @root, parent_node = nil)
  #   if node.nil?
  #     parent_node.left = Node.new(value) if value < parent_node.data
  #     parent_node.right = Node.new(value) if value > parent_node.data
  #   else
  #     return nil if value == node.data

  #     inserted = insert(value, node.left, node) if value < node.data
  #     inserted = insert(value, node.right, node) if value > node.data
  #     # DON'T PANIC
  #     # Looks like method traverses right fist when inserting to the left. This may be causing the nil issue.
  #     puts "value: #{value} node: #{node} node.data: #{node.data}"
  #     inserted
  #   end
  # end


  # Removed Pointer. Is this object worth having?
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

  def find(value, pointer = Pointer.new(self))
    return "'#{value}' not found in list." if pointer.nil?

    if value == pointer.data
      pointer
    else
      found = find(value, pointer.left) if value < pointer.data
      found = find(value, pointer.right) if value > pointer.data
      found
    end
  end

  # See how the methods traverse in binding pry
  def find(value, pointer = root)
    binding.pry
    return "'#{value}' not found in list." if pointer.nil?

    if value == pointer.data
      pointer
    else
      value < pointer.data ? find(value, pointer.left) : find(value, pointer.right)
    end
  end

  def find_parent(value, node = @root, parent_node = nil)
    return "'#{value}' not found in list." if node.nil?

    if value == node.data
      parent_node
    else
      find_parent(value, node.left, node) if value < node.data
      find_parent(value, node.right, node) if value > node.data
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
      preorder_list.push(pointer.data)

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
      inorder_list.push(pointer.data)

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
      postorder_list.push(pointer.data)
      postorder_list
    end
  end

  def height(node)
    # return height
  end

  # Recognize that many methods involve traversing. Can I make this task a method?
  def traverse
  end

  # Print a visualization of tree (from TOP student).
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test.insert(10)
