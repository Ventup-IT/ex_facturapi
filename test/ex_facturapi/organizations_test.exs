defmodule ExFacturapi.OrganizationsTest do
  use ExUnit.Case, async: true

  test "returns a organization list" do
    {status, _response} = ExFacturapi.Organizations.list()

    assert status == :ok
  end
end
