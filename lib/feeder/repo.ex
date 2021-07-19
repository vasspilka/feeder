defmodule Feeder.Repo do
  use Ecto.Repo,
    otp_app: :feeder,
    adapter: Ecto.Adapters.Postgres
end
