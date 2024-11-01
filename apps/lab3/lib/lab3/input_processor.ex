defmodule Lab3.InputProcessor do
  @moduledoc """
  InputProcessor module for processing input from the user.
  """

  def start(alg_pids) do
    loop(alg_pids)
  end

  defp loop(alg_pids) do
    handle_input(IO.gets(""), alg_pids)
  end

  defp handle_input(:eof, alg_pids) do
    Enum.each(alg_pids, fn pid -> send(pid, :eof) end)
  end

  defp handle_input(data, alg_pids) do
    data
    |> parse_line()
    |> broadcast_result(alg_pids)

    loop(alg_pids)
  end

  defp broadcast_result({:ok, point}, alg_pids) do
    Enum.each(alg_pids, fn pid -> send(pid, {:point, point}) end)
  end

  defp broadcast_result({:error, reason}, _alg_pids) do
    IO.puts("Failed to parse line: #{reason}")
  end

  defp parse_line(line) do
    # Теперь поддерживает запятые, точки с запятыми, табуляции и пробелы
    case String.trim(line) |> String.split(~r/[,\;\t\s]+/) do
      [x_str, y_str] ->
        with {x, ""} <- Float.parse(x_str),
             {y, ""} <- Float.parse(y_str) do
          {:ok, {x, y}}
        else
          _ -> {:error, "Invalid number format"}
        end

      _ ->
        {:error, "Invalid format"}
    end
  end
end
