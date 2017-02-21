/* Example pml process, 
specifying the "Graduate Student Development Process" */

process example {

  task analyze {
    iteration {
      action understand_req executable {
	requires { "req.html" }
	agent { "programmer" }
      }
      action develop_solution manual {
	requires { "req.html" }
	agent { "programmer" }
      }
      action analyze_impact manual {
	requires { "req.html" }
	agent { "programmer" }
      }
    }
  }

  task develop {
    iteration {
      action edit manual {
	requires { "main.c" }
	provides { "main.c" }
	tool { "xedit %s" }
	agent { "programmer" }
      }
      action compile manual {
	requires { "main.c" }
	provides { "hello" }
	tool { "cc %s -o %s" }
	agent { "programmer" }
      }
      action test manual {
	requires { "hello" }
	tool { "exec %s" }
	agent { "programmer" }
      }
      branch {
	action debug manual {
	  requires { "main.c" }
	  requires { "hello" }
	  tool { "xdbx %s" }
	  agent { "programmer" }
	}
      }
    }
    action check_in manual {
      requires { "main.c" }
      tool { "ci %s" }
      agent { "programmer" }
    }
  }
}
