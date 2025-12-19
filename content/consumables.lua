--[[
  
Tarot

]]

SMODS.Consumable { -- Summer
  key = "summer",
  set = "Tarot",
  atlas = "tarot",
  pos = { x = 1 , y = 0},
  config = {
    extra = {
      cards = 3
    }
  },
  loc_vars = function(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.cards
      }
    }
  end,
  can_use = function(self,card)
    if G and G.hand then
        if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
            return true
        end
    end
    return false
end,
  use = function (self, card, area, copier)
    for i=1, #G.hand.highlighted do
      G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_sbc_fire"])
      G.hand.highlighted[i]:flip()
      G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.5,
        func = function()
          G.hand.highlighted[i]:flip()
          return true
        end
      }))
    end
  end
}

SMODS.Consumable { -- Winter
  key = "winter",
  set = "Tarot",
  atlas = "tarot",
  pos = { x = 0 , y = 0},
  config = {
    extra = {
      cards = 3
    }
  },
  loc_vars = function(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.cards
      }
    }
  end,
  can_use = function(self,card)
    if G and G.hand then
        if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
            return true
        end
    end
    return false
end,
  use = function (self, card, area, copier)
    for i=1, #G.hand.highlighted do
      G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_sbc_ice"])
      G.hand.highlighted[i]:flip()
      G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.5,
        func = function()
          G.hand.highlighted[i]:flip()
          return true
        end
      }))
    end
  end
}

SMODS.Consumable { -- Butterfly
	key = "butterfly",
	set = "Tarot",
	atlas = "tarot",
	pos = { x = 3, y = 0},
	config = {
		extra = {
		  cards = 10,
		  hand_size = 2,
		  rounds = 3,
		  antes = 0,
		  used = false,
		}
	},
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.cards,
				center.ability.extra.hand_size,
				center.ability.extra.rounds,
				center.ability.extra.antes
			}
		}
	end,
	can_use = function(self,card)
		if G and G.deck and #G.deck.cards > 10 and card.ability.extra.used == false then return true end
		return false
	end,
	use = function (self, card, area, copier)	  
		local cardstodie = pseudorandom_element(G.deck, pseudoseed('dyinggg'))
		for i = 1, #cardstodie do
			if i <= card.ability.extra.cards then
				cardstodie[i]:dissolve()
			end
			if i > card.ability.extra.cards then
				break;
			end
		end
		G.hand:change_size(card.ability.extra.hand_size)
		card.ability.extra.antes = card.ability.extra.rounds
		card.ability.extra.used = true
	end,
	keep_on_use = function (self, card)
		return true
	end,
	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind.boss and card.ability.extra.used == true then
			card.ability.extra.antes = card.ability.extra.antes - 1
			if card.ability.extra.antes == 0 then
				G.hand:change_size(-card.ability.extra.hand_size)
			end
		end
	end,
}

--[[

Spectral

]]

SMODS.Consumable {
  key = "twirl",
  set = "Spectral",
  atlas = "spectral",
  pos = { x = 0 , y = 0},
  can_use = function (self, card)
    return true
  end,
  use = function(self, card, area, copier)
    for _, v in ipairs(G.playing_cards) do
      if v:is_suit("Spades") then v:change_suit("Diamonds")
      elseif v:is_suit("Diamonds") then v:change_suit("Clubs")
      elseif v:is_suit("Clubs") then v:change_suit("Hearts")
      elseif v:is_suit("Hearts") then v:change_suit("Spades")
      end
    end
  end
}