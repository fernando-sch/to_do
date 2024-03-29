defmodule ToDo.Tasks do
  @moduledoc """
    Module with all Task related functions
  """

  alias ToDo.Tasks.Task
  alias ToDo.Repo

  @spec list_tasks() :: list(Task.t())
  def list_tasks, do: Repo.all(Task)

  @spec create_task(map()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def create_task(%{} = attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_task(Ecto.UUID.t()) :: {:ok, Task.t()} | {:error, :not_found | :invalid_id}
  def get_task(task_id) do
    with {:ok, _} <- Repo.cast_id(task_id),
         %Task{} = task <- Repo.get(Task, task_id) do
      {:ok, task}
    else
      nil -> {:error, :not_found}
      {:error, :invalid_id} -> {:error, :invalid_id}
    end
  end

  @spec update_task(Task.t(), map()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def update_task(%Task{} = task, %{} = attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_task(Task.t()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def delete_task(%Task{} = task), do: Repo.delete(task)
end
