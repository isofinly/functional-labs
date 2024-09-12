defmodule Lab1 do
  @moduledoc """
  Solutions for the second Euler problem using different approaches in Elixir.
  """

  @limit 4_000_000

  # 1. Monolithic implementation with tail recursion
  def sum_even_fibs_tail_rec do
    sum_even_fibs_tail_rec(1, 2, 0)
  end

  defp sum_even_fibs_tail_rec(_, b, sum) when b > @limit, do: sum

  defp sum_even_fibs_tail_rec(a, b, sum) when rem(b, 2) == 0,
    do: sum_even_fibs_tail_rec(b, a + b, sum + b)

  defp sum_even_fibs_tail_rec(a, b, sum), do: sum_even_fibs_tail_rec(b, a + b, sum)

  # 1. Monolithic implementation with recursion (non-tail)
  def sum_even_fibs_rec do
    sum_even_fibs_rec(1, 2)
  end

  defp sum_even_fibs_rec(_, b) when b > @limit, do: 0

  defp sum_even_fibs_rec(a, b) do
    if rem(b, 2) == 0 do
      b + sum_even_fibs_rec(b, a + b)
    else
      sum_even_fibs_rec(b, a + b)
    end
  end

  # 2. Modular implementation with sequence generation, filtering, and folding
  def sum_even_fibs_modular do
    Stream.unfold({1, 2}, fn {a, b} -> {a, {b, a + b}} end)
    |> Stream.take_while(&(&1 <= @limit))
    |> Stream.filter(&(rem(&1, 2) == 0))
    |> Enum.reduce(0, &+/2)
  end

  # 3. Sequence generation using map (fixed)
  def sum_even_fibs_map_generation do
    Stream.unfold({0, 1}, fn {a, b} ->
      if b > @limit, do: nil, else: {{a, b}, {b, a + b}}
    end)
    |> Stream.map(fn {_, fib} -> fib end)
    |> Stream.take_while(&(&1 <= @limit))
    |> Stream.filter(&(rem(&1, 2) == 0))
    |> Enum.sum()
  end

  # 4. Using special syntax for loops (fixed)
  def sum_even_fibs_comprehension do
    for a <-
          Stream.unfold({1, 2}, fn {a, b} ->
            if b > @limit, do: nil, else: {{a, b}, {b, a + b}}
          end),
        elem(a, 1) <= @limit,
        rem(elem(a, 1), 2) == 0,
        reduce: 0 do
      acc -> acc + elem(a, 1)
    end
  end

  # 5. Working with infinite lists (streams in Elixir)
  def sum_even_fibs_stream do
    Stream.unfold({1, 2}, fn {a, b} -> {a, {b, a + b}} end)
    |> Stream.take_while(&(&1 <= @limit))
    |> Stream.filter(&(rem(&1, 2) == 0))
    |> Enum.sum()
  end

  # 6. Traditional implementation (iterative approach)
  def sum_even_fibs_traditional do
    sum_even_fibs_traditional(1, 2, 0)
  end

  defp sum_even_fibs_traditional(_, b, sum) when b > @limit, do: sum

  defp sum_even_fibs_traditional(a, b, sum) do
    new_sum = if rem(b, 2) == 0, do: sum + b, else: sum
    sum_even_fibs_traditional(b, a + b, new_sum)
  end

  # 1. Monolithic implementation with tail recursion
  def distinct_powers_tail_rec(n) do
    for a <- 2..n, b <- 2..n, reduce: MapSet.new() do
      acc -> MapSet.put(acc, pow(a, b))
    end
    |> MapSet.size()
  end

  defp pow(base, exp) when is_integer(exp) and exp >= 0 do
    pow_tail(base, exp, 1)
  end

  defp pow_tail(_, 0, acc), do: acc
  defp pow_tail(base, exp, acc) when rem(exp, 2) == 0, do: pow_tail(base * base, div(exp, 2), acc)
  defp pow_tail(base, exp, acc), do: pow_tail(base, exp - 1, acc * base)

  # 2. Monolithic implementation with recursion (non-tail)
  def distinct_powers_rec(n) do
    for a <- 2..n, b <- 2..n do
      :math.pow(a, b)
    end
    |> Enum.uniq()
    |> length()
  end

  # 3. Modular implementation
  def distinct_powers_modular(n) do
    Stream.flat_map(2..n, fn a ->
      Stream.map(2..n, fn b ->
        :math.pow(a, b)
      end)
    end)
    |> Stream.uniq()
    |> Enum.count()
  end

  def distinct_powers_map_generation(n) do
    2..n
    |> Enum.map(fn a ->
      2..n
      |> Enum.map(fn b -> :math.pow(a, b) end)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  # 4. Using comprehension
  def distinct_powers_comprehension(n) do
    for a <- 2..n, b <- 2..n, into: MapSet.new() do
      :math.pow(a, b)
    end
    |> MapSet.size()
  end

  # 5. Using streams
  def distinct_powers_stream(n) do
    Stream.flat_map(2..n, fn a ->
      Stream.map(2..n, fn b ->
        :math.pow(a, b)
      end)
    end)
    |> Enum.into(MapSet.new())
    |> MapSet.size()
  end

  # 6. Traditional approach
  def distinct_powers_traditional(n) do
    Enum.reduce(2..n, MapSet.new(), fn a, acc ->
      Enum.reduce(2..n, acc, fn b, inner_acc ->
        MapSet.put(inner_acc, :math.pow(a, b))
      end)
    end)
    |> MapSet.size()
  end
end
