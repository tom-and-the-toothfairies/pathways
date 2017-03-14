process Diabetes_Review {
    action review_progress_of_all_diabeties_patients {
	requires {Guidelines_for_Diabetes}
	requires {patient_record.diabetes_symptoms == "true"}
    }	
    iteration {
	action review_patient_diabetes {
	    agent {GP}
	    requires {patient_record.diabetes_symptoms == "true"}
	}
	action send_AutoText_to_patient { 
	    requires {patient_appointment.invitation == "accept"} 
	    provides {patient_appointment.arrangement} 
	} 
	action patient_appointment {
	    requires {patient_appointment.attend == "true"}
	    provides {blood_sample}
	}
	action transport_blood_sample {
	    agent {courier}
	    requires {patient.blood_sample}
	    provides {safe_transportation_of_blood_sample}
	}
	action take_blood_sample {
	    agent {medical_scientist}
	    requires {patient.blood_sample}
	    provides {analysis_of_blood_sample}
	}
	branch{
	    action analyse_blood_sample {
		agent {centrifugation_machine}
		agent {medical_scientist}
		requires {patient.blood_sample}
		provides {blood_sample.analytics}
	    }

	    action authorise_blood_sample {
		agent {medical_scientist}
		agent {principal_biochemist}
		requires {patient.blood_sample}
		provides {blood_sample.authorisation}

	    } 
	    action take_blood_sample{
		agent {GP}
		requires {patient.blood_sample}
		provides {blood_sample.biometric_analysis}
		provides {info_on_blood_sample}
		provides {consultation_on_blood_sample}
		provides {informs_decision_on_need_for_blood_pressure_test}
	    } 
	    
	    action arrange_patient_appointment{
		agent {receptionist}
		requires {patient_record}
		provides {patient_appointment.arrangement}
	    }
	    
	    action patient_appointment {
		agent {patient}
		requires {patient_appointment.attend == "true"}
		provides {patient_progress_review}
	    }		
	    action assessment_of_patient_blood_test_results {
		agent {Community_Nurse && patient}
		requires {blood_sample.biometric_analysis}
		provides {information_on_blood_sample}
	    }
	    action consult_with_patient {
		requires {blood_sample.results}
		provides {advice_on_psychosocial_self_monitoring}
		provides {consultation_on_weight_management}
		provides {consultation_on_exercise}
		provides {consultation_on_self_management}
	    }
	    action update_patient_record {
		requires {Patient_Record}
		provides {Patient_Record.update}
	    }
	    action patient_lifestyle_consultation {
		agent {dietician && patient}
		requires {blood_sample.results}
		provides {information_to_guide_consultation}
	    }
	    action setting_goals {
		requires {tangible_milestones_for_patient}
		provides {self_management_plan_for_patient}
		
	    }
	    action take_blood_sample {
		agent {phlebotomist && patient}
		requires {blood_sample}
		provides {patient.blood_sample}
		provides {blood_sample.results}
	    }
	    action fill_out_patient_details {
		requires {patient.blood_sample_details}
		provides {tracability_of_blood_sample}
	    }
	    action fill_out_patient_details{
		agent {phlebotomist && porter}
		requires {patient.blood_sample}
		provides {transport_patient.blood_sample}
	    }
	}
	action analyse_blood_sample{
	    agent {medical_scientisit && centrifugation_machine}
	    requires {patient.blood_sample}
	    provides {analysis_of_blood_sample}
	}
	action authorise_blood_sample {
	    agent {medical_scientist && principal_biochemist}
	    requires {patient.blood_sample}
	    provides {blood_sample.authorisation}
	}
    }

    action update_patient_information{
	agent {receptionist}
	requires {patient_record}
    }
    action check_patient_information {
	agent {receptionist && patient}	
	requires {patient_confirmation_of_details}
	provides {accurate_patient_record}
    }
    action arrange_patient_appointment {
	agent {receptionist && patient}	
	requires {new_appointment_details}
	provides {patient_appointment}
    }
    
    action assessment_of_blood_test_results {
	agent {Community_Nurse && patient}
	requires {blood_sample.biometric_analysis}
	provides {information_on_blood_sample}
    }
    action consult_with_patient {
	requires {blood_sample.results}
	provides {advice_on_psychosocial_self_monitoring}
	provides {consultation_on_weight_management}
	provides {consultation_on_exercise}
	provides {consultation_on_self_management}
    }
    action update_patient_record {
	requires {Patient_Record}
	provides {Patient_Record.update}
    }
    action lifestyle_consultation {
	agent {dietician && patient}
	requires {blood_sample.results}
	provides {information_to_guide_consultation}
    }
    action setting_goals{
	requires {tangible_milestones_for_patient}
	provides {self_management_plan_for_patient}
    }
    action optional_retinopathy_screening {
	agent {receptionist && patient}
	requires {eye_test} /* optional, if required*/
	provides {visual_test_results}
    }
    action visual_check {
	agent {photographer && patient}
	requires {patient_record}
	requires {consultation && eye_drops}
	provides {image_of_eyes}
	provides {eye_dilation_analysis}
    }
    action grade_eye_test_analysis {
	agent {grader}
	requires {eye_dilation_analysis}
	requires {analysis_and_spot_checks}
	provides {eye_test_results}
	provides {results_on_whether_linking_to_diabetes_condition}
    }
} 



