defmodule SntxGraphql.BlogPost.GetBlogPostTest do
  use SntxWeb.ConnCase, async: true
  use Sntx.DataCase, async: true

  @query """
  query (
    $id: UUID4!
  ){
    getPost(id: $id) {
     id,
     body,
     title
     author {
  	  email
     }
   }
  }
  """

  describe "get_blog_post" do
    setup do
      %{id: user_id} = insert(:account)
      %{id: post_id} = post = insert(:blog_post, %{author_id: user_id})

      %{id: post_id, post: post}
    end

    test "return a blog post if id exist", %{conn: conn, id: post_id, post: post} do
      response =
        conn
        |> graphql(@query, %{id: post_id})
        |> json_response(200)

      %{body: body, title: title} = post

      assert %{
               "data" => %{
                 "getPost" => %{
                   "author" => _email,
                   "body" => ^body,
                   "id" => ^post_id,
                   "title" => ^title
                 }
               }
             } = response
    end
  end
end
