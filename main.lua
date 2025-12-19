local config = SMODS.current_mod.config
local debug_mode = true


--[[

Load everything

]]

local contents = {
  "util",
  "atlas",
  "joker",
  "tarot",
  "spectral",
  'enhancement',
  "misc"
}


for k, v in pairs(contents) do
  assert(SMODS.load_file('/scr/'..v..'.lua'))()
end

if debug_mode then _RELEASE_MODE = false end -- DEBUG MODE

if debug_mode then
SMODS.Back{
	name = "7 Beat Games Deck",
	key = "sbg",
  atlas = "back",
	pos = {x = 0, y = 0},
	config = {
    ante_scaling = 0.7, 
  },
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
          for k, v in ipairs(G.playing_cards) do
            if v:get_id() == 7 then
              if v:is_suit("Spades") or v:is_suit("Hearts") then
                  v:set_ability(G.P_CENTERS["m_sbc_fire"])
              end
              if v:is_suit("Clubs") or v:is_suit("Diamonds") then
                v:set_ability(G.P_CENTERS["m_sbc_ice"])
              end
            end
				  end
				return true
			end
		}))
	end
}
end

--[[

  Config tab, prob

]]

--[[
 SMODS.current_mod.config_tab = function()
 	return {n = G.UIT.ROOT, config = {
 		-- config values here, see 'Building a UI' page
 	}, nodes = {
 		-- work your UI wizardry here, see 'Building a UI' page
 	}}
 end
]]

--[[

  Atlases

]]


--[[

Fire and Ice

]]


--[[

Jonklers / Debug

]] 

if debug_mode then
  SMODS.Joker { -- CC joker 1
    key = 'Chrysanthemum',
    config = { extra = { value_1 = 0} },
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.value_1 } }
    end,
    rarity = 4,
    cost = 6,
    atlas = "rd-jokers-1",
    pos = { x = 2 , y = 0},
    calculate = function(self, card, context)
      if context.setting_blind or context.before or context.pre_discard then
        card.ability.extra.value_1 = #G.deck.cards
      end
    end
  }
end

if debug_mode then
  SMODS.Joker { -- Midspin
    key = 'midspin',
    rarity = 2,
    cost = 6,
    atlas = "adofai-jokers-1",
    pos = { x = 4 , y = 0},
    config = { extra = { mult = 7 , mult_gain = 7 } },
    loc_vars = function(self, info_queue, card)
      return { vars = {
          card.ability.extra.mult,
          card.ability.extra.mult_gain,
      } }
    end,
    calculate = function(self, card, context)
      if ( context.repetition and context.other_card.seal == "Red" and context.cardarea == G.play) then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
      end
      if context.joker_main then
        return {
          mult_mod = card.ability.extra.mult,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        }
      end
    end
  }
end


