defmodule PDS.Repo do
  use Ecto.Repo,
    otp_app: :pds,
    adapter: Ecto.Adapters.Postgres
end
