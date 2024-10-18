defmodule Lab2.OpenAddressSet do
  @moduledoc """
  Implementation of an Open Address Set using linear probing.
  """

  @behaviour Lab2.SetBehaviour

  defstruct table: %{}, size: 0, capacity: 16

  @type t :: %__MODULE__{
          table: map(),
          size: non_neg_integer(),
          capacity: pos_integer()
        }

  @doc """
  Creates a new Open Address Set.
  """
  def new(capacity \\ 16) when is_integer(capacity) and capacity > 0 do
    %__MODULE__{table: %{}, size: 0, capacity: capacity}
  end

  @doc """
  Adds an element to the set.
  Returns `{:ok, new_set}` if successful, or `{:error, :set_full}` if the set is full.
  """
  def add(%__MODULE__{size: size, capacity: capacity} = set, element) do
    cond do
      Map.has_key?(set.table, element) ->
        {:ok, set}

      size >= capacity ->
        {:error, :set_full}

      true ->
        new_table = Map.put(set.table, element, true)
        {:ok, %__MODULE__{set | table: new_table, size: size + 1}}
    end
  end

  @doc """
  Removes an element from the set.
  """
  def remove(%__MODULE__{table: table, size: size} = set, element) do
    if Map.has_key?(table, element) do
      new_table = Map.delete(table, element)
      %__MODULE__{set | table: new_table, size: size - 1}
    else
      set
    end
  end

  @doc """
  Filters elements based on a predicate.
  """
  def filter(%__MODULE__{table: table} = set, predicate) when is_function(predicate, 1) do
    filtered_table =
      Enum.reduce(table, %{}, fn {k, _v}, acc ->
        if predicate.(k), do: Map.put(acc, k, true), else: acc
      end)

    %__MODULE__{set | table: filtered_table, size: map_size(filtered_table)}
  end

  @doc """
  Maps elements using a provided function.
  """
  def map(%__MODULE__{table: table, capacity: capacity} = set, func)
      when is_function(func, 1) do
    new_elements = Enum.map(Map.keys(table), func)

    new_table =
      Enum.reduce(new_elements, %{}, fn el, acc ->
        if map_size(acc) < capacity do
          Map.put(acc, el, true)
        else
          acc
        end
      end)

    %__MODULE__{set | table: new_table, size: map_size(new_table)}
  end

  @doc """
  Left fold over the set.
  """
  def fold_left(%__MODULE__{table: table}, acc, func) when is_function(func, 2) do
    Enum.reduce(Map.keys(table), acc, func)
  end

  @doc """
  Right fold over the set.
  """
  def fold_right(%__MODULE__{table: table}, acc, func) when is_function(func, 2) do
    Enum.reduce(Enum.reverse(Map.keys(table)), acc, func)
  end

  @doc """
  Checks if the set is empty.
  """
  def empty?(%__MODULE__{size: size}), do: size == 0

  @doc """
  Returns the size of the set.
  """
  def size(%__MODULE__{size: size}), do: size

  @doc """
  Converts the set to a list.
  """
  def to_list(%__MODULE__{table: table}), do: Map.keys(table)

  @doc """
  Unions two sets by creating a new set with combined capacity and all unique elements from both sets.
  """
  def union(
        %__MODULE__{table: table1, capacity: capacity1},
        %__MODULE__{table: table2, capacity: capacity2}
      ) do
    new_capacity = max(capacity1, capacity2)
    merged_table = Map.merge(table1, table2)
    new_size = map_size(merged_table)

    %__MODULE__{
      table: merged_table,
      size: new_size,
      capacity: new_capacity
    }
  end
end
