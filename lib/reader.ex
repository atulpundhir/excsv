defmodule Reader do
  @moduledoc """
  Module to read csv file
  """
  def main(args) do
    args |> parse_args
  end

  @doc """
    `args` can be -h or --help which returns `:help`

    Otherwise name of the csv file

    e.g. ./excsv test.csv

    Returns the lines and fields within csv
  """
  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean], aliases: [h: :help])
    case options do
      {[help: true], [], []} -> process(:help)
      {[help: true], [otherargs], []} -> process(:help)
      {_, [fileName], _} -> process(fileName)
      _ -> process(:help)
    end
  end

  # Process help
  # @params: :help
  def process(:help) do
    IO.puts """
      Usage: ./excsv <csv_name>
      Make sure csv file is proper

      Eg: ./excsv test.csv

      You can also specify the path

      Eg: ./excsv csv/test.csv
    """
    :ok
  end

  # Opens csv file and close the csv file after reading
  # @params: fileName
  def process(fileName) do
    response = File.open(fileName, [:read, :utf8])
    case response do
      {:ok, device} ->
        data = readLine(device)
        case data do
          {:error, :blank} ->
                File.close(device)
                {:error, :blank}
          :ok ->
                File.close(device)
                :ok
          _ ->
                {:error, :file_error}
        end
     _->
        :io.format("File Error~n")
        {:error, :nofile}
    end
  end

  # Reads Lines from CSV file one by one
  # @params: FileHandler
  def readLine(device) do
   line_data =  IO.read(device, :line)
   case line_data do
    :eof ->
        {:error, :blank}
    _ ->
       line = String.split(line_data, ",")
       :io.format("New Line Starts ~n")
       Enum.all?(line, fn(x) -> :io.format("Col ~p~n", [x]) end)
       readLine(device)
       :ok
   end
  end
end
