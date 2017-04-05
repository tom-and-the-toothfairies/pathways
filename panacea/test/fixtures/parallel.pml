process parallel_ddis {
  branch br1 {
    action b1 {
      requires { drug { "trandolapril" } }
    }
    action b2 {
      requires { drug { "torasemide" } }
    }
  }
}
