process foo {
  task bar {
    action baz {
      requires {
        time {
          days { 28 }
          years { 1 }
          minutes { 10 }
          years { 3 }
          hours { 7 }
        }
      }
    }
  }
}
