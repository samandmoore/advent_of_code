values = File.readlines('input.txt')
previous_value = nil
current_value = nil
values_greater_than_previous_value = []

values.each do |value|
  current_value = value.to_i
  if previous_value && current_value > previous_value
    values_greater_than_previous_value << current_value
  end
  previous_value = current_value
end

puts "There are #{values_greater_than_previous_value.size} values greater than their previous values."
