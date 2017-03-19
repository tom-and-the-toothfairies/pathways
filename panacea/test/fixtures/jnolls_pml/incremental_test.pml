process incremental_test {
    action introduction {
	script { 
	    "What happens when you are tasked with testing a non-trivial product
with which you have no familiarity?  Tamres describes an
``incremental approach'' to handling this situation, which builds a
test suite from a very small baseline.

The intent of this exercise is to provide first-hand experience with
the problems of testing a software product under these conditions as
noted by Tamres:
* a large, complex application;
* limited or no knowledge of the product;
* inadequate user documentation;
* limited testing expertise;
* limited guidance or help with the testing task;
* unrealistic deadline.
[Tamres, p.5]

You must perform this exercise on a Linux-based platform (The SCU
Design Center servers (<em>linux.dc.engr.scu.edu</em>) meet this
requirement)

The incremental approach has eight phases, as described in Chapter 1
of Tamres.  Your assignment is to perform each of these phases, as
described below. 
"
	}
    }
    /* This is a true iteration: It continues until the tester decides he
    has sufficient knowledge of the application to write a baseline test. */
    iteration explore {
	action develop_exploratory_test {
	    requires { product_documentation }
	    provides { exploratory_test }
	    script {
"Develop tests that help you become familiar with the product and it's 
behavior in response to various inputs.  Use whatever resources are 
available:
* tutorials or training material
* <a href='$product_documentation '>engineering or user documentation</a>
* have the project authority demonstrate the product
* random experimentation
* try all options, one at a time
* observe behavior from previous tests, and develop new ones in response
[Tamres, p.7]

The intent is to see how the product works by running it.  Repeat these 
steps until you can predict the product's behavior to specific input 
before running the test."
	    }
	}
	action run_exploratory_test {
	    requires { exploratory_test }
	    provides { exploratory_test_results }
	}
	action analyze_exploratory_test_output {
	    requires { exploratory_test_results }
	    provides { exploratory_test_analysis }
	}
	action record_exploratory_results {
	    requires { exploratory_test_results && test_report }
	    provides { test_report }
	}
    }

    /* Note: in practice, this is iterative, until results are as expected. 
    But the intent is to be able to write a baseline test derived from the
    knowledge uncovered during exploration. */
    sequence baseline {
	action develop_baseline {
	    requires { test_report && product_documentation}
	    provides { baseline_test }
	    script {
"Now you have to write a baseline test.  This should be the simplest
input that could be expected to work, using the default options.

Before running the baseline, you must define the expected output.
Using the results from the exploratory phases recorded in the test
report ($test_report) and the product documentation
($product_documentation), define the expected output for your test
input.  Have the project authority validate this expectation."
             }
	}
	action run_baseline {
	    requires { baseline_test }
	    provides { baseline_test_results }
	}
	action analyze_baseline_test_output {
	    requires { baseline_test_results }
	    provides { baseline_test_analysis }
	}
    }
    action record_baseline_results {
	requires { baseline_test_results && test_report }
	provides { test_report }

    }

    iteration trends_analysis {
	action develop_trend_test {
	    requires { test_report && product_documentation }
	    provides { trend_test }
            script {
"This is an optional phase.  Do these steps if 
* input and output are numeric values
* data value boundaries are not specified
* calculating expected results is difficult
* you have an idea of the range of expected values
* you need more familiarity with the product [Tamres, p.9]
"
            }
	}
	action run_trend_test {
	    requires { trend_test }
	    provides { trend_test_results }
	}
	action analyze_trend_test_output {
	    requires { trend_test_results }
	    provides { trend_test_analysis }
	}
	action record_trends_results {
	    requires { trends_test_results && test_report }
	     provides { test_report }
	}
    }

    sequence inventory {
	action enumerate_inputs {
	    requires { product_documentation }
	    provides { input_inventory }
	    script {
"In this stage, you catalog all of the product inputs, and enumerate
the states each of those inputs can have.  The goal is to test each
input in each state at least once, by incrementally modifying the
baseline test.  Use the product documentation ($product_documentation) as 
a guide for discovering the valid inputs."
            }
	}
	/* Note: following is really a 'foreach'. */
	iteration do_inventory_tests {
	    action develop_inventory_test {
		requires { /* input in */ input_inventory }
		provides { inventory_test }
                script {
"For each input in the input inventory ($input_inventory), define an
input case and expected result(s)."
                }
	    }
	    action run_inventory_test {
		requires { inventory_test }
		provides { inventory_test_results }
	    }
	    action analyze_inventory_test_output {
		requires { inventory_test_results }
		provides { inventory_test_analysis }
	    }
	    action record_inventory_results {
		requires { inventory_test_results && test_report }
		provides { test_report }
	    }
	}
    }

    sequence inventory_combinations {
	action enumerate_input_combinations {}
	iteration do_inventory_combination_tests {
	    action develop_combination_test {
                requires { input_inventory }
                provides { combination_test }
            }
	    action run_combination_test {
                requires { combination_test }
                provides { combination_test_results }
            }
	    action analyze_combination_test_output {
		requires { combination_test_results }
		provides { combinatino_test_analysis }
            }
	    action record_combination_results {
		requires { combination_test_results && test_report }
		provides { test_report }
	    }
	}
    }

    iteration probe_boundaries {
	    action develop_boundary_test {}
	    action run_boundary_test {}
	    action analyze_boundary_test_output {}
	    action record_boundary_results {
		requires { stress_test_results && test_report }
		provides { test_report }
	    }
    }


    iteration devious_tests {
	    action develop_devious_test {
                script {
"Using your evolving knowledge of the product, attempt to break it by
developing test cases with devious input.  For example:
* no input data
* invalid data (negative number, alphanumeric strings)
* illegal formats
* unusual data combinations
* corner cases, such as zero as a value 
[Tamres, p. 20]
Note that the expected result may be an error message or graceful exit."
                }
            }
	    action run_devious_test {}
	    action analyze_devious_test_output {}
	    action record_deviousresults {
		requires { devious_test_results && test_report }
		provides { test_report }
	    }
    }

    iteration stress_environment {
	    action develop_stress_test {
                script {
"Some applications should be tested with restricted resources:
* reduced memory
* limited or no disk space
* multiple concurrent instances of application
* running while backup in progress
* many asynchronous event driven processes
[Tamres, p21]
Also consider adverse events, to assess recovery and resilience:
* abort in middle of an operation
* disconnecting cables (i.e., network)
* power loss
"
                }
            }
	    action run_stress_test {}
	    action analyze_stress_test_output {}
	    action record_stress_results {
		requires { stress_test_results && test_report }
		provides { test_report }
	    }
    }

    sequence write_test_report {
	action write_title_page {}
	action insert_test_results {}
	action format_document {}
	action spell_check_document {
	    requires { test_report }
	    provides { test_report.spell_checked }
	}
	action proofread_document{
	    requires { test_report }
	    provides { test_report.proofread }
	}
    }

    /* Note: This is really a separate process. */
    selection submit_document {
	action submit_hardcopy {
	    requires { pdf_test_report && 
		test_report.spell_checked && 
		test_report.proofread 
	    }
	}
	action submit_electronic_copy {
	    requires { pdf_test_report && 
		test_report.spell_checked && 
		test_report.proofread 
	    }
	    provides { ack_message }
	}
    }
}
