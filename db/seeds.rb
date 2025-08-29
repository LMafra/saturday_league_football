def print_header(title)
  puts "\n\e[33m== #{title} ==\e[0m"
end

def print_item(label, *details)
  puts "✅ \e[32m#{label}\e[0m" + (details.any? ? " - #{details.join(' | ')}" : "")
end

def print_subitem(label, *details)
  puts "  └─ #{label}" + (details.any? ? " - #{details.join(' | ')}" : "")
end

begin
  # Clear existing data (uncomment if needed)
  # ActiveRecord::Base.connection.tables.each do |t|
  #   ActiveRecord::Base.connection.execute("TRUNCATE #{t} RESTART IDENTITY CASCADE")
  # end

  print_header "CREATING CHAMPIONSHIPS"
  championships = 3.times.map do |i|
    champ = FactoryBot.create(:championship)
    print_item "Championship #{i+1}", champ.name, champ.description
    champ
  end

  print_header "CREATING TEAMS"
  teams = 9.times.map do |i|
    team = FactoryBot.create(:team)
    print_item "Team #{i+1}", team.name
    team
  end

  print_header "CREATING PLAYERS"
  players = 30.times.map do |i|
    player = FactoryBot.create(:player)
    print_item "Player #{i+1}", player.name
    player
  end

  print_header "ASSIGNING PLAYERS TO TEAMS"
  shuffled_players = players.shuffle
  # Distribute players evenly (3-4 per team)
  teams.each do |team|
    players_for_team = shuffled_players.shift(3)
    players_for_team.each do |player|
      pt = FactoryBot.create(:player_team, player: player, team: team)
      print_item "PlayerTeam ##{pt.id}", "Player: #{player.name}", "Team: #{team.name}"
    end
  end
  # Assign remaining players to first 3 teams
  teams.take(3).each do |team|
    player = shuffled_players.shift
    pt = FactoryBot.create(:player_team, player: player, team: team)
    print_item "PlayerTeam ##{pt.id}", "Player: #{player.name}", "Team: #{team.name}"
  end

  print_header "BUILDING CHAMPIONSHIP STRUCTURE"
  championships.each do |championship|
    print_item "Working on Championship: #{championship.name}"

    rounds = 3.times.map do |i|
      round = FactoryBot.create(:round, name: "#{(i+1).ordinalize} Rodada", championship: championship)
      print_subitem "Round #{i+1}", round.name, round.round_date.to_s
      round
    end

    # Assign 3 teams to each round
    shuffled_teams = teams.shuffle
    rounds.each_with_index do |round, index|
      round_teams = shuffled_teams[index*3, 3]
      round_teams.each do |team|
        team.update!(round_id: round.id)
        print_subitem "Assigned Team #{team.name} to Round #{round.name}"
      end
    end

    rounds.each do |round|
      print_subitem "Creating matches for #{round.name}"
      round_teams = Team.where(round_id: round.id).to_a

      # Create all possible team combinations for matches
      round_teams.combination(2).each do |team1, team2|
        match = FactoryBot.create(:match,
                                  round: round,
                                  name: "#{team1.name} vs #{team2.name}",
                                  team_1: team1,
                                  team_2: team2,
                                  winning_team_id: [team1.id, team2.id].sample,
                                  draw: false
        )

        print_subitem "Match #{match.id}",
                      "#{team1.name} vs #{team2.name}",
                      "Winner: #{Team.find(match.winning_team_id).name}"

        # Create player stats for this match
        3.times do
          team = [team1, team2].sample
          player = team.players.sample

          stat = FactoryBot.create(:player_stat,
                                   player: player,
                                   team: team,
                                   match: match,
                                   goals: rand(0..2),
                                   own_goals: 0,
                                   assists: rand(0..2),
                                   was_goalkeeper: [true, false].sample
          )

          print_subitem "PlayerStat ##{stat.id}",
                        "#{player.name} (#{team.name})",
                        "Goals: #{stat.goals}",
                        "Assists: #{stat.assists}",
                        "GK: #{stat.was_goalkeeper}"
        end
      end

      # Assign 10 players to each round
      print_subitem "Creating player rounds for #{round.name}"
      shuffled_players = players.shuffle
      players_for_round = shuffled_players.shift(10)
      players_for_round.each do |player|
        pr = FactoryBot.create(:player_round, round: round, player: player)
        print_subitem "PlayerRound ##{pr.id}", "Player: #{pr.player.name}", "Round: #{round.name}"
      end
    end
  end

  print_header "FINAL CREATION REPORT"
  puts "\n\e[34mTotal Created Records:\e[0m"
  puts "• Championships: #{Championship.count}"
  puts "• Rounds: #{Round.count}"
  puts "• Matches: #{Match.count}"
  puts "• Teams: #{Team.count}"
  puts "• Players: #{Player.count}"
  puts "• PlayerTeams: #{PlayerTeam.count}"
  puts "• PlayerRounds: #{PlayerRound.count}"
  puts "• PlayerStats: #{PlayerStat.count}"

  puts "\n\e[32m✅ Seed data created successfully!\e[0m"

rescue => e
  puts "\n\e[31m❌ Error: #{e.message}\e[0m"
  puts e.backtrace.first(5).join("\n")
  raise
end