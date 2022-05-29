defmodule ExFacturapi.Utils do
  @spec encode_data(map(), fun()) :: binary()
  def encode_data(kv, encoder \\ &to_string/1) do
    IO.iodata_to_binary(encode_pair("", kv, encoder))
  end

  defp encode_pair(field, %{__struct__: struct} = map, encoder) when is_atom(struct) do
    [field, ?= | encode_value(map, encoder)]
  end

  defp encode_pair(parent_field, %{} = map, encoder) do
    encode_kv(map, parent_field, encoder)
  end

  defp encode_pair(parent_field, list, encoder) when is_list(list) and is_tuple(hd(list)) do
    encode_kv(Enum.uniq_by(list, &elem(&1, 0)), parent_field, encoder)
  end

  defp encode_pair(parent_field, list, encoder) when is_list(list) do
    prune(
      Enum.flat_map(list, fn value ->
        [?&, encode_pair(parent_field <> "[]", value, encoder)]
      end)
    )
  end

  defp encode_pair(field, nil, _encoder) do
    [field, ?=]
  end

  defp encode_pair(field, value, encoder) do
    [field, ?= | encode_value(value, encoder)]
  end

  defp encode_kv(kv, parent_field, encoder) do
    prune(
      Enum.flat_map(kv, fn
        {_, value} when value in [%{}, []] ->
          []

        {field, value} ->
          field =
            if parent_field == "" do
              encode_key(field)
            else
              parent_field <> "[" <> encode_key(field) <> "]"
            end

          [?&, encode_pair(field, value, encoder)]
      end)
    )
  end

  defp encode_key(item) do
    item |> to_string |> URI.encode_www_form()
  end

  defp encode_value(item, encoder) do
    item |> encoder.() |> URI.encode_www_form()
  end

  defp prune([?& | t]), do: t
  defp prune([]), do: []
end
