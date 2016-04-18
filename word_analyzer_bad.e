note
	description: "[
	Class to analyze words with some bad routines. 
	Students must use tests to find the bugs and fix them.
	Also, students should learn to use the debugger.
	Note: A STRING 's' is a sequence of CHAR where s[i] is valid,
	iff 1 <= i <= s.count. 
	s.valid_index(i) =def (1 <= i and i <= s.count)
	]"
	author: "$Author: jonathan $"
	date: "$Date: 2015-12-20 22:12:55 -0500 (Sun, 20 Dec 2015) $"
	revision: "$Revision: 1183 $"

class
	WORD_ANALYZER_BAD
inherit
	WORD_ANALYZER_INTERFACE
create
	make
feature -- commands
	first_repeated_character: CHARACTER
		 -- returns first repeated character or null character if none found
		 -- a character is repeated if it occurs at least twice in adjacent positions
		 -- e.g. 'l' is repeated in "hollow", but 'o' is not.
		local
			i: INTEGER
			ch: CHARACTER
			stop: BOOLEAN

		do
			from
				i := 1
				Result := '%U' -- not needed due to default initilization
			until
				i > word.count or stop
			loop

				ch := word[i]
				if ch = word[i+1] then
					Result := ch
					stop := true
				end
				i := i + 1
			end
		end

	first_multiple_character: CHARACTER
			-- Returns first multiply occuring character, or null if not found.
			-- A character is multiple if it occurs twice in a word,
			-- not neceassarily in adajacent positions.
			-- E.g. both 'o' and 'l' are multiple in "hollow", but 'h' is not.
		local
			i: INTEGER
			ch: CHARACTER
			stop: BOOLEAN
		do
			from
				i := 1
				Result := '%U'
			until
				i > word.count or stop
			loop
				ch := word[i]
				if find(ch,i) > 0 then
					Result := ch
					stop := true
				end
				i := i + 1
			end

		end

	count_repeated_characters: INTEGER
			-- counts groups of repeated characters.
			-- e.g., 'mississippi!!!' has 4 groups:
			--        sss, ss, pp and !!!.
			-- returns the number of such character groups
		local
			i: INTEGER
			nr: INTEGER -- number of repititions
		do
			from
				i := 2
				nr := 0
			until
				i >= word.count - 1
			loop
				if word[i] = word[i+1] then -- found repitition
					if word[i-1] /= word[i] then -- it's the start
						nr := nr + 1
					end
				end
				i := i + 1
			end
			Result := nr
		end

feature -- utilities
	find(c: CHARACTER; pos: INTEGER): INTEGER
		local
			i: INTEGER
			stop: BOOLEAN
		do
			from
				i := pos
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
		end


end
