defmodule SntxGraphql.BlogPost.CreateBlogPostTest do
  use SntxWeb.ConnCase, async: true
  use Sntx.DataCase, async: true

  setup :logged_conn

  @mutation """
  mutation(
    $title: String,
    $body: String
  ) {
      blogPostCreate(
        input: {
          title: $title,
          body: $body,
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

  describe "create_blog_post" do
    setup do
      params = %{
        title: Faker.Food.PtBr.dish(),
        body: Faker.Food.PtBr.description()
      }

      %{params: params}
    end

    test "should create a new post", %{logged_conn: conn, params: params} do
      response =
        conn
        |> graphql(@mutation, params)
        |> json_response(200)

      response = response["data"]["blogPostCreate"]["result"]
      %{title: title, body: body} = params

      assert %{
               "author" => %{"email" => nil},
               "id" => post_id,
               "title" => ^title,
               "body" => ^body
             } = response

      assert %Sntx.Blog.BlogPost{id: ^post_id} = Sntx.Repo.get(Sntx.Blog.BlogPost, post_id)
    end

    test "should not create a post when user is not logged", %{conn: conn, params: params} do
      response =
        conn
        |> graphql(@mutation, params)
        |> json_response(200)

      assert %{
               "data" => %{
                 "blogPostCreate" => %{
                   "messages" => [%{"field" => nil, "message" => "You must be logged in to perform this action"}],
                   "result" => nil
                 }
               }
             } = response
    end
  end
end
