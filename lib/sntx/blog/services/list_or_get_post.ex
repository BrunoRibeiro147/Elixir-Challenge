defmodule Sntx.Blog.Services.ListOrGetPosts do
  @moduledoc """
  Service for list all posts or just one
  """

  alias Sntx.Blog.BlogPost

  @type response :: {:ok, BlogPost.t()} | {:ok, [BlogPost.t()]} | {:ok, []} | {:error, :not_found}

  @spec execute(post_id :: Ecto.UUID.t() | nil) :: response()
  def execute(post_id \\ nil) do
    case post_id do
      nil ->
        BlogPost
        |> Sntx.Repo.all()
        |> Sntx.Repo.preload([:author])
        |> then(fn posts ->
          {:ok, posts}
        end)

      post_id ->
        get_one_post(post_id)
    end
  end

  defp get_one_post(post_id) do
    with {:ok, _uuid} <- Ecto.UUID.cast(post_id),
         post <- Sntx.Repo.get(BlogPost, post_id) |> Sntx.Repo.preload([:author]),
         false <- is_nil(post) do
      {:ok, post}
    else
      _ -> {:error, :no_blog_post}
    end
  end
end
