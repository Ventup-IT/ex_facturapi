defmodule ExFacturapi do
  @client_version Mix.Project.config()[:version]

  @spec version() :: String.t()
  def version do
    @client_version
  end
end
