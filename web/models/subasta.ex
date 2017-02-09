defmodule SimpleSubasta.Subasta do
  use SimpleSubasta.Web, :model

  schema "subastas" do
    field :titulo,      :string
    field :vendedor,    :string
    field :precio_base, :float
    field :duracion,    :integer
    field :terminada,   :boolean, default: false
    has_one :mejor_oferta, SimpleSubasta.Oferta

    timestamps
  end

  @required_fields ~w(titulo precio_base duracion terminada vendedor)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
