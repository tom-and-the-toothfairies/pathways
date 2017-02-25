process seq {
  task br {
/*
    action z manual {
      requires {"R.html"}
      provides {"R.html"}
    }
*/
    iteration it {

      action a manual {
	requires {"R.html"}
	provides {"R.html"}
      }

      selection aSelection {

	action b manual {
	  requires {"R.html"}
	  provides {"R.html"}
	}

	action c manual {
	  requires {"R.html"}
	  provides {"R.html"}
	}

      }
/*
      action d manual {
	requires {"R.html"}
	provides {"R.html"}
      }
*/
    }
  }
}




