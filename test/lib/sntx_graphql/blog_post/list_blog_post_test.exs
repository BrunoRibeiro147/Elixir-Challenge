defmodule SntxGraphql.BlogPost.ListBlogPostTest do
  use SntxWeb.ConnCase, async: true
  use Sntx.DataCase, async: true

  @query """
  {
    listPosts {
     id,
     body,
     author {
  	  email,
  	  firstName,
  	  lastName
     }
    }
  }
  """

  describe "list_blog_post" do
    setup do
      %{id: user_id} = insert(:account)
      insert_list(3, :blog_post, %{author_id: user_id})

      %{}
    end

    test "return a list with all posts", %{conn: conn} do
      response =
        conn
        |> graphql(@query)
        |> json_response(200)

      posts = response["data"]["listPosts"]

      assert length(posts) == 3
    end
  end
end
