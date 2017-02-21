defmodule Panacea.Pml.Parser.Error do
  @type error_info :: {pos_integer, atom, iodata}


  @spec format(error_info) :: String.t
  def format({number,_,message}) do
    [
      "line ",
      format_line_number(number),
      " -- ",
      format_message(message)
    ]
    |> IO.chardata_to_string()
  end

  defp format_line_number(number), do: Integer.to_string(number)

  defp format_message({:illegal, token}), do: ["unrecognized token '", token, "'"]
  defp format_message(message) do
    message
    |> :pml_parser.format_error
  end
end
