defmodule SimpleSubasta.OfertaView do
  use SimpleSubasta.Web, :view

  def render("index.json", %{oferta: oferta}) do
    %{data: render_one(oferta, SimpleSubasta.OfertaView, "oferta.json")}
  end

  def render("show.json", %{oferta: oferta}) do
    %{data: render_one(oferta, SimpleSubasta.OfertaView, "oferta.json")}
  end

  def render("oferta.json", %{oferta: oferta}) do
    %{id: oferta.id,
      comprador: oferta.comprador,
      precio: oferta.precio}
  end
end
