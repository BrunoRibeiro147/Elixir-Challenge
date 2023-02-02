defmodule Sntx.Blog.Services.CreatePost do
  @moduledoc """
  Service for create a post 
  """

  @spec execute(params :: map()) :: {:ok, Sntx.Blog.BlogPost.t()} | {:error, Ecto.Changeset.t()}
  def execute(params) do
    params
    |> Sntx.Blog.BlogPost.changeset()
    |> Sntx.Repo.insert()
  end
end
