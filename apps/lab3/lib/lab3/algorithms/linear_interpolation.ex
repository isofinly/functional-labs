defmodule Lab3.Algorithms.LinearInterpolation do
  @moduledoc """
  LinearInterpolation module for linear interpolation.
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
          |> Enum.take(-2)

        if length(new_window) == 2 do
          {p1, p2} = {Enum.at(new_window, 0), Enum.at(new_window, 1)}
          interpolated = linear_interpolate(p1, p2, frequency)
          send(output_pid, {:output, "Линейная", interpolated.xs, interpolated.ys})
        end

        loop(new_window, output_pid, frequency)

      :eof ->
        send(output_pid, :eof)
        :ok

      _ ->
        loop(window, output_pid, frequency)
    end
  end

  defp linear_interpolate({x1, y1}, {x2, y2}, freq) do
    step = 1.0 / freq
    xs = generate_steps(x1, x2, step)
    ys = Enum.map(xs, fn x -> y1 + (y2 - y1) / (x2 - x1) * (x - x1) end)

    %{
      xs: Enum.map(xs, &Float.round(&1, 2)),
      ys: Enum.map(ys, &Float.round(&1, 2))
    }
  end

  defp generate_steps(start, stop, step) do
    num_steps = trunc(Float.ceil((stop - start) / step))

    0..num_steps
    |> Enum.map(fn i -> Float.round(start + step * i, 2) end)
  end
end
