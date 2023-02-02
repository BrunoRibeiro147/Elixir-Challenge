defmodule SntxGraph.BlogPostTypes do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  payload_object(:blog_post_payload, :blog_post)

  input_object :blog_post_input do
    field :title, :string
    field :body, :string
  end

  object :author do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :avatar, :string
  end

  object :blog_post do
    field :id, :uuid4
    field :title, :string
    field :body, :string
    field :author, :author
  end
end
