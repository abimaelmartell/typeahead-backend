require 'sinatra/base'
require_relative 'data_store'

class Typeahead < Sinatra::Base
  before do
    content_type 'application/json'
  end

  set :suggestions_limit, Proc.new { ENV.fetch('SUGGESTION_NUMBER', 10).to_i }

  def initialize
    @store = DataStore.new
    @store.load_json_file!

    super
  end

  get '/typeahead/?:query?' do
    query = params[:query] || ""

    results = @store.get_suggestions_for(
      query,
      settings.suggestions_limit
    )

    results.to_json
  end

  post '/typeahead/set' do
    request.body.rewind

    data = JSON(
      request.body.read, symbolize_names: true
    )

    begin
      result = @store.increase_popularity_for(data[:name])

      result.to_json
    rescue DataStore::EntryNotFound
      status 400
    end
  end
end
