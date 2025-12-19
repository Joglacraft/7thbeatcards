SMODS.Blind {
	key = "zodiac",
	dollars = 5,
	mult = 2,
	atlas = 'blind',
	pos = { x = 0, y = 0 },
	boss_colour = HEX('b93d2e'),
	boss = {min = 0, max = 8},
	recalc_debuff = function (self, card, from_blind)
		if card.area ~= G.jokers and not G.GAME.blind.disabled then
			if card.config.center == G.P_CENTERS.m_sbc_ice or card.config.center == G.P_CENTERS.m_sbc_fire then
				return true
			end
			return false
		end
	end,
}

--[[
SMODS.Blind {
	key = "overseer",
	dollars = 5,
	mult = 2,
	atlas = 'blind',
	pos = { x = 0, y = 0 },
	boss_colour = HEX('ffffff'),
	boss = {min = 8, max = 8},
	recalc_debuff = function (self, card, from_blind)
		if card.area ~= G.jokers and not G.GAME.blind.disabled then
			if card.config.center == G.P_CENTERS.m_sbc_ice or card.config.center == G.P_CENTERS.m_sbc_fire then
				return true
			end
			return false
		end
	end,
}
--]]
