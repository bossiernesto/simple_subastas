defmodule SimpleSubasta.SubastaController do
   use SimpleSubasta.Web, :controller

   alias SimpleSubasta.Subasta
   alias SimpleSubasta.SubastaWorker

   def index(conn, _params) do
    #Obtener todas las subastas
    subastas = Repo.all from s in Subasta, preload: [:mejor_oferta]
    render(conn, "index.json", subastas: subastas)
   end

   def clientrender(conn, _params) do
     render conn, "index.html"
   end

   def show(conn, %{"id" => id}) do
     subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)
     render(conn, "show.json", subasta: subasta)
   end

   def create(conn, %{"subasta" => subasta_params}) do
      changeset = Subasta.changeset(%Subasta{mejor_oferta: nil}, subasta_params)
      case Repo.insert(changeset) do
        {:ok, subasta} ->
          # Notificamos al worker
          GenServer.cast({:global, :subasta_worker}, {:nueva_subasta, subasta.id})
          # Notificamos a los compradores sobre la nueva subasta
          SimpleSubasta.Endpoint.broadcast! "subastas:general",
                                            "nueva_subasta",
                                            %{subasta_id: subasta.id,
                                              precio: subasta.precio_base,
                                              duracion: subasta.duracion,
                                              vendedor: subasta.vendedor}
          conn
          |> put_status(:created)
          |> put_resp_header("location", subasta_path(conn, :show, subasta))
          |> render("show.json", subasta: subasta)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(SimpleSubasta.ChangesetView, "error.json", changeset: changeset)
      end
    end

   def update(conn, %{"id" => id, "subasta" => subasta_params}) do
     subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)
     changeset = Subasta.changeset(subasta, subasta_params)

     case Repo.update(changeset) do
       {:ok, subasta} ->
         render(conn, "show.json", subasta: subasta)
       {:error, changeset} ->
         conn
         |> put_status(:unprocessable_entity)
         |> render(SimpleSubasta.ChangesetView, "error.json", changeset: changeset)
     end
   end

   def delete(conn, %{"id" => id}) do
     subasta = Repo.get!(Subasta, id)

     Repo.delete!(subasta)
     send_resp(conn, :no_content, "")
   end

   def cancelar(conn, %{"subasta_id" => id}) do
    subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)

    if !is_nil(subasta.mejor_oferta) do
      Repo.delete!(subasta.mejor_oferta)
    end

    changeset = Subasta.changeset(subasta, %{terminada: true})

    case Repo.update(changeset) do
      {:ok, subasta} -> GenServer.cast({:global, :subasta_worker}, {:cancela_subasta, subasta.id})
                        render(conn, "show.json", subasta: subasta)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SimpleSubasta.ChangesetView, "error.json", changeset: changeset)
    end
   end

end
