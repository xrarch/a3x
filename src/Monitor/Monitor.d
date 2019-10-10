#include "<df>/dragonfruit.h"
#include "<inc>/a3x.h"

var MonitorRunning 0
public MonitorRunning

var MonitorCommandList 0
public MonitorCommandList

var MonitorLine 0
public MonitorLine

var MonitorLinePoint 0
public MonitorLinePoint

var MonitorNvramrc 0
var MonitorOldCI 0
var MonitorOldCIM 0
var MonitorNvramrcBuf 0
var MonitorNvramrcLen 0
var MonitorNvramrcPtr 0
var MonitorPastNvramrc 0

#include "monitor.h"

extern MonitorCommandsInit

extern MonitorCommandBanner

procedure Monitor (* -- *)
	if (MonitorCommandList@ 0 ==)
		MonitorCommandsInit
	end

	1 MonitorRunning!

	if (MonitorLine@) MonitorLine@ Free end

	256 Calloc MonitorLine!

	MonitorCommandBanner

	while (MonitorRunning@)
		MonitorPrompt
		MonitorDoLine
	end

	MonitorExit
end

(* should be called before any command leaves the monitor, for instance 'boot' *)
procedure MonitorExit (* -- *)
	if (MonitorLine@) MonitorLine@ Free end
end

procedure MonitorParseDevPath (* -- dev or 0 *)
	auto word
	MonitorParseWord word!

	auto dev
	word@ DevTreeWalk dev!

	if (dev@ 0 ==)
		word@ " bad device path %s.\n" Printf
	end

	word@ Free
	dev@
end

procedure MonitorPrompt (* -- *)
	MonitorLine@ MonitorLinePoint!
	"  > " Printf
	MonitorLine@ 255 Gets
end

procedure MonitorDoLine (* -- *)
	auto word
	MonitorParseWord word!

	if (word@ strlen 0 ~=)
		if (word@ MonitorDoCommand ~~)
			word@ " %s is not a recognized command.\n" Printf
		end else return end
	end

	word@ Free
end

procedure MonitorParseWord { -- word }
	256 Calloc word!

	MonitorLinePoint@ word@ ' ' 255 strntok MonitorLinePoint!
end

procedure MonitorDoCommand { name -- ok }
	auto plist
	MonitorCommandList@ plist!

	auto n
	plist@ List_Head + @ n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue
		pnode!

		if (pnode@ MonitorCommand_Name + @ name@ strcmp)
			name@ Free

			pnode@ MonitorCommand_Callback + @ Call 1 ok! return
		end

		n@ ListNodeNext n!
	end

	0 ok!
end

procedure MonitorAddCommand { helptext callback name -- }
	auto command
	MonitorCommand_SIZEOF Calloc command!

	name@ command@ MonitorCommand_Name + !
	callback@ command@ MonitorCommand_Callback + !
	helptext@ command@ MonitorCommand_HelpText + !

	(* command@ MonitorCommand_HelpText + command@ MonitorCommand_Callback + command@ MonitorCommand_Name + "namep 0x%x\ncbp 0x%x\nhtp 0x%x\n" Printf *)

	command@ MonitorCommandList@ ListInsert
end




