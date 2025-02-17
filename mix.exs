defmodule TestTask.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_task,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      mod: {TestTask.Application, []},
      extra_applications: [:xmerl, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps() do
    [
      {:ex_doc, "~> 0.29.0", only: :dev},
      {:plug, "~> 1.15.3"},
      {:bandit, "~> 1.0"},
      {:websock_adapter, "~> 0.5"},
      {:nitro, "~> 8.2.4"},
      {:kvs, "~> 11.9"},
      {:n2o, "~> 10.12.4"},
      {:syn, "~> 2.1.1"},
      {:rocksdb, "~> 1.8"}
    ]
  end
end
