defmodule Sntx.Repo.Migrations.CreateBlogPostTable do
  use Ecto.Migration

  def change do
    create table(:blog_post, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :string
      add :author_id, references("user_accounts", type: :binary_id)

      timestamps()
    end
  end
end
