defmodule Panacea.Asclepius.Remote.HTTP do
  @behaviour Panacea.Asclepius.Remote

  @asclepius_uri Keyword.get(Application.get_env(:panacea, :asclepius), :uri)
  @ping_timeout 50
  # one minute timeout for now
  @ddi_timeout 60 * 1000
  @default_headers [{"Content-Type", "application/json"}]

  def ping do
    asclepius_uri("/ping")
    |> HTTPoison.get([recv_timeout: @ping_timeout])
    |> decode_response()
  end

  def ddis(drugs) do
    {:ok, body} = %{drugs: drugs} |> Poison.encode
    asclepius_uri("/ddis")
    |> HTTPoison.post(body, @default_headers, [recv_timeout: @ddi_timeout])
    |> decode_response()
  end

  defp asclepius_uri(path) do
    URI.merge(@asclepius_uri, path) |> to_string()
  end

  defp decode_response({:ok, %HTTPoison.Response{status_code: code} = response}) when code in 200..299 do
    body = decode_body(response.body)
    {:ok, body}
  end
  defp decode_response({:ok, %HTTPoison.Response{} = response}) do
    body = decode_body(response.body)
    {:error, {:asclepius_error, response.status_code, body}}
  end
  defp decode_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, {:network_error, reason}}
  end

  defp decode_body(body) do
    case Poison.decode(body) do
      {:ok, data} ->
        data
      _ ->
        %{}
    end
  end
end
