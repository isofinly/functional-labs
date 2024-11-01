defmodule Lab3.InputProcessor do
  @moduledoc """
  InputProcessor module for processing input from the user.
  """

  def start(alg_pids) do
    loop(alg_pids)
  end

  defp loop(alg_pids) do
    case IO.gets("") do
      :eof ->
        Enum.each(alg_pids, fn pid -> send(pid, :eof) end)

      data ->
        case parse_line(data) do
          {:ok, point} ->
            Enum.each(alg_pids, fn pid -> send(pid, {:point, point}) end)

          {:error, reason} ->
            IO.puts("Failed to parse line: #{reason}")
        end

        loop(alg_pids)
    end
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
