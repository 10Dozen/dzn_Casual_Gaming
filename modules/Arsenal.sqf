/*
 *	Arsenal & Garage
 *
*/

dzn_CG_fnc_openArsenal = {
	closeDialog 2;
	["Open", true] call BIS_fnc_Arsenal;
};

dzn_CG_fnc_openGarage = {
	closeDialog 2;

	BIS_fnc_garage_center = createVehicle ["Land_HelipadEmpty_F", player getPos [20,getDir player], [], 0, "CAN_COLLIDE" ];
	private _pos = getPosATL BIS_fnc_garage_center;
	
	["Open", true] call BIS_fnc_garage;	
	
	waitUntil { !isNull (uiNamespace getVariable "rscdisplaygarage") };	
	sleep 0.25;
	waitUntil {isNull (uiNamespace getVariable "rscdisplaygarage")};
	
	private _v = nearestObject [_pos, "AllVehicles"];
	private _vType = typeOf _v;
	private _vCustomizationStr = [_v,""] call BIS_fnc_exportVehicle;
	while { !((crew _v) isEqualTo []) } do {
		private _crewman = ((crew _v) select 0);
		moveOut _crewman;
		sleep 0.01;
		deleteVehicle _crewman;
	};
	
	deleteVehicle _v;
	
	sleep 0.25;
	private _nv = _vType createVehicle _pos;
	_nv setPosATL _pos;
	_nv call compile _vCustomizationStr;
	
	sleep 0.025;
	while { !((crew _nv) isEqualTo []) } do {
		private _crewman = ((crew _nv) select 0);
		moveOut _crewman;
		sleep 0.01;
		deleteVehicle _crewman;
	};
};
