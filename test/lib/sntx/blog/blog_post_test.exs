defmodule Sntx.Blog.BlogPostTest do
  use Sntx.DataCase, async: true
  alias Sntx.Blog.BlogPost

  describe "changeset/2" do
    setup do
      %{id: user_id} = insert(:account)

      params = %{
        title: Faker.Food.PtBr.dish(),
        body: Faker.Food.PtBr.description(),
        author_id: user_id
      }

      %{params: params}
    end

    test "returns a valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = BlogPost.changeset(params)
    end

    test "inserts a blog_post with valid changeset", %{params: params} do
      assert {:ok, %BlogPost{}} =
               params
               |> BlogPost.changeset()
               |> Sntx.Repo.insert()
    end

    for field <- [:title, :body, :author_id] do
      test "returns an invalid changeset if #{field} are missing", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.drop([unquote(field)])
                 |> BlogPost.changeset()
      end
    end

    test "returns an error if try to create a blog with a unexistent author", %{params: params} do
      assert {:error, %Ecto.Changeset{valid?: false}} =
               params
               |> Map.put(:author_id, Ecto.UUID.generate())
               |> BlogPost.changeset()
               |> Sntx.Repo.insert()
    end
  end
end
