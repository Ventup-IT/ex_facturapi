defmodule ExFacturapi.CRUD do
  alias ExFacturapi.Requester

  defmacro __using__(opts) do
    quote do
      if :create in unquote(opts) do
        @spec create(map()) :: map()
        def create(data) do
          Requester.request(:post, endpoint(), data)
        end
      end

      if :get in unquote(opts) do
        @spec get(binary()) :: map()
        def get(id) when is_bitstring(id) do
          resource_url = Path.join(endpoint(), id)
          Requester.request(:get, resource_url, [])
        end
      end

      if :update in unquote(opts) do
        @spec update(binary(), map()) :: map()
        def update(id, data) when is_bitstring(id) do
          resource_url = Path.join(endpoint(), id)
          Requester.request(:put, resource_url, data)
        end
      end

      if :get_all in unquote(opts) do
        @spec get_all(list()) :: map()
        def get_all(pagination_opts \\ []) when is_list(pagination_opts) do
          Requester.request(:get, endpoint(), pagination_opts)
        end
      end

      if :delete in unquote(opts) do
        @spec delete(binary(), map()) :: map()
        def delete(id, data \\ []) when is_bitstring(id) do
          resource_url = Path.join(endpoint(), id)
          Requester.request(:delete, resource_url, data)
        end
      end
    end
  end
end
