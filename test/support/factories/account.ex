defmodule Sntx.Factories.Account do
  @moduledoc false

  use ExMachina.Ecto, repo: Sntx.Repo

  alias Sntx.User.Account

  defmacro __using__(_opts) do
    quote do
      def account_factory do
        %Account{
          id: Ecto.UUID.generate(),
          email: Faker.Internet.email(),
          password_hash: Faker.String.base64(),
          confirmed_at: DateTime.utc_now()
        }
      end
    end
  end
end
