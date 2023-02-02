defmodule Sntx.Blog.Services.CreatePostTest do
  use Sntx.DataCase, async: true

  describe "execute/1" do
    setup do
      %{id: user_id} = insert(:account)

      params = %{
        title: Faker.Food.PtBr.dish(),
        body: Faker.Food.PtBr.description(),
        author_id: user_id
      }

      %{params: params}
    end

    test "insert a blog post if all params are valid", %{params: params} do
      assert {:ok, %Sntx.Blog.BlogPost{}} = Sntx.Blog.Services.CreatePost.execute(params)
    end

    test "returns an invalid changeset if all params are invalid", %{params: params} do
      assert {:error, %Ecto.Changeset{valid?: false}} =
               params
               |> Map.drop([:title])
               |> Sntx.Blog.Services.CreatePost.execute()
    end
  end
end
