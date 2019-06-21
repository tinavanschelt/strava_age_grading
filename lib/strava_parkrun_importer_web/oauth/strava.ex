defmodule Strava do
  @moduledoc """
  An OAuth2 strategy for Strava.
  """
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  # defp config do
  #   [
  #     strategy: Strava,
  #     site: "https://developers.strava.com",
  #     authorize_url: "https://strava.com/oauth2/authorize",
  #     token_url: "https://www.strava.com/oauth/token"
  #   ]
  # end

  # Public API

  # def client do
  #   Application.get_env(:oauth2_example, Strava)
  #   |> Keyword.merge(config())
  #   |> OAuth2.Client.new()
  # end
  def client do
    OAuth2.new(
      strategy: __MODULE__,
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      redirect_uri: System.get_env("REDIRECT_URI"),
      site: "https://developers.strava.com",
      authorize_url: "https://strava.com/oauth2/authorize",
      token_url: "https://www.strava.com/oauth/token"
    )
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(
      client(),
      Keyword.merge(params, client_secret: client().client_secret)
    )
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> put_header(
      "Authorization",
      "Basic " <>
        Base.encode64(System.get_env("CLIENT_ID") <> ":" <> System.get_env("CLIENT_SECRET"))
    )
    |> AuthCode.get_token(params, headers)
  end
end
