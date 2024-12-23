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
	loc_txt = {
		name ="7 Beat Games Deck",
		text={
			"Start with a Deck",
			"full of {C:attention}Sevens{}",
		},
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


Jonklers


]] 

SMODS.Joker { -- Speed trial
  key = 'Speed_trial',
  loc_txt = {
    name = 'Speed trial',
    text = {
        "Gains {X:mult,C:white}x#2#{} Mult when {C:attention}blind{} is selected",
        "Loses {X:mult,C:white}x#3#{} Mult when {C:attention}discarding{}",
        "{C:inactive}Currently {X:mult,C:white}x#1#{C:inactive} Mult{}",
        "{C:inactive,s:0.8}(Mult can't go below 1x)"
    }
  },
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
  loc_txt = {
    name = 'Battleworn Insomniac',
    text = {
      "{X:mult,C:white}x#1#{} Mult every {C:attention}#4#th{} played #2#",
      "{C:inactive}#3# remaining{}"
    }
  },
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
  loc_txt = {
    name = 'Fire and Ice',
    text = {
      "When hand is played, alternate",
      "between {X:chips,C:white}x2{} Chips and {X:mult,C:white}x2{} Mult",
      "{C:inactive}Currently {#4#}x#1#{C:inactive} #5#{}"
    }
  },
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
  loc_txt = {
    name = 'Oneshot',
    text = {
      "Gains {X:mult,C:white}x#4#{} Mult",
      "when {C:attention}played hand{}",
      "has {C:attention}1{} card",
      "{C:inactive} (Currently {X:mult,C:white}x#3#{C:inactive} Mult){}",
      "{C:inactive,s:0.7}(Idea by {C:dark_edition,s:0.7}#1#{C:inactive,s:0.7}){}",
      "{C:inactive,s:0.7}(Sprite by {C:dark_edition,s:0.7}#2#{C:inactive,s:0.7}){}"
    }
  },
  config = { extra = { idea = "deathmodereal", sprite = "k_lemun" ,  Xmult = 1.0 , Xmult_gain = 0.1 } },
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
  loc_txt = {
    name = 'Practice mode',
    text = {
      "{C:chips}#1#{} Chips",
      "Gains {C:chips}+#2#{} Chips per {C:attention}discarded card{}",
      "Resets when {C:attention:}boss blind{} is defeated",
      "{C:inactive} (Currently {C:chips}#3##1#{C:inactive} Chips){}",
      "{C:inactive,s:0.8}(Cannot subtract Chips){}"
    }
  },
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
  loc_txt = {
    name = 'Spin to Win',
    text = {
      "Gains {X:mult,C:white}x#2#{} Mult every time the", 
      "shop is {C:attention}rerolled{} or the",
      "{C:attention} wheel of fortune{} is used",
      "{C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} Mult){}"
    }
  },
  rarity = 3,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 3 , y = 0},
  config = { extra = { Xmult = 1.0 , Xmult_gain = 0.1} },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.Xmult,
        card.ability.extra.Xmult_gain
        -- text = {"Whatever the fuck"}
    } }
  end,
  calculate = function(self, card, context)
    if context.using_consumeable or context.reroll_shop then
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

SMODS.Joker { -- Midspin
  key = 'midspin',
  loc_txt = {
    name = 'Midspin',
    text = {
      "Gains {C:mult}+#2#{} Mult every time a", 
      "card is {C:attention}retriggered{}",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}",
      '{C:inactive,s:0.8}"It\'s called a midspin cuz you spin it in the middle of your turn"{}'
    }
  },
  rarity = 2,
  cost = 6,
  atlas = "adofai-jokers-1",
  pos = { x = 4 , y = 0},
  config = { extra = { mult = 0 , mult_gain = 3 , times_fired = 0 , timse_to_fire = 0} },
  loc_vars = function(self, info_queue, card)
    return { vars = {
        card.ability.extra.mult,
        card.ability.extra.mult_gain,
        card.ability.extra.times_fired,
        card.ability.extra.times_to_fire
    } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.times_fired = 0
      card.ability.extra.times_to_fire = #context.full_hand
    end
    if context.repetition and card.ability.extra.times_fired < card.ability.extra.times_to_fire then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
      card.ability.extra.times_fired = card.ability.extra.times_fired + 1
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


--[[

Spectral

]]
SMODS.Consumable {
  key = "twirl",
  set = "Spectral",
  atlas = "spectral",
  pos = { x = 0 , y = 0},
  loc_txt = {
    name = "Twirl",
    text = {
      "Changes the suit of each card ",
      "in the entirety of your deck.",
      "{C:inactive} (Spades > Diamonds{}",
      "{C:inactive}> Club > Hearts){}"
    }
  },
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