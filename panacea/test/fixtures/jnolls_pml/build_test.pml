 process build_test {
     action compile {
          requires { code }
          provides { code.compiles == "true" }
     }
     action test {
          requires { code.compiles == "true" }
          provides { test_report }
     }
 }
