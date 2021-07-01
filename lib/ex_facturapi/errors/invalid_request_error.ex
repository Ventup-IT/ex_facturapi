defmodule ExFacturapi.InvalidRequestError do
  defexception type: "invalid_request_error", message: nil, param: nil
end
