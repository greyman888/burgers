class Order < ApplicationRecord
  has_many :selections,     dependent: :destroy
  has_many :items,          through: :selections

  def process_order
    types = ["Addition", "Burger", "Drink", "Meal", "Side", "Subtraction"]
    types_with_size = ["Drink", "Meal", "Side"]
    sizes = ["Small", "Medium", "Large"]
    threshold = 3
    results = []
  
    entities = JSON.parse(self.response || "{}")
  
    # Step 1 is to match the entities to items
    entities.each do |entity|
      closest_type = find_closest_match(entity["type"], types, threshold)
      next unless closest_type
  
      # Set default values for size if not provided
      if types_with_size.include?(closest_type)
        if closest_type == "Meal"
          closest_size = entity["size"] ? (find_closest_match(entity["size"], sizes, threshold) || "Medium") : "Medium"
        else  
          closest_size = entity["size"] ? (find_closest_match(entity["size"], sizes, threshold) || "Small") : "Small"
        end
      end
  
      items = if closest_size
                Item.where(category: closest_type, size: closest_size).to_a
              else
                Item.where(category: closest_type).to_a
              end
  
      item = find_closest_item(entity["name"], items, threshold) 
      if item.nil?
        self.update(missing: "#{self.missing}#{entity["name"]}, ")
      end
      next unless item

      results << {id: entity["id"], item_id: item.id, type: item.category, name: item.name, size: item.size, related_to: entity["related_to"]}
    end
  
    # Step 2 is to create order selections and burger modifications

    # Create a list of meals
    meals = []
    burgers = []
    results.each do |result|
      if result[:type] == "Meal"
        # create selection to use as meal_id
        selection = Selection.create(order_id: self.id, item_id: result[:item_id])
        meals << {id: result[:id], selection_id: selection.id, side_count: 0, size: result[:size]}
      end
    end

    results.each do |result|
      if !["Addition", "Subtraction", "Meal"].include?(result[:type]) 
        # Link Meals
        meal_id = nil
        meals.each do |meal|
          if result[:related_to].include?(meal[:id])
            meal_id = meal[:selection_id]
            meal[:side_count] += 1 if result[:type] != "Burger"
            meal[:side] = true if result[:type] == "Side"
            meal[:drink] = true if result[:type] == "Drink"
          end
        end
        selection = Selection.create(order_id: self.id, item_id: result[:item_id], meal_id: meal_id)
        
        # Create list of Burgers to link additions and subtractions
        if result[:type] == "Burger"
          burgers << {id: result[:id], selection_id: selection.id} # assumes burgers come before additions
        end
      elsif ["Addition", "Subtraction"].include?(result[:type]) 
        # Link burger modifications
        selection_id = nil
        burgers.each do |burger|
          if result[:related_to].include?(burger[:id])
            selection_id = burger[:selection_id]
          end
        end
        Modification.create(selection_id: selection_id, item_id: result[:item_id])
      end
    end

    # Step3 - fill in missing Meal defaults (Each meal should have 2 sides)
    meals.each do |meal|
      # Validate minimum sizes for sides (a medium meal should at have at least medium sides)
      sides = Selection.where(meal_id: meal[:selection_id])
      sides.each do |selection|
        side = selection.item
        if side.size > meal[:size] # Sizes work in reverse alphabetical order
          item = Item.find_by(category: side.category, name: side.name, size: meal[:size])
          selection.update(item_id: item.id)
        end
      end

      # add missing implied items
      case meal[:side_count]
      when 0
        side = Item.find_by(category: "Side", name: "Fries", size: meal[:size])
        Selection.create(order_id: self.id, item_id: side.id, meal_id: meal[:selection_id])
        side = Item.find_by(category: "Drink", name: "Cola", size: meal[:size])
        Selection.create(order_id: self.id, item_id: side.id, meal_id: meal[:selection_id])
      when 1
        if meal[:drink]
          side = Item.find_by(category: "Side", name: "Fries", size: meal[:size])
          Selection.create(order_id: self.id, item_id: side.id, meal_id: meal[:selection_id])
        else
          side = Item.find_by(category: "Drink", name: "Cola", size: meal[:size])
          Selection.create(order_id: self.id, item_id: side.id, meal_id: meal[:selection_id])
        end
      when 2
        nil
      else
        # Code required to remove additional items
      end
    end
  end
  
  def find_closest_match(target, candidates, threshold)
    matcher = Amatch::Levenshtein.new(target)
    closest = candidates.min_by { |candidate| matcher.match(candidate) }
    return closest if matcher.match(closest) <= threshold
    nil
  end
  
  def find_closest_item(target_name, items, threshold)
    cleaned_name = target_name.gsub(/Meal|Drink|Side/i, "").strip
    name_matcher = Amatch::Levenshtein.new(cleaned_name)
    closest = items.min_by { |item| name_matcher.match(item.name) }
    return closest if name_matcher.match(closest.name) <= threshold
    nil
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
        template: "burger example 2",
        mode: "balanced"
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      self.response = response.body
      self.save
    else
      puts "Request failed: #{response.body}"
    end
    
  end

end
