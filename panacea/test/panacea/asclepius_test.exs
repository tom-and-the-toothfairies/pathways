defmodule Panacea.AsclepiusTest do
  alias Panacea.Asclepius
  use ExUnit.Case, async: true

  describe "ready?" do
    test "defaults to false" do
      Asclepius.start_link

      refute Asclepius.ready?
    end
  end

  describe "set_readiness" do
    test "updates the readiness" do
      Asclepius.start_link
      refute Asclepius.ready?

      Asclepius.set_readiness(true)
      assert Asclepius.ready?

      Asclepius.set_readiness(false)
      refute Asclepius.ready?
    end
  end
end
