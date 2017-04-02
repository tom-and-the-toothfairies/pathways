process parallel_ddis {
  branch {
    action b1 {
      requires { drug { "trandolapril" } }
    }
    action b2 {
      requires { drug { "torasemide" } }
    }
  }
}
