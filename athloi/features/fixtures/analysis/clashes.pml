process foo {
  action clash1 {
    requires { drug { "paracetamol" } }
  }
  action clash2 {
  }
  action clash2 {
  }
  action clash1 {
  }
}
