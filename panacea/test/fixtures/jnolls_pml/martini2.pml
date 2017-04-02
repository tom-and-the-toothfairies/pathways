process martini {
    branch mix_and_prepare {
	sequence mix {
	    action add_ice manual {
		requires {"ice"}
		requires {"shaker"}
		provides {"shaker"}
		agent {"bartender"}
		script {"add enough ice to shaker so that the gin will just barely cover it."}
	    }
	    action add_vermouth manual {
		requires {"vermouth"}
		requires {"shaker"}
		provides {"shaker"}
		agent {"bartender"}
		script {"add generous amount of vermouth, swirl in shaker so ice and sides are coated, then discard."}
	    }
	    action add_gin manual {
		requires {"gin"}
		requires {"shaker"}
		provides {"shaker"}
		agent {"bartender"}
		script {"add appropriate amount of gin (preferably Beefeaters), about two ounces per martini."}
	    }
	    action shake manual {
		requires {"shaker"}
		provides {"shaker"}
		agent {"bartender"}
		script {"shake gently until ingredients are well chilled.  The shaking should not be so violent that it breaks chips off the ice; a vigourous swirling motion can be substituted."}
	    }
	}

	iteration prepare {
	    selection twist_or_olive {
		sequence prepare_twist {
		    action cut_twist {}
		    action twist_twis {}
		}
		sequence prepare_olive {
		    action wash_olive manual {
			requires {"olive"}
			provides {"olive"}
			agent {"bartender"}
			script {"if you are not using olives packed in vermouth, wash one or two olives per martini under tap to remove the brine"}
		    }
		    action skewer_olive manual {
			requires {"olive"}
			requires {"martini-glass"}
			requires {"toothpick"}
			provides {"martini-glass"}
			agent {"bartender"}
			script {"place one or two olives on a toothpick and insert into well chilled martini glass"}
		    }
		}
	    }
	}
    }

    iteration pour {
	action pour_one manual {
	    requires {"martini-glass"}
	    requires {"pitcher"}
	    provides {"martini"}
	    agent {"bartender"}
	    script {"pour an appropriate amount into a prepared martini glass.  Appropriate is enough so that all glasses end up with the same amount."}
	}
    }
}
