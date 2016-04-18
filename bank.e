note
	description: "[
		(1) A Bank consists of many customers.
		There are `count' customers.
		(2) New customers can be added to the bank by name.
		    We never delete a customer record, 
		    even after they leave the bank.
		(3) Each customer shall have a single account at the bank.
		    Initially the balance in the account is zero.
		(4) Money can be deposited to and withdrawn from customer accounts.
		    Money is deposited as a dollar amount, 
		    perhaps with more than two decimal places.
		(5) Money calculations shall be precise 
		  (e.g. adding, subtracting and multiplying 
		  money amounts must be without losing pennies or parts of pennies).
		(6) Money can also be transferred between two customer accounts.
		(7) Balances in accounts shall never be negative.
		(8) Customers are identified by name, 
		    so there cannot be two customers having the same name.	  
		(9) Customers are stored in a list sorted alpahabetically by name.
		(11) The bank has an attribute `total' that stores the total
			of all the balances in the various customer accounts.
			This can be used to check for fraud.
			
			-----------------------------------------
			You will see '--Todo' whereyou must revise
			-----------------------------------------

		]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK
inherit
	ANY
		redefine out end
create
	make

feature {NONE} -- Initialization
	make
			-- Create a bank
		do
			-- ToDo
			-- This is not guaranteed to be correct
			count := 0
			total := zero
			zero := "0"
			one := "1"
			create {ARRAYED_LIST[CUSTOMER]} customers.make (10)
		end

feature -- bank attributes

	-- don't change the bank attributes

	zero, one: VALUE

	count : INTEGER
		-- total number of bank customers

	total: VALUE
		-- total of all the balances in the customers accounts

	customers : LIST[CUSTOMER]
		-- list of all bank customers

	flag: BOOLEAN
		-- A flag to help with insertion

