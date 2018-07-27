if !exists(':Tabularize')
	finish
endif

AddTabularPattern! markdown_table /\(^\|| \| |\|$\)/l0c1
