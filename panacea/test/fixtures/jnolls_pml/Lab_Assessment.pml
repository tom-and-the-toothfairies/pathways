process Lab_Assessment{
	action PresentToSpecialistLab {
		requires { symptoms }
		provides { test_plan }
	}
	action PrepareTests {
		requires { test_plan }
		provides { test_suite }
	}
	action RunTests {
		requires { test_suite && examination_results
			&& diagnosis }
		provides { diagnosis.status == "tested" }
	}
}
