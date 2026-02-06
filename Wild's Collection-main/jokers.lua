SMODS.Atlas{
	key = 'jokers',
	path = 'Jokers.png',
	px = 71,
	py = 95,
	-- 2x is 142 by 190
}


SMODS.Joker:take_ownership('photograph', -- object key (class prefix not required)
	{ -- table of properties to change from the existing object
	rarity = 2,
	},
	true -- silent | suppresses mod badge
)


SMODS.Joker{
	key = 'isaacs_dice',
	atlas = 'jokers',
	pos = {x = 0, y = 0},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { add_odds_1 = 6 , add_odds_2 = 36 } },
	rarity = 'Perkolator_Perkeo_R',
	cost = 6,
	loc_vars = function (self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative 
		return {
			vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.add_odds_1 or 6, card.ability.extra.add_odds_2 or 36}
		}
	end,
	calculate = function (self,card,context)
		if context.ending_shop and context.main_eval then
			if pseudorandom(pseudoseed('13473941')) < (G.GAME.probabilities.normal / card.ability.extra.add_odds_1 or 6) then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(1, 0.5)
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.add_card({set = 'Joker', area = G.jokers, key = key, legendary = false, edition = 'e_negative' })
								return true
							end
						}))
						return true
					end
				}))
				return {
					message = "Return!",
					colour = HEX('56a786')
				}
			else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    blockable = true,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06*G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                return true
                            end
                        }))
                        return true
                    end
                }))
            	return{}
            end
		end
		if context.end_of_round and context.main_eval then
			if pseudorandom(pseudoseed('36008016')) < (G.GAME.probabilities.normal / card.ability.extra.add_odds_2 or 36) then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(1, 0.5)
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.add_card({set = 'Joker', area = G.jokers, key = key, legendary = true, edition = 'e_negative' })
								return true
							end
						}))
						return true
					end
				}))
				return {
					message = "RISE!",
					colour = HEX('56a786')
				}
			else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    blockable = true,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06*G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                return true
                            end
                        }))
                        return true
                    end
                }))
            	return{}
            end
		end
	end
}

SMODS.Joker{
	key = 'the_lamb',
	atlas = 'jokers',
	pos = { x = 2, y = 0 },
	unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
	rarity = 'Perkolator_Perkeo_R',
	cost = 8,
	loc_vars = function (self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} } 
		return {}
	end,
	calculate = function (self,card,context)
		if context.ending_shop and context.main_eval then
			local card = pseudorandom_element(G.consumeables.cards, pseudoseed('08547280'))
			if card then 
				G.E_MANAGER:add_event(Event({
					func = function()
						card:start_dissolve()
						local consumable_types = {'Tarot','Spectral','Planet'}
						SMODS.add_card({set = pseudorandom_element(consumable_types, pseudoseed('05968425')), area = G.consumeables, edition = 'e_negative' })
						return true
					end
				}))
			end
			return true
		end
	end
}

SMODS.Joker{
	key = 'GNA',
	atlas = 'jokers',
	pos = {x = 1, y = 1},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	config = { extra = { add_odds = 2 } },
	rarity = 'Perkolator_Perkeo_R',
	cost = 8,
	loc_vars = function (self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
		return { 
            vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.add_odds or 2}
        }
	end,
	calculate = function (self,card,context)
		if context.first_hand_drawn and not context.blueprint then
			local eval = function() return G.GAME.current_round.hands_played == 0 end
			juice_card_until(card, eval, true)
		end
		if context.cardarea == G.jokers and context.before then
			if #context.full_hand  == 1 and  G.GAME.current_round.hands_played == 0 then
				if pseudorandom(pseudoseed('52027459')) < G.GAME.probabilities.normal / (card.ability.extra.add_odds or 2) then
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
					_card:set_edition('e_negative', true)
					_card:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card)
					G.hand:emplace(_card)
					_card.states.visible = nil
					G.E_MANAGER:add_event(Event({
						func = function()
							_card:start_materialize()
							return true
						end
					})) 
					return {
						message = "Boo!",
						colour = HEX('56a786'),
						playing_cards_created = {true}
					}
				else
            		G.E_MANAGER:add_event(Event({
            	    	trigger = 'after',
            	    	delay = 0.0,
            	    	blockable = true,
            	    	func = function()
            	        	G.E_MANAGER:add_event(Event({
            	            	trigger = 'after',
            	        	    delay = 0.06*G.SETTINGS.GAMESPEED,
            	        	    blockable = false,
            	        	    blocking = false,
            	        	    func = function()
            	        	        return true
            	        	    end
            	        	}))
            	        	return true
            	    	end
            		}))
            		return{}
            	end
			end
		end
	end
}

