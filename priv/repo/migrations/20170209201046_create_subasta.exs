defmodule SimpleSubasta.Repo.Migrations.CreateSubasta do
  use Ecto.Migration

  def change do
    create table(:subastas) do
      add :titulo, :string
      add :vendedor, :string
      add :precio_base, :float
      add :duracion, :integer
      add :terminada, :boolean

      timestamps
    end
  end
end
