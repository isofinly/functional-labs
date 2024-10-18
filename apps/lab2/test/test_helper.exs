defmodule Lab2.Helper do
  use ExUnit.CaseTemplate
  use ExUnitProperties

  using do
    quote do
      import Lab2.Helper
      import ExUnitProperties
    end
  end

  @doc """
  Generates a random OpenAddressSet for property-based testing.
  """
  def open_address_set_generator do
    integer_capacity = StreamData.integer(1..100)

    StreamData.bind(integer_capacity, fn capacity ->
      elements = StreamData.list_of(StreamData.atom(:alphanumeric), max_length: capacity)

      StreamData.map(elements, fn elems ->
        Enum.reduce(elems, Lab2.OpenAddressSet.new(capacity), fn el, acc ->
          # It is kinda pointless to test the test helper for function depth
          # credo:disable-for-next-line
          case Lab2.OpenAddressSet.add(acc, el) do
            {:error, _} -> acc
            {:ok, new_set} -> new_set
          end
        end)
      end)
    end)
  end
end
