defmodule ExFacturapi.Requester do
  @default_api_endpoint "https://www.facturapi.io/v1/"
  @default_http_client HTTPoison
  @missing_secret_key_error_message """
    Missing Keys, please set them up
  """

  alias ExFacturapi.APIConnectionError
  alias ExFacturapi.APIError
  alias ExFacturapi.AuthenticationError
  alias ExFacturapi.InvalidRequestError
  alias ExFacturapi.RateLimitError

  @spec request(atom(), String.t(), map()) :: map()
  def request(action, endpoint, data, body \\ "", headers \\ [])
      when action in [:get, :post, :put, :delete] do
    action
    |> http_client().request(request_url(endpoint, data), body, headers ++ headers())
    |> handle_response
  end

  defp http_client,
    do:
      Application.get_env(:facturapi, :http_client) ||
        @default_http_client

  defp get_api_endpoint,
    do:
      System.get_env("FACTURAPI_ENDPOINT") ||
        Application.get_env(:facturapi, :endpoint) ||
        @default_api_endpoint

  defp request_url(endpoint), do: Path.join(get_api_endpoint(), endpoint)

  defp request_url(endpoint, []), do: Path.join(get_api_endpoint(), endpoint)

  defp request_url(endpoint, data) do
    base_url = request_url(endpoint)
    query_params = ExFacturapi.Utils.encode_data(data)
    "#{base_url}?#{query_params}"
  end

  defp headers,
    do: [
      {"Authorization", "Basic #{Base.encode64(get_api_key() <> ":")}"},
      {"Content-Type", "application/json"}
    ]

  defp get_api_key,
    do:
      System.get_env("FACTURAPI_USER_KEY") ||
        Application.get_env(:facturapi, :user_key) ||
        raise(AuthenticationError, message: @missing_secret_key_error_message)

  defp get_api_live_key,
    do:
      System.get_env("FACTURAPI_LIVE_KEY") ||
        Application.get_env(:facturapi, :live_key) ||
        raise(AuthenticationError, message: @missing_secret_key_error_message)

  defp get_api_test_key,
    do:
      System.get_env("FACTURAPI_TEST_KEY") ||
        Application.get_env(:facturapi, :test_key) ||
        raise(AuthenticationError, message: @missing_secret_key_error_message)

  defp get_organization_id,
    do:
      System.get_env("FACTURAPI_ORGANIZATION_ID") ||
        Application.get_env(:facturapi, :organization_id) ||
        raise(AuthenticationError, message: @missing_secret_key_error_message)

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}),
    do: {:error, %APIConnectionError{message: "Network Error: #{reason}"}}

  defp handle_response({:ok, %{body: body, status_code: 200}}),
    do: {:ok, process_response_body(body)}

  defp handle_response({:ok, %{body: body, status_code: code}}) do
    message =
      error =
      body
      |> process_response_body
      |> Map.fetch!("message")

    error_struct = get_error_struct(code, message, error["param"])

    {:error, error_struct}
  end

  defp get_error_struct(400, param, message),
    do: %InvalidRequestError{message: message, param: param}

  defp get_error_struct(401, _param, message),
    do: %AuthenticationError{message: message}

  defp get_error_struct(404, param, message),
    do: %InvalidRequestError{message: message, param: param}

  defp get_error_struct(429, _param, message),
    do: %RateLimitError{message: message}

  defp get_error_struct(_, _param, message), do: %APIError{message: message}

  defp process_response_body(body) do
    Poison.decode!(body)
  end
end
