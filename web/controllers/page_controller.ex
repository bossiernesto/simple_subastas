defmodule SimpleSubasta.PageController do
  use SimpleSubasta.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
