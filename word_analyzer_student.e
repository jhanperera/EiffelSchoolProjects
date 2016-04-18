note
	description: "Corrected student version of WORD_ANALYZER"
	author: "Jhan Perera - CSE13187"
	date: "$Date$"
	revision: "$Revision$"

class
	WORD_ANALYZER_STUDENT
inherit
	WORD_ANALYZER_INTERFACE

create
	make

feature -- List of methods that will are implemented.

	first_repeated_character: CHARACTER
		 -- returns first repeated character or null character if none found
		 -- a character is repeated if it occurs at least twice in adjacent positions
	 	-- e.g. 'l' is repeated in "hollow", but 'o' is not.

		local	--Local variables
			i: INTEGER
			ch: CHARACTER
			stop: BOOLEAN
		do
			from
				i := 2	-- Start at the second character
				Result := '%U' -- Null character
			until
				i >= word.count or stop -- Check if we are at the end of the string, past it, or if stop = true
			loop

				ch := word[i]
				if ch = word[i-1] then -- Check the character before i
					Result := ch
					stop := true -- found the first repeating character, set the flag to true
				end
				i := i + 1
			end
		end

	first_multiple_character: CHARACTER
		-- Returns first multiply occuring character, or null if not found.
		-- A character is multiple if it occurs twice in a word,
		-- not neceassarily in adajacent positions.
		-- E.g. both 'o' and 'l' are multiple in "hollow", but 'h' is not.

		local	-- Local variables
			i: INTEGER
			ch: CHARACTER
			stop: BOOLEAN
		do
			from
				i := 1 --Start at the first character
				Result := '%U' -- Null character
			until
				i >= word.count  or stop  -- Check if we are at the end of the string, past it, or if stop = true
			loop
				ch := word[i]
				if find(ch,i) > 0 then -- use the find routine to find another character that matches
					Result := ch
					stop := true -- found another character in the string, set the flag to true.
				end
				i := i + 1
			end

		end

	count_repeated_characters: INTEGER
			-- counts groups of repeated characters.
			-- e.g., 'mississippi!!!' has 4 groups: ss, ss, pp and !!!.
			-- returns the number of such character groups

			local -- Local variables
				i: INTEGER
				nr: INTEGER -- number of repititions
			do
				from
					i := 1 -- Start at the first character
					nr := 0
				until
					i >= word.count -- Make sure we check the last character as well
				loop
					if word[i] = word[i+1] then -- found adjacent repitition
							nr := nr + 1 -- Incement counter
					end
					i := i + 1
				end
				Result := nr -- return the count of all repeating characters
			end

feature -- utilities
	find(c: CHARACTER; position: INTEGER): INTEGER
			-- returns index of 'c' in word
			-- in range position..word.count

		require
			correct_position:
				true
				-- Pos is a valid index in the attribute "word"
				position > 0 and position <= word.count -- position is within the index of work ie 1...word.count
		local
			i: INTEGER
			stop: BOOLEAN
		do
			from
				i := position + 1 -- need to start on the position after the current one
				Result := 0 -- default
			until
				i > word.count or stop
			loop
				if c = word[i] then
					Result := i
					stop := true
				end
				i := i + 1
			end
		ensure
			correct_index:
				true
				-- The Query returns the index of a character c in word in range of [pos, word.count],
				-- Otherwise it returns 0 if the character is not found.
				Result >= 0 and Result <= word.count -- the result is greater than or equal to 0 and is less than word.count
													 -- this ensures that the value returned is within the range of word or
													 -- is 0 if the character is not found.
		end


end
