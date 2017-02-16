process test_branch {
  task t1 {
    iteration {
      branch {
	action A manual {
	  requires {"R.html"}
	  provides {"R.html"}
	  agent {"ed"}
	  tool {"hammer"}
	}
	action B manual {
	  requires {"R.html"}
	  provides {"R.html"}
	  agent {"ed"}
	  tool {"hammer"}
	}
	action C manual {
	  requires {"R.html"}
	  provides {"R.html"}
	  agent {"ed"}
	  tool {"hammer"}
	}
      }
    }
  }
}

