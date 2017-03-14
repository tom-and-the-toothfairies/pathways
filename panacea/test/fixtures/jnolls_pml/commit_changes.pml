process commit_change {
  iteration {
    iteration {
      action update_workspace {
	script { "run `cvs update' in workspace." }
      }
      action resolve_conflicts {
	script { 
	  "If any files are preceded by `C' in cvs output, update
	   caused a conflict.  Resolve by looking for strings
	   `<<<<<<<', `=======', and `>>>>>>>' in updated files; these
	   delimit areas of conflict."
	}
      }
      action test_changes {
	script { "Run `make test' in workspace." }
      }
      action fix_failures {
	script { "Fix any failures uncovered by tests." }
      }
    }

    action commit_changes {
      script { "run `cvs commit -m log-message'. " }
    }

    sequence test_integration {
      action login_as_testuser {
	script { "Login to test host as `jntestuser'." }
      }
      action delete_old_workspace {
	script { "Run `cvs release peos; rm -r peos'." }
      }
      action checkout_workspace {
	script { "Run `cvs checkout peos-test'." }
	provides { workspace }
      }
      action run_tests {
	script { "Run `make test' in src/os/kernel, src/ui/web2." }
	requires { workspace }
	provides { workspace.tests == "passed" || workspace.tests == "failed" }
      }
    }
  }
  action complete_commit {
    requires { workspace.tests == "passed" }
    script { "If all tests passed, you are finished.  If not, go back and fix any failures uncovered." }

  }

}
