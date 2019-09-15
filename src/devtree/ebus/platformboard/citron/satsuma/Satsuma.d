const AHDBCmdPort 0x19
const AHDBPortA 0x1A
const AHDBPortB 0x1B

const AHDBCmdSelect 0x1
const AHDBCmdRead 0x2
const AHDBCmdWrite 0x3
const AHDBCmdInfo 0x4
const AHDBCmdPoll 0x5

const AHDBBuffer 0xF8020000

var AHDBDMANode 0
var AHDBDMATransfer 0

struct AHDB_VDB
	16 Label
	128 PartitionTable
	4 Magic
endstruct

struct AHDB_PTE
	8 Label
	4 Blocks
	1 Status
	3 Unused
endstruct

procedure AHDBDMATransferBlock (* src dest -- *)
	auto dest
	dest!

	auto src
	src!

	if (AHDBDMANode@ 0 ==)
		auto ndma
		"/dma" DevTreeWalk ndma!

		if (ndma@ 0 ~=)
			ndma@ AHDBDMANode!

			ndma@ DeviceSelectNode
				"transfer" DGetMethod AHDBDMATransfer!
			DeviceExit
		end
	end

	if (AHDBDMANode@ 0 ~=)
		AHDBDMANode@ DeviceSelectNode
			src@ dest@
			4 4
			1024
			2
			AHDBDMATransfer@ Call
		DeviceExit
	end else
		dest@ src@ 4096 memcpy
	end
end

procedure AHDBPartitions (* id -- *)
	auto id
	id!

	auto vdbuf
	4096 Malloc vdbuf!

	if (vdbuf@ 0 AHDBRead)
		if (vdbuf@ AHDB_VDB_Magic + @ 0x4E4D494C ==)
			auto i
			0 i!

			auto pc
			0 pc!

			auto offset
			2 offset!

			while (i@ 8 <)
				auto ptr
				AHDB_PTE_SIZEOF i@ * vdbuf@ + ptr!

				if (ptr@ AHDB_PTE_Status + gb 0 ~=)
					auto char
					2 Calloc char!
					'a' pc@ + char@ sb

					DeviceNew
						char@ DSetName

						id@ "id" DAddProperty
						ptr@ AHDB_PTE_Blocks + @ "blocks" DAddProperty
						offset@ "offset" DAddProperty

						"logical" "type" DAddProperty

						pointerof AHDBRead "readBlock" DAddMethod
						pointerof AHDBWrite "writeBlock" DAddMethod

						DevCurrent@
					DeviceExit

					auto dn
					dn!

					ptr@ AHDB_PTE_Blocks + @ offset@ + offset!

					pc@ 1 + pc!
				end

				i@ 1 + i!
			end
		end
	end

	vdbuf@ Free
end

procedure BuildSatsuma (* -- *)
	DeviceNew
		"dks" DSetName

		auto i
		0 i!
		while (i@ 8 <)
			auto present
			auto blocks

			i@ AHDBPoll blocks! present!

			if (present@ 1 ==)
				DeviceNew
					auto lilbuf
					5 Calloc lilbuf!
					i@ lilbuf@ itoa
					lilbuf@ DSetName

					i@ "id" DAddProperty
					blocks@ "blocks" DAddProperty
					0 "offset" DAddProperty

					"disk" "type" DAddProperty

					pointerof AHDBRead "readBlock" DAddMethod
					pointerof AHDBWrite "writeBlock" DAddMethod

					i@ AHDBPartitions
					DevCurrent@
				DeviceExit

				auto dn
				dn!
			end

			i@ 1 + i!
		end
	DeviceExit
end

procedure AHDBRead (* ptr block -- ok? *)
	auto rs
	InterruptDisable rs!

	auto block
	block!

	auto ptr
	ptr!

	auto id
	"id" DGetProperty id!

	if (block@ "blocks" DGetProperty >=) rs@ InterruptRestore ERR return end

	"offset" DGetProperty block@ + block!

	id@ AHDBSelect

	block@ AHDBPortA DCitronOutl
	AHDBCmdRead AHDBCmdPort DCitronCommand

	AHDBBuffer ptr@ AHDBDMATransferBlock

	rs@ InterruptRestore

	1
end

procedure AHDBWrite (* ptr block -- ok? *)
	auto rs
	InterruptDisable rs!

	auto block
	block!

	auto ptr
	ptr!

	auto id
	"id" DGetProperty id!

	if (block@ "blocks" DGetProperty >=) rs@ InterruptRestore ERR return end

	"offset" DGetProperty block@ + block!

	id@ AHDBSelect

	ptr@ AHDBBuffer AHDBDMATransferBlock

	block@ AHDBPortA DCitronOutl
	AHDBCmdWrite AHDBCmdPort DCitronCommand

	rs@ InterruptRestore

	1
end

procedure AHDBPoll (* id -- blocks present? *)
	auto id
	id!

	auto rs
	InterruptDisable rs!

	id@ AHDBPortA DCitronOutl

	AHDBCmdPoll AHDBCmdPort DCitronCommand

	AHDBPortA DCitronInl
	AHDBPortB DCitronInl

	rs@ InterruptRestore
end

procedure AHDBInfo (* -- event details *)
	auto rs
	InterruptDisable rs!

	AHDBCmdInfo AHDBCmdPort DCitronCommand
	AHDBPortA DCitronInb
	AHDBPortB DCitronInb

	rs@ InterruptRestore
end

procedure AHDBSelect (* drive -- *)
	auto drive
	drive!

	auto rs
	InterruptDisable rs!

	drive@ AHDBPortA DCitronOutl
	AHDBCmdSelect AHDBCmdPort DCitronCommand

	rs@ InterruptRestore
end