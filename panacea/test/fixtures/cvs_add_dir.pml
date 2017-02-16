process cvs_add_dir {
    action create_directory {
	script { "In your workspace, create the new directory (using 'mkdir')." }
    }
    action add_directory {
	script { "Notify cvs that you intend to add the directory to the repository, by typing 'cvs add dirname', where 'dirname' is the name of the directory you created in the create_directory ation." }
    }
    action commit_directory {
	script { "Add the directory to the repository by typing 'cvs commit -m 'Added dirname.' dirname'." }
    }
    action change_permissions {
	script { "Grant access to you team members by changing the directory permissions in the repository: 'cd $CVSROOT/path/to/parent/dir; chmod a+rw g+s'" }
    }
}