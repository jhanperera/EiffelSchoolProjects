note
	description: "A customer has a name and an account with a balance"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUSTOMER

inherit
	ANY
		redefine is_equal end

create
	make

feature{NONE} -- Creation

	make(a_name:STRING)
			-- Create a customer with an `account'
		local
			l_account: ACCOUNT
			l_name: IMMUTABLE_STRING_8
		do
			l_name := a_name
			name := l_name
			create l_account.make_with_name (a_name)
			account := l_account
		ensure
			correct_name: name ~ a_name
			correct_balance: balance = balance.zero
		end

feature -- queries

	name: IMMUTABLE_STRING_8

	balance: VALUE
		do
			Result := account.balance
		end

	account: ACCOUNT

	is_equal(a_customer: CUSTOMER): BOOLEAN
		do
			Result := current.account.name ~ a_customer.account.name  and then current.account.balance = a_customer.account.balance
		end

	output_string: STRING
		do
			Result:= "name: " + current.name + ", balance: " + balance.out
		end


invariant
	name_consistency: name ~ account.name
	balance_consistency: balance = account.balance
end
