#include "<df>/dragonfruit.h"
#include "<inc>/aixo.h"

procedure AIXOValidate { aixo -- good }
	if (aixo@ AIXOHeader_Magic + @ AIXOMagic ==)
		1 good!
	end else
		0 good!
	end
end

procedure AIXOSymbolByName { name aixo -- value }
	auto symtab
	aixo@ AIXOHeader_SymbolTableOffset + @ aixo@ + symtab!

	auto stringtab
	aixo@ AIXOHeader_StringTableOffset + @ aixo@ + stringtab!

	auto symcount
	aixo@ AIXOHeader_SymbolCount + @ symcount!

	auto ptr
	symtab@ ptr!

	auto max
	symcount@ AIXOSymbol_SIZEOF * symtab@ + max!

	-1 value!

	while (ptr@ max@ <)
		auto sn
		ptr@ AIXOSymbol_Name + @ stringtab@ + sn!

		if (sn@ name@ strcmp)
			ptr@ AIXOSymbol_Value + @ value!
			break
		end

		AIXOSymbol_SIZEOF ptr +=
	end
end

procedure AIXOCode { aixo -- codeoff }
	aixo@ AIXOHeader_CodeOffset + @ aixo@ + codeoff!
end

procedure AIXOCodeType { aixo -- codetype }
	aixo@ AIXOHeader_CodeType + gb codetype!
end