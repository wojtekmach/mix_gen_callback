defmodule GenCallback.MixProject do
  use Mix.Project

  def project() do
    [
      app: :mix_gen_callback,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      docs: docs(),
      deps: deps()
    ]
  end

  defp docs() do
    [
      main: "Mix.Tasks.Gen.Callback"
    ]
  end

  defp deps() do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
