defmodule Sntx.Blog.Services.ListOrGetPostsTest do
  use Sntx.DataCase, async: true

  alias Sntx.Blog.BlogPost
  alias Sntx.Blog.Services.ListOrGetPosts

  describe "execute/1" do
    setup do
      %{id: user_id} = insert(:account)
      %{id: post_id} = insert(:blog_post, %{author_id: user_id})

      insert_list(2, :blog_post, %{author_id: user_id})

      %{id: post_id}
    end

    test "returns an list of BlogPost when no params are pass" do
      assert {:ok, [%BlogPost{}, %BlogPost{}, %BlogPost{}]} = ListOrGetPosts.execute()
    end

    test "return a BlogPost when the post_id is pass", %{id: post_id} do
      assert {:ok, %BlogPost{id: ^post_id}} = ListOrGetPosts.execute(post_id)
    end

    test "returns an error if post_id does not exist" do
      assert {:error, :no_blog_post} = ListOrGetPosts.execute(Ecto.UUID.generate())
    end

    test "returns an error if post_id is not a uuid" do
      assert {:error, :no_blog_post} = ListOrGetPosts.execute("test")
    end
  end
end
