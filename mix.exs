defmodule Test1.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_1,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Test1.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29.0", only: :dev},
      {:n2o, "~> 11.9"},
      {:nitro, "~> 9.9"},
      {:cowboy, "~> 2.13"},
      {:rocksdb, "~> 1.9"},
      {:kvs, "~> 11.9"},
      {:syn, "~> 2.1.1"}
    ]
  end
end
