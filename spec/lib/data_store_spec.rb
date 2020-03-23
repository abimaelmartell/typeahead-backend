require 'spec_helper'

require_relative '../../lib/data_store'

describe DataStore do
  let (:data) {
    {
      'John' => 20,
      'Ana' => 30,
      'Anabelle' => 50,
      'Johnson' => 40,
      'Johnny' => 10,
    }
  }

  describe '#initialize' do
    it 'should be able to set data' do
      service = described_class.new data

      expect(service.data.count).to eql(data.count)
    end
  end

  describe '#load_json_file!' do
    it 'should read from json file' do
      service = described_class.new

      expect { service.load_json_file! }.to change { service.data }
    end
  end

  describe '#increase_popularity' do
    it 'should update times on provided name' do
      service = described_class.new data

      expect {
        service.increase_popularity_for('ana')
      }.to change{
        service.data[1][:times]
      }.from(30).to(31)
    end
  end

  describe '#get_suggestions' do
    let(:service) { described_class.new data }

    it 'should return suggestions ordered by popularity' do
      results = service.get_suggestions_for('jo')

      expect(results.count).to eql(3)
      expect(results.first[:name]).to eql('Johnson')
    end

    it 'should return exacth matches first' do
      results = service.get_suggestions_for('john')

      expect(results.count).to eql(3)
      expect(results.first[:name]).to eql('John')
    end
  end
end
