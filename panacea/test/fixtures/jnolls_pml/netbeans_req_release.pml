process RequirementsAndRelease {
  sequence Requirements {
    sequence SetProjectTimeline {
      action ReviewNetBeans {
	requires { NetBeansRoadmap }
/*	provides { }*/
	tool { "WebBrowser " }
	agent { "Previous release manager, Sun ONE Studio development team (e.g. Forte'), Sun ONE Studio Marketing Manager " }
	script {
	  "available at <a href=http://www.netbeans.org/devhome/docs/roadmap.html>http://www.netbeans.org/devhome/docs/roadmap.html</a>"
	}
      }
      action SetReleaseDate {
	requires { NetBeansRoadmap }
	provides { ReleaseDate }
	tool { "Pen, paper " }
	agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	script { "" }
      }
      sequence DetermineProject {
	branch SunONEStudioDevelopmentMeeting {
	  action ReviewNetBeansVisionStatmenet {
	    requires { NetBeansVisionStatement }
	    /*provides { }*/
	    tool { "Web browser " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { 
	      "available at <a href=http://www.netbeans.org/about/os/vision.html>http://www.netbeans.org/about/os/vision.html</a>"
	    }
	  }
	  action ReviewUncompletedMilestonesFromPreviousRelease {
	    requires { PreviousVersionReleaseDocuments }
	    provides { ProspectiveFeaturesForUpcomingRelease }
	    tool { "Web browser " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { 
	      "Available at <a href=http://www.netbeans.org/devhome/docs/releases/33/features/nb33-features-overview.html>http://www.netbeans.org/devhome/docs/releases/33/features/nb33-features-overview.html</a>"
	    }
	  }
	  action ReviewIssuzillaFeatureRequests {
	    requires { IssuzillaIssueRepository }
	    provides { ProspectiveFeaturesForUpcomingRelease }
	    tool { "Web browser, Issuezilla " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { 
	      "Go to <a href=http://www.netbeans.org/devhome/issues.html>Issuezilla</a>
	      Search for feature requests/enhancements from current release"
	    }
	  }
	}
	iteration EstablishFeatureSet {
	  action CompileListOfPossibleFeaturesToInclude {
	    requires { ProspectiveFeaturesGatheredFromIssuezilla && ProspectiveFeaturesFromPreviousReleases }
	    provides { FeatureSetForUpcomingRelease }
	    tool { "Pen, paper " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { "" }
	  }
	  action CategorizeFeaturesProposedFeatureSet /*into"Must Have," "Should Have," and "Nice to Have"*/ {
	    requires { FeatureSetForUpcomingRelease }
	    provides { WeightedListOfFeaturesToImplement /* (signifying relative importance) */ }
	    tool { "Pen, paper " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { "" }
	  }
	  action SendMessageToCommunityForFeedback /* {nbdev, nbusers, qa, nbdiscuss }*/ {
	    requires { WeightedListOfFeaturesToImplement }
	    /*provides { }*/
	    tool { "Email client " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { "" }
	  }
	  action ReviewFeedbackFromCommunity /* r.e. proposed feature set*/ {
	    requires { FeebackMessagesOnMail }
	    provides { PotentialRevisionsToDevelopmentProposal }
	    tool { "Web browser " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { "" }
	  }
	  action ReviseProposalBasedOnFeedback {
	    requires { PotentialRevisionsToDevelopmentProposal }
	    provides { RevisedDevelopmentProposal }
	    tool { "Pen, paper " }
	    agent { "Previous release manager, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	    script { "" }
	  }
	}
	action PostFinalDevelopmentProposalToNetBeansWebsite {
	  requires { RevisedDevelopmentProposal }
	  provides { FinalDevelopmentProposal }
	  tool { "Web editor " }
	  agent { "NetBeans web team, Sun ONE Studio Development team, Sun ONE Studio Marketing Manager " }
	  script { "" }
	}
	action AssignDevelopersToCompleteProjectMilestones {
	  requires { RevisedDevelopmentProposal }
	  /* provides { }*/
	  tool { "Email client " }
	  agent { "NetBeans developers (Sun ONE Studio developers, module developers) " }
	  script { "" }
	}	
      }
      sequence SetReleaseStageCompletionDates {
	action SetFeatureFreezeDate {
	  requires { ReleaseDate }
	  provides { FeatureFreezeDate }
	  tool { "" }
	  agent { "Previous release manager, Sun ONE Studio Development team " }
	  script { "" }
	}
	action SetMilestoneCompletionDates {
	  requires { FeatureFreezeDate && ReleaseDate }
	  provides { MilestoneCompletionDates }
	  tool { "" }
	  agent { "Developer(s) responsible for feature completion " }
	  script { "" }
	}
      }
    }
    sequence EstablishReleaseManager {
      action EmailSolicitationForReleaseManager {
	/*requires { }*/
	provides { ReleaseManagerRequest }
	tool { "Email client " }
	agent { "PreviousReleaseManager " }
	script { "" }
      }
      action WaitForVolunteer {
/*	requires { }
	provides { }*/
	tool { "" }
	agent { "" }
	script { "Wait for community members to volunteer to be the release manager " }
      }
      iteration CollectCandidacyNominations {
	action SendCandidacyAnnouncement {
	  requires { ReleaseManagerRequest }
	  provides { ReleaseManagerCandidacyAnnouncement }
	  tool { "Email client " }
	  agent { "Release manager candidate " }
	  script { "" }
	}
      }
      action EstablishReleaseManagerConsensus {
	requires { ReleaseManagerCandidacyAnnouncements }
	provides { ReleaseManagerDecision }
	tool { "Email client " }
	agent { "NetBeans community (nbdev mailing list) " }
	script { "" }
      }
      action AnnounceNewReleaseManager {
	requires { ReleaseManagerDecision }
	provides { ReleaseManagerAnnoucementToNbdevMailingList }
	tool { "Email client " }
	agent { "Previous release manager " }
	script { "" }
      }
    }
    action SolicitModuleMaintainersForInclusionInUpcomingRelease {
      requires { FeatureFreezeDate }
      provides { ModuleInclusionNoticeToNbdevMailingList}
      tool { "Email client " }
      agent { "Release manager " }
      script { "" }
    }
  }
  sequence Release {
    iteration Stabilization {
      sequence Build {
	action ChangeBuildBranchName {
	  requires { CvsCodeRepository }
	  provides { NewBranchForCurrentBuild }
	  tool { "CVS code repository " }
	  agent { "Release manager, module maintainers " }
	  script { "" }
	}
	iteration MakeInstallTar {
	  action MakeInstallTarForEachPlatform {
	    requires { DevelopmentSourceForEachPlatform }
	    provides { InstallExecutableTar }
	    tool { "Ant, Build tools, Install tools, Tar, Zip tools " }
	    agent { "Release manager, build automation script"  }
	    script { "" }
	  }
	}
      }
      sequence Deploy {
	action UploadInstallTarFilesToWebRepository {
	  requires { BinaryReleaseDownloads && WebRepository }
	  /* provides { }*/
	  tool { "FTP client " }
	  agent { "Release manager " }
	  script { "" }
	}
	action UpdateWebPage {
	  requires { ProjectWeb }
	  provides { UpdatedWeb }
	  tool { "Web editor " }
	  agent { "Web team " }
	  script { "" }
	}
	action MakeReadmeInstallationNotesAndChangelog {
	  requires { ChangesFromIndividualModules}
	  provides { README && InstallationNotes && Changelog}
	  tool { "Text editor " }
	  agent { "Release manager " }
	  script { "" }
	}
	action SendReleaseNotificationToCommunityInvitingTheCommunityToDownloadAndTestIt { 
	  /* requires { }*/
	  provides { ReleaseNotice }
	  tool { "Email client" }
	  agent { "Release manager" }
	  script { "" }
	}
      }
      sequence Test {
	action ExecuteAutomaticTestScripts{
	  requires { TestScripts && ReleaseBinaries}
	  provides { TestResults}
	  tool { "Automated test suite (xtest, others) " }
	  agent { "Sun ONE Studio QA team " }
	  script { "" }
	}
	action ExecuteManualTestScripts{
	  requires { ReleaseBinaries}
	  provides { TestResults}
	  tool { "NetBeans IDE " }
	  agent { "users, developers, Sun ONE Studio QA team, Sun ONE Studio developers " }
	  script { "" }
	}
	iteration UpdateIssuezilla{
	  action ReportIssuesToIssuezilla{
	    requires { TestResults}
	    provides { IssuezillaEntry}
	    tool { "Web browser " }
	    agent { "users, developers, Sun ONE Studio QA team, Sun ONE Studio developers " }
	    script {
	      "Navigate to <a href='http://www.netbeans.org/issues'>Issuezilla</a>.
	      Select issue number/component to update	."
	    }
	  }
	  action UpdateStandingIssueStatus{
	    requires { St&&ingIssueFromIssuezilla && TestResults}
	    provides { UpdatedIssuezillaIssueRepository}
	    tool { "Web browser " }
	    agent { "users, developers, Sun ONE Studio QA team, Sun ONE Studio developers " }
	    script { "" }
	  }
	}
	action PostBugStats{
	  requires { TestResults}
	  provides { BugStatusReport && TestResultReport}
	  tool { "Web editor, JFreeChart " }
	  agent { "Release manager " }
	  script { "" }
	}
      }
      sequence Debug {
	action ExamineTestReport {
	  requires { TestReport && BugStats }
	  /* provides { }*/
	  tool { "Web browser" }
	  agent { "developers, Sun ONE development team, module maintainers, module contributors, release manager " }
	  script { "" }
	}
	action WriteBugFix {
	  requires { ErroneousSource }
	  provides { PotentialBugFix }
	  tool { "Source editor " }
	  agent { "developers, Sun ONE development team, module maintainers, module contributors, release manager " }
	  script { "" }
	}
	action VerifyBugFix {
	  requires { PotentialBugFix }
	  provides { WorkingBugFix }
	  tool { "Source editor, source compiler, test tools " }
	  agent { "developers, Sun ONE development team, module maintainers, module contributors, release manager " }
	  script { 
	    "Compile source locally.
	    Execute module locally.
	    Perform automatic, manual unit testing.
	    Perform automatic, manual integration testing."
	  }
	}
	action CommitCodeToCvsCodeRepository {
	  requires { WorkingBugFix && CVSCodeRepsository}
	  provides { UpdatedSource}
	  tool { "CVS client " }
	  agent { "developers, Sun ONE development team, module maintainers, module contributors, release manager " }
	  script { 
	    "Upload revised source to the CVS code repository in respective branch."
	  }
	}
	action UpdateIssuezillaToReflectChanges{
	  requires { IssuezillaIssueRepository}
	  provides { UpdateIssueStatus}
	  tool { "Web browser " }
	  agent { "developers, Sun ONE development team, module maintainers, module contributors, release manager " }
	  script { "" }
	}
      }
    }
  }
}

