defmodule ReaderTest do
  use ExUnit.Case

  import Reader, only: [parse_args: 1]

  test "test for valid help calls" do
    assert parse_args(["-h" ]) == :ok
    assert parse_args(["--help"]) == :ok
  end

  test "test for invalid help calls" do
    assert parse_args(["-h", "invalid"]) == :ok
  end

  test "test for invalid files" do
    assert parse_args(["csv/nofile.csv"]) == {:error, :nofile}
    assert parse_args(["csv/blank.csv"]) == {:error, :blank}
  end

  test "test for valid file" do
    assert parse_args(["csv/test.csv"]) == :ok
  end
end
