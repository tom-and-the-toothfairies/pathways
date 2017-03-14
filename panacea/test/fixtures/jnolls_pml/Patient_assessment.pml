process Diabetes_assessment {
	
	action Get_patient_symptoms {
		requires {patient_record}
		provides {patient_symptoms}
	}
	
	action Assess_patient_symptoms {
		requires {patient_symptoms}
		provides {assessment.diagnosis}
	}
}