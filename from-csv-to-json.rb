# Author Lucian Ghinda
# Purpose: 
#   to parse the CSV file and create a JSON structure based on it.

require 'csv'
require 'set'
require 'json'
require 'byebug'

def get_programming_lang(str)
  str.downcase!
  programming_languages = Set.new 
  programming_languages.merge(str.split(",").map(&:downcase).map(&:strip))
  programming_languages << 'ruby' if str.include? 'ruby on rails'
  programming_languages << 'python' if str.include? 'python with django'
  return programming_languages.to_a
end

def transform_to_json(row)
  begin 
    {
      "name": row[0],
      "original_programming_language": get_programming_lang(row[1]),
      "founded": row[2],
      "money_raised_so_far": row[3].tr(',','.').to_f,
      "number_of_employees": row[5],
      "rank": row[6].to_i,
      "current_programming_language": get_programming_lang(row[8]),
      "sources": [row[9], row[10], row[11], row[12], row[13]],
      "startup_list": row[7]
    }
  rescue NoMethodError => e
    puts "Fix #{row.inspect}"
  end
end

def process_csv(csv_filename, json_filename)
  csv_content = File.read(csv_filename)
  csv = CSV.parse(csv_content, col_sep: ';', headers: true)

  data = []
  csv.each do |row|
    data << transform_to_json(row)
  end

  File.open(json_filename, 'w') do |f|
    f.write(data.to_json)
  end
end


# the main part 
process_csv('./startups-list.csv', './startups-list.json')