process PSP {
    task PSP_Meta_Action {

	iteration
	{ 

	    action Start_time_to_TRL manual
	    {
		input {"TRL_Line_entry"}
		output {"TRL_Line_entry"}
		agent {"programmer"}
		tool {"HTML"}
		script {"TRL_Instructions"}
	    }


	    action Do_part_of_Action manual
	    {
		input {"'Action'.inputs"}
		output {"'Action'.outputs"}
		agent {"'Action'.agent"}
		tool {"'Action'.tool"}
		script {"'Action'.script"}
	    }

	    action Stop_and_duration_time_to_TRL manual
	    {
		input {"TRL_Line_entry"}
		output {"TRL_Line_entry"}
		agent {"programmer"}
		tool {"HTML"}
		script {"TRL_Instructions" }
 	    }

	}

    }
}








