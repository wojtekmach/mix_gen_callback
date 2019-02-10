defmodule GenCallback.MixProject do
  use Mix.Project

  def project() do
    [
      app: :gen_callback,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps() do
    []
  end
end