feature -- Commands using a single account

	-- do not change the precondition and postcondition tags
	-- you may change the part of the contract that comes after the tag
	-- you ma change the routine implemementations

	new (name1: STRING)
			-- Add a new customer named 'name1'
			-- to the end of list `customers'
		require
			customer_not_already_present:
				 not (customer_exists(name1))
			valid_name:
				name1 /~ " " and then name1 /~ "%U" and then name1 /~ ""
		local
			customer_to_add: CUSTOMER
		do
			-- Add the new customer into the list.
			create {CUSTOMER} customer_to_add.make (name1)

			-- Incremen the count of the numbe of customes.
			count := count + 1
			-- Preform a quick sort
			if count > 1 and then flag = false  then
				-- Check if the count > 1 and if a depoit has not been done yet
				customers.force (customer_to_add)
				-- Perform a quick sort
				quick_sort(1, count)
				else
					-- deposte has been done already we add the new customer to the end
					customers.force (customer_to_add)
					-- Reset flag
					flag := false
			end


		ensure
			total_balance_unchanged:
				sum_of_all_balances = old sum_of_all_balances
			num_customers_increased:
				count = old count + 1
			total_unchanged:
				total = old total
			customer_added_to_list:
				customer_exists (name1)
				and then customers[customer_id (name1)].name ~ name1
				and then customers[customer_id (name1)].balance ~ zero
			other_customers_unchanged:
				customers_unchanged_other_than(name1, old customers.deep_twin)
		end

	deposit(a_name:STRING; a_value: VALUE)
			-- Deposit an amount of 'a_value' into account owned by 'a_name'.
		require
			customer_exists:
				customer_exists(a_name)
			positive_amount:
				(a_value > zero)
		do
			-- Despoiste the ammount into the cusomers account
			customers[customer_id (a_name)].account.deposit (a_value)
			-- Incrase the total
			total := total.add (a_value)
			-- Set flag to be true
			flag := true

		ensure
			deposit_num_customers_unchanged:
				count = old count
			total_increased:
				total = old total.add (a_value)
			deposit_customer_balance_increased:
				customers[customer_id (a_name)].balance = old customers[customer_id (a_name)].balance + a_value
			deposit_other_customers_unchanged:
				customers_unchanged_other_than(a_name, old customers.deep_twin)
			total_balance_increased:
				sum_of_all_balances = old sum_of_all_balances + a_value
		end

	withdraw (a_name:STRING; a_value: VALUE)
			-- Withdraw an amount of 'a_value' from account owned by 'a_name'.
		require
			customer_exists:
				customer_exists(a_name)
			positive_amount:
				(a_value > zero)
			sufficient_balance:
				not (customer_with_name(a_name).balance.is_less(a_value))

		do
			-- Withdraw theamount from the custoers account
			customers[customer_id (a_name)].account.withdraw (a_value)
			-- Decrease the total
			total := total.minus (a_value)


		ensure
			withdraw_num_customers_unchanged:
				count = old count
			total_decreased:
				total = old total.minus (a_value)
			withdraw_customer_balance_decreased:
				customers[customer_id (a_name)].balance = old customers[customer_id (a_name)].balance - a_value
			withdraw_other_customers_unchanged:
				customers_unchanged_other_than(a_name, current.customers.deep_twin)
			total_balance_decreased:
				sum_of_all_balances = old sum_of_all_balances - a_value
		end

feature -- Command using multiple accounts

	transfer (name1: STRING; name2: STRING; a_value: VALUE)
			-- Transfer an amount of 'a_value' from
			-- account `name1' to account `name2'
		require
			distinct_accounts:
				not (name1.is_case_insensitive_equal_general (name2))
			customer1_exists:
				customer_exists(name1)
			customer2_exists:
				customer_exists(name2)
			sufficient_balance:
				not (customer_with_name(name1).balance.is_less(a_value))
		do
			-- Withdraw from first customer
			customers[customer_id (name1)].account.withdraw (a_value)
			-- Deposite to the second customer
			customers[customer_id (name2)].account.deposit (a_value)

		ensure
			same_total:
				total = old total
			same_count:
				count = old count
			total_balance_unchanged:
				sum_of_all_balances = old sum_of_all_balances
			customer1_balance_decreased:
				customers[customer_id (name1)].balance = old customers[customer_id (name1)].balance - a_value
			customer2_balance_increased:
				customers[customer_id (name2)].balance = old customers[customer_id (name2)].balance + a_value
			other_customers_unchanged:
				customers_unchanged_other_than(name1, current.customers.deep_twin)
				and then customers_unchanged_other_than(name2, current.customers.deep_twin)
		end

