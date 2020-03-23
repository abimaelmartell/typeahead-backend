require 'spec_helper'

require_relative '../../lib/typeahead.rb'

ENV['SUGGESTION_NUMBER'] = "5"

describe Typeahead do
  let (:app) { Typeahead }
  let (:suggestion_number) { ENV['SUGGESTION_NUMBER'].to_i }

  describe 'GET /typeahead' do
    context 'without trailing slash' do
      it 'should respond ok' do
        get '/typeahead'
        expect(last_response).to be_ok
      end
    end

    context 'without params' do
      it 'should respond ok' do
        get '/typeahead/'
        expect(last_response).to be_ok
      end
    end

    context 'with query "jo"' do
      let (:query) { "jo" }
      let (:response) { get "/typeahead/#{query}" }
      let (:results) { JSON(response.body) }

      it 'should return SUGGESTION_NUMBER results for that query' do
        expect(response).to be_ok
        expect(results.count).to eql(suggestion_number)
      end

      it 'should return exact match first' do
        expect(results.first['name'].downcase).to eql(query)
      end

      it 'should return the rest ordered by "times"' do
        suggestions = results.slice(1, suggestion_number - 1)
        times = suggestions.map { |e| e["times"] }

        sorted = times.sort{ |a,b| b <=> a }

        expect(times).to eql(sorted)
      end
    end
  end

  describe 'POST /typeahead/set' do
    context 'with unexising name' do
      let (:data) { { name: 'invalid' }.to_json }

      it 'should return 400 error' do
        post '/typeahead/set', data

        expect(last_response).to be_bad_request
      end
    end

    context 'with valid name' do
      let (:name) { 'annabelle' }
      let (:data) { { name: name }.to_json }

      it 'should return the entry object' do
        post '/typeahead/set', data

        expect(last_response).to be_ok

        entry = JSON(last_response.body)

        expect(entry['name'].downcase).to eql(name)
        expect(entry['times']).to be_an_instance_of(Integer)
      end
    end
  end
end
