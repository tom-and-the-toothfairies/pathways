/* Simple process to smoke test kernel. */
process simple {
    action a {
	requires { a }
	provides { a }
    }
    action b {
	requires { a }
	provides { a }
    }
    action c {
	requires { a }
	provides { a }
    }
}
