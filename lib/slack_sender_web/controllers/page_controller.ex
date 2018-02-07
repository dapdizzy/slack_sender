defmodule SlackSenderWeb.PageController do
  use SlackSenderWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
