defmodule PDS.XRPC.Router do
  use PDS.XRPC, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PDS.XRPC do
    pipe_through [:api]
    get "/", APIController, :query
    post "/", APIController, :procedure
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:pds, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
