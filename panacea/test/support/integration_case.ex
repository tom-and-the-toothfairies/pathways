defmodule Panacea.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Panacea.ConnCase
      use PhoenixIntegration
    end
  end

end
