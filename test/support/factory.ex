defmodule Sntx.Factory do
  @moduledoc """
  Sntx application factories (ExMachina)
  """

  use ExMachina.Ecto, repo: Sntx.Repo
  use Sntx.Factories.Account
  use Sntx.Factories.BlogPost
end
