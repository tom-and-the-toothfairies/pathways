process onr_grants {
    task PreAward {
	task PreSolicitation {
	}
	task Solicitation {
	}
    }
    task GrantAward {
	task ProcessPropForAward {
	    action PO_ReceiveProposal manual {
	    }
	    action ReviewCertifications manual  {
	    }
	    action ReviewSignatures  manual {
	    }
	    action ReviewBAADate manual  {
	    }
	    action ReviewProposal  manual {
	    }
	}
	task EvaluteGrantProposal {
	    action MakeTechnicalSelection  manual {
	    }
	    action PerformCostAnalysis manual {
	    }
	    action Create_PR manual {
	    }
	    action Electronic_PR_To_O2 manual {
	    }
	    action HardcopyProposalTo_O2 manual {
	    }
	    action O2_Record_PR manual {
	    }
	    action O2_Prin_PR manual {
	    }
	    action Sort_PRs_Numerically manual {
	    }
	    action Verify_PR_Complete manual {
	    }
	    action Compare_PR_DollarsToProposal manual {
	    }
	    action Carry_PR_PackageTo_BD manual {
	    }
	    action Assign_PR_PackageToGS manual {
	    }
	    action ValidateHardCopyWith_PR manual {
	    }
	    action VerifyBudgetAmount manual {
	    }
	    action VerifyFundingAmount manual {
	    }
	    action VerifyAllowableCosts manual {
	    }
	    action CheckIndirectRates manual {
	    }
	}
	task AwardGrant {
	    action SignGrantDocument manual {
	    }
	    action GiveFileToReceptionist manual {
	    }
	    action LogReceiptDateInINRIS manual {
	    }
	    action ForwardFileToFileRoom manual {
	    }
	    action CopyCoverPage manual {
	    }
	    action CopyFAD manual {
	    }
	    action CopySigPage manual {
	    }
	    action PlaceOnPendingReviewShelf manual {
	    }
	    action GiveCopiesToReceptionist manual {
	    }
	    action LogDateSentToFMInINRIS manual {
	    }
	}
	task DeliverPackageToFiscal {
	}
	task RecordObligationDataInSTARS {
	    action SignFADSheet manual {
	    }
	    action PickUpOriginalGrantDocument manual {
	    }
	    action LogDateRetInINRIS manual {
	    }
	    action GiveFileToFileRoom manual {
	    }
	    action MatchFileWithSignedFAD manual {
	    }
	}
	task MakeCopies {
	    action CopyGrantDocument manual {
	    }
	    action CopyDistSheet manual {
	    }
	    action CopyCMemo manual {
	    }
	    action PlaceCopiesInEnvelope manual {
	    }
	    action RecordDateMailedInINRIS manual {
	    }
	    action RecordDateDistbutedInINRIS manual {
	    }
	    action FileOriginalInGrantFile manual {
	    }
	    action GiveEnvelopeToReceptionist manual {
	    }
	}
	task PlaceEnvelopeInOutgoingMail {
	    action DistributeCopyToDFAS manual {
	    }
	    action DistributeCopyToCAO manual {
	    }
	    action DistributeCopyToWinner manual {
	    }
	    action DistributeCopyToXXXX manual {
	    }
	}
    }
    task GrantAdministration {
    }
    task GrantCloseOut {
    }
}
