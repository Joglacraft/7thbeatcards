SMODS.Enhancement({
  key = 'fire',
  atlas = "deck",
  pos = { x = 0 , y = 0},
  config = {
    mult = 0, --mult it gives
    extra = {
      mult_gain = 5, --mult it adds
      other_card = 1, -- Count of other cards
    }
  },
  loc_vars = function (self, info_queue, card)
    card.ability.mult = 0
    card.ability.extra.mult_gain = 5
    card.ability.extra.other_card = 0
    if G.jokers then
        for k, v in pairs(G.playing_cards) do
          if v.config.center == G.P_CENTERS.m_sbc_ice or v.config.center == G.P_CENTERS.m_sbc_wind then 
            card.ability.extra.other_card = card.ability.extra.other_card + 1
            card.ability.mult = card.ability.extra.mult_gain * card.ability.extra.other_card
          end
      end
    end
      return {
      vars = {
        card.ability.mult,
        card.ability.extra.mult_gain,
        card.ability.extra.other_card
      }
      }
  end
})

SMODS.Enhancement({
  key = 'ice',
  atlas = "deck",
  pos = { x = 1 , y = 0},
  config = {
    bonus = 0,
    extra = {
      bonus_gain = 10,
      other_card = 1,
  }
  },
  loc_vars = function (self, info_queue, card)
    card.ability.bonus = 0
    card.ability.extra.bonus_gain = 10
    card.ability.extra.other_card = 0
    if G.jokers then
      for k, v in pairs(G.playing_cards) do
        if v.config.center == G.P_CENTERS.m_sbc_fire or v.config.center == G.P_CENTERS.m_sbc_wind then 
          card.ability.extra.other_card = card.ability.extra.other_card + 1
          card.ability.bonus = card.ability.extra.bonus_gain * card.ability.extra.other_card
        end
      end
    end
    return {
      vars = {
        card.ability.bonus,
        card.ability.extra.bonus_gain,
        card.ability.extra.other_card
      }
    }
  end
})