SMODS.Joker{
    key = "ersatz_joker",
    atlas = 'jokers',
    rarity = "Perkolator_Perkeo_R",
	cost = 5,
    pos = {x = 4, y = 0},
	unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
	loc_vars = function (self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
		return {}
	end,
    calculate = function(self, card, context)
      	if context.end_of_round and context.cardarea == G.jokers and context.main_eval then
        	if G.GAME.blind.boss and not context.blueprint then
				if G.consumeables.cards[1] then
					G.E_MANAGER:add_event(Event({
						func = function()
							local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('91746205')), nil)
							card:set_edition('e_negative', true)
							card:add_to_deck()
							G.consumeables:emplace(card)
							local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('91746205')), nil)
							card:set_edition('e_negative', true)
							card:add_to_deck()
							G.consumeables:emplace(card)
							return true
						end
					}))
					return (
						card:start_dissolve()
					)
				end
        	end
      	end
    end
}

SMODS.Joker {
	key = 'psychopomp',
	rarity = "Perkolator_Perkeo_R",
	atlas = 'jokers',
	unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
	pos = {x = 1, y = 0},
	cost = 10,
    loc_vars = function(self, info_queue, card)
    	info_queue[#info_queue+1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
    end,
    calculate = function(self, card, context)
    	if context.before and context.scoring_hand and G.GAME.current_round.hands_played == 0 then
        G.E_MANAGER:add_event(Event ( {
        	trigger = 'before',
        	delay = 1,
        	func = function()
				card:juice_up(1, 0.5)
            	local _card = context.scoring_hand[1]
            	if not _card.edition then
              		_card:set_edition({negative = true}, true)
            	end
            return true
        	end 
		} ))
      	end
    end
}

SMODS.Joker{
	key = 'common_charity',
	atlas = 'jokers',
	pos = {x = 3, y = 1},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	rarity = 1,
	cost = 6,
	calculate = function (self,card,context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card and (context.other_card.config.center.rarity == 1) then
			return {
			  message =  localize('k_again_ex'),
			  repetitions = 1,
			}
		end
	end
}

SMODS.Joker{
	key = 'double_rainbow',
	atlas = 'jokers',
	pos = {x = 0, y = 1},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	rarity = 2,
	cost = 7,
	calculate = function (self,card,context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card and (context.other_card.config.center.rarity == 2) then
			return {
			  message =  localize('k_again_ex'),
			  repetitions = 1,
			}
		end
	end
}

SMODS.Joker{
	key = 'perfect_stake',
	atlas = 'jokers',
	pos = {x = 3, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	rarity = 3,
	cost = 8,
	calculate = function (self,card,context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card and (context.other_card.config.center.rarity == 3) then
			return {
			  message =  localize('k_again_ex'),
			  repetitions = 1,
			}
		end
	end
}

SMODS.Joker{
	key = '7_leaf_clover',
	atlas = 'jokers',
	pos = {x = 4, y = 1},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	rarity = 4,
	cost = 20,
	calculate = function (self,card,context)
		if context.retrigger_joker_check and not context.retrigger_joker and not context.j_Perkolator_rivel and context.other_card ~= card and (context.other_card.config.center.rarity == 4) then
			return {
			  message =  localize('k_again_ex'),
			  repetitions = 1,
			}
		end
	end
}

SMODS.Joker{
	key = 'beetlejuice',
	atlas = 'jokers',
	pos = {x = 2, y = 1},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
	rarity = "Perkolator_Perkeo_R",
	cost = 3,
	calculate = function (self,card,context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card and (context.other_card.config.center.rarity == "Perkolator_Perkeo_R") then
			return {
			  message =  localize('k_again_ex'),
			  repetitions = 1,
			}
		end
	end
}

SMODS.Joker{
	key = 'pricilla',
	rarity = 4,
	atlas = 'jokers',
	pos = {x = 0, y = 2},
	soul_pos = {x = 0, y = 3},
	cost = 20,
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    loc_vars = function(self, info_queue, card)
    	return {}
	end,
    calculate = function(self, card, context)
    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss and not self.gone then
		G.E_MANAGER:add_event(Event({
			func = function()
				G.jokers.config.card_limit = G.jokers.config.card_limit + 1
				card:juice_up(1, 0.5)
			return true
			end
		}))
		return {
        	message = '+1',
        	colour = G.C.PURPLE,
        	delay = 0.45, 
        } 
    end
end,	
}

SMODS.Joker{
	key = 'grock',
	atlas = 'jokers',
    pos = { x = 1, y = 2 },
    soul_pos = { x = 1, y = 3 },
    rarity = 4,
    cost = 20,
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    loc_vars = function(self, info_queue, card)
        return { }
    end,
	calculate = function(self, card, context)
        if context.end_of_round and context.individual == true and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.other_card.debuff and not context.blueprint then
            ease_dollars(11)
			delay(0.5)
            return {
				card = context.other_card,
                message = localize('$')..11,
                dollars = 11,
                colour = G.C.MONEY
			}
        end
    end
}

SMODS.Joker{
    key = "remi",
    atlas = 'jokers',
    rarity = 4,
	cost = 20,
    pos = {x = 2, y = 2},
	soul_pos = {x = 2, y = 3},
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
	config = { extra = { Xmult = 3, add_odds = 2 } },
	loc_def = function(card)
        return { card.ability.extra.Xmult }
    end,
	loc_vars = function (self, info_queue, card)
		return {
            vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.add_odds or 2}
        }
	end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual == true and not context.end_of_round then
			if pseudorandom(pseudoseed('34777634')) < G.GAME.probabilities.normal / card.ability.extra.add_odds then
				if context.other_card then
                	if context.other_card.debuff then
                    	return {
                        	message = localize('k_debuffed'),
                        	colour = G.C.RED,
                        	card = context.other_card,
                    	}
                	else
						G.E_MANAGER:add_event(Event({
							func = function()
								card:juice_up(1, 0.5)
							return true
							end
						}))
                    	return {
                        	Xmult = card.ability.extra.Xmult / 2,
                        	card = context.other_card
                    	}
					end
				end
			else
				G.E_MANAGER:add_event(Event({
            	trigger = 'after',
            	delay = 0.0,
            	blockable = true,
            	func = function()
            	    G.E_MANAGER:add_event(Event({
            	        trigger = 'after',
            	    	delay = 0.06*G.SETTINGS.GAMESPEED,
            	    	blockable = false,
            	    	blocking = false,
            	    	func = function()
            	    	    return true
            	    	end
            	    }))
            	    return true
            	end
            	}))
            	return{}
            end
        end
    end
}

SMODS.Joker{
	key = 'vercoe',
    rarity = 4,
    atlas = "jokers", 
	pos = {x = 3, y = 2},
	soul_pos = {x = 3, y = 3},
    cost = 20,
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
	config = {extra = {Xmult = 1.25}},
	loc_vars = function(self,info_queue,card)
		return { vars = {card.ability.extra.Xmult} }
	end,
	calculate = function (self,card,context)
		if context.other_joker and context.other_joker ~= card then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult = card.ability.extra.Xmult
			}
		end
	end
}

SMODS.Joker{
    key = 'rivel',
    rarity = 4,
	atlas = 'jokers',
    pos = { x = 4, y = 2},
    soul_pos = { x = 4, y = 3},
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    config = {ante_mod = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.ante_mod }}
    end,
    calculate = function(self, card, context)
      	if context.end_of_round and context.cardarea == G.jokers and context.main_eval then
        	if G.GAME.blind.boss and not context.blueprint then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(1, 0.5)
						ease_ante(-G.GAME.round_resets.blind_ante)
            			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-"..card.ability.ante_mod.." Ante", colour = G.C.FILTER})
					return true
					end
				}))
				return (
					card:start_dissolve()
				)
        	end
      	end  
    end
}
