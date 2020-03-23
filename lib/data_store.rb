class DataStore
  class EntryNotFound < StandardError; end

  attr_reader :data

  def initialize(initial_data = nil)
    if initial_data
      @data = parse_json_to_data(initial_data)
    end
  end

  def load_json_file!
    file = File.read("./data.json")

    json = JSON(file)

    @data = parse_json_to_data(json)
  end

  def get_suggestions_for(query, limit = 10)
    if query.nil?
      return @data
    end

    regex = /^#{query}/i

    @data
      .select { |e| e[:name] =~ regex }
      .sort { |a, b| b[:times] <=> a[:times] }
      .tap do |r|
          if i = r.index { |x| compare_str(x[:name], query) }
            r.unshift(r.delete_at(i))
          end
        end
      .first(limit)
  end

  def increase_popularity_for(name)
    i = @data.find_index { |entry| compare_str(entry[:name], name) }

    if i.nil?
      raise EntryNotFound
    end

    @data[i][:times] += 1

    @data[i]
  end

private

  def parse_json_to_data(json)
    json.map { |k, v| { name: k, times: v } }
  end

  def compare_str(a, b)
    a.downcase == b.downcase
  end
end
