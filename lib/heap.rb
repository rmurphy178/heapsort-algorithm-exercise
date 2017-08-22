class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []
    @prc = prc
  end

  def count
    store.length
  end

  def extract
    store[0], store[-1] = store[-1], store[0]
      extracted = store.pop
      @store = BinaryMinHeap.heapify_down(store, 0, &prc)
      extracted
  end

  def peek
    @store[0]
  end

  def push(val)
    @store << val
    @store = BinaryMinHeap.heapify_up(store, count - 1, &prc)
  end

  public
  def self.child_indices(len, parent_index)
    [2 * parent_index + 1, 2 * parent_index + 2].select do |idx|
      idx < len
    end
  end

  def self.parent_index(child_index)
    parent_index = (child_index - 1) / 2
    raise "root has no parent" if parent_index < 0
    parent_index
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el, el1| el <=> el1 }

    left_child_idx, right_child_idx = child_indices(len, parent_idx)

    parent_value = array[parent_idx]

    children = []
    children << array[left_child_idx] if left_child_idx
    children << array[right_child_idx] if right_child_idx

    if children.all? { |child| prc.call(parent_value, child) <= 0 }
      return array
    end

      swap_idx = 0
      if children.length == 1
        swap_idx = left_child_idx
      else
        swap_idx =
          prc.call(children[0], children[1]) == -1 ? left_child_idx : right_child_idx
      end

      array[parent_idx], array[swap_idx] = array[swap_idx], parent_value
      heapify_down(array, swap_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el, el1| el <=> el1 }

    return array if child_idx == 0

    parent_idx = parent_index(child_idx)
    child_val, parent_value = array[child_idx], array[parent_idx]
    if prc.call(child_val, parent_value) >= 0
      return array
    else
      array[child_idx], array[parent_idx] = parent_value, child_val
      heapify_up(array, parent_idx, len, &prc)
    end
  end
end
