#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

procedure NVRAMCheck (* -- ok? *)
	if (NVRAMHeader_Magic NVRAMOffset @ NVRAMMagic ==)
		1 return
	end
	0 return
end

procedure NVRAMFormat (* -- *)
	auto i
	0 i!
	while (i@ NVRAMSize <)
		0 i@ NVRAMOffset !
		4 i +=
	end

	NVRAMMagic NVRAMHeader_Magic NVRAMOffset !
end

procedure NVRAMOffset { loc -- nvaddr }
	if (loc@ NVRAMSize >=)
		0 nvaddr!
		return
	end

	loc@ NVRAMBase + nvaddr!
end

procedure NVRAMFindFree (* -- free or 0 *)
	auto i
	0 i!

	auto sp
	NVRAMHeader_SIZEOF sp!
	while (i@ NVRAMVarCount <)
		if (sp@ NVRAMOffset gb 0 ==)
			sp@ NVRAMOffset return
		end

		sp@ NVRAMVariable_SIZEOF + sp!
		1 i +=
	end

	0 return
end

procedure NVRAMDeleteVar { name -- }
	auto vl
	name@ NVRAMGetVar vl!

	if (vl@ 0 ==) return end

	0 vl@ NVRAMVariable_Contents - sb
end

procedure NVRAMSetVar { str name -- }
	auto vl
	name@ NVRAMGetVar vl!

	if (vl@ 0 ==) (* doesnt exist, we need to make it *)
		NVRAMFindFree vl!

		if (vl@ 0 ==) (* no free space, abort *)
			return
		end

		vl@ name@ strcpy
		vl@ NVRAMVariable_Contents + str@ strcpy
	end else
		vl@ str@ strcpy
	end
end

procedure NVRAMSetVarNum { num name -- }
	auto buf
	15 Calloc buf!

	num@ buf@ itoa
	buf@ name@ NVRAMSetVar

	buf@ Free
end

procedure NVRAMGetVar { name -- ptr }
	auto i
	0 i!

	auto sp
	NVRAMHeader_SIZEOF sp!
	while (i@ NVRAMVarCount <)
		if (sp@ NVRAMOffset name@ strcmp)
			sp@ NVRAMVariable_Contents + NVRAMOffset ptr!
			return
		end

		sp@ NVRAMVariable_SIZEOF + sp!
		1 i +=
	end

	0 ptr!
	return
end

procedure NVRAMGetVarNum (* var -- n *)
	NVRAMGetVar dup if (0 ~=) atoi return end
end