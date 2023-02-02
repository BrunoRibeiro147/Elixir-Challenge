defmodule Sntx.Blog.Services.DeletePost do
  @moduledoc """
  Service for delete a post
  """

  alias Sntx.Blog.BlogPost
  alias Sntx.Blog.Services.ListOrGetPosts

  @type response :: {:ok, BlogPost.t()} | {:error, Ecto.Changeset.t()}

  @spec execute(user_id :: Ecto.UUID.t(), post_id :: Ecto.UUID.t()) :: response()
  def execute(user_id, post_id) do
    with {:ok, post} <- ListOrGetPosts.execute(post_id),
         true <- post.author_id == user_id do
      post
      |> Sntx.Repo.delete()
    else
      false -> {:error, :no_permissions}
      error -> error
    end
  end
end
