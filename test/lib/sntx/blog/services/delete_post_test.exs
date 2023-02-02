defmodule Sntx.Blog.Services.DeletePostTest do
  use Sntx.DataCase, async: true

  alias Sntx.Blog.BlogPost
  alias Sntx.Blog.Services.DeletePost, as: DeletePostService

  describe "execute/3" do
    setup do
      %{id: user_id} = insert(:account)
      %{id: post_id} = insert(:blog_post, %{author_id: user_id})

      %{user_id: user_id, post_id: post_id}
    end

    test "should delete a post if user is the author", %{
      user_id: user_id,
      post_id: post_id
    } do
      assert {:ok, %BlogPost{}} = DeletePostService.execute(user_id, post_id)
    end

    test "should not delete a post if user is not the author", %{post_id: post_id} do
      assert {:error, :no_permissions} = DeletePostService.execute(Ecto.UUID.generate(), post_id)
    end
  end
end
