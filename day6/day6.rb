# --- Day 6: Trash Compactor ---
# After helping the Elves in the kitchen, you were taking a break and helping them re-enact a movie scene when you over-enthusiastically jumped into the garbage chute!

# A brief fall later, you find yourself in a garbage smasher. Unfortunately, the door's been magnetically sealed.

# As you try to find a way out, you are approached by a family of cephalopods! They're pretty sure they can get the door open, but it will take some time. While you wait, they're curious if you can help the youngest cephalopod with her math homework.

# Cephalopod math doesn't look that different from normal math. The math worksheet (your puzzle input) consists of a list of problems; each problem has a group of numbers that need to either be either added (+) or multiplied (*) together.

# However, the problems are arranged a little strangely; they seem to be presented next to each other in a very long horizontal list. For example:

# 123 328  51 64
#  45 64  387 23
#   6 98  215 314
# *   +   *   +
# Each problem's numbers are arranged vertically; at the bottom of the problem is the symbol for the operation that needs to be performed. Problems are separated by a full column of only spaces. The left/right alignment of numbers within each problem can be ignored.

# So, this worksheet contains four problems:

# 123 * 45 * 6 = 33210
# 328 + 64 + 98 = 490
# 51 * 387 * 215 = 4243455
# 64 + 23 + 314 = 401
# To check their work, cephalopod students are given the grand total of adding together all of the answers to the individual problems. In this worksheet, the grand total is 33210 + 490 + 4243455 + 401 = 4277556.

# Of course, the actual worksheet is much wider. You'll need to make sure to unroll it completely so that you can read the problems clearly.

# Solve the problems on the math worksheet. What is the grand total found by adding together all of the answers to the individual problems?

# --- Part Two ---
# The big cephalopods come back to check on how things are going. When they see that your grand total doesn't match the one expected by the worksheet, they realize they forgot to explain how to read cephalopod math.

# Cephalopod math is written right-to-left in columns. Each number is given in its own column, with the most significant digit at the top and the least significant digit at the bottom. (Problems are still separated with a column consisting only of spaces, and the symbol at the bottom of the problem is still the operator to use.)

# Here's the example worksheet again:
#
# 328 - 64X - 98X
# should become
#  + 369 (0,0,0) +  248 (1,1,1) + 8 (2, nil, nil)
#
# 123 - 45 - 6
# should become
#  + 1 (0,nil, nil) +  24 (1,0,1) + 356 (2, nil, nil)
#
# 123 328  51 64
#  45 64  387 23
#   6 98  215 314
# *   +   *   +
# Reading the problems right-to-left one column at a time, the problems are now quite different:

# The rightmost problem is 4 + 431 + 623 = 1058
# The second problem from the right is 175 * 581 * 32 = 3253600
# The third problem from the right is 8 + 248 + 369 = 625 XXXX
# Finally, the leftmost problem is 356 * 24 * 1 = 8544
# Now, the grand total is 1058 + 3253600 + 625 + 8544 = 3263827.

# Solve the problems on the math worksheet again. What is the grand total found by adding together all of the answers to the individual problems?

class Worksheet
  class Equation

    def initialize(numbers, operation)
      @numbers = numbers
      @operation = operation
    end

    def to_s
      "numbers: #{@numbers.join(", ")} : operation: #{@operation}"
    end

    def solve
      case operation
        when '+' then numbers.sum
        when '*' then numbers.reduce(:*)
      end
    end

    private

    attr_reader :numbers, :operation
  end

  def initialize(lines)
    @raw_lines = lines
  end

  def part1
    parsed = @raw_lines.map { |row| row.split }
    equations = parsed.transpose.map do |column|
      numbers = column[0...-1].map(&:to_i)
      operation = column.last

      Equation.new(numbers, operation)
    end

    equations.sum(&:solve)
  end

  def part2
    columns = @raw_lines.map(&:chars).transpose
    operator_indices = columns.each_index.select { |i| columns[i].last =~ /[+*]/ }
    equations = []

    (operator_indices + [columns.length]).each_cons(2) do |operator_index, next_operator_index|
      operator = columns[operator_index].last
      numbers = []

      (operator_index...next_operator_index).each do |col_idx|
        digits = columns[col_idx][0...-1].join.delete(' ')
        numbers << digits.to_i unless digits.empty?
      end

      equations << Equation.new(numbers, operator)
    end

    equations.sum(&:solve)
  end

  private

  attr_reader :raw_lines
end


EXAMPLE_INPUT = [
  " 123 328  51 64  ",
  "  45 64  387 23  ",
  "   6 98  215 314 ",
  "*   +   *   +    "
]

example = Worksheet.new(EXAMPLE_INPUT)
puts "example input part 1: #{example.part1}, part 2: #{example.part2}"

worksheet = Worksheet.new(File.readlines("day6/input.txt", chomp: true))
puts "real input part 1: #{worksheet.part1} part 2: #{worksheet.part2}"
