defmodule DigitsWeb.PageController do
  use DigitsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
