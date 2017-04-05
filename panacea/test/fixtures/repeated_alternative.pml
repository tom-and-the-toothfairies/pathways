process repeated_alternative_ddis {
  iteration it1 {
    selection sel1 {
      action s1 {
        requires { drug { "trandolapril" } }
      }
      action s2 {
        requires { drug { "torasemide" } }
      }
    }
  }
}
