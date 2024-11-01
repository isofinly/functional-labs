defmodule Lab3.OutputProcessor do
  @moduledoc """
  OutputProcessor module for processing output from the algorithms.
  """

  def start do
    loop()
  end

  defp loop do
    receive do
      {:output, method, xs, ys} ->
        IO.puts("#{method}:")
        IO.puts(Enum.map_join(xs, "\t", &float_to_string(&1)))
        IO.puts(Enum.map_join(ys, "\t", &float_to_string(&1)))
        loop()

      :eof ->
        :ok

      _ ->
        loop()
    end
  end

  defp float_to_string(float) do
    :erlang.float_to_binary(float, [:compact, {:decimals, 2}])
  end
end
