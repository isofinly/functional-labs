defmodule Lab2.SetBehaviour do
  @moduledoc """
  Defines the behavior for a Set data structure.
  """

  @callback new(capacity :: pos_integer()) :: Lab2.OpenAddressSet.t()

  @callback add(set :: Lab2.OpenAddressSet.t(), element :: any()) ::
              {:ok, Lab2.OpenAddressSet.t()} | {:error, atom()}

  @callback remove(set :: Lab2.OpenAddressSet.t(), element :: any()) :: Lab2.OpenAddressSet.t()

  @callback filter(set :: Lab2.OpenAddressSet.t(), predicate :: (any() -> boolean())) ::
              Lab2.OpenAddressSet.t()

  @callback map(set :: Lab2.OpenAddressSet.t(), func :: (any() -> any())) ::
              Lab2.OpenAddressSet.t()

  @callback fold_left(
              set :: Lab2.OpenAddressSet.t(),
              acc :: any(),
              func :: (any(), any() -> any())
            ) :: any()

  @callback fold_right(
              set :: Lab2.OpenAddressSet.t(),
              acc :: any(),
              func :: (any(), any() -> any())
            ) :: any()

  @callback union(
              set1 :: Lab2.OpenAddressSet.t(),
              set2 :: Lab2.OpenAddressSet.t()
            ) :: Lab2.OpenAddressSet.t()

  @callback empty?(set :: Lab2.OpenAddressSet.t()) :: boolean()

  @callback size(set :: Lab2.OpenAddressSet.t()) :: non_neg_integer()

  @callback to_list(set :: Lab2.OpenAddressSet.t()) :: list(any())
end
