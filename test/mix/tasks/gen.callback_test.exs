defmodule Mix.Tasks.Gen.CallbackTest do
  use ExUnit.Case, async: true

  test "good module" do
    Mix.Task.run("gen.callback", ["GenServer"])
  end
end
