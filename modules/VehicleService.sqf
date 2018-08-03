/*
 *	Vehicle Service
 *
*/

dzn_CG_fnc_serviceVehicle = {
	private _title = "";
	private _veh = vehicle player;
	
	switch (_this) do {
		case 0: {
			_title = "Repaired";
			_veh setDamage 0;
		};
		case 1: {
			_title = "Refueled";
			_veh setFuel 1;
		};
		case 2: {
			_title = "Rearmed";
			_veh setVehicleAmmo 1;
		};
		case 3: {
			_title = "Driver added";
			private _grp = createGroup (side player);
			private _u = _grp createUnit [typeof player, getPos _veh, [], 0, "FORM"];
			_u assignAsDriver _veh;
			_u moveInDriver _veh;	
		};
		case 4: {
			openMap false;
			
			_title = "Set In Flight";
			_veh engineOn true;
			private _pos = getPosASL _veh;
			
			_veh setPosATL [_pos select 0, _pos select 1, 200];
			if (getPosASL _veh select 2 < 10) exitWith { _title = "Set In Flight -- Aborted"; };
			
			_veh setVelocityModelSpace [0, if (_veh isKindOf "Plane") then { 100 } else { 50 }, 0];
		};
	};

	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />%1", toUpper(_title)];
};
