class DataStore
  attr_reader :data

  def initialize(initial_data = nil)
    @data = initial_data
  end

  def load_json_file!
    file = File.read("./data.json")

    @data = JSON(file, symbolize_names: true)
  end

  def get_suggestions_for(query)
    regex = /^#{query}/i
    regex_match = /^#{query}$/i

    suggestions = @data.select { |e| e[:name] =~ regex }

    suggestions.sort do |a, b|
      if a[:name].match?(regex_match)
        -1
      else
        b[:times] <=> a[:times]
      end
    end
  end

  def increase_popularity_for(name)
    i = @data.find_index { |entry| entry[:name] == name }

    if i.nil?
      return false
    end

    @data[i][:times] += 1

    true
  end
end
