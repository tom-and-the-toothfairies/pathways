process submitTime {
	action get_card {
		provides { timecard.status == blank }
		script { "try Accounting dept. if supervisor doesn't have timecards." }
	}
	task fill_out {
		action enter_pay_period {
			requires { timecard.status == blank }
			provides { timecard.status == ready }
			agent { "employee" }
		}
		action fill_hours {
			requires { timecard.status == ready }
			requires { "record_of_hours" }
			provides { timecard.status == filled }
			agent { "employee" }
		}
		action fill_totals {
			requires { timecard.status == filled }
			requires { "calculator" }
			provides { timecard.status == totaled }
			agent { "employee" }
		}
	}
	task sign {
		action sign_card {
			requires { timecard.status == totaled }
			agent { "employee" }
			script { "sign & date the timecard yourself." }
		}
		action approve_card {
			requires { timecard.status == totaled }
			provides { timecard.status == signed }
			agent { "supervisor" }
			script { "get approval & signature/date from supervisor." }
		}
	}
	action turn_in {
		requires { timecard.status == signed }
		provides { "paycheck" }
		agent { "employee" }
		script { "turn in filled/totaled/signed/countersigned timecard to the Accounting or HR dept." }
	}
}