feature -- queries for contracts

	-- You may find the following queries helpful.
	-- Change them as necessary, or add your own
	-- if you add your own, contract them, and test them

	sum_of_all_balances : VALUE
			-- Summation of the balances in all customer accounts
		do
			from
				Result := zero
				customers.start
			until
				customers.after
			loop
				Result := Result.add (customers.item.balance)
				customers.forth
			end
		ensure
			comment("Result = (SUM i : 1..count: customers[i].balance)")
			Result = total
		end

	customer_exists(a_name: STRING): BOOLEAN
			-- Is customer `a_name' in the list?
		do
			from
				customers.start
			until
				customers.after or Result
			loop
				if customers.item.name ~ a_name then
					Result := true
				end
				customers.forth
			end
		ensure
			comment("EXISTS c in customers: c.name = a_name")
		end

	customer_id(a_name:STRING):INTEGER
		-- Return the customers id of 'a_name'
		local
			index_of: INTEGER
		do
			index_of := 1
			from
				customers.start
			until
				customers.after
			loop
				if customers.item.name ~ a_name then
					Result := index_of
				end
				customers.forth
				index_of := index_of + 1
			end

		end

	customer_with_name (a_name: STRING): CUSTOMER
			-- return customer with name `a_name'
		require
			customer_exists (a_name)
		do
			Result := customers[1]
			-- The above is needed to remove the VEVI compile error
			-- of void safety
			Result := customers[customer_id (a_name)]
		ensure
			correct_Result: Result.name ~ a_name
		end

	customers_unchanged_other_than (a_name: STRING; old_customers: like customers): BOOLEAN
			-- Are customers other than `a_name' unchanged?
		local
			c_name: STRING
		do
			from
				Result := true
				--make old_customer do a object comparison
				old_customers.compare_objects
				customers.start
			until
				customers.after or not Result
			loop
				c_name := customers.item.name
				if c_name /~ a_name then
					Result := Result and then
						old_customers.has (customers.item)
				end
				customers.forth
			end
		ensure
			Result =
				across
					customers as c
				all
					c.item.name /~ a_name IMPLIES
						old_customers.has (c.item)
				end
		end


feature -- invariant queries
	unique_customers: BOOLEAN

		do
			Result := true	-- Assign Result to true
			across
				customers as a 	-- Iterate through the array
			loop
				across
					customers as b	-- Iterate through the array
				loop
					if a.item = b.item and a /~ b and count > 0 then
						-- Check if a and b are the same item and if a and b are not the same pointer
						Result := false
					end
				end
			end

		ensure
			Result = across
				1 |..| count as i
			all
				across 1 |..| count as j
				all
					customers[i.item] ~ customers[j.item]
					implies i.item = j.item
				end
			end
		end
feature -- Queries on string representation.

	customers_string: STRING
			-- Return printable state of `customers'.
		local
			sorted_customers: TWO_WAY_LIST[CUSTOMER]
		do
			create sorted_customers.make
			across
				customers as c
			loop
				sorted_customers.extend (c.item)
			end

			create Result.make_empty
			across
				sorted_customers as c
			loop
				Result := Result + c.item.output_string + "%N"
			end
		end


	out : STRING
			-- Return a sorted list of customers.
		do
			Result := customers_string
		end

	comment(s:STRING): BOOLEAN
		do
			Result := true
		end

feature -- quicksort

	quick_sort(a_first: INTEGER; a_last: INTEGER)
			-- QuickSort function for customers
		local
			l_first: INTEGER
			l_last: INTEGER
			l_pivot: INTEGER
		do
			-- Follwowing a simple recursive quicksort method
			l_first:= a_first
			l_last:= a_last
			if l_first < l_last  then
				l_pivot:= partition(l_first, l_last)
				quick_sort(l_last, l_pivot -1)
				quick_sort(l_pivot + 1, l_last)
			end


		 end
	-- Create a partition
	partition(lo: INTEGER;  hi: INTEGER): INTEGER
			--partition function to help quicksort
		require
			lo_is_greater_than_zero:
				lo > 0
			hi_is_less_than_count:
				hi <= current.count
		local
			 pivot: CUSTOMER
			 l_i: INTEGER
			 l_j: INTEGER
		do
			pivot:= current.customers[hi]
			l_i:= lo
			from
				l_j := lo
			until
				l_j = (hi - 1)
			loop
				if current.customers[l_j].name < pivot.name then
					swap(l_i, l_j)
					l_i := l_i+1
					l_j := l_j + 1
				end
			end
			swap(l_i, hi)
			Result:= l_i

		 end

		 swap(i: INTEGER; j: INTEGER)
		 		--Swap function for the partition function
		 	local
		 	 	old_itemi: CUSTOMER
		 	 	old_itemj: CUSTOMER
		 	 	dummy: CUSTOMER
		 	do
		 		old_itemi := current.customers[i].deep_twin
		 		old_itemj := current.customers[j].deep_twin
		 		-- Create a dummy so we avoid duplicate names when swaping
				create {CUSTOMER} dummy.make ("%U")
				current.customers[j] := dummy

		 		current.customers[i] := old_itemj
		 		current.customers[j] := old_itemi


			end

invariant
	value_constrsaints:
		zero = zero.zero and one = one.one
	consistent_count:
		count = customers.count
	consistent_total:
		total = sum_of_all_balances

	customer_names_unique:
		-- cannot have duplicate names in `customers'
		unique_customers
	customers_are_sorted:
		-- list has to be sorted
		across
				1 |..| count as i
			all
				across i.item |..| count as j
				all
					customers[i.item].name <= customers[j.item].name
					implies i.item <= j.item
				end
			end
end

