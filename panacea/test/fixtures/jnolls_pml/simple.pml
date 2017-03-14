process simple {
  action a {
    requires { foo }
    provides { foo } 
  }
  action b {
    requires { foo }
    provides { bar } 
  }
}  
