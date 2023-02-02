defmodule SntxGraphql.BlogPost.UpdateBlogPostTest do
  use SntxWeb.ConnCase, async: true
  use Sntx.DataCase, async: true

  setup :logged_conn

  @mutation """
  mutation(
    $id: UUID4!,
    $title: String,
  ) {
      blogPostUpdate(
        id: $id
        input: {
          title: $title,
        }
  ) {
    messages {
      message
      field
    }
    result {
      id,
      title,
      body,
      author {
        email,
      }
    }
   }
  }
  """

  describe "update_blog_post" do
    setup do
      params = %{
        title: Faker.Food.PtBr.dish()
      }

      %{params: params}
    end

    test "should update a post", %{logged_conn: conn, logged_user: user, params: params} do
      %{id: post_id, title: old_title} = insert(:blog_post, %{author_id: user.id})

      response =
        conn
        |> graphql(@mutation, Map.put(params, :id, post_id))
        |> json_response(200)

      response = response["data"]["blogPostUpdate"]["result"]
      %{title: new_title} = params
      %{email: email} = user

      assert %{
               "author" => %{"email" => ^email},
               "body" => _body,
               "id" => ^post_id,
               "title" => ^new_title
             } = response

      assert old_title != new_title
    end

    test "should not update a post when the logged user is not the author", %{logged_conn: conn, params: params} do
      %{id: user_id} = insert(:account)
      %{id: post_id} = insert(:blog_post, %{author_id: user_id})

      response =
        conn
        |> graphql(@mutation, Map.put(params, :id, post_id))
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostUpdate" => %{
                   "messages" => [%{"field" => "base", "message" => "Insufficient permissions"}],
                   "result" => nil
                 }
               }
             } = response
    end

    test "should not update a post when user is not logged", %{conn: conn, params: params} do
      response =
        conn
        |> graphql(@mutation, %{id: Ecto.UUID.generate(), input: params})
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostUpdate" => %{
                   "messages" => [%{"field" => nil, "message" => "You must be logged in to perform this action"}],
                   "result" => nil
                 }
               }
             } = response
    end
  end
end
