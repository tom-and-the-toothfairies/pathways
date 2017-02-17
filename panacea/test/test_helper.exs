formatters = [ExUnit.CLIFormatter]

if System.get_env("CI") do
  ExUnit.start formatters: [JUnitFormatter|formatters]
else
  ExUnit.start formatters: formatters
end

ExUnit.start

