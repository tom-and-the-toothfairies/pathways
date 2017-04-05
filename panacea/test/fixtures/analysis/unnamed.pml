process foo {
  task {
    action boo {
      requires { drug { "paracetamol" } }
    }
  }
}
