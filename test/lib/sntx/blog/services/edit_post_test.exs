defmodule Sntx.Blog.Services.UpdatePostTest do
  use Sntx.DataCase, async: true

  alias Sntx.Blog.BlogPost
  alias Sntx.Blog.Services.UpdatePost, as: UpdatePostService

  describe "execute/3" do
    setup do
      %{id: user_id} = insert(:account)
      %{id: post_id, body: old_body} = insert(:blog_post, %{author_id: user_id})

      params = %{
        body: Faker.Food.PtBr.ingredient()
      }

      %{user_id: user_id, post_id: post_id, old_body: old_body, params: params}
    end

    test "should update a post if user is the author", %{
      user_id: user_id,
      post_id: post_id,
      old_body: old_body,
      params: %{body: new_body} = params
    } do
      assert {:ok, %BlogPost{body: ^new_body}} = UpdatePostService.execute(user_id, post_id, params)

      assert old_body != new_body
    end

    test "should not update a post if user is not the author", %{post_id: post_id, params: params} do
      assert {:error, :no_permissions} = UpdatePostService.execute(Ecto.UUID.generate(), post_id, params)
    end
  end
end
