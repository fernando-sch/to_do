defmodule ToDoWeb.FallbackController do
  use ToDoWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors = traverse_errors(changeset)

    conn
    |> put_status(422)
    |> put_view(json: ToDoWeb.ErrorJSON)
    |> render("422.json", errors: errors)
  end

  defp traverse_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
