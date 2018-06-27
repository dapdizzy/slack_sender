defmodule SlackSenderWeb.Router do
  use SlackSenderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlackSenderWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", SlackSenderWeb do
    pipe_through :api

    post "/slack_sender", SlackSenderController, :send
    post "/slack_receiver", SlackSenderController, :receive
    post "/supervisor_registration", SlackSenderController, :register

  end
end
