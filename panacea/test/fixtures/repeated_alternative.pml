process repeated_alternative_ddis {
  iteration {
    selection {
      action s1 {
        requires { drug { "trandolapril" } }
      }
      action s2 {
        requires { drug { "torasemide" } }
      }
    }
  }
}
