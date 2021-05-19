require 'net/http'
require 'json'

namespace :country_generator do
  desc "Generate countries"
  task gen: :environment do
    url = 'https://gist.githubusercontent.com/Keeguon/2310008/raw/865a58f59b9db2157413e7d3d949914dbf5a237d/countries.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    countries = YAML.load(response.gsub("\'", ' '))
    compact = countries.map(&:compact)
    Country.create(compact)
  end
end
