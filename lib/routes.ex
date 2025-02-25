defmodule Test1.Routes do
  import N2O

  def finish(state, cx), do: {:ok, state, cx}

  def init(state, ctx) do
    %{path: p} = cx(ctx, :req)
    {:ok, state, cx(ctx, path: p, module: route_prefix(p))}
  end

  def route_prefix(<<"/ws/", p::binary>>), do: route(p)
  def route_prefix(<<"/", p::binary>>), do: route(p)
  def route_prefix(p), do: route(p)

  def route(<<>>), do: Test1.Index
  def route(<<"app/chat", _::binary>>), do: Test1.Chat
  def route(<<"app/index", _::binary>>), do: Test1.Index
  def route(_), do: Test1.Index
end
