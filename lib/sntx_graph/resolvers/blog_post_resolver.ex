defmodule SntxGraph.BlogPostResolver do
  import SntxWeb.Payload
  alias Sntx.Blog.Services
  alias Sntx.Blog.BlogPost

  def create(%{input: input}, %{context: ctx}) do
    with params <- build_create_post_payload(ctx.user.id, input),
         {:ok, %BlogPost{} = post} <- Services.CreatePost.execute(params) do
      {:ok, post}
    else
      error -> mutation_error_payload(error)
    end
  end

  defp build_create_post_payload(user_id, input) do
    input
    |> Map.put(:author_id, user_id)
  end

  def update(%{id: post_id, input: input}, %{context: ctx}) do
    with {:ok, %BlogPost{} = post} <- Services.UpdatePost.execute(ctx.user.id, post_id, input) do
      {:ok, post}
    else
      error -> mutation_error_payload(error)
    end
  end

  def delete(%{id: post_id}, %{context: ctx}) do
    with {:ok, %BlogPost{} = post} <- Services.DeletePost.execute(ctx.user.id, post_id) do
      {:ok, post}
    else
      error -> mutation_error_payload(error)
    end
  end

  def get_post(%{id: post_id}, _) do
    case Services.ListOrGetPosts.execute(post_id) do
      {:ok, post} -> {:ok, post}
      error -> mutation_error_payload(error)
    end
  end

  def list_posts(_, _) do
    Services.ListOrGetPosts.execute()
  end
end
