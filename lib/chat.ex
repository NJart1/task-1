defmodule Test1.Chat do
  require NITRO
  require KVS
  require N2O
  require Logger

  def event(:init) do
    room = :n2o.session(:room)
    if room == [], do: :nitro.redirect("/app/index.htm")
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
    |> Enum.each(fn {:msg, _, message} ->
      event({:client, message})
    end)
  end

  def event(:logout) do
    :nitro.wire("ws.close();")
    :nitro.redirect("/app/index.htm")
  end

  def event(:chat), do: chat(:nitro.q(:message))

  def event({:client, message}) do
    :nitro.wire(NITRO.jq(target: :message, method: [:focus, :select]))

    :nitro.insert_top(
      :history,
      NITRO.message(body: :nitro.jse(message))
    )
  end

  def chat(message) do
    room = :n2o.session(:room)

    room
    |> :kvs.writer()
    |> KVS.writer(args: {:msg, :kvs.seq([], []), message})
    |> :kvs.add()
    |> :kvs.save()

    :n2o.send({:topic, room}, N2O.client(data: message))
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
