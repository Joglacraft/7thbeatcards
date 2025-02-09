SMODS.Joker { -- Fire and Ice
  key = 'ADOFAI',
  rarity = 2,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 1 , y = 0},
  config = { extra = { Xmult = 2 , Xchips = 2 , isFire= false , status_a = "X:chips,C:white" , status_b = "Chips"} },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.Xmult,
        card.ability.extra.Xchips,
        card.ability.extra.isFire,
        card.ability.extra.status_a,
        card.ability.extra.status_b
    } }
  end,
  calculate = function (self,card,context) 
    if context.joker_main then
      if not context.blueprint then
        if card.ability.extra.isFire then -- Fire means mult
          card.ability.extra.isFire = false
          card.ability.extra.status_a = "X:mult,C:white"
          card.ability.extra.status_b = "Chips"
          return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult } }),
          }
        else -- Ice means chips
          card.ability.extra.isFire = true 
          card.ability.extra.status_a = "X:chips,C:white"
          card.ability.extra.status_b = "Mult"
          return {
            message = localize({ type = "variable", key = "a_xchips", vars = { card.ability.extra.Xchips } }),
            Xchip_mod = card.ability.extra.Xchips,
            colour = G.C.CHIPS
        }
        end
      end
    end
  end
}

SMODS.Joker { -- Speed trial
  key = 'Speed_trial',
  config = { extra = { Xmult = 1.0 , Xmult_gain = 0.2 , Xmult_lose = 0.1} },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain , card.ability.extra.Xmult_lose} }
  end,
  rarity = 3,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 0 , y = 0},
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult_mod = card.ability.extra.Xmult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
      }
    end
    if context.setting_blind then
      card.ability.extra.Xmult = ( card.ability.extra.Xmult + card.ability.extra.Xmult_gain )
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
    end
    if context.pre_discard then
      if card.ability.extra.Xmult > 1.0 then
        card.ability.extra.Xmult = ( card.ability.extra.Xmult - card.ability.extra.Xmult_lose )
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Downgrade!"})
      end
    end
  end
}

SMODS.Joker { --Practice mode
  key = 'practice_mode',
  atlas = "adofai-jokers-1",
  pos = { x = 8 , y = 0},
  config = { extra = { chips = -20 , chips_gain = 5, prefix = ""} },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.chips ,
        card.ability.extra.chips_gain,
        card.ability.extra.prefix
      } }
    end,
    calculate = function(self, card, context)
      if G.GAME.blind.boss and context.end_of_round and not context.repetition and not context.individual then
        card.ability.extra.chips = -20
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset!"})
        card.ability.extra.prefix = ""
      end
      if context.joker_main and card.ability.extra.chips >= 0 then
        return {
          chip_mod = card.ability.extra.chips,
          message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
        }
      end
      if context.discard then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
        if card.ability.extra.chips >= 0 then
          card.ability.extra.prefix = "+"
        end
      end
    end
}

SMODS.Joker { -- Spin 2 win
  key = 'spin2win',
  rarity = 3,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 3 , y = 0},
  config = { extra = { Xmult = 1.0 , Xmult_gain = 0.2} },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.Xmult,
        card.ability.extra.Xmult_gain
        -- text = {"Whatever the fuck"}
    } }
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable.ability.name == "The Wheel of Fortune" then
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
    end
    if context.joker_main and ( card.ability.extra.Xmult > 1.00) then
      return {
        Xmult_mod = card.ability.extra.Xmult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
      }
    end
  end
}

SMODS.Joker { -- NHH
  key = 'NHH',
  rarity = 2,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 7 , y = 0},
  config = {  extra = { 
    Xmult = 1.0,
    Xmult_min = 110,
    Xmult_max = 200,
  } }, -- xmult is times 100 because of the random function not liking decimals.
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.idea,
        card.ability.extra.sprite,
        card.ability.extra.Xmult,
        card.ability.extra.Xmult_min,
        card.ability.extra.Xmult_max,
    } }
  end,
  calculate = function (self, card, context)
    if context.joker_main then
      card.ability.extra.Xmult = (pseudorandom("Charla", card.ability.extra.Xmult_min, card.ability.extra.Xmult_max)/100)
      return {
        mult_mod = card.ability.extra.Xmult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
      }
    end
  end
}

SMODS.Joker { --Third sun
  key = 'third_sun',
  rarity = 2,
  cost = 5,
  atlas = "adofai-jokers-1",
  pos = { x = 2 , y = 0},
  config = { extra = { chips = 0, chips_gain = 5, mult = 0, mult_gain = 3, other_ice = 0, other_fire = 0 } },
  update = function(self, card, dt)
        if not G.SETTINGS.paused and G.jokers then
            card.ability.extra.other_ice = 0
            card.ability.extra.other_fire = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_sbc_ice then card.ability.extra.other_ice = card.ability.extra.other_ice + 1
                 card.ability.extra.chips = card.ability.extra.chips_gain * card.ability.extra.other_ice end
                if v.config.center == G.P_CENTERS.m_sbc_fire then card.ability.extra.other_fire = card.ability.extra.other_fire + 1
                 card.ability.extra.mult = card.ability.extra.mult_gain * card.ability.extra.other_fire end
            end
        end
    end,
    
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.extra.chips,
            center.ability.extra.chips_gain,
            center.ability.extra.mult,
            center.ability.extra.mult_gain
        }}
    end,

    calculate = function(self, card, context)
     if context.joker_main then
            return {
            mult_mod = card.ability.extra.mult,
            chips = card.ability.extra.chips,
             message = { "Me when:" }
            }
        end
    end
}

SMODS.Joker { --Third sun
  key = 'totonou',
  rarity = 2,
  cost = 5,
  atlas = "adofai-jokers-1",
  pos = { x = 9 , y = 0},
  config = { extra = { Xmult = 2 } },
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.extra.Xmult
        }}
    end,

    calculate = function(self, card, context)
	local fried = 0
	local rice = 0
	if G.jokers and context.joker_main then
	for k, v in ipairs(context.scoring_hand) do
                if v.config.center == G.P_CENTERS.m_sbc_ice then
				rice = 1
				end
			end
	for k, v in ipairs(context.scoring_hand) do
                if v.config.center == G.P_CENTERS.m_sbc_fire then
				fried = 1
				end
			end
	if fried == 1 and rice == 1 then
            return {
            Xmult_mod = card.ability.extra.Xmult,
			message = 'X' .. card.ability.extra.Xmult
            }
		end
		end
		end
}