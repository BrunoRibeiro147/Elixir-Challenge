defmodule SntxGraph.BlogPostQueries do
  use Absinthe.Schema.Notation

  alias SntxGraph.BlogPostResolver

  object :blog_post_queries do
    field :get_post, :blog_post do
      arg :id, non_null(:uuid4)

      resolve(&BlogPostResolver.get_post/2)
    end

    field :list_posts, list_of(:blog_post) do
      resolve(&BlogPostResolver.list_posts/2)
    end
  end
end
