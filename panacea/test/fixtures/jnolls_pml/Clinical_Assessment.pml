process Clinical_Assessment {
  iteration {
    iteration {
      action PresentToSpecialistClinician {
	requires { reported_symptoms }
	provides { scheduled_examination }
      }
      action Examine {
	requires { scheduled_examination }
	provides { examination_results }
      }
    }
    action Diagnose {
      requires { examination_results }
      provides { diagnosis }
    }
    action Treat {
      requires { diagnosis }
      provides { treatment }
    }

  }
}
