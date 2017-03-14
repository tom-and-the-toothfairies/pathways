/* 
 * Dementia management pathway, from Pádraig O’Leary, John Noll, and Ita Richardson, 
 * "A Resource Flow Approach to Modelling Care Pathways," FHEIS 2013, Macao.
 */

process Dementia_management {

  action identify_causal_or_exacerbating_factors { 
    requires { Guidelines_For_Treatment_Of_Patients }
  }
  action provide_patient_carer_with_information {
    agent {GP && patient && carer}
    requires {
      patient_record.Confirmed_Dementia
      && patient_record.requests_privacy == "false" 
    }
    provides { information_to_carer }
  }	
  action create_treatment_or_care_plan {
    agent {
      memory_assessment_service 
      && GP && clinical_psychologiest && nurses
      && occupational_therapists && phsiotherapists 
      && speech_and_language_therapists 
      && social_workers && voluntary_organisation
    }
    requires { patient_history }
    provides { care_plan }
  }
  action formal_review_of_care_plan {
    agent { person && carer }
    requires { care_plan }
    provides { care_plan.reviewed == "true" } 
  }
  action assess_carer_needs { 
    agent { carer}
    provides { care_plan.respite_care }
  }
  
  branch  {

    branch cognitive_symptom_mgt {

      action non_medication_interventions {
	provides { 
	  support_for_carer && info_about_servicesAndInterventions 
	  && (optional) cognitive_simulation
	}
      }
      action medication_interventions {
	agent {specialist && carer}
	requires { (intangible)carer_view_on_patient_condition }
	provides { prescription }
      }

    } /* end of management_of_cognitive_symptoms  */

    branch non_cognitive_symptom_mgt {

      action non_medication_interventions { 
	agent {carer && patient}
	requires { (intangible)non_cognitive_symptoms || (intangible) challenging_behaviour }
	provides { early_assessment }
      }
      action medication_interventions {
	requires { (intangible) risk_of_harm_or_distress}
	provides { medication }
      }

    } /* end of management_of_non_cognitive_symptoms */

  } /* end cognitive/non-cognitive symptoms branch */
  


  action obtain_carers_view {
    agent { carer }
    provides { (intangible) view_on_condition}
  }
  action document_symptoms {
    agent { patient }
    provides { patient_record.symptoms }
  }
  /* optional, if required */
  action assess_behavioural_disturbances {
    agent { patient }
    requires { (intangible) risk_of_behavioural_disturbance }
    provides { care_plan.appropriate_setting }
  }




  branch {
    iteration {
      action record_changes {
	agent { patient }
	provides { patient_record.symptoms }
	provides { (optional) medication }
      }
    }

    iteration  {
      action monitor_patients_on_medication{
	agent { patient }
	provides { (optional)care_plan.medication }
      }
      action consider_alt_assessments {
	requires { 
	  patient_record.disability 
	  || patient_record.sensory_impairment 
	  || patient_record.lingustic_problems 
	  || patient_record.speech_problems 
	} 
	provides { care_plan.alternative_assessment_method }
      }
    }

    iteration {

      action manage_comorbidity {
	/*requires { }*/
	provides { 
	  comorbidity.depression 
	  && comorbidity.psychosis
	  && comorbidity.delirium 
	  && comorbidity.parkinsons_disease 
	  && comorbidity.stroke 
	}
      }

      action psychosocial_interventions {
	requires { comorbidity.depression || comorbidity.anxiety }
	agent { carer}
      }

    }

  } /* branch */

} /* process */


