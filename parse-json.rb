# Author Lucian Ghinda
# Purpose: 
#   to parse the aggregated JSON data and split it based on programming languages
#   or frameworks. 

require "json"
require 'byebug'
require 'pry'
require 'pp'

def prog_lang_to_filename(prog_lang)
  prog_lang.tr("+","plus").tr("#","sharp").tr('.','').tr(" ",'')
end

file = File.read './startups-list.json'
data = JSON.parse(file)

groupped = {}

data.each do |company|
  company['original_programming_language'].each do |prog_lang|
    unless groupped.keys.include?(prog_lang)
      groupped[prog_lang] = {
        count: 0,
        total_funding: 0,
        startup_list: {
          "YCombinator": 0,
          "TechStars": 0, 
        },
        companies: [],
      }
    end
    groupped[prog_lang][:companies] << company 
    begin 
      groupped[prog_lang][:count] += 1
      groupped[prog_lang][:total_funding] += company["money_raised_so_far"]
      groupped[prog_lang][:startup_list][company["startup_list"].to_sym] += 1
    rescue NoMethodError => e 
      byebug 
    end 
  end
end

groupped.sort_by do |k,v|
  v[:count]
end.reverse!

groupped.each do |key, value|
  json_filename = File.join('./groupped', "#{prog_lang_to_filename(key)}.json")
  File.open(json_filename, 'w') do |f|
    f.write(value.to_json)
  end
end
