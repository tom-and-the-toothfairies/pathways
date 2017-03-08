process foo {
  task bar {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "arsenic" }
      }
      provides { "a cured patient" }
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "plutonium" }
      }
      provides { "a cured patient" }
    }
  }
}
