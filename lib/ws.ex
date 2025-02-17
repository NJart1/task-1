defmodule TestTask.WS do
  require N2O
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  get("/ws/app/:mod",
    do:
      conn
      |> WebSockAdapter.upgrade(TestTask.WS, [module: extract(mod)], timeout: 60_000)
      |> halt()
  )

  def extract(route), do: :application.get_env(:n2o, :router, TestTask.Application).route(route)

  def init(args), do: {:ok, N2O.cx(module: Keyword.get(args, :module))}

  def handle_in({"N2O," <> _ = message, _}, state),
    do: response(:n2o_proto.stream({:text, message}, [], state))

  def handle_in({"PING", _}, state), do: {:reply, :ok, {:text, "PONG"}, state}

  def handle_in({message, _}, state) when is_binary(message),
    do: response(:n2o_proto.stream({:binary, message}, [], state))

  def handle_info(message, state), do: response(:n2o_proto.info(message, [], state))

  def response({:reply, {:binary, rep}, _, s}), do: {:reply, :ok, {:binary, rep}, s}
  def response({:reply, {:text, rep}, _, s}), do: {:reply, :ok, {:text, rep}, s}

  def response({:reply, {:bert, rep}, _, s}),
    do: {:reply, :ok, {:binary, :n2o_bert.encode(rep)}, s}

  def response({:reply, {:json, rep}, _, s}),
    do: {:reply, :ok, {:binary, :n2o_json.encode(rep)}, s}

  match _ do
    send_resp(conn, 404, ":Р. IDK, read documentation")
  end
end
