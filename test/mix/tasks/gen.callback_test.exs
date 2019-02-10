defmodule Mix.Tasks.Gen.CallbackTest do
  use ExUnit.Case, async: true

  test "GenServer" do
    Mix.Task.run("gen.callback", ["GenServer"])
  end

  test "Enumerable" do
    Mix.Task.run("gen.callback", ["Enumerable"])
  end
end
