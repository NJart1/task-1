defmodule TestTask.Index do
  require NITRO
  require KVS
  require N2O
  require Logger

  def room() do
    case :n2o.session(:room) do
      ~c"" -> "lobby"
      "" -> "lobby"
      x -> x
    end
  end

  def event(:init) do
    room = TestTask.Index.room()
    :kvs.ensure(KVS.writer(id: room))
    :n2o.reg({:topic, room})
    :nitro.update(:heading, NITRO.h2(id: :heading, body: "Кімната #{room}"))
    :nitro.update(:logout, NITRO.button(id: :logout, postback: :logout, body: "Вийти з Кімнати"))

    :nitro.update(
      :send,
      NITRO.button(id: :send, body: "Надіслати", postback: :chat, source: [:message])
    )

    room
    |> :kvs.all()
    |> Enum.each(fn {:msg, _, user, message} ->
      event({:client, {user, message}})
    end)
  end

  def event(:logout) do
    :n2o.user([])
    :nitro.wire("ws.close();")
    :nitro.redirect("/app/login.htm")
  end

  def event(:chat), do: chat(:nitro.q(:message))

  def event({:client, {user, message}}) do
    :nitro.wire(NITRO.jq(target: :message, method: [:focus, :select]))

    :nitro.insert_top(
      :history,
      NITRO.message(body: [NITRO.author(body: user), :nitro.jse(message)])
    )
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()

  def chat(message) do
    room = TestTask.Index.room()
    user = :n2o.user()

    room
    |> :kvs.writer()
    |> KVS.writer(args: {:msg, :kvs.seq([], []), user, message})
    |> :kvs.add()
    |> :kvs.save()

    :n2o.send({:topic, room}, N2O.client(data: {user, message}))
  end
end
