externconst MonitorRunning (* var *)

externconst MonitorCommandList (* var *)

externconst MonitorLine (* var *)
externconst MonitorLinePoint (* var *)

externconst MonitorState (* var *)

struct MonitorCommand
	4 Name
	4 Callback
	4 HelpText
endstruct

struct MonitorI
	4 Running
	4 Line
	4 LinePoint
endstruct

(* should be called before any command leaves the monitor, for instance 'boot' *)
extern MonitorExit (* -- *)

extern MonitorParseDevPath (* -- dev or 0 *)

extern MonitorPrompt (* -- *)

extern MonitorDoLine (* -- *)

extern MonitorParseWord (* -- word *)

extern MonitorDoCommand (* command -- ok? *)

extern MonitorAddCommand (* helptext callback name -- *)

extern ResetLines (* -- *)

extern WaitNext (* -- result *)