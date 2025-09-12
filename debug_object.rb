require_relative 'lib/json_rb'

result = JSONParser.parse('{"key": "value"}')
puts "Object value class: #{result[:token][:value].class}"
puts "Object value: #{result[:token][:value].inspect}"

if result[:token][:value].is_a?(Array) && !result[:token][:value].empty?
  puts "First pair type: #{result[:token][:value].first[:type]}"
end