# frozen_string_literal: true

# Tracker for traversing through a binary search tree (BST)

class Pointer
  attr_reader :tree, :parent
  attr_accessor :node

  def initialize(tree)
    @tree = tree
    @node = tree.root
    @parent = nil
  end

  # Can I make a method that will update previous_node anytime #left or #right is called? 
  # Without adding logic inside those methods?
  def left
    @parent = @node
    @node = node.left
  end

  def right
    @parent = @node
    @node = node.right
  end

  # def nil_traverse
  #   return nil if nil?
  # end

  def nil?
    @node.nil?
  end

  def data
    return nil if nil?

    @node.data
  end

  def traverse
  end
end
