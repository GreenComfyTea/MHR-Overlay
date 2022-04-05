local ailments = {};
local player;

--0 Paralyze
--1 Sleep
--2 Stun
--3 Flash
--4 Poison
--5 Blast
--6 Stamina
--7 MarionetteStart
--8 Water
--9 Fire
--10 Ice
--11 Thunder
--12 FallTrap
--13 ShockTrap
--14 Capture
--15 Koyashi
--16 SteelFang

ailments.poison_id = 4;
ailments.blast_id = 5;

function ailments.apply_ailment_buildup(monster, attacker_id, ailment_type, ailment_buildup)
	if monster == nil or player == nil or (ailment_type ~= ailments.poison_id and ailment_type ~= ailments.blast_id) then
		return;
	end

	-- get the buildup accumulator for this type
	if monster.ailment[ailment_type].buildup == nil then
		monster.ailment[ailment_type].buildup = {};
	end
	
	-- accumulate this buildup for this attacker
	monster.ailment[ailment_type].buildup[attacker_id] = (monster.ailment[ailment_type].buildup[attacker_id] or 0) + ailment_buildup;
end

-- Code by coavins
function ailments.calculate_ailment_contribution(monster, ailment_type)
	-- get total
	local total = 0;
	for attacker_id, player_buildup in pairs(monster.ailment[ailment_type].buildup) do
		total = total + player_buildup;
	end

	for attacker_id, player_buildup in pairs(monster.ailment[ailment_type].buildup) do
		-- update ratio for this attacker
		monster.ailment[ailment_type].share[attacker_id] = player_buildup / total;
		-- clear accumulated buildup for this attacker
		-- they have to start over to earn a share of next ailment trigger
		monster.ailment[ailment_type].buildup[attacker_id] = 0;
	end
end

-- Code by coavins
function ailments.apply_ailment_damage(monster, ailment_type, ailment_damage)
	-- we only track poison and blast for now
	if ailment_type == nil or ailment_damage == nil then
		return;
	end

	local damage_source_type = "";
	if ailment_type == ailments.poison_id then
		damage_source_type = "poison";
	elseif ailment_type == ailments.blast_id then
		damage_source_type = "blast";
	else
		return;
	end

	local damage = ailment_damage;


	-- split up damage according to ratio of buildup on boss for this type
	for attacker_id, percentage in pairs(monster.ailment[ailment_type].share) do
		local damage_portion = damage * percentage;
		
		local damage_object = {};
		damage_object.total_damage = damage_portion;
		damage_object.physical_damage = 0;
		damage_object.elemental_damage = 0;
		damage_object.ailment_damage = damage_portion;
		
		local attacking_player = player.get_player(attacker_id);
		
		if attacking_player ~= nil then
			player.update_damage(attacking_player, damage_source_type, true, damage_object);
		end

		player.update_damage(player.total, damage_source_type, true, damage_object);
	end

	
end

function ailments.init_module()
	player = require("MHR_Overlay.Damage_Meter.player");
end

return ailments;