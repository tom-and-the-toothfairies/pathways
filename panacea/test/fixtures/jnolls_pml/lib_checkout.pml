process library_checkout {
	sequence checkout {
		action go_checkout_counter {
			requires {"books to be checked out"}
			agent    {"user"}
			script   {"If you found books, go to checkout counter"}
		}
		action give_card_books {
			requires {"library card and books"}
			agent    {"user"}
			agent    {"librarian"}
			script   {"Give library card and books to librarian "}
		}
		action scan_card   {
			requires {"card"}
			requires {"scanner"}
			provides {"details of card holder"}
			agent    {"librarian"}
			script   {"Scan card through scanner and wait for cardholder information to show up "}
		}

		selection validity  {
			sequence continue_checkout  {
				action scan_books  {
					requires {"books"}
					requires {"scanner"}
					provides {"details of books added to cardholder account"}
					agent    {"librarian"}
					script   {"Scan the books"}
				}

 				action demagnitize_books {
					requires {"books"}
					requires {"demagnitizer"}
					agent    {"librarian"}
					script   {"De-magnitize the books by moving them across the demagnitizer strip"}
				}

				action print_receipt  {
					requires {"printer"}
					provides {"receipt"}
					agent    {"librarian"}
					script   {"Print the receipt" }
				}

				action hand_books_to_user {
					requires {"books"}
					requires {"card"}
					requires {"receipt"}
					provides {"books"}
					provides {"card"}
					provides {"receipt"}
					agent    {"librarian"}
					agent    {"user"} 
					script   {"Give the books, card and receipt to user"}
		  		}

			} /* end sequence continue_checkout */
			sequence pay_fine  {
				action fine_payment  {
					requires {"Account showing some fine amount"}
					requires {"Cash"}
					agent    {"user"}
					agent    {"librarian"}
					script   {"Receive the fine amount from the user in cash"}
				}
				action update_account  {	
					requires {"Fine amount paid"}
					provides {"updated account information"}
					agent    {"librarian"}
					script   {"When fine amount received, update the account information so no fine shown"}			
				 }
				action print_receipt  {
					requires {"printer"}
					provides {"receipt"}
					agent    {"librarian"}
					script   {"Print the receipt" }
				}
				iteration {
					sequence continue_checkout {}
				} /* end iteration */
			} /* end sequence fine_payment */
		} /* end selection validity */
	} /* end sequence checkout */
} /* end process library_checkout */

