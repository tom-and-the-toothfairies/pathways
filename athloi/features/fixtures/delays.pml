process foo {
  task bar {
    action baz {
      tool { "pills" }
      script { "eat the pills" }
      agent { "patient" }
      requires {
        drug { "torasemide" }
      }
      provides { "a cured patient" }
      requires {
        time {
          minutes { 45 }
        }
      }
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { (intangible)(inscrutable) pml.wtf && ("foo" || 1 != 2) }
      requires {
        drug { "trandolapril" }
      }
      provides { "a cured patient" }
      requires {
        time {
          years { 20 }
          days { 15 }
          hours { 10 }
          minutes { 6 }
        }
      }
    }
  }
}
