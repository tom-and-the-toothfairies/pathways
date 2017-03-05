process foo {
  task bar {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires { "chebi:9342" }
      provides { "a cured patient" }
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires { "dinto:DB00503" }
      provides { "a cured patient" }
    }
    action baz3 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires { "chebi:465284" }
      provides { "a cured patient" }
    }
    action baz4 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires { "chebi:421707" }
      provides { "a cured patient" }
    }
  }
}
