process foo {
  task {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "paracetamol" }
      }
      provides { "a cured patient" }
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "cocaine" }
      }
      provides { "a cured patient" }
    }
    action baz2{
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      provides { "a cured patient" }
    }

    action baz{
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      provides { "a cured patient" }
    }
  }
}
