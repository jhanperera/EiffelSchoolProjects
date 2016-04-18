note
	description: "Summary description for {WORD_ANALYZER_INTERFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WORD_ANALYZER_INTERFACE

feature {NONE} -- Initialization

	make(a_word: STRING)
			-- Init
		do
			word := a_word
			io.put_string (word)
		ensure
			word = a_word
		end

feature-- queries
	word: STRING

feature -- commands

	first_repeated_character: CHARACTER
		 -- returns first repeated character or null character if none found
		 -- a character is repeated if it occurs at least twice in adjacent positions
		 -- e.g. 'l' is repeated in "hollow", but 'o' is not.
		deferred
		end

	first_multiple_character: CHARACTER
		-- Returns first multiply occuring character, or null if not found.
		-- A character is multiple if it occurs twice in a word,
		-- not neceassarily in adajacent positions.
		-- E.g. both 'o' and 'l' are multiple in "hollow", but 'h' is not.
		deferred
		end

	count_repeated_characters: INTEGER
			-- counts groups of repeated characters.
			-- e.g., 'mississippi!!!' has 4 groups: ss, ss, pp and !!!.
			-- returns the number of such character groups
		deferred
		end

feature -- utilities
	comment(s:READABLE_STRING_32): BOOLEAN
		do
			Result := true
		end

end
