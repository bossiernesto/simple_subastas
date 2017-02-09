defmodule SimpleSubasta.SubastasChannel do
  use Phoenix.Channel

  def join("subastas:general", _message, socket) do
    {:ok, socket}
  end

  def join("subastas:" <> _subasta_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

end
