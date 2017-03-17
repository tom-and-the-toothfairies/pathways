process develop {
	iteration {
		action edit manual {
			requires { code.type == module }
			provides { code.status == modified }
		}
		action compile manual {
			requires { code.status == modified }
			provides { progA.type == "executable "}
		}
		action test manual {
			requires { progA }
			provides { progA.status == tested }
		}	
		selection {
			action debug manual {
				requires { progA.status == tested }
				provides { progA.status == debugged }
			}
			action check_in manual {
				requires { progA.status == tested }
				provides { progA.status == checked_in }
			}
		}
	}
}
