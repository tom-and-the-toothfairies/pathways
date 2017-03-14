/* 
 * Test changes committed to CVS.  
 * Initial version, without resource attributes.
 * $ID$
 */
process test_commit {
  iteration {
      action login_as_testuser {
        requires { test_user }
	script { "Login to test host as $test_user." }
      }
      action delete_old_workspace {
        requires { working_dir }
	script { "Run `cvs release $working_dir; rm -r $working_dir." }
      }
      action checkout_workspace {
	script { "Run `cvs checkout $test_module'." }
	provides { working_dir }
      }
      action run_tests {
	script { "Run `make test' in `$working_dir/src' directory." }
	requires { working_dir }
      }
  }
  action update_status_report {
    requires { working_dir }
    script { "If all tests passed, you are finished; add this to your
    list of accomplishments for today.  If not, go back and fix any
    failures uncovered." } 

  }
  action complete_commit {
    requires { working_dir }
    script { "You are finished.  Get a cup of coffee!" }
  }
}
