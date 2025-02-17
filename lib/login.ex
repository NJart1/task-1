defmodule TestTask.Login do
  require NITRO
  require Logger

  def event(:init) do
    :nitro.update(
      :button_1,
      NITRO.button(id: :button_1, body: "Кімната 1", postback: {:login, "1"})
    )

    :nitro.update(
      :button_2,
      NITRO.button(id: :button_2, body: "Кімната 2", postback: {:login, "2"})
    )

    :nitro.update(
      :button_3,
      NITRO.button(id: :button_3, body: "Кімната 3", postback: {:login, "3"})
    )
  end

  def event({:login, room}) do
    :n2o.session(:room, room)
    :nitro.wire("ws.close();")
    :nitro.redirect(["/app/index.htm?room=", room])
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
