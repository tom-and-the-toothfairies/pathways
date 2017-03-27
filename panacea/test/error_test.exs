defmodule Panacea.Web.ErrorTest do
  use ExUnit.Case
  alias Panacea.Web.Error

  describe "from_reason/1" do
    test "it generates a nice error" do
      assert {:invalid_data, "foo", %{line: 10}} |> Error.from_reason ==
        %Error{
          status_code: :unprocessable_entity,
          title: "Invalid data",
          detail: "foo",
          meta: %{line: 10}
        }
    end

    test "meta defaults to an empty map when no metadata is provided" do
      assert {:invalid_data, "foo"} |> Error.from_reason ==
        %Error{
          status_code: :unprocessable_entity,
          title: "Invalid data",
          detail: "foo",
          meta: %{}
        }
    end
  end

  describe "title/1" do
    test "it converts the atom to a sentence" do
      assert Error.title(:encoding_error) == "Encoding error"
    end
  end

  describe "status_code/1" do
    test "it returns :internal_server_error for unknown error types" do
      assert Error.status_code(:foo) == :internal_server_error
    end

    test "it returns the correct code for known error types" do
      assert Error.status_code(:invalid_data) == :unprocessable_entity
      assert Error.status_code(:encoding_error) == :unprocessable_entity
      assert Error.status_code(:syntax_error) == :unprocessable_entity
      assert Error.status_code(:asclepius_error) == :internal_server_error
      assert Error.status_code(:network_error) == :internal_server_error
    end
  end
end
