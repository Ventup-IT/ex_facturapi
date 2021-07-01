# ExFacturapi

ExFacturAPI is a library to access to the FacturAPI API.

## Installation

```elixir
def deps do
  [
    {:ex_facturapi, "~> 0.1.0"}
  ]
end
```

## Usage Examples

```elixir

## List all organizations

iex> ExFacturapi.Organizations.list()

## Retrieve an organization

iex> ExFacturapi.Organizations.retrieve("organization-id")

## Create an organization

iex> ExFacturapi.Organizations.create(%{name: "skynet"})

## Get Organization API keys

iex> ExFacturapi.Organizations.api_keys("organization-id")

## Update Organization fiscal information

iex> ExFacturapi.Organizations.legal("organization-id", 
  %{
    name: "SkyNet", 
    legal_name: "Skynet Inc.", 
    tax_system: "601", 
    website: "https://sky.net", 
    phone: "555-5555", 
    address: %{
      exterior: "10-b", 
      interior: "200A", 
      zip: "12224", 
      street: "Bearoso st", 
      neighborhood: "Palm Spring", 
      city: "Los Angeles", 
      municipality: "L.A.", 
      state: "CA", 
      country: "USA"
    }
  })
```
