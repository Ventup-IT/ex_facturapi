defmodule ExFacturapi.OrganizationsTest do
  use ExUnit.Case, async: true

  describe "List organizations" do
    test "return :ok" do
      Application.put_env(:facturapi, :http_client, FacturAPI.Organizations.List.Ok)
      {status, _response} = ExFacturapi.Organizations.list()

      assert status == :ok
    end

    test "returns :error" do
      Application.put_env(:facturapi, :http_client, FacturAPI.Organizations.List.Error)
      {status, _response} = ExFacturapi.Organizations.list()

      assert status == :error
    end
  end
end
