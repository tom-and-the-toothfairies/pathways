defmodule Panacea.Web.Error do
  defstruct [:status_code, :title, :detail, :meta]
  alias __MODULE__

  def from_reason({type, message}) do
    %Error{
      status_code: status_code(type),
      title: title(type),
      detail: message,
      meta: meta(type, message)
    }
  end

  @status_codes %{
    invalid_data: :unprocessable_entity,
    encoding_error: :unprocessable_entity,
    syntax_error: :unprocessable_entity,
    asclepius_error: :internal_server_error,
    network_error: :internal_server_error
  }

  def status_code(reason) do
    Map.get(@status_codes, reason, :internal_server_error)
  end

  def title(reason) do
    reason
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  def meta(_, _), do: %{}
end
