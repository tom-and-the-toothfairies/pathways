process foo {
  task bar {
    action baz {
      requires {
        time {
          days { 365 }
        }
      }
    }
  }
}
