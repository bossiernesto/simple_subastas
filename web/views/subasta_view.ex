defmodule SimpleSubasta.SubastaView do
  use SimpleSubasta.Web, :view

  def render("index.json", %{subastas: subastas}) do
    %{data: render_many(subastas, SimpleSubasta.SubastaView, "subasta.json")}
  end

  def render("show.json", %{subasta: subasta}) do
    %{data: render_one(subasta, SimpleSubasta.SubastaView, "subasta.json")}
  end

  def render("subasta.json", %{subasta: subasta}) do
    %{id: subasta.id,
      titulo: subasta.titulo,
      vendedor: subasta.vendedor,
      precio_base: subasta.precio_base,
      duracion: subasta.duracion,
      terminada: subasta.terminada,
      mejor_oferta: render_one(subasta.mejor_oferta, SimpleSubasta.OfertaView, "oferta.json")}
  end
end
