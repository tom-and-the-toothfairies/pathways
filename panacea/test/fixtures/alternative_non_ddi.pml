process alternative_non_ddis {
  selection {
    action s1 {
      requires { drug { "trandolapril" } }
    }
    action s2 {
      requires { drug { "torasemide" } }
    }
  }
}
