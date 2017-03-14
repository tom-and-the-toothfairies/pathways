process implement_peos {
    action checkout {
        requires { repository }
	provides { workspace }
        script { "cvs -d $repository checkout peos-test" }
    }
    action check_tcltk {
            script { "Check if '/home/jntestuser/tcl_install/include/tcl.h' exists.  If not change machine." }
    }
    action goto_kernel_dir {
        requires { workspace }
        script { "run 'cd $workspace/src/os/kernel'" }
    }
    sequence run_app
    {
        iteration {
            action build_kernel {
                requires { workspace }
	        script { "run make" }
            }
            action fix_kernel_failures {
                script { "fix any failures" }
            }
        }
        selection {
            sequence run_gtk_app {
                action goto_gtk_dir {
                    requires { workspace }
                    script { "run 'cd $workspace/src/ui/GUI'" }
                }
                iteration {
                    action build_gtk_app {
                        requires { workspace }
                        script { "run make" }
                    }
                    action fix_gtk_failures{
                        script { "fix any failures" }
                    }
                }
                action run_gtk_app {
                    requires { workspace }
                    script { "run ./gtkpeos" }
                }
            }
            sequence run_java_app {
                action goto_gtk_dir {
                    requires { workspace }
                    script { "run 'cd $workspace/src/ui/java-gui'" }
                }
                action set_java_env {
                    script { "
                        run . /etc/profile
                        run setup jdk-1.4.0
                        run export CLASSPATH=/home/jnoll/lib/xmlParserAPIs.jar:/home/jnoll/lib/junit/junit.jar:/home/jnoll/lib/xercesImpl.jar"
                    }
                }
                iteration {
                    action build_java_app {
                        requires { workspace }
                        script { "run make" }
                    }
                    action fix_java_failures{
                        script { "fix any failures" }
                    }
                }
                action run_java_app {
                    requires { workspace }
                    script { "run ./runpeos" }
                }
            }
            sequence run_web_app {
                action goto_web_dir {
                    requires { workspace }
                    script { "run 'cd $workspace/src/ui/web2'" }
                }
                action set_html_dir {
                    requires { html_dir }
                    script { "run export HTML_DIR=$html_dir" }
                }
                iteration {
                    action build_web_app {
                        requires { workspace }
                        script { "run make install" }
                    }
                    action fix_web_failures{
                        script { "fix any failures" }
                    }
                }
                action run_web_app {
                    requires { peos_url }
                    script { "
                        run a web browser
                        goto $peos_url"
                    }
                }
            }
        }
    }
}
