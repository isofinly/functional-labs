defmodule Lab3.Algorithms.LagrangeInterpolation do
  @moduledoc """
  LagrangeInterpolation module for Lagrange interpolation.
  """

  def start(output_pid, frequency) do
    loop([], output_pid, frequency)
  end

  defp loop(window, output_pid, frequency) do
    receive do
      {:point, point} ->
        new_window =
          [point | window]
          |> Enum.sort_by(fn {x, _y} -> x end)
          |> Enum.take(-5)

        if length(new_window) >= 3 do
          interpolated = lagrange_interpolate(new_window, frequency)
          send(output_pid, {:output, "Лагранж", interpolated.xs, interpolated.ys})
        end

        loop(new_window, output_pid, frequency)

      :eof ->
        send(output_pid, :eof)
        :ok

      _ ->
        loop(window, output_pid, frequency)
    end
  end

  defp lagrange_interpolate(points, freq) do
    {x_min, x_max} =
      points
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.min_max()

    step = 1.0 / freq
    xs = generate_steps(x_min, x_max, step)
    ys =
      Enum.map(xs, fn x ->
        lagrange(points, x)
      end)

    %{
      xs: Enum.map(xs, &Float.round(&1, 2)),
      ys: Enum.map(ys, &Float.round(&1, 2))
    }
  end

  defp lagrange(points, x) do
    Enum.reduce(points, 0.0, fn {x_i, y_i}, acc ->
      term =
        points
        |> Enum.filter(fn {x_j, _y_j} -> x_j != x_i end)
        |> Enum.reduce(1.0, fn {x_j, _y_j}, prod ->
          prod * ((x - x_j) / (x_i - x_j))
        end)
        |> Kernel.*(y_i)

      acc + term
    end)
  end

  defp generate_steps(start, stop, step) do
    num_steps = trunc(Float.ceil((stop - start) / step)) + 1

    0..num_steps
    |> Enum.map(fn i -> Float.round(start + step * i, 2) end)
    |> Enum.filter(fn x -> x <= stop end)
  end
end
