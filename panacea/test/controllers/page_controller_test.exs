defmodule Panacea.PageControllerTest do
  use Panacea.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Submit"
  end
end
