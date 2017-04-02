defmodule Panacea.Pml.Parser.Error do
  @type error_info :: {pos_integer, atom, iodata}

  @spec format(error_info) :: String.t
  def format({_,_,message}) do
    message
    |> format_message()
    |> to_string()
  end

  defp format_message({:illegal, token}) do
    "unrecognized token '#{token}'"
  end
  defp format_message(message) do
    message
    |> :pml_parser.format_error()
  end
end
