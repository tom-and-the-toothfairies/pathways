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
    }
    action baz2 {
      tool { "pills" }
      script { "eat the pills" }
      agent { (intangible)(inscrutable) pml.wtf && ("foo" || 1 != 2) }
      requires {
        drug { "trandolapril" }
      }
      provides { "a cured patient" }
    }
  }
}
