externptr MonitorRunning (* var *)

externptr MonitorCommandList (* var *)

externptr MonitorLine (* var *)
externptr MonitorLinePoint (* var *)

externptr MonitorState (* var *)

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
extern MonitorExit { -- }

extern MonitorParseDevPath { -- dev }

extern MonitorPrompt { -- }

extern MonitorDoLine { -- }

extern MonitorParseWord { -- word }

extern MonitorDoCommand { name -- ok }

extern MonitorAddCommand { helptext callback name -- }

extern ResetLines { -- }

extern WaitNext { -- result }