// Virtual Arsenal Supporter Customization - 
// by CRE4MPIE
// Inspired by fn_r3m3dy - thx xD
// PS: Arrays are a bitch


// Remember to change your createvehicle.txt to log for logic only and not kick ( 2 "^Logic")
// Add exception to antihack for BIS_fnc_arsenal,bis_fnc_setidentity in filterExecAttempt.sqf
// payload.sqf	if (!isNull (uiNamespace getVariable ["RscDisplayArsenal", displayNull]) && !_isAdmin) exitWith { _cheatFlag = "Virtual Arsenal" };


switch (_supporterLevel) do {			
		case 1: // Supporter
		{
		
		if (isDedicated) exitWith {};
		if !(hasinterface) exitwith {};

		["Preload"] call BIS_fnc_arsenal;
		private["_keyDown"];

		[] spawn {
			waitUntil {!isNull player && player == player};
			waitUntil{!isNil "BIS_fnc_init"};
			waituntil {!(IsNull (findDisplay 46))};
	
	private["_i", "_keyDown"];
   	_keyDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (_this select 1 == 210) then {['Open', true] call BIS_fnc_arsenal;}"];
				};
					
				["Open", true] spawn BIS_fnc_arsenal;	
			
				systemChat format["Welcome %1, You have a Supporter Loadout!", name player];
		};	
			
	};
	