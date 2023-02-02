defmodule Sntx.Blog.Services.UpdatePost do
  @moduledoc """
  Service for edit a post
  """

  alias Sntx.Blog.BlogPost
  alias Sntx.Blog.Services.ListOrGetPosts

  @type response :: {:ok, BlogPost.t()} | {:error, Ecto.Changeset.t()}

  @spec execute(user_id :: Ecto.UUID.t(), post_id :: Ecto.UUID.t(), params :: map()) :: response()
  def execute(user_id, post_id, params) do
    with {:ok, post} <- ListOrGetPosts.execute(post_id),
         true <- post.author_id == user_id do
      post
      |> BlogPost.changeset(params)
      |> Sntx.Repo.update()
    else
      false -> {:error, :no_permissions}
      error -> error
    end
  end
end
