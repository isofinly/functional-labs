defmodule Lab2.OpenAddressSetTest do
  use ExUnit.Case
  use Lab2.Helper
  use ExUnitProperties

  alias Lab2.OpenAddressSet

  describe "add/2" do
    test "adds an element to the set" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, :a)
      assert OpenAddressSet.size(set) == 1
      assert :a in OpenAddressSet.to_list(set)
    end

    test "does not add duplicate elements" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, :a)
      {:ok, set} = OpenAddressSet.add(set, :a)
      assert OpenAddressSet.size(set) == 1
    end

    test "returns error when set is full" do
      set = OpenAddressSet.new(1)
      {:ok, set} = OpenAddressSet.add(set, :a)
      assert {:error, :set_full} = OpenAddressSet.add(set, :b)
    end
  end

  describe "remove/2" do
    test "removes an existing element" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, :a)
      set = OpenAddressSet.remove(set, :a)
      assert OpenAddressSet.size(set) == 0
      refute :a in OpenAddressSet.to_list(set)
    end

    test "does nothing if element does not exist" do
      set = OpenAddressSet.new()
      set = OpenAddressSet.remove(set, :a)
      assert OpenAddressSet.size(set) == 0
    end
  end

  describe "filter/2" do
    test "filters elements based on predicate" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, :a)
      {:ok, set} = OpenAddressSet.add(set, :b)
      {:ok, set} = OpenAddressSet.add(set, :c)
      filtered_set = OpenAddressSet.filter(set, fn x -> x != :b end)
      assert OpenAddressSet.size(filtered_set) == 2
      refute :b in OpenAddressSet.to_list(filtered_set)
    end
  end

  describe "map/2" do
    test "maps elements using a function" do
      set = OpenAddressSet.new(10)
      {:ok, set} = OpenAddressSet.add(set, 1)
      {:ok, set} = OpenAddressSet.add(set, 2)
      {:ok, set} = OpenAddressSet.add(set, 3)
      mapped_set = OpenAddressSet.map(set, fn x -> x * 2 end)
      assert OpenAddressSet.size(mapped_set) == 3
      assert [2, 4, 6] == Enum.sort(OpenAddressSet.to_list(mapped_set))
    end
  end

  describe "fold_left/3" do
    test "folds elements from left" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, 1)
      {:ok, set} = OpenAddressSet.add(set, 2)
      {:ok, set} = OpenAddressSet.add(set, 3)
      result = OpenAddressSet.fold_left(set, 0, fn x, acc -> acc + x end)
      assert result == 6
    end
  end

  describe "fold_right/3" do
    test "folds elements from right" do
      set = OpenAddressSet.new()
      {:ok, set} = OpenAddressSet.add(set, 1)
      {:ok, set} = OpenAddressSet.add(set, 2)
      {:ok, set} = OpenAddressSet.add(set, 3)
      result = OpenAddressSet.fold_right(set, [], fn x, acc -> [x | acc] end)
      assert Enum.sort(result) == [1, 2, 3]
    end
  end

  describe "union/2" do
    test "unions two sets without exceeding capacity" do
      set1 = OpenAddressSet.new(5)
      {:ok, set1} = OpenAddressSet.add(set1, :a)
      {:ok, set1} = OpenAddressSet.add(set1, :b)

      set2 = OpenAddressSet.new(5)
      {:ok, set2} = OpenAddressSet.add(set2, :b)
      {:ok, set2} = OpenAddressSet.add(set2, :c)

      union_set = OpenAddressSet.union(set1, set2)
      assert OpenAddressSet.size(union_set) == 3
      assert Enum.sort(OpenAddressSet.to_list(union_set)) == [:a, :b, :c]
      # Capacity should be the maximum of both sets' capacities
      assert union_set.capacity == max(set1.capacity, set2.capacity)
    end

    test "unions two sets with capacity constraints" do
      set1 = OpenAddressSet.new(2)
      {:ok, set1} = OpenAddressSet.add(set1, :a)
      {:ok, set1} = OpenAddressSet.add(set1, :b)

      set2 = OpenAddressSet.new(2)
      {:ok, set2} = OpenAddressSet.add(set2, :b)
      {:ok, set2} = OpenAddressSet.add(set2, :c)

      union_set = OpenAddressSet.union(set1, set2)
      assert OpenAddressSet.size(union_set) == 3
      assert Enum.sort(OpenAddressSet.to_list(union_set)) == [:a, :b, :c]
      # Capacity should be the maximum of both sets' capacities
      assert union_set.capacity == max(set1.capacity, set2.capacity)
    end
  end

  describe "Monoid properties" do
    property "associativity of union" do
      check all(
              set1 <- open_address_set_generator(),
              set2 <- open_address_set_generator(),
              set3 <- open_address_set_generator()
            ) do
        union1 = OpenAddressSet.union(OpenAddressSet.union(set1, set2), set3)
        union2 = OpenAddressSet.union(set1, OpenAddressSet.union(set2, set3))

        assert Enum.sort(OpenAddressSet.to_list(union1)) ==
                 Enum.sort(OpenAddressSet.to_list(union2))

        assert union1.capacity == max(OpenAddressSet.union(set1, set2).capacity, set3.capacity)
        assert union2.capacity == max(set1.capacity, OpenAddressSet.union(set2, set3).capacity)
      end
    end

    property "identity element for union" do
      check all(set <- open_address_set_generator()) do
        empty_set = OpenAddressSet.new(set.capacity)
        union = OpenAddressSet.union(set, empty_set)
        assert Enum.sort(OpenAddressSet.to_list(union)) == Enum.sort(OpenAddressSet.to_list(set))
        assert union.capacity == set.capacity
      end
    end

    property "union is commutative" do
      check all(
              set1 <- open_address_set_generator(),
              set2 <- open_address_set_generator()
            ) do
        union1 = OpenAddressSet.union(set1, set2)
        union2 = OpenAddressSet.union(set2, set1)

        assert Enum.sort(OpenAddressSet.to_list(union1)) ==
                 Enum.sort(OpenAddressSet.to_list(union2))

        assert union1.capacity == union2.capacity
      end
    end
  end
end
