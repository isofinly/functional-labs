defmodule Lab3 do
  @moduledoc """
  Lab3 module for running the interpolation algorithms.
  """

  def main(args) do
    # Parse command-line arguments
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [
          algorithms: :string,
          frequency: :integer
        ],
        aliases: [
          a: :algorithms,
          f: :frequency
        ]
      )

    algorithms = parse_algorithms(opts[:algorithms] || "linear")
    frequency = opts[:frequency] || 1

    # Start output process
    output_pid = spawn(Lab3.OutputProcessor, :start, [])

    # Start interpolation algorithm processes
    alg_pids =
      Enum.map(algorithms, fn alg ->
        case alg do
          :linear ->
            spawn(Lab3.Algorithms.LinearInterpolation, :start, [output_pid, frequency])

          :lagrange ->
            spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [output_pid, frequency])

          _ ->
            IO.puts("Unknown algorithm: #{alg}")
            nil
        end
      end)
      # Remove nils
      |> Enum.filter(& &1)

    # Start input processing
    Lab3.InputProcessor.start(alg_pids)
  end

  defp parse_algorithms(algo_str) do
    algo_str
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&String.to_atom/1)
  end
end
