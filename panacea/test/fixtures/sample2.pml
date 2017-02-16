process example {
	branch {
		sequence code {
			action edit {
				requires { code.type == module }
				provides { code.status == modified }
			}
			action compile {
				requires { code.status == modified }
				provides { progA.type == executable }
			}
		}
		sequence test {
			action plan {
				requires { dtp.type == test_plan }
				provides { dtp.status == modified }
			}
			action test_code {
				requires { progA }
				provides { progA.status == tested }
			}
		}
	}
	action check_in {
		requires { progA.status == tested }
		provides { code.status == checked_in }
	}
}
