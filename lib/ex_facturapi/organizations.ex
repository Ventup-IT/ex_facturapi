defmodule ExFacturapi.Organizations do
  alias ExFacturapi.Requester
  use ExFacturapi.CRUD, [:get, :update, :create, :get_all, :delete]

  @spec endpoint() :: String.t()
  def endpoint do
    "/organizations"
  end

  @spec api_keys(binary()) :: map()
  def api_keys(id) do
    resource_url = Path.join([endpoint(), id, "apikeys"])
    Requester.request(:get, resource_url, [])
  end

  @spec legal(binary(), map()) :: map()
  def legal(id, data) do
    resource_url = Path.join([endpoint(), id, "legal"])
    Requester.request(:put, resource_url, data)
  end

  @spec certificates(binary(), map()) :: map()
  def certificates(id, data) do
    resource_url = Path.join([endpoint(), id, "certificate"])

    multipart =
      {:multipart,
       [
         {:file, data[:cer],
          {"form-data", [name: "filedata", filename: Path.basename(data[:cer])]}, []},
         {:file, data[:key],
          {"form-data", [name: "filedata", filename: Path.basename(data[:cer])]}, []}
       ]}

    Requester.request(:put, resource_url, %{password: data[:password]}, multipart, [
      {"Content-Type", "multipart/form-data"}
    ])
  end
end
