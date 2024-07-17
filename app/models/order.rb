class Order < ApplicationRecord
  has_many :selections,     dependent: :destroy
  has_many :items,          through: :selections

  def process_order
    # Create lists and defaults
    types = ["Addition", "Burger", "Drink", "Meal", "Side", "Subtraction", "User" ]
    results = []

    entities = JSON.parse(self.response)
    entities.each do |entity|
      type_matcher = Amatch::Levenshtein.new(entity["type"])
      closest_type = types.min_by {|type| type_matcher.match(type)}

      name_matcher = Amatch::Levenshtein.new(entity["name"])
      items = Item.where(category: closest_type).to_a
      closest_item = items.min_by {|item| name_matcher.match(item.name)}

      # Size goes here

      results << [entity["name"], closest_item&.name]
    end
    return results
  end


  def convert_to_JSON
    ais_api_key = ENV["AIS_API_KEY"]
    uri = URI.parse("https://api.ai-struct.com/api/v1/submit")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ais_api_key}"

    request.body = {
      chunk: {
        text: self.chunk,
        template: "burger example 1",
        mode: "accuracy"
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      # puts "Request was successful: #{response.body}"
      self.response = response.body
      self.save
    else
      puts "Request failed: #{response.body}"
    end
    
  end

end
