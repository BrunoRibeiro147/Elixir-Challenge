defmodule SntxGraphql.BlogPost.DeleteBlogPostTest do
  use SntxWeb.ConnCase, async: true
  use Sntx.DataCase, async: true

  setup :logged_conn

  @mutation """
  mutation(
    $id: UUID4!,
  ) {
      blogPostDelete(
        id: $id
  ) {
    messages {
      message
      field
    }
    result {
      id
    },
    successful
   }
  }
  """

  describe "delete_blog_post" do
    test "should delete a post", %{logged_conn: conn, logged_user: user} do
      %{id: post_id} = insert(:blog_post, %{author_id: user.id})

      response =
        conn
        |> graphql(@mutation, %{id: post_id})
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostDelete" => %{
                   "messages" => [],
                   "result" => %{"id" => ^post_id},
                   "successful" => true
                 }
               }
             } = response
    end

    test "should not delete a post when the logged user is not the author", %{logged_conn: conn} do
      %{id: user_id} = insert(:account)
      %{id: post_id} = insert(:blog_post, %{author_id: user_id})

      response =
        conn
        |> graphql(@mutation, %{id: post_id})
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostDelete" => %{
                   "messages" => [%{"field" => "base", "message" => "Insufficient permissions"}],
                   "result" => nil
                 }
               }
             } = response
    end

    test "should not delete a post when user is not logged", %{conn: conn} do
      response =
        conn
        |> graphql(@mutation, %{id: Ecto.UUID.generate()})
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostDelete" => %{
                   "messages" => [%{"field" => nil, "message" => "You must be logged in to perform this action"}],
                   "result" => nil
                 }
               }
             } = response
    end
  end
end
