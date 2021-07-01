defmodule ExFacturapi.Requester do
  @default_api_endpoint "https://www.facturapi.io/v1/"
  @default_http_client HTTPoison

  alias ExFacturapi.{
    APIConnectionError,
    APIError,
    AuthenticationError,
    InvalidRequestError,
    RateLimitError
  }

  @missing_secret_key_error_message """
    Missing Keys, please set them up
  """

  @spec request(atom(), String.t(), map()) :: map()
  def request(action, endpoint, data, body \\ "", headers \\ [])
      when action in [:get, :post, :put, :delete] do
    action
    |> http_client().request(request_url(endpoint, data), body, headers ++ create_headers())
    |> handle_response
  end

  defp http_client do
    Application.get_env(:facturapi, :http_client) ||
      @default_http_client
  end

  defp get_api_endpoint do
    System.get_env("FACTURAPI_ENDPOINT") ||
      Application.get_env(:facturapi, :endpoint) ||
      @default_api_endpoint
  end

  defp request_url(endpoint) do
    Path.join(get_api_endpoint(), endpoint)
  end

  defp request_url(endpoint, []) do
    Path.join(get_api_endpoint(), endpoint)
  end

  defp request_url(endpoint, data) do
    base_url = request_url(endpoint)
    query_params = ExFacturapi.Utils.encode_data(data)
    "#{base_url}?#{query_params}"
  end

  defp create_headers do
    [
      {"Authorization", "Basic #{Base.encode64(get_api_key() <> ":")}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp get_api_key do
    System.get_env("FACTURAPI_USER_KEY") ||
      Application.get_env(:facturapi, :user_key) ||
      raise AuthenticationError, message: @missing_secret_key_error_message
  end

  defp get_api_live_key do
    System.get_env("FACTURAPI_LIVE_KEY") ||
      Application.get_env(:facturapi, :live_key) ||
      raise AuthenticationError, message: @missing_secret_key_error_message
  end

  defp get_api_test_key do
    System.get_env("FACTURAPI_TEST_KEY") ||
      Application.get_env(:facturapi, :test_key) ||
      raise AuthenticationError, message: @missing_secret_key_error_message
  end

  defp get_organization_id do
    System.get_env("FACTURAPI_ORGANIZATION_ID") ||
      Application.get_env(:facturapi, :organization_id) ||
      raise AuthenticationError, message: @missing_secret_key_error_message
  end

  defp handle_response({:ok, %{body: body, status_code: 200}}) do
    {:ok, process_response_body(body)}
  end

  defp handle_response({:ok, %{body: body, status_code: code}}) do
    message =
      error =
      body
      |> process_response_body
      |> Map.fetch!("message")

    error_struct =
      case code do
        code when code in [400, 404] ->
          %InvalidRequestError{message: message, param: error["param"]}

        401 ->
          %AuthenticationError{message: message}

        429 ->
          %RateLimitError{message: message}

        _ ->
          %APIError{message: message}
      end

    {:error, error_struct}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    %APIConnectionError{message: "Network Error: #{reason}"}
  end

  defp process_response_body(body) do
    IO.inspect(Poison.decode!(body))
    Poison.decode!(body)
  end
end
