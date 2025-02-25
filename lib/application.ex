defmodule Test1.Application do
  use Application

  def start(_, _) do
    :kvs.join()
    {:ok, port} = :application.get_env(:n2o, :port)
    :cowboy.start_clear(:http, [port: port], %{env: %{dispatch: :n2o_cowboy.points()}})
    IO.puts("Login -> http://localhost:8020/app/index.htm")
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
