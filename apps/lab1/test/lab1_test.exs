defmodule Lab1Test do
  use ExUnit.Case
  doctest Lab1

  @expected_result 4_613_732

  test "sum_even_fibs_tail_rec" do
    assert Lab1.sum_even_fibs_tail_rec() == @expected_result
  end

  test "sum_even_fibs_rec" do
    assert Lab1.sum_even_fibs_rec() == @expected_result
  end

  test "sum_even_fibs_modular" do
    assert Lab1.sum_even_fibs_modular() == @expected_result
  end

  test "sum_even_fibs_map" do
    assert Lab1.sum_even_fibs_map_generation() == @expected_result
  end

  test "sum_even_fibs_comprehension" do
    assert Lab1.sum_even_fibs_comprehension() == @expected_result
  end

  test "sum_even_fibs_stream" do
    assert Lab1.sum_even_fibs_stream() == @expected_result
  end

  test "sum_even_fibs_traditional" do
    assert Lab1.sum_even_fibs_traditional() == @expected_result
  end

  test "distinct_powers with n=5" do
    assert Lab1.distinct_powers_tail_rec(5) == 15
    assert Lab1.distinct_powers_rec(5) == 15
    assert Lab1.distinct_powers_modular(5) == 15
    assert Lab1.distinct_powers_comprehension(5) == 15
    assert Lab1.distinct_powers_stream(5) == 15
    assert Lab1.distinct_powers_traditional(5) == 15
  end

  test "distinct_powers with n=10" do
    assert Lab1.distinct_powers_tail_rec(10) == 69
    assert Lab1.distinct_powers_rec(10) == 69
    assert Lab1.distinct_powers_modular(10) == 69
    assert Lab1.distinct_powers_comprehension(10) == 69
    assert Lab1.distinct_powers_stream(10) == 69
    assert Lab1.distinct_powers_traditional(10) == 69
  end

  test "distinct_powers with n=15" do
    assert Lab1.distinct_powers_tail_rec(15) == 177
    assert Lab1.distinct_powers_rec(15) == 177
    assert Lab1.distinct_powers_modular(15) == 177
    assert Lab1.distinct_powers_comprehension(15) == 177
    assert Lab1.distinct_powers_stream(15) == 177
    assert Lab1.distinct_powers_traditional(15) == 177
  end

  @tag :slow
  test "distinct_powers with n=100" do
    assert Lab1.distinct_powers_tail_rec(100) == 9183
    assert Lab1.distinct_powers_rec(100) == 9183
    assert Lab1.distinct_powers_modular(100) == 9183
    assert Lab1.distinct_powers_comprehension(100) == 9183
    assert Lab1.distinct_powers_stream(100) == 9183
    assert Lab1.distinct_powers_traditional(100) == 9183
  end
end
