defmodule ExFacturapi.Receipts do
  use ExFacturapi.CRUD, [:get, :update, :create, :get_all, :delete]

  @spec endpoint() :: String.t()
  def endpoint do
    "/receipts"
  end
end
