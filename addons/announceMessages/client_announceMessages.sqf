//***************************************************************
//***************************************************************
//Coded by calibaan www.nomercykillers.com

//***************************************************************
//***************************************************************
private ["_MessagesToAnnounceStringArray","_DisplayTimesCheckArray","_MinimumSleepTimeScalar","_DisplayReadyMessageStringsArray","_MiniumTimeBetweenAnnouncementsScalar","_CurrentAnnouncementTimeCounterScalar","_UpdatedAnnouncementTimeScalar","_CompiledMessageDisplayString"];

/*
	The message announcement array has the following format: [Message to display, format String, Time between announcements, format scalar]
	For example:
	["Testmessage1 here!", 60], ["This is testmessage 2 displayed every 90 seconds!", 90]
*/

_MessagesToAnnounceStringArray = 

[ 
["Looking for an admin? Contact us on teamspeak - ts.pipehitters.us", 600],
["If you like the server then donate a beer, Ask about the details on Teamspeak", 1500], 
["This server is monitored 24/7 by admins, all actions are logged", 1000], 
["This server restarts every 6 hours to ensure optimal client performance !", 3600]
];

if ((count _MessagesToAnnounceStringArray) == 0) exitWith 
	{
	diag_log format ["** Automatic message announcement not used, the array is empty. **"];
	};

if (isNil ("CGV_MessageAnnouncementArray")) then
	{
		CGV_MessageAnnouncementArray = [];
	};

_DisplayTimesCheckArray = [];
{
CGV_MessageAnnouncementArray set [count CGV_MessageAnnouncementArray, [_x select 0, _x select 1, 0]];
_DisplayTimesCheckArray set [count _DisplayTimesCheckArray, _x select 1];
} forEach _MessagesToAnnounceStringArray;

_MinimumSleepTimeScalar = [_DisplayTimesCheckArray, 0] call BIS_fnc_findExtreme;
if (_MinimumSleepTimeScalar > 300) then 
	{
	_MinimumSleepTimeScalar = 300;
	};
_MinimumSleepTimeScalar = 5;

while {(true)} do 
	{
	_DisplayReadyMessageStringsArray = [];
	
		{
		_DisplayMessageString = _x select 0;
		_MiniumTimeBetweenAnnouncementsScalar = _x select 1;
		_CurrentAnnouncementTimeCounterScalar = _x select 2;
		
		if (_CurrentAnnouncementTimeCounterScalar >= _MiniumTimeBetweenAnnouncementsScalar) then 
			{
			_DisplayReadyMessageStringsArray set [count _DisplayReadyMessageStringsArray, _DisplayMessageString];
			_UpdatedAnnouncementTimeScalar = 0;
			}
			else
			{
			_UpdatedAnnouncementTimeScalar = _CurrentAnnouncementTimeCounterScalar + _MinimumSleepTimeScalar;
			};
		
		[CGV_MessageAnnouncementArray, [_forEachIndex, 2], _UpdatedAnnouncementTimeScalar] call BIS_fnc_setNestedElement;
		} forEach CGV_MessageAnnouncementArray;
	
	if ((count _DisplayReadyMessageStringsArray) != 0) then 
		{
		_CompiledMessageDisplayString = "";
		
			{
			_CompiledMessageDisplayString = _CompiledMessageDisplayString + _x;
			} forEach _DisplayReadyMessageStringsArray;
		
		cutText [_CompiledMessageDisplayString, "PLAIN DOWN", 2, false];
		};
	
	sleep _MinimumSleepTimeScalar;
	};