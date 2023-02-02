defmodule Sntx.Factories.BlogPost do
  @moduledoc false

  use ExMachina.Ecto, repo: Sntx.Repo

  alias Sntx.Blog.BlogPost

  defmacro __using__(_opts) do
    quote do
      def blog_post_factory do
        %BlogPost{
          id: Ecto.UUID.generate(),
          title: Faker.Food.PtBr.dish(),
          body: Faker.Food.PtBr.description(),
          author_id: Ecto.UUID.generate()
        }
      end
    end
  end
end
