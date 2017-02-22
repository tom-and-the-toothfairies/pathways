process eggs {
	action add_oil {
		requires {"oil"}
		requires {"pan"}
		provides {"pan"}
		agent {"user"}
	}
	action add_egg {
		requires {"egg"}
		requires {"pan"}
		provides {"pan"}
		agent {"user"}
	}
	action scramble {
		requires {"fork"}
		requires {"pan"}
		provides {"pan"}
		agent {"user"}
	}
	action serve_egg {
		requires {"pan"}
		requires {"plate"}
		provides {"plate"}
		agent {"user"}
	}
}
