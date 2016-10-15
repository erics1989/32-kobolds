T = require 'BearLibTerminal'
Serpent = require 'serpent'

FOV_CHEAT = false
MAP_W = 64
MAP_H = 64
MAX_LINES = 43

data = {}

-- !level

data.level = {
    [1] = {
        person = {
            'fighter_person',
            'archer_person',
            'wizard_person',
            'cleric_person',
            'thief_person',
            'conjurer_person',
            'assassin_person',
            'skirmisher_person'
        },
        item = {
            'potion_of_fire_item',
            'potion_of_foliage_item',
            'potion_of_frozen_time_item',
            'potion_of_life_item',
            'potion_of_poison_item',
            'potion_of_distortion_item',
            'potion_of_obstruction_item',
            'potion_of_erosion_item',
            'potion_of_clairvoyance_item',
            'potion_of_pastoral_dreams_item',
            'potion_of_the_quickling_item'
        }
    }
}

-- !persons

data.hero = {
    color = '#fdf6e3', char = '@',
    name = 'hero',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_damage(defender, 1)
                note(string.format('the %s punches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
            end
        end
    },
    init = function (person)
        person.hp = 64
        person.speed = 1
        person_item_equip(person, item_init('broadsword_item'))
    end,
}

data.fighter_person = {
    color = '#dc322f', char = 'f',
    name = 'kobold fighter',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 4
        person.speed = 1
        person_item_equip(person, item_init('shortsword_item')
)
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            local f = 0
            for _, p in ipairs(hero.fov.persons) do
                if p ~= hero and p ~= person then
                    if dist_c(p.x, p.y, hero.x, hero.y) <= 2 then
                        f = f + 1
                    end
                end
            end
            if f > 0 then
                if dist == 1 then 
                    person_fight(person, hero.x, hero.y)
                else
                    person_advance(person, hero.x, hero.y)
                end
            else
                if dist == 1 then
                    person_retreat_to_dist(person, 2)
                elseif dist == 2 then
                    -- pass
                else
                    person_advance(person, hero.x, hero.y)
                end
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.skirmisher_person = {
    color = '#cb4b16', char = 's',
    name = 'kobold skirmisher',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 2
        person_item_equip(person, item_init('shortsword_item'))
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            local f = 0
            for _, p in ipairs(hero.fov.persons) do
                if p ~= hero and p ~= person then
                    if dist_c(p.x, p.y, hero.x, hero.y) <= 2 then
                        f = f + 1
                    end
                end
            end
            if f > 0 then
                if dist == 1 then 
                    person_fight(person, hero.x, hero.y)
                else
                    person_advance(person, hero.x, hero.y)
                end
            else
                if dist == 1 then
                    person_retreat_to_dist(person, 2)
                elseif dist == 2 then
                    -- pass
                else
                    person_advance(person, hero.x, hero.y)
                end
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.archer_person = {
    color = '#b58900', char = 'a',
    name = 'kobold archer',
    attack = {
        dist = 8,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person_item_equip(person, item_init('shortbow_item'))
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if dist <= 1 then
                person_retreat_to_dist(person, 2)
            elseif dist <= 8 then
                person_fight(person, hero.x, hero.y)
            else
                person_advance(person, hero.x, hero.y)
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.wizard_person = {
    color = '#d33682', char = 'w',
    name = 'kobold wizard',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person.shock_action = action_init('shock_action')
        person_action_enter(person, person.shock_action)
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if person.prepared then
                if dist == 1 then
                    person_retreat_to_dist(person, 5)
                elseif dist <= 8 then
                    person_action_use(person, person.prepared.action, hero.x, hero.y)
                else
                    person_advance(person, hero.x, hero.y)
                end
            elseif person.preparing then
                if dist <= person.preparing.counters + 1 then
                    person_retreat_to_dist(person, 5)
                elseif dist <= 8 then
                    person_rest(person)
                else
                    person_advance(person, hero.x, hero.y)
                end
            else
                if dist <= 4 then
                    person_retreat_to_dist(person, 5)
                elseif dist <= 8 then
                    person_action_use(person, person.shock_action)
                else
                    person_advance(person, hero.x, hero.y)
                end
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.cleric_person = {
    color = '#6c71c4', char = 'c',
    name = 'kobold cleric',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person.cure_action = action_init('cure_action')
        person_action_enter(person, person.cure_action)
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            local f, f_dist
            for _, p in ipairs(hero.fov.persons) do
                if p ~= hero and p ~= person then
                    if person_detects(person, p) and p.damage ~= 0 then
                        f = p
                        f_dist = dist_c(person.x, person.y, p.x, p.y)
                        break
                    end
                end
            end
            if f and f_dist <= 8 then
                if person.prepared then
                    if dist == 1 then
                        person_retreat_to_dist_and_friend(person, 4, f)
                    else
                        person_action_use(person, person.prepared.action, f.x, f.y)
                    end
                elseif person.preparing then
                    if dist <= person.preparing.counters + 1 then
                        person_retreat_to_dist_and_friend(person, 4, f)
                    else
                        person_rest(person)
                    end
                else
                    if dist <= 3 then
                        person_retreat_to_dist_and_friend(person, 4, f)
                    else
                        person_action_use(person, person.cure_action)
                    end
                end
            elseif f then
                person_retreat_to_dist_and_friend(person, 4, f)
            else
                if dist <= 3 then
                    person_retreat_to_dist(person, 4)
                elseif dist == 3 then
                    -- pass
                else
                    person_advance(person, hero.x, hero.y)
                end
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.thief_person = {
    color = '#859900', char = 't',
    name = 'kobold thief',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person.hide_action = action_init('hide_action')
        person_action_enter(person, person.hide_action)
        person.covet_action = action_init('covet_action')
        person_action_enter(person, person.covet_action)
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if person.items[1] then
                person_retreat_to_black(person)
            else
                if person.hidden then
                    if dist == 1 then
                        person_action_use(person, person.covet_action, hero.x, hero.y)
                    else
                        person_advance(person, hero.x, hero.y)
                    end
                else
                    person_retreat_to_black(person)
                end
            end
        elseif person.hero_pt then
            if person.items[1] then
                if person.hidden then
                    -- pass
                else
                    person_action_use(person, person.hide_action)
                end
            else
                if person.hidden then
                    person_advance(person, person.hero_pt.x, person.hero_pt.y)
                else
                    person_action_use(person, person.hide_action)
                end
            end
        end
    end
}

data.assassin_person = {
    color = '#2aa198', char = 'a',
    name = 'kobold assassin',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person.hide_action = action_init('hide_action')
        person_action_enter(person, person.hide_action)
        person_item_equip(person, item_init('shortsword_of_poison_item'))
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if person.hidden then
                if dist == 1 then
                    person_fight(person, hero.x, hero.y)
                else
                    person_advance(person, hero.x, hero.y)
                end
            else
                person_retreat_to_black(person)
            end
        elseif person.hero_pt then
            if person.hidden then
                person_advance(person, person.hero_pt.x, person.hero_pt.y)
            else
                person_action_use(person, person.hide_action)
            end
        end
    end
}

data.conjurer_person = {
    color = '#268bd2', char = 'c',
    name = 'kobold conjurer',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s scratches the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 2
        person.speed = 1
        person.conjure_action = action_init('conjure_action')
        person_action_enter(person, person.conjure_action)
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if person.prepared then 
                if dist == 1 then
                    person_retreat_to_dist(person, 6)
                else
                    local pt = person_advance_pt(person, hero.x, hero.y)
                    if pt then
                        person_action_use(person, person.prepared.action, pt.x, pt.y)
                    end
                end
            elseif person.preparing then
                if dist <= person.preparing.counters + 1 then
                    person_retreat_to_dist(person, 6)
                else
                    person_rest(person)
                end
            else
                if dist <= 4 then
                    person_retreat_to_dist(person, 6)
                else
                    person_action_use(person, person.conjure_action)
                end
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

data.floating_blade_person = {
    color = '#268bd2', char = ')',
    name = 'spectral blade',
    attack = {
        dist = 1,
        execute = function (person, _, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s slashes the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 1)
            end
        end
    },
    init = function (person)
        person.hp = 1
        person.speed = 1
    end,
    act = function (person)
        if hero.fov[person.x][person.y] then
            person.hero_pt = { x = hero.x, y = hero.y }
            local dist = hero.dist[person.x][person.y]
            if dist == 1 then
                person_fight(person, hero.x, hero.y)
            else
                person_advance(person, hero.x, hero.y)
            end
        elseif person.hero_pt then
            person_advance(person, person.hero_pt.x, person.hero_pt.y)
        end
    end
}

-- !shine

data.hidden_shine = {
    name = 'hidden',
    person_shine_enter = function (person, shine)
        person.hidden = shine
    end,
    person_step = function (person, shine, x, y, dx, dy)
        if hero.dist[person.x][person.y] <= 4 then
            note(string.format('the hero senses a faint presence.'), person.x, person.y)
        end
    end,
    person_fight = function (person, shine, x, y)
        person_shine_exit(person, shine)
    end,
    person_shine_exit = function (person, shine)
        person.hidden = nil
    end
}

data.poison_shine = {
    name = 'poison',
    person_shine_enter = function (person, shine)
        note(string.format('the %s is poisoned.', data[person.def].name), person.x, person.y)
        person.poison = shine
    end,
    preact_damage = function (person, shine)
        person_damage(person, 1)
    end,
    person_shine_exit = function (person, shine)
        note(string.format('the %s\'s poison ceases.', data[person.def].name), person.x, person.y)
        person.poison = nil
    end
}

data.burning_shine = {
    name = 'burning',
    person_shine_enter = function (person, shine)
        note(string.format('the %s catches on fire.', data[person.def].name), person.x, person.y)
        person.burning = shine
        shine.counters = 8
    end,
    preact_damage = function (person, shine)
        person_fire_damage(person, 1)
    end,
    person_shine_exit = function (person, shine)
        note(string.format('the %s\'s fire burns out.', data[person.def].name), person.x, person.y)
        person.burning = nil
    end
}

data.time_stop_shine = {
    name = 'time stop',
    person_shine_enter = function (person, shine)
        note(string.format('the %s steps outside of time\'s flow.', data[person.def].name), person.x, person.y)
        person.time_stop = shine
        shine.counters = 8
    end,
    person_shine_exit = function (person, shine)
        note(string.format('the %s returns to time\'s flow.', data[person.def].name), person.x, person.y)
        person.time_stop = nil
    end
}

data.asleep_shine = {
    name = 'asleep',
    person_shine_enter = function (person, shine)
        note(string.format('the %s falls asleep.', data[person.def].name), person.x, person.y)
        shine.counters = 8
        person.asleep = shine
    end,
    person_be_fought = function (person, shine, attacker)
        person_shine_exit(person, shine)
    end,
    person_shine_exit = function (person, shine)
        note(string.format('the %s wakes up.', data[person.def].name), person.x, person.y)
        person.asleep = nil
    end
}

data.preparing_shine = {
    name = 'chanting',
    person_shine_enter = function (person, shine)
        assert(shine.counters)
        note(string.format('the %s starts chanting.', data[person.def].name, shine.counters), person.x, person.y)
        person.preparing = shine
    end,
    person_step = function (person, shine, x, y, dx, dy)
        person_shine_exit(person, shine)
    end,
    person_shine_exit = function (person, shine)
        if shine.counters == 0 then
            person.preparing = nil
            person_shine_enter(person, shine_init('prepared_shine'))
            person.prepared.action = shine.action
        else
            note(string.format('the %s stops chanting.', data[person.def].name), person.x, person.y)
            person.preparing = nil
        end
    end
}

data.prepared_shine = {
    name = 'prepared',
    person_shine_enter = function (person, shine)
        person.prepared = shine
    end,
    person_postact = function (person, shine)
        person_shine_exit(person, shine)
    end,
    person_shine_exit = function (person, shine)
        person.prepared = nil
    end
}

data.extreme_speed_shine = {
    name = 'extreme speed',
    person_shine_enter = function (person, shine)
        shine.former_hp = person.hp
        shine.former_damage = person.damage
        person.hp = 1
        person.damage = 0
        person.speed = person.speed + 24
        shine.counters = 16
        note(string.format('the %s speeds up into a blur.', data[person.def].name), person.x, person.y)
    end,
    person_shine_exit = function (person, shine)
        person.hp = shine.former_hp
        person.damage = shine.former_damage
        person.speed = person.speed - 24
    end
}

-- !action

data.hide_action = {
    name = 'hide',
    use = {
        execute = function (person, action, x, y)
            if not person.hidden and not hero.fov[person.x][person.y] then
                person_shine_enter(person, shine_init('hidden_shine'))
            end
        end
    },
}

data.covet_action = {
    name = 'covet',
    use = {
        dist = 1,
        execute = function (person, action, x, y)
            local s = space(x, y)
            local defender = s.person
            if defender then
                if defender.items[1] then
                    local item = sort1(
                        defender.items,
                        function (a, b)
                            if a.value then
                                if b.value then
                                    return a.value > b.value
                                else
                                    return true
                                end
                            end
                        end
                    )
                    note(string.format('the %s steals a %s.', data[person.def].name, data[item.def].name), person.x, person.y)
                    person_item_exit(defender, item)
                    person_item_enter(person, item)
                end
            end
            if person.hidden then
                person_shine_exit(person, person.hidden)
            end
        end
    },
}

data.cure_action = {
    name = 'cure',
    use = {
        prepare = 2,
        dist = 8,
        execute = function (person, action, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s cures %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, -8)
            end
        end
    }
}

data.shock_action = {
    name = 'shock',
    use = {
        prepare = 3,
        dist = 8,
        execute = function (person, action, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s shocks the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_electric_damage(defender, 4)
            end
        end
    }
}

data.conjure_action = {
    name = 'conjure',
    use = {
        prepare = 4,
        execute = function (person, action, x, y)
            if vacant(x, y) then
                note(string.format('the %s conjures a floating blade.', data[person.def].name), person.x, person.y)
                person_enter(person_init('floating_blade_person'), x, y)
            end
        end
    }
}


data.potion_of_fire_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of incineration',
    desc = 'a flask of pressurized explosive energy. sets everything and everyone within a 4 tile radius on fire.',
    drink = {
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        burn(bx, by)
                    end
                end
            end
        end
    },
    toss = {
        dist = 8,
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            for bx = ax - 8, ax + 8 do
                for by = ay - 8, ay + 8 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        burn(bx, by)
                    end
                end
            end
        end
    },
}

data.potion_of_foliage_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of foliage', shortname = 'of foliage',
    desc = 'a flask of strange seeds that can cause dense foliage to sprout from the earth in an instant.',
    drink = {
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('dense foliage breaks from the earth.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if data[s.terrain.def].dirt then
                            terrain_enter(terrain_init('dense_foliage_terrain'), bx, by)
                        end
                    end
                end
            end
        end
    },
    toss = {
        dist = 8,
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('dense foliage breaks from the earth.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if data[s.terrain.def].dirt then
                            terrain_enter(terrain_init('dense_foliage_terrain'), bx, by)
                        end
                    end
                end
            end
        end
    }
}

data.potion_of_frozen_time_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of frozen time',
    desc = 'drink this sedimented potion to stop time for everything but you.',
    drink = {
        execute = function (person, object, ax, ay)
            person_shine_enter(person, shine_init('time_stop_shine'))
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, ax, ay)
            person_shine_enter(person, shine_init('time_stop_shine'))
        end
    }
}

data.potion_of_life_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of clotting',
    desc = 'a carbonated herbal drink that closes wounds and restores 16 hit points.',
    drink = {
        execute = function (person, object, ax, ay)
            local s = space(ax, ay)
            local defender = s and s.person
            if defender then
                person_damage(defender, -16)
                note(string.format('the %s\'s health is restored.', data[defender.def].name), person.x, person.y)
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, ax, ay)
            local s = space(ax, ay)
            local defender = s and s.person
            if defender then
                person_damage(defender, -16)
                note(string.format('the %s\'s health is restored.', data[defender.def].name), person.x, person.y)
            end
        end
    },
}

data.potion_of_poison_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of miasma',
    desc = 'a flask of organ-twisting poison. handle with care. does 16 poison damage.',
    drink = {
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_poison(defender, 16)
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_poison(defender, 16)
            end
        end
    },
}

data.potion_of_distortion_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of escape',
    desc = 'a space-distorting cream that sends the user to another place. be careful: you can\'t postpone your problems forever...',
    drink = {
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s vanishes.', data[defender.def].name), defender.x, defender.y)
                local pts = get_pts(vacant)
                local pt = pts[math.random(#pts)]
                person_move(defender, pt.x, pt.y)
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s vanishes.', data[defender.def].name), defender.x, defender.y)
                local pts = get_pts(vacant)
                local pt = pts[math.random(#pts)]
                person_move(defender, pt.x, pt.y)
            end
        end
    },
}

data.potion_of_obstruction_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of obstruction',
    desc = 'upon exposure to air, the fluid in this flask forms a giant crystal. and upon further exposure to air, it disappears into nothing.',
    drink = {
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('a gemstone formation obstructs the area.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if vacant(bx, by) then
                            local terrain = terrain_init('gemstone_terrain')
                            terrain.child_terrain = s.terrain
                            terrain_enter(terrain, bx, by)
                        end
                    end
                end
            end
        end
    },
    toss = {
        dist = 8,
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('a gemstone formation obstructs the area.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if vacant(bx, by) then
                            local terrain = terrain_init('gemstone_terrain')
                            terrain.child_terrain = s.terrain
                            terrain_enter(terrain, bx, by)
                        end
                    end
                end
            end
        end
    },
}

data.potion_of_erosion_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of erosion',
    desc = 'this concoction transmutes stone to disintegrating crystals.',
    drink = {
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('the stone erodes.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if data[s.terrain.def].stone then
                            local terrain = terrain_init('gemstone_terrain')
                            terrain.child_terrain = terrain_init('dirt_terrain')
                            terrain_enter(terrain, bx, by)
                        end
                    end
                end
            end
        end
    },
    toss = {
        dist = 8,
        area = function (ax, ay, bx, by, cx, cy)
            return dist_e(bx, by, cx, cy) <= 4
        end,
        execute = function (person, object, ax, ay)
            note('the stone erodes.', ax, ay)
            for bx = ax - 4, ax + 4 do
                for by = ay - 4, ay + 4 do
                    local s = space(bx, by)
                    if s and data[object.def].drink.area(person.x, person.y, ax, ay, bx, by) then
                        if data[s.terrain.def].stone then
                            local terrain = terrain_init('gemstone_terrain')
                            terrain.child_terrain = terrain_init('dirt_terrain')
                            terrain_enter(terrain, bx, by)
                        end
                    end
                end
            end
        end
    },
}

data.potion_of_clairvoyance_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of clairvoyance',
    desc = 'drink this to be overcome with perfect knowledge of the topologies of the kobolds\' cave.',
    drink = {
        execute = function (person, object, ax, ay)
            note('the floor\'s shapes are elucidated.', ax, ay)
            for x = 1, MAP_W do
                for y = 1, MAP_H do
                    local s = space(x, y)
                    person.visited[x][y] = data[s.terrain.def].char
                end
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, ax, ay)
            note('the floor\'s shapes are elucidated.', ax, ay)
            for x = 1, MAP_W do
                for y = 1, MAP_H do
                    local s = space(x, y)
                    person.visited[x][y] = data[s.terrain.def].char
                end
            end
        end
    }
}

data.potion_of_pastoral_dreams_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of pastoral dreams',
    desc = 'a sedative and invoker of therapeutic dreams.',
    drink = {
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_damage(defender, -16)
                person_shine_enter(defender, shine_init('asleep_shine'))
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_damage(defender, -16)
                person_shine_enter(defender, shine_init('asleep_shine'))
            end
        end
    },
}

data.potion_of_the_quickling_item = {
    color = '#fdf6e3', char = '!',
    name = 'potion of the quickling',
    desc = 'drink this to gain face-stretching speeds but the constitution of a butterfly.',
    drink = {
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s.person
            if defender then
                person_shine_enter(defender, shine_init('extreme_speed_shine'))
            end
        end
    },
    toss = {
        dist = 8,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                person_damage(defender, -16)
                person_shine_enter(defender, shine_init('asleep_shine'))
            end
        end
    },
}

-- !weapon

data.broadsword_item = {
    color = '#fdf6e3', char = ')',
    name = 'broadsword', 
    desc = 'a huge cut-and-thrust edge, basket-hilted destruction tool, and adventurer\'s best friend. quite expensive. does 8 damage, enough to end the hardiest kobold in one shot.',
    equip = 'hand', value = 8,
    attack = {
        dist = 1,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s slashes the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 8)
            end
        end
    }
}

data.shortsword_item = {
    color = '#fdf6e3', char = ')',
    name = 'shortsword',
    desc = 'a chipped stone edge. you aren\'t going to resort to this, are you? does 2 damage.',
    equip = 'hand',
    attack = {
        dist = 1,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s stabs the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 2)
            end
        end
    }
}

data.shortsword_of_poison_item = {
    color = '#fdf6e3', char = ')',
    name = 'shortsword of poison',
    desc = 'a chipped stone edge coated with enough poison to kill a little bird (probably). does 2 damage and 2 poison damage.',
    equip = 'hand',
    attack = {
        dist = 1,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                note(string.format('the %s stabs the %s.', data[person.def].name, data[defender.def].name), person.x, person.y)
                person_damage(defender, 2)
                person_poison(defender, 2)
            end
        end
    }
}

data.shortbow_item = {
    color = '#fdf6e3', char = ')',
    name = 'shortbow',
    desc = 'a shortbow. it has no sense of craft and has disastrously bad accuracy. hits 25% of the time and does 2 damage.',
    equip = 'hand',
    attack = {
        dist = 8,
        execute = function (person, object, x, y)
            local s = space(x, y)
            local defender = s and s.person
            if defender then
                if math.random() <= 0.25 then
                    note(string.format('the %s shoots the %s. it hits.', data[person.def].name, data[defender.def].name), person.x, person.y)
                    person_damage(defender, 2)
                else
                    note(string.format('the %s shoots the %s. it misses.', data[person.def].name, data[defender.def].name, data[person.def].name), person.x, person.y)
                end

            end
        end
    }
}

-- !terrain

data.stone_terrain = {
    bkcolor = '#839496', color = '#586e75', char = '#',
    stone = true
}

data.dirt_terrain = {
    bkcolor = '#002b36', color = '#586e75', char = '.',
    walkable = true, transparent = true,
}

data.grass_terrain = {
    bkcolor = '#002b36', color = '#859900', char = '\"',
    walkable = true, transparent = true, flammable = true
}

data.dense_foliage_terrain = {
    bkcolor = '#002b36', color = '#859900', char = '#',
    walkable = true, dirt = true, flammable = true
}

data.fire_terrain = {
    bkcolor = '#002b36', color = '#cb4b16', char = '^',
    walkable = true, transparent = true,
    init = function (terrain)
        terrain.speed = 4
        terrain.counters = 8
    end,
    act = function(terrain)
        terrain.counters = terrain.counters - 1
        if terrain.counters == 0 then
            terrain_enter(terrain_init('dirt_terrain'), terrain.x, terrain.y)
        else
            for x = math.max(terrain.x - 1, 1), math.min(terrain.x + 1, MAP_W) do
                for y = math.max(terrain.y - 1, 1), math.min(terrain.y + 1, MAP_H) do
                    local t = map[x][y]
                    terrain_burn(t.terrain)
                end
            end
        end
    end,
    person_terrain_step = function (person, terrain)
        person_burn(person)
    end
}

data.gemstone_terrain = {
    bkcolor = '#6c71c4', color = '#586e75', char = '#',
    stone = true, transparent = true,
    init = function (terrain)
        terrain.speed = 1
        terrain.counters = 8
    end,
    act = function(terrain)
        local exposed
        for x = terrain.x - 1, terrain.x + 1 do
            for y = terrain.y - 1, terrain.y + 1 do
                local s = space(x, y)
                if s and dist_c(terrain.x, terrain.y, x, y) == 1 then
                    if data[s.terrain.def].walkable then
                        exposed = true
                    end
                end
            end
        end
        if exposed then
            terrain.counters = terrain.counters - 1
        end
        if terrain.counters == 0 then
            terrain_enter(terrain_init('dirt_terrain'), terrain.x, terrain.y)
        end
    end
}

-- !generate

function generate_map()
    map = {}
    for x = 1, MAP_W do
        map[x] = {}
        for y = 1, MAP_H do
            map[x][y] = { items = {} }
        end
    end
    generate_shape()
    generate_terrain()
    generate_objects(level)
end

function generate_shape()
    local dirt = automata(
        function (x, y)
            return
                dist_e(MAP_W / 2, MAP_H / 2, x, y) < MAP_W / 2 - 1 and
                math.random() <= 0.5
        end,
        4
    )
    for x = 1, MAP_W do
        for y = 1, MAP_H do
            if dirt[x][y] then
                terrain_enter(terrain_init('dirt_terrain'), x, y)
            else
                terrain_enter(terrain_init('stone_terrain'), x, y)
            end
        end
    end
    connect(
        function (x, y)
            local s = space(x, y)
            return s.terrain.def == 'dirt_terrain'
        end
    )
end

function connect(valid)
    local start = get_pts(valid)[1]
    while true do
        local dist1 = dijk_map({ start }, valid, no_diag)
        local d = get_pts(function (x, y) return valid(x, y) and dist1[x][y] == math.huge end)
        if d[1] then
            local c = get_pts(function (x, y) return valid(x, y) and dist1[x][y] < math.huge end)
            local dist2, prev2 = dijk_map(c, function () return true end, no_diag)
            local dest = sort1(d, function (a, b) return dist2[a.x][a.y] < dist2[b.x][b.y] end)
            local source = get_source(prev2, dest)
            L_connector(source.x, source.y, dest.x, dest.y)
        else
            break
        end
    end
end

function no_diag(ax, ay, bx, by)
    return dist_e(ax, ay, bx, by) == 1 and 1 or math.huge
end


function L_connector(ax, ay, bx, by)
    local xstep = ax <= bx and 1 or -1
    local ystep = ay <= by and 1 or -1
    local x = ax
    local y = ay
    if math.random() < 0.5 then
        while x ~= bx do
            x = x + xstep
            terrain_enter(terrain_init('dirt_terrain'), x, y)
        end
        while y ~= by do
            y = y + ystep
            terrain_enter(terrain_init('dirt_terrain'), x, y)
        end
    else
        while x ~= bx do
            x = x + xstep
            terrain_enter(terrain_init('dirt_terrain'), x, y)
        end
        while y ~= by do
            y = y + ystep
            terrain_enter(terrain_init('dirt_terrain'), x, y)
        end
    end
end

function automata(seed, n)
    local gen1 = {}
    for x = 1, MAP_W do
        gen1[x] = {}
        for y = 1, MAP_H do
            gen1[x][y] = seed(x, y)
        end
    end
    for i = 1, n do
        local gen2 = {}
        for ax = 1, MAP_W do
            gen2[ax] = {}
            for ay = 1, MAP_H do
                local c = 0
                for bx = math.max(ax - 1, 1), math.min(ax + 1, MAP_W) do
                    for by = math.max(ay - 1, 1), math.min(ay + 1, MAP_H) do
                        if gen1[bx][by] then
                            c = c + 1
                        end
                    end
                end
                gen2[ax][ay] = 4 < c
            end
        end
        gen1 = gen2
    end
    return gen1
end

function generate_terrain()
    local grass = automata(function (x, y) return math.random() < 0.4 end, 2)
    for x = 1, MAP_W do
        for y = 1, MAP_H do
            local s = space(x, y)
            if s.terrain.def == 'dirt_terrain' then
                if grass[x][y] then
                    terrain_enter(terrain_init('grass_terrain'), x, y)
                end
            end
        end
    end
end

function generate_objects(level)
    local dirt_terrain_pts = get_pts(function (x, y) return data[space(x, y).terrain.def].walkable end)

    local pt = table.remove(dirt_terrain_pts, math.random(#dirt_terrain_pts))
    person_enter(hero, pt.x, pt.y)

    for i = 1, 32 do
        local person_defs = data.level[level].person
        local def = person_defs[math.random(#person_defs)]
        local pt = table.remove(dirt_terrain_pts, math.random(#dirt_terrain_pts))
        person_enter(person_init(def), pt.x, pt.y)
    end
    
    for i = 1, 8 do
        local item_defs = data.level[level].item
        local def = item_defs[math.random(#item_defs)]
        local pt = table.remove(dirt_terrain_pts, math.random(#dirt_terrain_pts))
        item_enter(item_init(def), pt.x, pt.y)
    end
end

-- !game

function new_game()
    notes = { 'press [[c]] to check the controls.' }
    hero = person_init('hero')
    kobolds = {}
    level = 0
    descend()
end

function descend()
    level = level + 1
    actors = {}
    generate_map()
    if not hero.visited then
        hero.visited = {}
        for x = 1, MAP_W do
            hero.visited[x] = {}
            for y = 1, MAP_H do
                hero.visited[x][y] = false
            end
        end
    end
    state_one.postact()
    state_one.preact()
end

function space(x, y)
    return map[x] and map[x][y]
end

function vacant(x, y)
    local s = space(x, y)
    return s and data[s.terrain.def].walkable and not s.person
end

function dist_c(ax, ay, bx, by)
    return math.max(math.abs(bx - ax), math.abs(by - ay))
end

function dist_e(ax, ay, bx, by)
    return math.sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
end

function bresen(ax, ay, bx, by)
    local pts = {}
    local dx = math.abs(bx - ax)
    local dy = math.abs(by - ay)
    local xstep = ax <= bx and 1 or -1
    local ystep = ay <= by and 1 or -1
    if dx < dy then
        local x = ax
        local err = dy / 2
        for y = ay, by, ystep do
            table.insert(pts, { x = x, y = y })
            err = err - dx
            if err < 0 then
                x = x + xstep
                err = err + dy
            end
        end
    else
        local y = ay
        local err = dx / 2
        for x = ax, bx, xstep do
            table.insert(pts, { x = x, y = y })
            err = err - dy
            if err < 0 then
                y = y + ystep
                err = err + dx
            end
        end
    end
    return pts
end


function LoS(ax, ay, bx, by, valid)
    local pts = bresen(ax, ay, bx, by)
    table.remove(pts, 1)
    table.remove(pts)
    for i, pt in ipairs(pts) do
        if not valid(pt.x, pt.y) then
            return false
        end
    end
    return true
end

function note(s, x, y)
    if not (x and y) or (hero.fov and hero.fov[x][y]) then
        if notes[MAX_LINES] then
            table.remove(notes, 1)
        end
        table.insert(notes, s)
    end
end

function find(t, o)
    for i, v in ipairs(t) do
        if v == o then return i end
    end
end

function delete(t, o)
    assert(find(t, o))
    table.remove(t, find(t, o))
end

function get_pts(valid)
    local pts = {}
    for x = 1, MAP_W do
        for y = 1, MAP_H do
            if valid(x, y) then
                table.insert(pts, { x = x, y = y })
            end
        end
    end
    return pts
end

function sort1(t, f)
    local one = t[1]
    for _, v in ipairs(t) do
        if f(v, one) then
            one = v
        end
    end
    return one
end

function get_closest(pts, dist)
    local closest
    local closest_dist = math.huge
    for _, pt in ipairs(pts) do
        local dist = dist[pt.x][pt.y]
        if dist < closest_dist then
            closest = pt
            closest_dist = dist
        end
    end
    return closest
end

function delete_fast(t, o)
    for i, v in ipairs(t) do
        if v == o then
            local j = #t
            t[i] = t[j]
            t[j] = nil
            return v
        end
    end
end

function get_adjacent(ax, ay, valid)
    local pts = {}
    for bx = ax - 1, ax + 1 do
        for by = ay - 1, ay + 1 do
            if not (bx == ax and by == ay) then
                if space(bx, by) and valid(bx, by) then
                    table.insert(pts, { x = bx, y = by })
                end
            end
        end
    end
    return pts
end

function astar_heuristic(ax, ay, bx, by)
    return math.abs(bx - ax) + math.abs(by - ay)
end

function astar(open, destx, desty, valid, cost, max, reverse, heuristic)
    cost = cost or dist_c
    max = max or math.huge
    heuristic = heuristic or astar_heuristic
    local dist = {}
    local dist_heuristic = {}
    local prev = {}
    for x = 1, MAP_W do
        dist[x] = {}
        dist_heuristic[x] = {}
        prev[x] = {}
        for y = 1, MAP_H do
            dist[x][y] = math.huge
            dist_heuristic[x][y] = math.huge
        end
    end
    for _, pt in ipairs(open) do
        dist[pt.x][pt.y] = 0
        dist_heuristic[pt.x][pt.y] = heuristic(pt.x, pt.y, destx, desty)
    end
    while open[1] do
        local current = get_closest(open, dist_heuristic)
        if current.x == destx and current.y == desty then
            return get_path(prev, current, reverse)
        end
        delete_fast(open, current)
        for _, pt in ipairs(get_adjacent(current.x, current.y, valid)) do
            local d = dist[current.x][current.y] + cost(current.x, current.y, pt.x, pt.y)
            if d <= max and d < dist[pt.x][pt.y] then
                dist[pt.x][pt.y] = d
                prev[pt.x][pt.y] = current
                dist_heuristic[pt.x][pt.y] = d + heuristic(pt.x, pt.y, destx, desty)
                table.insert(open, pt)
            end
        end
    end
end

function dijk(open, dest_fn, valid, cost, max, reverse)
    cost = cost or dist_c
    max = max or math.huge
    local dist = {}
    local prev = {}
    for x = 1, MAP_W do
        dist[x] = {}
        prev[x] = {}
        for y = 1, MAP_H do
            dist[x][y] = math.huge
        end
    end
    for _, pt in ipairs(open) do
        dist[pt.x][pt.y] = 0
    end
    while open[1] do
        local open2 = {}
        for _, current in ipairs(open) do
            if dest_fn(current.x, current.y) then
                return get_path(prev, current)
            end
            for _, pt in ipairs(get_adjacent(current.x, current.y, valid)) do
                local d = dist[current.x][current.y] + cost(current.x, current.y, pt.x, pt.y)
                if d <= max and d < dist[pt.x][pt.y] then
                    dist[pt.x][pt.y] = d
                    prev[pt.x][pt.y] = current
                    table.insert(open2, pt)
                end
            end
        end
        open = open2
    end
end

function dijk_map(open, valid, cost, max)
    cost = cost or dist_c
    max = max or math.huge
    local dist = {}
    local prev = {}
    for x = 1, MAP_W do
        dist[x] = {}
        prev[x] = {}
        for y = 1, MAP_H do
            dist[x][y] = math.huge
        end
    end
    for _, pt in ipairs(open) do
        dist[pt.x][pt.y] = 0
    end
    while open[1] do
        local open2 = {}
        for _, current in ipairs(open) do
            for _, pt in ipairs(get_adjacent(current.x, current.y, valid)) do
                local d = dist[current.x][current.y] + cost(current.x, current.y, pt.x, pt.y)
                if d <= max and d < dist[pt.x][pt.y] then
                    dist[pt.x][pt.y] = d
                    prev[pt.x][pt.y] = current
                    table.insert(open2, pt)
                end
            end
        end
        open = open2
    end
    return dist, prev
end

function get_path_to_adjacent(ax, ay, bx, by, valid, cost, max)
    return astar(
        get_adjacent(bx, by, valid), ax, ay,
        function (x, y) return (x == ax and y == ay) or valid(x, y) end,
        cost, max, true
    )
end

function get_path(prev, pt, reverse)
    local path = { pt }
    while prev[pt.x][pt.y] do
        pt = prev[pt.x][pt.y]
        if reverse then
            table.insert(path, pt)
        else
            table.insert(path, 1, pt)
        end
    end
    return path
end

function get_source(prev, pt)
    if prev[pt.x][pt.y] then
        return get_source(prev, prev[pt.x][pt.y])
    else
        return pt
    end
end

----

function burn(x, y)
    local s = space(x, y)
    if s.person then
        person_burn(s.person)
    end
    terrain_burn(s.terrain)
end

----

function actor_enter(actor)
    actor.secs = 1 / actor.speed
    table.insert(actors, actor)
end

function actor_setsecs(actor)
    if not actor.time_stop and actor.speed then
    -- check speed for rotten meats which exit the actors list
        actor.secs = 1 / actor.speed
    end
end

function actor_exit(actor)
    actor.secs = nil
    delete(actors, actor)
end

----

function person_init(def)
    assert(data[def])
    local person = { def = def, person = true }
    person.shines = {}
    person.actions = {}
    person.items = {}
    if data[person.def].init then data[person.def].init(person) end
    if person.hp then person.damage = 0 end
    return person
end

function person_enter(person, x, y)
    local s = space(x, y)
    assert(s)
    assert(vacant(x, y))
    person_attach(person, x, y)
    if person.speed then actor_enter(person) end
    person_postact(person)
    if person ~= hero then
        table.insert(kobolds, person)
    end
end

function person_exit(person)
    person_detach(person)
    if person.speed then actor_exit(person) end
    if person ~= hero then
        delete(kobolds, person)
    end
end

function person_attach(person, x, y)
    person.x, person.y = x, y
    space(person.x, person.y).person = person
end

function person_detach(person)
    space(person.x, person.y).person = nil
end

function person_preact(person)
    if person.shines then
        local delete_these = {}
        for i, shine in ipairs(person.shines) do
            if shine.counters then
                shine.counters = shine.counters - 1
                if shine.counters == 0 then
                    table.insert(delete_these, shine)
                end
            end
        end
        for _, shine in ipairs(delete_these) do
            person_shine_exit(person, shine)
        end
        for i, shine in ipairs(person.shines) do
            if data[shine.def].preact_damage then
                data[shine.def].preact_damage(person, shine)
            end
        end
    end
end

function FoV(person)
    hero.fov = {}
    hero.fov.persons = {}
    hero.fov.items = {}
    for x = 1, MAP_W do
        hero.fov[x] = {}
        for y = 1, MAP_H do
            local a =
                dist_c(hero.x, hero.y, x, y) <= 16 and
                (
                    LoS(hero.x, hero.y, x, y, transparent) or
                    LoS(x, y, hero.x, hero.y, transparent)
                )
            hero.fov[x][y] = a
            if a then
                local s = space(x, y)
                if s.person then
                    table.insert(hero.fov.persons, s.person)
                end
                if s.items[1] then
                    table.insert(hero.fov.items, s.items)
                end
                person.visited[x][y] = data[s.terrain.def].char
            end
        end
    end
    table.sort(hero.fov.persons, function (a, b) return dist_c(person.x, person.y, a.x, a.y) < dist_c(person.x, person.y, b.x, b.y) end)
    table.sort(hero.fov.items, function (a, b) return dist_c(person.x, person.y, a[1].x, a[1].y) < dist_c(person.x, person.y, b[1].x, b[1].y) end)
end

function person_search(person)
    for x = 1, MAP_W do
        for y = 1, MAP_H do
            if hero.fov[x][y] then
                local s = space(x, y)
                if s.person and s.person.hidden then
                    person_shine_exit(s.person, s.person.hidden)
                end
            end
        end
    end
end

function transparent(x, y)
    return data[space(x, y).terrain.def].transparent
end

function person_detects(p1, p2)
    if not p2.hidden then
        if p1 == hero then
            return hero.fov[p2.x][p2.y]
        elseif p2 == hero then
            return hero.fov[p1.x][p1.y]
        else
            return
                dist_e(p1.x, p1.y, p2.x, p2.y) <= 16 and
                (
                    LoS(p1.x, p1.y, p2.x, p2.y, transparent) or
                    LoS(p1.x, p1.y, p2.x, p2.y, transparent)
                )
        end
    end
end

function person_postact(person)
    if data[person.def].person_postact then
        data[person.def].person_postact(person)
    end
    for _, shine in ipairs(person.shines) do
        if data[shine.def].person_postact then
            data[shine.def].person_postact(person, shine)
        end
    end
    local s = space(person.x, person.y)
    if data[s.terrain.def].person_terrain_step then
        data[s.terrain.def].person_terrain_step(person, s.terrain)
    end
end

function person_update_distmap(person)
    person.dist = dijk_map(
        {{ x = person.x, y = person.y }},
        function (x, y) return data[map[x][y].terrain.def].walkable end,
        dist_c,
        16
    )
end

function person_rest(person)
    for _, shine in ipairs(person.shines) do
        if data[shine.def].person_rest then
            data[shine.def].person_rest(person, shine)
        end
    end
end

function person_process(person)
    if data[person.process.def].person_process then
        data[person.process.def].person_process(person, person.process)
    end
end

function person_step(person, x, y)
    local s = space(x, y)
    if s and vacant(x, y) then
        local dx, dy = x - person.x, y - person.y
        person_detach(person)
        person_attach(person, x, y)
        for _, shine in ipairs(person.shines) do
            if data[shine.def].person_step then
                data[shine.def].person_step(person, shine, x, y, dx, dy)
            end
        end
        if person.hand and data[person.hand.def].person_step then
            data[person.hand.def].person_step(person, item, x, y, dx, dy)
        end
    end
end

function cautious(ax, ay, bx, by)
    if hero.dist[bx][by] == 1 then return 8 else return 1 end
end

function person_advance(person, destx, desty)
    -- use a* to advance
    local pt = person_advance_pt(person, destx, desty)
    if pt then
        person_step(person, pt.x, pt.y)
    end
end

function person_advance_pt(person, destx, desty)
    local pts = astar(
        {{ x = person.x, y = person.y }},
        destx, desty,
        function (x, y) return vacant(x, y) or (x == destx and y == desty) end,
        function (x, y) return 1 end,
        16
    )
    if pts then
        return pts[2]
    else
        return sort1(
            get_adjacent(person.x, person.y, vacant),
            function (a, b) return hero.dist[a.x][a.y] < hero.dist[b.x][b.y] end
        )
    end
end

function person_retreat_to_dist(person, dist)
    -- use dijkstra to step to a specific distance from the hero
    local pts = dijk(
        {{ x = person.x, y = person.y }},
        function (x, y) return hero.dist[x][y] >= dist end,
        vacant,
        cautious,
        16
    )
    if pts then
        local pt = pts[2]
        person_step(person, pts[2].x, pts[2].y)
    else
        local pt = sort1(
            get_adjacent(person.x, person.y, vacant),
            function (a, b) return hero.dist[a.x][a.y] > hero.dist[b.x][b.y] end
        )
        person_step(person, pt.x, pt.y)
    end
end

function person_retreat_to_dist_and_friend(person, dist, f)
    local pts = dijk(
        {{ x = person.x, y = person.y }},
        function (x, y)
            return hero.dist[x][y] >= dist and dist_c(x, y, f.x, f.y) <= 8
        end,
        vacant,
        cautious,
        16
    )
    if pts then
        local pt = pts[2]
        person_step(person, pts[2].x, pts[2].y)
    else
        local pt = sort1(
            get_adjacent(person.x, person.y, vacant),
            function (a, b) return hero.dist[a.x][a.y] > hero.dist[b.x][b.y] end
        )
        person_step(person, pt.x, pt.y)
    end
end

function person_retreat_to_black(person)
    -- use dijkstra to step to a space the hero can't see
    local pts = dijk(
        {{ x = person.x, y = person.y }},
        function (x, y) return not hero.fov[x][y] end,
        vacant,
        cautious,
        16
    )
    if pts then
        local pt = pts[2]
        person_step(person, pts[2].x, pts[2].y)
    else
        local pt = sort1(
            get_adjacent(person.x, person.y, vacant),
            function (a, b) return hero.dist[a.x][a.y] > hero.dist[b.x][b.y] end
        )
        person_step(person, pt.x, pt.y)
    end
end

function person_retreat(person)
    -- use dijkstra to retreat from the hero
    local dist, prev = dijk_map(
        {{ x = person.x, y = person.y }},
        vacant,
        cautious,
        8
    )
    local furthest
    local furthest_dist = 0
    for x = person.x - 8, person.x + 8 do
        for y = person.y - 8, person.y + 8 do
            local s = space(x, y)
            if s and dist[x][y] < math.huge and hero.dist[x][y] > furthest_dist then
                furthest = { x = x, y = y }
                furthest_dist = hero.dist[x][y]
            end
        end
    end
    if furthest then
        local pts = get_path(prev, furthest)
        person_step(person, pts[2].x, pts[2].y)
    else
        local pt = sort1(
            get_adjacent(person.x, person.y, vacant),
            function (a, b) return hero.dist[a.x][a.y] > hero.dist[b.x][b.y] end
        )
        person_step(person, pt.x, pt.y)
    end
end

function person_move(person, x, y)
    -- for knockback, teleportation, etc.
    local s = space(x, y)
    if s and vacant(x, y) then
        local dx, dy = x - person.x, y - person.y
        person_detach(person)
        person_attach(person, x, y)
    end
end

function person_bump(p1, p2)
    assert(p2.hidden)
    person_shine_exit(p2, p2.hidden)
end

function person_fight(person, x, y)
    -- attack + aux attacks
    person_attack(person, x, y)
    for _, shine in ipairs(person.shines) do
        if data[shine.def].person_fight then
            data[shine.def].person_fight(person, shine, x, y)
        end
    end
    local s = space(x, y)
    local defender = s and s.person
    if defender then
        for _, shine in ipairs(defender.shines) do
            if data[shine.def].person_be_fought then
                data[shine.def].person_be_fought(defender, shine, person)
            end
        end
    end
end

function person_attack(person, x, y)
    -- attack (no aux attacks)
    if person.hand then
        person_item_attack(person, person.hand, x, y)
    else
        data[person.def].attack.execute(person, nil, x, y)
    end
    for _, shine in ipairs(person.shines) do
        if data[shine.def].person_attack then
            data[shine.def].person_attack(person, shine, x, y)
        end
    end
end

function person_item_attack(person, item, x, y)
    data[item.def].attack.execute(person, item, x, y)
end

function person_damage(person, damage)
    -- get hit / returns damage, death
    if person.protected then
        damage = 0
    end
    damage = math.ceil(damage)
    person.damage = math.max(person.damage + damage, 0)
    if person.hp <= person.damage then
        person_die(person)
        return damage, true
    else
        if data[person.def].post_damage then
            data[person.def].post_damage(person)
        end
        return damage
    end
end

function person_fire_damage(person, damage)
    -- get hit w/ fire damage
    if person.drenched then
        return person_damage(person, damage / 2)
    else
        return person_damage(person, damage)
    end
end

function person_electric_damage(person, damage)
    -- get hit w/ electric damage
    if person.drenched then
        return person_damage(person, damage * 2)
    else
        return person_damage(person, damage)
    end
end

function person_burn(person, counters)
    if not person.drenched then
        counters = counters or 8
        if person.burning then
            person.burning.counters = counters
        else
            local shine = shine_init('burning_shine')
            shine.counters = counters
            person_shine_enter(person, shine)
        end
    end
end

function person_drench(person, counters)
    counters = counters or 8
    if person.burning then
        person_shine_exit(person, person.burning)
    end
    if person.drenched then
        person.drenched.counters = counters
    else
        local shine = shine_init('drenched_shine')
        shine.counters = counters
        person_shine_enter(person, shine)
    end
end

function person_poison(person, counters)
    assert(counters)
    if person.poison then
        person.poison.counters = person.poison.counters + counters
    else
        local shine = shine_init('poison_shine')
        shine.counters = counters
        person_shine_enter(person, shine)
    end
end

function person_stun(person, counters)
    if person.stunned then
        person.stunned.counters = person.stunned.counters + counters
    else
        local shine = shine_init('stunned_shine')
        shine.counters = counters
        person_shine_enter(person, shine)
    end
end

function person_satiate(person, counters)
    assert(person.satiated)
    person.satiated.counters = person.satiated.counters + counters
end

function person_die(person)
    person.dead = true
    person_exit(person)
    if data[person.def].die then
        data[person.def].die(person)
    end
    if data[person.def].corpse then
        local item = item_init(data[person.def].corpse)
        item_enter(item, person.x, person.y)
    end
    for _, item in ipairs(person.items) do
        item_enter(item, person.x, person.y)
    end
    if person == hero then
        state_death_init()
    elseif person.def == 'floating_blade_person' then
        note(string.format('the %s vanishes.', data[person.def].name))

    else
        note(string.format('the %s dies. there are %d kobolds left.', data[person.def].name, #kobolds))
        if #kobolds == 0 then
            state_ascension_init()
        end
    end
end

----

function shine_init(def)
    assert(data[def])
    local shine = { def = def }
    if data[shine.def].init then
        data[shine.def].init(shine)
    end
    return shine
end

function person_shine_enter(person, shine)
    table.insert(person.shines, shine)
    if data[shine.def].person_shine_enter then
        data[shine.def].person_shine_enter(person, shine)
    end
end

function person_shine_exit(person, shine)
    delete(person.shines, shine)
    if data[shine.def].person_shine_exit then
        data[shine.def].person_shine_exit(person, shine)
    end
end

----

function action_init(def)
    assert(data[def])
    local action = { def = def }
    if data[action.def].init then data[action.def].init(action) end
    return action
end

function person_action_enter(person, action)
    table.insert(person.actions, action)
end

function person_action_exit(person, action)
    delete(person.actions, action)
end

function person_action_use(person, action, x, y)
    if data[action.def].use.prepare then
        if person.prepared and person.prepared.action == action then
            person_shine_exit(person, person.prepared)
            data[action.def].use.execute(person, action, x, y)
        else
            local shine = shine_init('preparing_shine')
            shine.action = action
            shine.counters = data[action.def].use.prepare
            person_shine_enter(person, shine)
        end
    else
        data[action.def].use.execute(person, action, x, y)
    end
    for _, shine in ipairs(person.shines) do
        if data[shine.def].person_action_use then
            data[shine.def].person_action_use(person, shine, action, x, y)
        end
    end
end

----

function item_init(def)
    assert(data[def])
    local item = { def = def, item = true }
    if data[item.def].init then
        data[item.def].init(item)
    end
    return item
end

function item_enter(item, x, y)
    -- enter map
    item.x, item.y = x, y
    table.insert(space(item.x, item.y).items, item)
    if item.speed then actor_enter(item) end
end

function item_exit(item)
    -- exit map
    delete(space(item.x, item.y).items, item)
    if item.speed then actor_exit(item) end
end

function person_item_enter(person, item, x, y)
    -- enter person's inventory
    table.insert(person.items, item)
    if item.speed then actor_enter(item) end
end

function person_item_exit(person, item)
    -- exit person's inventory
    if data[item.def].equip and person[data[item.def].equip] == item then
        person_item_unequip(person, item)
    end
    delete(person.items, item)
    if item.speed then actor_exit(item) end
end

function person_item_equip(person, item)
    assert(person[data[item.def].equip] ~= item)
    if not find(person.items, item) then
        person_item_enter(person, item)
    end
    if person[data[item.def].equip] then
        person_item_unequip(person, person[data[item.def].equip])
    end
    person[data[item.def].equip] = item
    if data[item.def].person_item_equip then
        data[item.def].person_item_equip(person, item)
    end
end

function person_item_unequip(person, item)
    assert(person[data[item.def].equip] == item)
    person[data[item.def].equip] = nil
    if data[item.def].person_item_unequip then
        data[item.def].person_item_unequip(person, item)
    end
end

function person_item_pickup(person, item)
    -- delete speed stat to skip actor_enter and actor_exit
    local speed = item.speed
    item.speed = nil
    item_exit(item)
    item.x, item.y = nil, nil
    person_item_enter(person, item)
    item.speed = speed
end

function person_item_drop(person, item)
    -- delete speed stat to skip actor_enter and actor_exit
    local speed
    speed, item.speed = item.speed, nil
    person_item_exit(person, item)
    item_enter(item, person.x, person.y)
    item.speed = speed
end

function person_item_drink(person, item, x, y)
    note(string.format('the %s drinks a %s.', data[person.def].name, data[item.def].name), person.x, person.y)
    person_item_exit(person, item)
    data[item.def].drink.execute(person, item, x, y)
end

function person_item_toss(person, item, x, y)
    note(string.format('the %s throws a %s.', data[person.def].name, data[item.def].name), person.x, person.y)
    person_item_exit(person, item)
    data[item.def].toss.execute(person, item, x, y)
end

----

function terrain_init(def)
    assert(data[def])
    local terrain = { def = def, terrain = true }
    if data[terrain.def].init then
        data[terrain.def].init(terrain)
    end
    return terrain
end

function terrain_enter(terrain, x, y)
    assert(x)
    assert(y)
    terrain.x, terrain.y = x, y
    local s = space(terrain.x, terrain.y)
    if s.terrain then
        terrain_exit(s.terrain)
    end
    s.terrain = terrain
    if terrain.speed then actor_enter(terrain) end
end

function terrain_exit(terrain)
    space(terrain.x, terrain.y).terrain = nil
    if terrain.speed then actor_exit(terrain) end
end

function terrain_burn(terrain)
    if data[terrain.def].flammable then
        terrain_enter(terrain_init('fire_terrain'), terrain.x, terrain.y)
    end
end

----

state_one = {}

function state_one.init()
    state = state_one
    state_one.verbose = false
end

function state_one.draw()
    state_one.draw_map()
    if state == state_aim then
        T.print(1, 1, string.format('range: %d', state_aim.dist or 0))
    end
    local n = state_one.verbose and 43 or 8
    for i = 1, n do
        local note = notes[#notes - (n - i)]
        if note then T.print(1, (43 - n) + i, note) end
    end
    state_one.draw_sidebar()
end

function state_one.draw_map()
    local cx, cy = hero.x - 22, hero.y - 17
    for Tx = 0, 79 do
        for Ty = 0, 44 do
            local x = cx + Tx
            local y = cy + Ty
            a, b, c = shades_etc(x, y)
            if a and b and c then
                T.print(Tx, Ty, 
                    string.format('[bkcolor=%s][color=%s]%s[/bkcolor][/color]', a, b, c)
                )
            end
        end
    end
end

function state_one.draw_sidebar()
    local x = 46
    local y = 1
    local short = false
    T.print(x, y,
        string.format(
            '[color=%s]%s[/color] [color=#93a1a1]%s[/color]',
            data[hero.def].color,
            data[hero.def].char,
            data[hero.def].name
            )
        )
        y = y + 1
        local str = string.format(
            '%s %d/%d',
            string.char(3),
            hero.hp - hero.damage,
            hero.hp
        )
        for _, shine in ipairs(hero.shines) do
            str = string.format('%s, %s', str, data[shine.def].name)
            if shine.counters then
                str = string.format('%s (%d)', str, shine.counters)
            end
        end
        if str then
            local h = T.print(x + 2, y, string.format('[bbox=31]%s', str))
            y = y + h
        end
        if hero.hand then
            T.print(x + 2, y,
                string.format(
                    '[color=%s]%s[/color] %s',
                    data[hero.hand.def].color,
                    data[hero.hand.def].char,
                    data[hero.hand.def].name
                )
            )
            y = y + 1
        end
        y = y + 1
    for _, person in ipairs(hero.fov.persons) do
        if y > 33 then break end
        if person ~= hero and not person.hidden then
            if y <= 33 then
                T.print(x, y,
                    string.format(
                        '[color=%s]%s[/color] [color=#93a1a1]%s[/color]',
                        data[person.def].color,
                        data[person.def].char,
                        data[person.def].name
                    )
                )
            end
            y = y + 1
        end
    end
    for _, items in ipairs(hero.fov.items) do
        local s = space(items[1].x, items[1].y)
        if not s.person or s.person.hidden then
            if y <= 33 then
                if items[2] then
                    T.print(x, y,
                        string.format(
                            '[color=#b58900]%s[/color] items',
                            #items <= 9 and #items or '?'
                        )
                    )
                else
                    local item = items[1]
                    T.print(x, y,
                        string.format('[color=%s]%s[/color] %s', 
                            data[item.def].color,
                            data[item.def].char,
                            data[item.def].name
                        )
                    )
                end
            end
            y = y + 1
        end
    end
    if y > 33 then
        T.print(x, 33, string.format('  +%d other objects                 ', y - 32))
    end
end

function shades_etc(x, y)
    local bkcolor, color, char
    if map[x] and map[x][y] then
        local t = map[x][y]
        if FOV_CHEAT or hero.fov[x][y] then
            bkcolor = data[t.terrain.def].bkcolor
            if t.person and not t.person.hidden then
                color = data[t.person.def].color
                char = data[t.person.def].char
            elseif t.items[2] then
                color = '#b58900'
                char = t.items[10] and '?' or #t.items
            elseif t.items[1] then
                local item = t.items[1]
                color = data[item.def].color
                char = data[item.def].char
            else
                color = data[t.terrain.def].color
                char = data[t.terrain.def].deep_char or data[t.terrain.def].char
            end
        elseif hero.visited[x][y] then
            bkcolor, color, char = '#000000', '#586e75', hero.visited[x][y]
        end
    end
    if state == state_aim then
        if state_aim.x == x and state_aim.y == y then
            bkcolor = '#fdf6e3'
        elseif state_aim.check_area(x, y) then
            bkcolor = '#eee8d5'
        end
        color = color or '#93a1a1'
        char = char or '?'
    end
    return bkcolor, color, char
end

function state_one.update(e)
    if e == T.TK_SPACE or e == T.TK_KP_5 then state_one.rest()
    elseif e == T.TK_J or e == T.TK_KP_2 then state_one.step(0, 1)
    elseif e == T.TK_K or e == T.TK_KP_8 then state_one.step(0, -1)
    elseif e == T.TK_H or e == T.TK_KP_4 then state_one.step(-1, 0)
    elseif e == T.TK_L or e == T.TK_KP_6 then state_one.step(1, 0)
    elseif e == T.TK_Y or e == T.TK_KP_7 then state_one.step(-1, -1)
    elseif e == T.TK_U or e == T.TK_KP_9 then state_one.step(1, -1)
    elseif e == T.TK_B or e == T.TK_KP_1 then state_one.step(-1, 1)
    elseif e == T.TK_N or e == T.TK_KP_3 then state_one.step(1, 1)
    elseif e == T.TK_F then state_shoot_init()
    elseif e == T.TK_G then state_one.pickup()
    elseif e == T.TK_I then state_items_init()
    elseif e == T.TK_W then state_equip_init()
    elseif e == T.TK_Q then state_drink_init()
    elseif e == T.TK_T then state_toss_init()
    elseif e == T.TK_D then state_drop_init()
    elseif e == T.TK_C then state_controls_init()
    elseif e == T.TK_1 then FOV_CHEAT = not FOV_CHEAT
    elseif e == T.TK_PERIOD then state_one.verbose = not state_one.verbose
    elseif e == T.TK_SLASH then state_menu_init()
    --elseif e == T.TK_1 then ProFi:start()
    --elseif e == T.TK_2 then ProFi:stop() ProFi:writeReport()

    end
end

function state_one.rest()
    person_search(hero) 
    rotate()
end

function state_one.step(dx, dy)
    local destx = hero.x + dx
    local desty = hero.y + dy
    local s = space(destx, desty)
    if s then
        if vacant(destx, desty) then
            person_step(hero, destx, desty)
        elseif s.person then
            if s.person.hidden then
                person_bump(hero, s.person)
            else
                person_fight(hero, destx, desty)
            end
        end
    end
    rotate()
end

function state_one.pickup()
    local s = space(hero.x, hero.y)
    if #hero.items < 26 then
        if s.items[2] then
            state_pickup_init()
        elseif s.items[1] then
            person_item_pickup(hero, s.items[1])
            rotate()
        end
    else
        note('you can\'t carry more than 24 items.')
    end
end

function state_one.pray()
    local t = map[hero.x][hero.y]
    if t.terrain.def == 'shrine_terrain' then
        print('praying')
        check_cards(t.terrain.cards)
    end
end

function state_one.descend()
    local t = map[hero.x][hero.y]
    if t.terrain.def == 'descent_terrain' then
        descend()
    end
end

----

function state_one.preact()
    person_preact(hero)
    FoV(hero)
    if hero.prepared then
        state_action_use(hero.prepared.action)
    end
    
end

function state_one.postact()
    person_postact(hero)
    FoV(hero)
    person_update_distmap(hero)
end

function rotate()
    state_one.postact()
    actor_setsecs(hero)
    while hero.damage < hero.hp do
        local atbat = actors[1]
        for _, actor in ipairs(actors) do
            if actor.secs < atbat.secs then
                atbat = actor
            end
        end
        local t = atbat.secs
        for _, actor in ipairs(actors) do
            actor.secs = actor.secs - t
        end
        if atbat == hero then
            state_one.preact()
            break
        elseif atbat.person then
            person_act(atbat)
        else
            data[atbat.def].act(atbat)
        end
        actor_setsecs(atbat)
    end
end

function person_act(person)
    person_preact(person)
    if not person.dead then
        if person.stunned or person.asleep then
        
        elseif person.process then
            person_process(person)
        else
            data[person.def].act(person)
        end
        person_postact(person)
    end
end


----

state_aim = {}

function state_aim.init(fn, area, dist)
    state = state_aim
    state_aim.fn = fn
    state_aim.area = area or function (x, y) return false end
    state_aim.dist = dist or 0
    
    local p = hero.fov.persons[2]
    if p and dist_c(hero.x, hero.y, p.x, p.y) <= state_aim.dist then
        state_aim.x, state_aim.y = p.x, p.y
    else
        state_aim.x = hero.x
        state_aim.y = hero.y
    end
end

function state_aim.deinit()
    state_aim.fn = nil
    state_aim.area = nil
    state_aim.dist = nil
    state_aim.x = nil
    state_aim.y = nil
end

function state_aim.draw()
    state_one.draw()
end

function state_aim.check_area(x, y)
    return
        state_aim.area and
        state_aim.area(hero.x, hero.y, state_aim.x, state_aim.y, x, y)
end

function state_aim.update(e)
    if     e == T.TK_J then state_aim.step(0, 1)
    elseif e == T.TK_K then state_aim.step(0, -1)
    elseif e == T.TK_H then state_aim.step(-1, 0)
    elseif e == T.TK_L then state_aim.step(1, 0)
    elseif e == T.TK_Y then state_aim.step(-1, -1)
    elseif e == T.TK_U then state_aim.step(1, -1)
    elseif e == T.TK_B then state_aim.step(-1, 1)
    elseif e == T.TK_N then state_aim.step(1, 1)
    elseif e == T.TK_A then
        local fn, x, y = state_aim.fn, state_aim.x, state_aim.y
        state_aim.deinit()
        state_one.init()
        fn(x, y)
    elseif e == T.TK_ESCAPE then
        state_aim.deinit()
        state_one.init()
    end
end

function state_aim.step(dx, dy)
    if dist_c(hero.x, hero.y, state_aim.x + dx, state_aim.y + dy) <= (state_aim.dist or 0) then
        state_aim.x = state_aim.x + dx
        state_aim.y = state_aim.y + dy
    end
end

----

function state_shoot_init()
    local attack = hero.hand and data[hero.hand.def].attack or data[hero.def].attack
    state_aim.init(
        function (x, y) person_fight(hero, x, y) rotate() end,
        attack.area,
        attack.dist
    )
end

----

state_decide = {}

function state_decide.init(head, text, choices)
    state = state_decide

    state_decide.head = head
    state_decide.text = text
    state_decide.choices = choices
end

function state_decide.deinit()
    state_decide.head = nil
    state_decide.text = nil
    state_decide.choices = nil
end

function state_decide.draw()
    state_one.draw()
    local y = 1
    T.color(T.color_from_name('#93a1a1'))
    T.print(1, y, string.format('%s', state_decide.head))
    y = y + 2

    T.color(T.color_from_name('#839496'))
    if state_decide.text then
        local h = T.print(1, y, string.format('[bbox=43]%s', state_decide.text))
        y = y + h + 1
    end
    
    T.color(T.color_from_name('#93a1a1'))
    for i, choice in ipairs(state_decide.choices) do
        T.print(1, y, string.format('%s) %s', string.char(96 + i), choice.text))
        y = y + 1
    end
    y = y + 1

    T.color(T.color_from_name('#839496'))
    local choice = state_decide.choices[T.TK_ESCAPE]
    if choice then
        T.print(1, y, string.format('esc) %s', choice.text))
    end
end

function state_decide.update(e)
    if     e == T.TK_A then state_decide.choose(1)
    elseif e == T.TK_B then state_decide.choose(2)
    elseif e == T.TK_C then state_decide.choose(3)
    elseif e == T.TK_D then state_decide.choose(4)
    elseif e == T.TK_E then state_decide.choose(5)
    elseif e == T.TK_F then state_decide.choose(6)
    elseif e == T.TK_G then state_decide.choose(7)
    elseif e == T.TK_H then state_decide.choose(8)
    elseif e == T.TK_I then state_decide.choose(9)
    elseif e == T.TK_J then state_decide.choose(10)
    elseif e == T.TK_K then state_decide.choose(11)
    elseif e == T.TK_L then state_decide.choose(12)
    elseif e == T.TK_M then state_decide.choose(13)
    elseif e == T.TK_N then state_decide.choose(14)
    elseif e == T.TK_O then state_decide.choose(15)
    elseif e == T.TK_P then state_decide.choose(16)
    elseif e == T.TK_Q then state_decide.choose(17)
    elseif e == T.TK_R then state_decide.choose(18)
    elseif e == T.TK_S then state_decide.choose(19)
    elseif e == T.TK_T then state_decide.choose(20)
    elseif e == T.TK_U then state_decide.choose(21)
    elseif e == T.TK_V then state_decide.choose(22)
    elseif e == T.TK_W then state_decide.choose(23)
    elseif e == T.TK_X then state_decide.choose(24)
    elseif e == T.TK_Y then state_decide.choose(25)
    elseif e == T.TK_Z then state_decide.choose(26)
    elseif e then
        state_decide.choose(e)
    end
end

function state_decide.choose(i)
    local choice = state_decide.choices[i]
    if choice then
        state_decide.deinit()
        choice.fn()
    end
end

----

function state_pickup_init()
    local choices = {}
    local s = space(hero.x, hero.y)
    for _, item in ipairs(s.items) do
        local text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name)
        local fn = function ()
            if #hero.items < 26 then
                person_item_pickup(hero, item)
                rotate()
                if not hero.dead then
                    if s.items[1] then
                        state_pickup_init()
                    else
                        state_one.init()
                    end
                end
            else
                state_pickup_init()
                note('you can\'t carry more than 26 items.')
            end
        end
        table.insert(choices, { text = text, fn = fn })
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('pick up', nil, choices)

end

----

function state_items_init()
    local choices = {}
    for _, item in ipairs(hero.items) do
        local text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name)
        local fn = function () state_item_init(item) end
        table.insert(choices, { text = text, fn = fn })
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('items', nil, choices)
end

----

function state_item_init(item)
    local choices = {}

    if data[item.def].equip then
        if hero[data[item.def].equip] == item then
            local choice = {
                text = 'unequip it',
                fn = function () state_item_unequip(item) end
            }
            table.insert(choices, choice)
        else
            choice = {
                text = 'equip it',
                fn = function () state_item_equip(item) end
            }
            table.insert(choices, choice)
        end
    end

    if data[item.def].drink then
        local choice = {
            text = 'drink it',
            fn = function () state_item_drink(item) end
        }
        table.insert(choices, choice)
    end

    if data[item.def].toss then
        local choice = {
            text = 'throw it',
            fn = function () state_item_toss(item) end
        }
        table.insert(choices, choice)
    end

    local choice = {
        text = 'drop it',
        fn = function () state_item_drop(item) end
    }
    table.insert(choices, choice)
    
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init(
        string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name),
        data[item.def].desc,
        choices
    )
end

function state_item_equip(item)
    state_one.init()
    person_item_equip(hero, item)
    rotate()
end

function state_item_unequip(item)
    state_one.init()
    person_item_unequip(hero, item)
    rotate()
end

function state_item_drink(item)
    state_aim.init(
        function (x, y) person_item_drink(hero, item, x, y) rotate() end,
        data[item.def].drink.area,
        data[item.def].drink.dist
    )
end

function state_item_toss(item)
    state_aim.init(
        function (x, y) person_item_toss(hero, item, x, y) rotate() end,
        data[item.def].toss.area,
        data[item.def].toss.dist
    )
end

function state_item_drop(item)
    state_one.init()
    person_item_drop(hero, item)
    rotate()
end


----

function state_equip_init()
    local choices = {}
    for _, item in ipairs(hero.items) do
        if data[item.def].equip then
            if hero[data[item.def].equip] == item then
                local choice = {
                    text = string.format('[color=%s]%s[/color] %s (unequip)', data[item.def].color, data[item.def].char, data[item.def].name),
                    fn = function () state_item_unequip(item) end
                }
                table.insert(choices, choice)
            else
                local choice = {
                    text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name),
                    fn = function () state_item_equip(item) end
                }
                table.insert(choices, choice)
            end
        end
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('equip what?', nil, choices)
end

function state_drink_init()
    local choices = {}
    for _, item in ipairs(hero.items) do
        if data[item.def].drink then
            local choice = {
                text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name),
                fn = function () state_item_drink(item) end
            }
            table.insert(choices, choice)
        end
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('drink what?', nil, choices)
end

function state_toss_init()
    local choices = {}
    for _, item in ipairs(hero.items) do
        if data[item.def].toss then
            local choice = {
                text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name),
                fn = function () state_item_toss(item) end
            }
            table.insert(choices, choice)
        end
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('throw what?', nil, choices)
end

function state_drop_init()
    local choices = {}
    for _, item in ipairs(hero.items) do
        local choice = {
            text = string.format('[color=%s]%s[/color] %s', data[item.def].color, data[item.def].char, data[item.def].name),
            fn = function ()
                person_item_drop(hero, item)
                rotate()
                if not hero.dead then
                    if hero.items[1] then
                        state_drop_init()
                    else
                        state_one.init()
                    end
                end
            end
        }
        table.insert(choices, choice)
    end
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('drop what?', nil, choices)
end

----

function state_death_init()
    local choices = {}
    local choice = {
        text = 'start from scratch',
        fn = function ()
            new_game()
            state_one.init()
        end
    }
    table.insert(choices, choice)
    choices[T.TK_ESCAPE] = { text = 'quit', fn = function () state = nil end }
    state_decide.init('you died.', nil, choices)
end

function state_ascension_init()
    local choices = {}
    local choice = {
        text = 'start from scratch',
        fn = function ()
            new_game()
            state_one.init()
        end
    }
    table.insert(choices, choice)
    choices[T.TK_ESCAPE] = { text = 'quit', fn = function () state = nil end }
    state_decide.init('you defeated the 32 kobolds!', nil, choices)
end


----

function state_continue_init()
    local choices = {
        { text = 'continue', fn = function () state_one.init() end },
        { text = 'start from scratch', fn = function () new_game() state_one.init() end },
    }
    choices[T.TK_ESCAPE] = { text = 'quit', fn = function () state = nil end }
    state_decide.init('32 kobolds', nil, choices)
end

function state_start_init()
    local choices = {
        { text = 'start from scratch', fn = function () new_game() state_one.init() end },
    }
    choices[T.TK_ESCAPE] = { text = 'quit', fn = function () state = nil end }
    state_decide.init('32 kobolds', choices, true, '©')
end

function state_menu_init()
    local choices = {
        { text = 'start from scratch', fn = function () new_game() state_one.init() end },
        { text = 'save and quit', fn = function () save_state() state = nil end },
        { text = 'check controls', fn = function () state_controls_init() end },
    }
    choices[T.TK_ESCAPE] = { text = 'quit', fn = function () state_one.init() end }
    state_decide.init('32 kobolds', nil, choices)
end

function state_controls_init()
    local text = 
        '12346789 or hjklyubn: step or attack\n' ..
        '5 or space: rest (and search)\n' ..
        'f: aim attack\n' ..
        'g: pick up an item\n' ..
        'i: inventory\n' ..
        'e: (un)equip\n' ..
        'q: drink an item\n' ..
        't: throw an item\n' ..
        'd: drop an item (put it on the ground)\n' ..
        'c: controls\n' ..
        '. or >: see/hide more notes\n' ..
        '/ or ?: main menu'
    local choices = {}
    choices[T.TK_ESCAPE] = { text = 'back', fn = function () state_one.init() end }
    state_decide.init('controls', text, choices)
end

function save_state()
    local game = {
        hero = hero,
        actors = actors,
        map = map,
        kobolds = kobolds,
        level = level,
        notes = notes
    }
    f = io.open('save_state', 'w')
    f:write(Serpent.dump(game))
    f:close()
end

function load_state()
    local f = io.open('save_state', 'r')
    if f then
        local s = f:read()
        io.close(f)
        os.remove('save_state')
        local t = loadstring(s)()
        hero = t.hero
        actors = t.actors
        map = t.map
        kobolds = kobolds
        level = t.level
        notes = t.notes

        state_continue_init()
        return true
    end
end
----

function run()
    math.randomseed(os.time())
    T.open()
    T.set('window: size=80x45, title=\'32K\'')
    T.set('input: filter=[keyboard, close]')
    T.set('font: max_brazilian_8x8.png, size=16x16, transparent=#000000')

    if not load_state() then
        new_game()
        state_one.init()
    end

    while state do
        T.bkcolor(T.color_from_name('#000000'))
        T.color(T.color_from_name('#839496'))
        T.clear()
        state.draw()
        T.refresh()
        if T.has_input() then
            local e = T.read()
            if e == T.TK_CLOSE then
                state = nil
            else
                state.update(e)
            end
        end
    end
end

run()

