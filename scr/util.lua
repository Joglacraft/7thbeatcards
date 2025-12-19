local ref = Back.apply_to_run
function Back.apply_to_run(self)
  ref(self)
  if self.effect.config.create_cards then
    for _,v in pairs(self.effect.config.create_cards) do
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil, v, nil)
          card:add_to_deck()
          G.jokers:emplace(card)
          return true
        end
      }))
    end
  end
end