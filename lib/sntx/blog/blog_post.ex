defmodule Sntx.Blog.BlogPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sntx.User.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t :: %__MODULE__{}

  @required [:title, :body, :author_id]
  @optional []

  schema "blog_post" do
    field :title, :string
    field :body, :string

    belongs_to :author, Account

    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> foreign_key_constraint(:author_id)
  end
end
