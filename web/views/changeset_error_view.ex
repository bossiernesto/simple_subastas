defmodule SimpleSubasta.ChangesetErrorView do
  use SimpleSubasta.Web, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: changeset}
  end
end
