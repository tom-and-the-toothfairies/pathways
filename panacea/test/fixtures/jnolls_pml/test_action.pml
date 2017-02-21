process start_test {
	task one {
	  action test_script {
	    requires {"script"}
  	    script{"this is a script"}
	  }
	}
}
