process foo {
  task bar {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "paracetamol" }
      }
      provides { "a cured patient" }
    }
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "cocaine" }
      }
      provides { "a cured patient" }
    }
    action bar {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "cocaine" }
      }
      provides { "a cured patient" }
    }
  }
}
