require 'nokogiri'
require 'active_support/core_ext'
require 'json'

def remove_unused_infos(input_file, output_file)
  doc = Nokogiri::XML(File.new(input_file))
  cities = <<-XML
  <?xml version="1.0" encoding="utf-8"?>
  <cities>
  XML
  
  useful_fields = ['ville_id', 'ville_departement', 'ville_nom',
                   'ville_latitude_deg', 'ville_longitude_deg',
                   'ville_code_postal']
  
  doc.xpath('//table').each do |table|
    city = "<city> "
    table.children.each do |column|
      city << " <#{column['name']}>#{column.text}</#{column['name']}> " if (useful_fields.include?(column['name']))
    end
    city << '</city>'
    cities << city
  end

  cities << ' </cities>'

  File.open(output_file, "w+") do |data|
    data << cities
  end
  json = Hash.from_xml(cities).to_json
  File.open('test.json', 'w+').write json
end

def main
  remove_unused_infos(ARGV[0], ARGV[1])
end

main
