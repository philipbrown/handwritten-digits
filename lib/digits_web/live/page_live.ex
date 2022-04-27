defmodule DigitsWeb.PageLive do
  @moduledoc """
  PageLive LiveView
  """

  use DigitsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{prediction: nil})}
  end

  def render(assigns) do
    ~H"""
    <div id="wrapper" phx-update="ignore" class="mx-auto h-96 w-96 mb-8">
      <div id="canvas" phx-hook="Draw" class="mx-auto h-96 w-96"></div>
    </div>

    <div class="mx-auto flex justify-center space-x-4">
      <button phx-click="reset" class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">Reset</button>
      <button phx-click="predict" class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">Predict</button>
    </div>

    <%= if @prediction do %>
    <div class="mx-auto text-center mt-8">
      <div class="font-semibold">
        Prediction:
      </div>
      <div class="text-8xl">
        <%= @prediction %>
      </div>
    </div>
    <% end %>
    """
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
      socket
      |> assign(prediction: nil)
      |> push_event("reset", %{})
    }
  end

  def handle_event("predict", _params, socket) do
    {:noreply, push_event(socket, "predict", %{})}
  end

  def handle_event("image", "data:image/png;base64," <> raw, socket) do
    name = Base.url_encode64(:crypto.strong_rand_bytes(10), padding: false)
    path = Path.join(System.tmp_dir!(), "#{name}.png")

    File.write!(path, Base.decode64!(raw))

    prediction = Digits.Model.predict(path)

    File.rm!(path)

    {:noreply, assign(socket, prediction: prediction)}
  end
end
