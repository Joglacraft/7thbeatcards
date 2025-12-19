SMODS.Joker { -- Samurai
  key = 'samurai',
  rarity = 1,
  cost = 6,
  atlas = "rd-jokers-1",
  pos = { x = 6 , y = 0},
  config = {  extra = { mult = 7 } },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.mult
    } }
  end,
  calculate = function (self, card, context)
     if context.cardarea == G.play and context.individual and context.other_card:get_id() == 7 then
      return {
        mult = card.ability.extra.mult
      }
    end
  end
}

SMODS.Joker { --Oneshot
  key = 'oneshot',
  config = { extra = { idea = "deathmodereal", sprite = "k_lemun" ,  Xmult = 1.0 , Xmult_gain = 0.05 } },
  loc_vars = function(self, info_queue, card)
    return { vars = {
      card.ability.extra.idea,
      card.ability.extra.sprite,
      card.ability.extra.Xmult,
      card.ability.extra.Xmult_gain
      } }
    end,
    rarity = 2,
    cost = 6,
    atlas = "rd-jokers-1",
    pos = { x = 1 , y = 0},

    calculate = function(self, card, context)
      if context.before and context.cardarea == G.jokers and #context.full_hand == 1 and not context.blueprint then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
      end
      if context.joker_main then
        return {
          Xmult_mod = card.ability.extra.Xmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
        }
      end
    end
}

SMODS.Joker { -- Battleworn insomniac
  key = 'battleworn_insomniac',
  atlas = "rd-jokers-1",
  pos = { x = 5 , y = 0},
  config = { extra = { Xmult = 2.0, rank = 7 , count = 0 , active = 7 , status = false} },
  loc_vars = function(self, info_queue, card)
    return { vars = { 
      card.ability.extra.Xmult , 
      card.ability.extra.rank , 
      ( card.ability.extra.active - card.ability.extra.count ) ,
      card.ability.extra.active,
      card.ability.extra.status
    } }
  end,
  rarity = 3,
  cost = 6,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
      if card.ability.extra.count == (card.ability.extra.active - 1) then
        card.ability.extra.count = 0
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Active!"})
        card.ability.extra.status = true
      elseif not context.blueprint then
        -- Increase the counter
        card.ability.extra.count = card.ability.extra.count + 1
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = (( card.ability.extra.active - card.ability.extra.count ).." more!")})
      end
    end
    if context.joker_main and card.ability.extra.status then
      card.ability.extra.status = false
      return {
        Xmult_mod = card.ability.extra.Xmult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
      }
  end
end
}

SMODS.Joker { -- Skipshot
  key = 'skipshot',
  config = { extra = { 
    dollars = 1, 
    skipped = 0,
    x_dollars = 3
  } },
  loc_vars = function(self, info_queue, card)
    return { vars = { 
      card.ability.extra.dollars, 
      card.ability.extra.skipped,
      card.ability.extra.x_dollars
  } }
  end,
  rarity = 2,
  cost = 6,
  atlas = "rd-jokers-1",
  pos = { x = 3 , y = 0},
  calc_dollar_bonus = function(self, card)
    return card.ability.extra.dollars
  end,
  calculate = function(self, card, context)
    if context.skip_blind then
      card.ability.extra.skipped = card.ability.extra.skipped + 1
      card.ability.extra.dollars = (card.ability.extra.skipped * card.ability.extra.x_dollars) + 1
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
    end
  end
}

SMODS.Joker { -- Logun
  key = 'reduce',
  atlas = "rd-jokers-1",
  pos = { x = 4 , y = 0},
  rarity = 4,
  cost = 8,
  config = {  extra = { 
    blind_mult = 0.5,
  } }, -- xmult is times 100 because of the random function not liking decimals.
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.blind_mult
    } }
  end,
  calculate = function (self, card, context)
    if context.setting_blind then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Active!"})
      G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.blind_mult
      G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
      G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
      G.HUD_blind:recalculate() 
    end
  end
}

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
			remove_default_message = true,
			mult_mod = card.ability.extra.mult,
			chips = card.ability.extra.chips,
			message = '+' .. card.ability.extra.chips .. ' +' .. card.ability.extra.mult
			}
        end
    end
}

SMODS.Joker { --Totonou
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

SMODS.Joker { -- Emomomo
	key = 'emomomo',
	rarity = 3,
	cost = 5,
	atlas = "adofai-jokers-1",
	pos = { x = 1 , y = 0},
	config = { extra = { Xmult = 1, Xmult_gain = 0.1, mult = 0, mult_gain = 5, chips = 0, chips_gain = 10}},
	loc_vars = function(self, info_queue, center)
		return { vars = {
			center.ability.extra.Xmult,
			center.ability.extra.Xmult_gain,
			center.ability.extra.mult,
			center.ability.extra.mult_gain,
			center.ability.extra.chips,
			center.ability.extra.chips_gain,
		} }
	end,
	calculate = function(self, card, context)
		if context.individual then
            if context.cardarea == G.play then
				if context.other_card:is_face() then
					local chance = pseudorandom_element({1, 2, 3}, pseudoseed('bitch'))
					if chance == 1 then
						card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
					end
					if chance == 2 then
						card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
					end
					if chance == 3 then
						card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
					end
				end
			end
		end
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				mult_mod = card.ability.extra.mult,
				chips = card.ability.extra.chips,
			}
		end
	end
}