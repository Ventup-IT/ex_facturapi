defmodule FacturAPI.Organizations.List do
  defmodule Ok do
    def request(_action, _url, _params, _headers) do
      {
        :ok,
        %{
          body: """
            {
            "data": [
              {
                "certificate": {
                  "expires_at": "2023-05-29T18:11:48.000Z",
                  "has_certificate": true,
                  "updated_at": "2021-07-02T14:12:21.830Z"
                },
                "completion_level": 31,
                "created_at": "2021-07-02T14:12:18.367Z",
                "customization": {
                  "color": "75A4FF",
                  "has_logo": true,
                  "next_folio_number": 2,
                  "pdf_extra": {"codes": true, "product_key": true}
                },
                "id": "60df1ec20123c3001b851b04",
                "is_production_ready": true,
                "legal": {
                  "address": {
                    "city": "Ciudad Santa Catarina",
                    "country": "MEX",
                    "exterior": "399",
                    "interior": "t3 1602",
                    "municipality": "Santa Catarina",
                    "neighborhood": null,
                    "neighborhood_code": "",
                    "state": "Aguascalientes",
                    "street": "Ave. Miguel Aleman",
                    "zip": "66354"
                  },
                  "legal_name": "Casa",
                  "name": "Departamento",
                  "phone": "8120001311",
                  "tax_id": "XAMA620210DQ5",
                  "tax_system": "612",
                  "website": null
                },
                "logo_url": "https://storage.googleapis.com/cdn.facturapi.io/organization/e2eef1a4c624e931eb7a9a861fb17d22d2fbea64/logo.jpg",
                "pending_steps": [],
                "receipts": {
                  "ask_address": "optional",
                  "duration_days": 0,
                  "invoicing_period": "month",
                  "next_folio_number": 1
                }
              }
            ],
            "page": 1,
            "total_pages": 1,
            "total_results": 1
            }
          """,
          status_code: 200
        }
      }
    end
  end

  defmodule Error do
    def request(_action, _url, _params, _headers) do
      {
        :error,
        %HTTPoison.Error{reason: "Failed to connect"}
      }
    end
  end
end
