process foo {
  task bar {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "marmalade" }
      }
      provides { "a cured patient" }
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "dimethylheptylpyran" }
      }
      provides { "a cured patient" }
    }
  }
}
