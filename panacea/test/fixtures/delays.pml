process foo {
  task bar {
    action baz {
      requires {
        time {
          days { 364 }
          years { 1 }
          minutes { 10 }
          hours { 7 }
        }
      }
    }
    action baz2 {
      requires {
        time {
          hours { 3 }
          days { 2 }
        }
      }
    }
  }
  action baz3 {
    requires {
      time {
        minutes { 59 }
      }
    }
  }
  action baz4 {
    requires {
      time {
        years { 99 }
      }
    }
  }
  action baz5 {
    requires {
      time {
        hours { 23 }
      }
    }
  }
  action baz6 {
    requires {
      time {
        days { 364 }
      }
    }
  }
}
