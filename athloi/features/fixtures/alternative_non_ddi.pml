process alternative_non_ddis {
  selection sel1 {
    action s1 {
      requires { drug { "trandolapril" } }
    }
    action s2 {
      requires { drug { "torasemide" } }
    }
  }
}
