values = File.readlines('input.txt')
groups_greater_than_previous = 0
a = []
b = []

values.each do |value|
  if a.size < 3
    a << value.to_i
  end

  if a.size > 1
    b << value.to_i
  end

  if a.size == 3 && b.size == 3
    a_sum = a.reduce(&:+)
    b_sum = b.reduce(&:+)
    if b_sum > a_sum
      groups_greater_than_previous = groups_greater_than_previous + 1
    end
    a = b
    b = a.dup[1..-1]
  end
end

puts "There are #{groups_greater_than_previous} groups greater than their previous groups."
