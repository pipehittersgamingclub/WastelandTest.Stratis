// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Description: The main init.

#define DEBUG false

enableSaving [false, false];

// block script injection exploit
inGameUISetEventHandler ["PrevAction", ""];
inGameUISetEventHandler ["Action", ""];
inGameUISetEventHandler ["NextAction", ""];

_descExtPath = str missionConfigFile;
currMissionDir = compileFinal str (_descExtPath select [0, count _descExtPath - 15]);

X_Server = false;
X_Client = false;
X_JIP = false;

// versionName = ""; // Set in STR_WL_WelcomeToWasteland in stringtable.xml

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

A3W_scriptThreads = [];

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "storeConfig.sqf"; // Separated as its now v large
[] execVM "briefing.sqf";


if (!isDedicated) then
{
	[] spawn
	{
		if (hasInterface) then // Normal player
		{
			9999 cutText ["Welcome to Pipehitters A3Wasteland, please wait while your client initializes.", "BLACK", 0.01];

			waitUntil {!isNull player};
			removeAllWeapons player;
			client_initEH = player addEventHandler ["Respawn", { removeAllWeapons (_this select 0) }];

			// Reset group & side
			[player] joinSilent createGroup playerSide;
			player setVariable ["playerSpawning", true, true];

			execVM "client\init.sqf";
		}
		else // Headless
		{
			waitUntil {!isNull player};
			if (typeOf player == "HeadlessClient_F") then
			{
				execVM "client\headless\init.sqf";
			};
		};
	};
};

if (isServer) then
{
	diag_log format ["############################# %1 #############################", missionName];
	diag_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts

[] execVM "addons\R3F_LOG\init.sqf";
[] execVM "addons\proving_ground\init.sqf";
[] execVM "addons\scripts\DynamicWeatherEffects.sqf";
[] execVM "addons\JumpMF\init.sqf";
[] execVM "addons\outlw_magRepack\MagRepack_init.sqf"; // Repack your near empty clips
[] execVM "addons\laptop\init.sqf";		 // hack Laptop mission addon
// [] execVM "addons\safezone\safezone.sqf"; //safezones temporarily disabled
[] execVM "addons\vactions\functions.sqf"; //vehicle actions
[] execVM "addons\HvT\HvT.sqf"; // High Value Target
[] execVM "addons\TearGas\tear_gas.sqf"; // teargass bitches !
[] execVM "addons\APOC_Airdrop_Assistance\init.sqf";
[] execVM "addons\zlt_fastrope\zlt_fastrope.sqf";
[] execVM "addons\AF_Keypad\AF_KP_vars.sqf";			// Keypad for base locking
if (isServer) then {call compile preprocessFile "mapconfig\structures\initBuildings.sqf";}; // GID Positioning System

//Client Announcements
if (!(isServer)) then 
{
ClientPreComp_AnnounceMessages = compileFinal preprocessFileLineNumbers "addons\announceMessages\client_AnnounceMessages.sqf";

[] call ClientPreComp_AnnounceMessages;
};
