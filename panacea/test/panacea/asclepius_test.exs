defmodule Panacea.AsclepiusTest do
  alias Panacea.Asclepius
  use ExUnit.Case

  setup do
    Asclepius.set_readiness(false)
  end

  describe "ready?" do
    test "defaults to false" do
      refute Asclepius.ready?
    end
  end

  describe "set_readiness" do
    test "updates the readiness" do
      refute Asclepius.ready?

      Asclepius.set_readiness(true)
      assert Asclepius.ready?

      Asclepius.set_readiness(false)
      refute Asclepius.ready?
    end
  end
end
