local config = SMODS.current_mod.config
local debug_mode = false

local old_back_apply_to_run = Back.apply_to_run
function Back.apply_to_run(self)
  old_back_apply_to_run(self)
  if self.effect.config.sbc_speed_trial then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sbc_Speed_trial', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
  if self.effect.config.sbc_battleworn_insomniac then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sbc_battleworn_insomniac', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
  if self.effect.config.sbc_oneshot then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sbc_oneshot', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
  if self.effect.config.sbc_practice_mode then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sbc_practice_mode', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
  if self.effect.config.sbc_astro then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sbc_astro', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
  if self.effect.config.blueprint then
    G.E_MANAGER:add_event(Event({
      func = function()
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_blueprint', nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        return true
      end
    }))
  end
end


_RELEASE_MODE = false -- DEBUG MODE

SMODS.Back{
	name = "7 Beat Games Deck",
	key = "sbg",
	pos = {x = 1, y = 3},
	config = {
    only_one_rank = '7',
    ante_scaling = 1, 
  },
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
                for _, card in ipairs(G.playing_cards) do
					assert(SMODS.change_base(card, nil, self.config.only_one_rank))
				end
				return true
			end
		}))
	end
}

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

SMODS.Atlas { -- RD jokers
  key = "rd-jokers-1",
  path = "rd-jokers-1.png",
  px = 71,
  py = 95
}

SMODS.Atlas { -- ADOFAI jokers
  key = "adofai-jokers-1",
  path = "adofai-jokers-1.png",
  px = 71,
  py = 95
}

SMODS.Atlas { -- Spectal cards
  key = "spectral",
  path = "spectral.png",
  px = 128,
  py = 188
}

--[[

Fire and Ice

]]


if debug_mode then
  --[[
  SMODS.Enhancement({
    key = 'fire',
    config = {
      mult = 0,
      extra = {
        b_mult = 5,
        c_mult = 1,
      }
    },
    loc_vars = function (self)
      self.config.extra.c_mult = 0
      self.config.b_mult = 5
        for k, v in pairs(G.playing_cards) do
          if v.config.center == G.P_CENTERS.m_sbc_fire then 
            self.config.extra.c_mult = self.config.extra.c_mult + 1
          end
        end
      self.config.mult = self.config.extra.b_mult * self.config.extra.c_mult
      print("mult | ",self.config.mult)
      return {
        vars = { self.config.mult , self.config.extra.b_mult , self.config.extra.c_mult},
      }
    end,
  })
  ]]
  --[[
    SMODS.Enhancement({
    key = 'fire',
    config = {
      mult = 0,
      extra = {
        b_mult = 5,
        c_mult = 1,
      }
    },
    loc_vars = function (self, info_queue, card)
      return {
        vars = { self.config.mult , self.config.extra.b_mult , self.config.extra.c_mult},
      }
    end,
    calculate = function (self, card, context, effect)
      if context.individual then
        card.config.extra.c_mult = 0
        card.config.extra.b_mult = 5
          for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_sbc_fire then 
              card.config.extra.c_mult = card.config.extra.c_mult + 1
            end
          end
        card.config.mult = card.config.extra.b_mult * card.config.extra.c_mult
      end
    end
  })
  ]]
  --[[
  SMODS.Enhancement({
    key = 'fire',
    config = {
      mult = 0,
      extra = {
        b_mult = 5,
        c_mult = 1,
      }
    },
    loc_vars = function (self, info_queue, card)
      print(card.ability.b_mult)
      return {
        vars = { card.ability.mult, card.ability.extra.b_mult, card.ability.extra.c_mult},
      }
    end,
    calculate = function (self, card, context, effect)
      if context.individual then
        card.ability.extra.c_mult = 0
        card.ability.extra.b_mult = 5
          for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_sbc_fire then 
              card.ability.extra.c_mult = card.ability.extra.c_mult + 1
            end
          end
         card.ability.mult = card.ability.extra.b_mult * card.ability.extra.c_mult
      end
    end
  })
end
-]]

  SMODS.Enhancement({
    key = 'ice',
    config = {
      bonus = 10
    },
    loc_vars = function (self)
      return {
        vars = { self.config.bonus }
      }
    end
  })
end
--[[

Jonklers

]] 

if debug_mode then

  SMODS.Joker { -- Test Joker
    key = 'test_joker',
    config = { extra = { value_1 = 0} },
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.value_1 } }
    end,
    rarity = 4,
    cost = 6,
    calculate = function(self, card, context)
      if context.joker_main then
        C =  C + 2
        print(C)
      end
    end
  }



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

SMODS.Joker { -- Battleworn insomniac
  key = 'battleworn_insomniac',
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

SMODS.Joker { -- Fire and Ice
  key = 'ADOFAI',
  rarity = 2,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 1 , y = 0},
  config = { extra = { Xmult = 2.0 , Xchips = 2.0 , isFire= false , status_a = "X:chips,C:white" , status_b = "Chips"} },
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
        if card.ability.extra.isFire then
          card.ability.extra.isFire = false
          card.ability.extra.status_a = "X:mult,C:white"
          card.ability.extra.status_b = "Mult"
          return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmod } }),
          }
        else
          card.ability.extra.isFire = true
          card.ability.extra.status_a = "X:chips,C:white"
          card.ability.extra.status_b = "Chips"
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

SMODS.Joker { --Practice mode
  key = 'practice_mode',
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
SMODS.Joker { -- Samurai
  key = 'samurai',
  rarity = 1,
  cost = 6,
  atlas = "rd-jokers-1",
  pos = { x = 0 , y = 0},
  config = {  extra = { idea = "nil", sprite = "nil" , mult = 7 } },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.idea,
        card.ability.extra.sprite,
        card.ability.extra.mult
    } }
  end,
  calculate = function (self, card, context)
    if context.scoring_hand and context.cardarea == G.play and context.other_card:get_id() == 7 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}

SMODS.Joker { -- NHH
  key = 'NHH',
  rarity = 3,
  cost = 6,
  atlas = "rd-jokers-1",
  pos = { x = 0 , y = 0},
  config = {  extra = { idea = "nil", sprite = "nil" , Xmult = 1.0 , Xmult_min = 75 , Xmult_max = 150 } },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.idea,
        card.ability.extra.sprite,
        card.ability.extra.Xmult,
        card.ability.extra.Xmult_min,
        card.ability.extra.Xmult_max
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



--[[

Spectral

]]
if debug_mode then
  SMODS.Consumable {
    key = "twirl",
    set = "Spectral",
    atlas = "spectral",
    pos = { x = 0 , y = 0},
    can_use = function (self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local conv = {
          Spades = "Diamonds",
          Clubs = "Hearts",
          Diamonds = "Spades",
          Hearts = "Clubs",
      }
      for _, v in ipairs(G.deck.cards) do
          if conv[v.base.suit] then
              v:change_suit(conv[v.base.suit])
          end
      end
  end
  }
end