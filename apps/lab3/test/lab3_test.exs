defmodule Lab3Test do
  use ExUnit.Case

  describe "LinearInterpolation" do
    test "interpolates two points correctly" do
      parent = self()
      pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])

      send(pid, {:point, {+0.0, +0.00}})
      send(pid, {:point, {1.571, +1.0}})
      # Завершаем процесс
      send(pid, :eof)

      assert_receive {:output, "Линейная", [+0.00, +1.00, +2.00], [+0.00, +0.64, +1.27]}, 1000
    end

    test "interpolates non-integer steps correctly" do
      parent = self()
      pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])

      send(pid, {:point, {1.0, 2.0}})
      send(pid, {:point, {3.0, 4.0}})
      # Завершаем процесс
      send(pid, :eof)

      assert_receive {:output, "Линейная", [1.00, 2.00, 3.00], [2.00, 3.00, 4.00]}, 1000
    end
  end

  describe "LagrangeInterpolation" do
    test "interpolates three points correctly" do
      parent = self()
      pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])

      send(pid, {:point, {+0.0, +0.00}})
      send(pid, {:point, {+1.0, +1.0}})
      send(pid, {:point, {+2.0, +0.0}})
      # Завершаем процесс
      send(pid, :eof)

      assert_receive {:output, "Лагранж", [+0.00, +1.00, +2.00], [+0.00, +1.00, +0.00]}, 1000
    end

    test "interpolates five points correctly" do
      parent = self()
      pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])

      send(pid, {:point, {0.0, 0.00}})
      send(pid, {:point, {1.0, 1.00}})
      send(pid, {:point, {2.0, 0.00}})
      send(pid, {:point, {3.0, -1.00}})
      send(pid, {:point, {4.0, 0.00}})
      # Завершаем процесс
      send(pid, :eof)

      expected_xs = [0.00, 1.00, 2.00, 3.00, 4.00]
      expected_ys = [0.00, 1.00, 0.00, -1.00, 0.00]

      assert_receive {:output, "Лагранж", ^expected_xs, ^expected_ys}, 1000
    end
  end
end
