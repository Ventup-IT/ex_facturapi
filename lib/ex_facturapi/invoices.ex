defmodule ExFacturapi.Invoices do
  use ExFacturapi.CRUD, [:get, :update, :create, :get_all, :delete]

  @spec endpoint() :: String.t()
  def endpoint do
    "/invoices"
  end
end
