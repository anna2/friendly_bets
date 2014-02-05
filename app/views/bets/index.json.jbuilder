json.array!(@bets) do |bet|
  json.extract! bet, :id, :title, :description, :amount
  json.url bet_url(bet, format: :json)
end
