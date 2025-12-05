# As the forklifts break through the wall, the Elves are delighted to discover that there was a cafeteria on the other side after all.

# You can hear a commotion coming from the kitchen. "At this rate, we won't have any time left to put the wreaths up in the dining hall!" Resolute in your quest, you investigate.

# "If only we hadn't switched to the new inventory management system right before Christmas!" another Elf exclaims. You ask what's going on.

# The Elves in the kitchen explain the situation: because of their complicated new inventory management system, they can't figure out which of their ingredients are fresh and which are spoiled. When you ask how it works, they give you a copy of their database (your puzzle input).

# The database operates on ingredient IDs. It consists of a list of fresh ingredient ID ranges, a blank line, and a list of available ingredient IDs. For example:

# 3-5
# 10-14
# 16-20
# 12-18

# 1
# 5
# 8
# 11
# 17
# 32
# The fresh ID ranges are inclusive: the range 3-5 means that ingredient IDs 3, 4, and 5 are all fresh. The ranges can also overlap; an ingredient ID is fresh if it is in any range.

# The Elves are trying to determine which of the available ingredient IDs are fresh. In this example, this is done as follows:

# Ingredient ID 1 is spoiled because it does not fall into any range.
# Ingredient ID 5 is fresh because it falls into range 3-5.
# Ingredient ID 8 is spoiled.
# Ingredient ID 11 is fresh because it falls into range 10-14.
# Ingredient ID 17 is fresh because it falls into range 16-20 as well as range 12-18.
# Ingredient ID 32 is spoiled.
# So, in this example, 3 of the available ingredient IDs are fresh.

# Process the database file from the new inventory management system. How many of the available ingredient IDs are fresh?

# --- Part Two ---
# The Elves start bringing their spoiled inventory to the trash chute at the back of the kitchen.

# So that they can stop bugging you when they get new inventory, the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh. An ingredient ID is still considered fresh if it is in any range.

# Now, the second section of the database (the available ingredient IDs) is irrelevant. Here are the fresh ingredient ID ranges from the above example:

# 3-5
# 10-14
# 16-20
# 12-18
# The ingredient IDs that these ranges consider to be fresh are 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20. So, in this example, the fresh ingredient ID ranges consider a total of 14 ingredient IDs to be fresh.

# Process the database file again. How many ingredient IDs are considered to be fresh according to the fresh ingredient ID ranges?

class FreshRange
  def self.from_string(range_string)
    low, high = range_string.split('-').map(&:to_i)
    new(low: low, high: high)
  end

  def self.merge(ranges)
    merged = []

    ranges.sort_by(&:low).each do |range|
      if merged == []
        merged = [range]
      else
        last_merged = merged.pop
        merged = merged.concat(last_merged.merge(range))
      end
    end

    merged
  end

  def initialize(low:, high:)
    @low, @high = low, high
  end

  attr_reader :low, :high

  def includes?(ingredient_id)
    @low <= ingredient_id.id && ingredient_id.id <= @high
  end

  def count
    @high - @low + 1
  end

  def to_s
    "#{@low}-#{@high}"
  end

  # returns an array of ranges: 1 or 2 depending on whether the ranges overlap
  def merge(other)
    if @high + 1 >= other.low
      [FreshRange.new(low: @low, high: [other.high, @high].max)]
    else
      [self, other]
    end
  end
end

class IngredientId
 def initialize(id)
   @id = id.to_i
 end

 attr_reader :id

 def to_s
   "id:#{@id}"
 end

end

def part1(ranges, ingredient_ids)
  merged = FreshRange.merge(ranges)

  ingredient_ids.count do |ingredient_id|
    merged.any? do |range|
      range.includes?(ingredient_id)
    end
  end
end

def part2(ranges)
  FreshRange.merge(ranges).sum(&:count)
end

# example
EXAMPLE_INPUT = <<~INPUT
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
INPUT

rangesStr, ingredientsStr = EXAMPLE_INPUT.split(/\n{2}/)
ranges = rangesStr.split(/\n/).map { |range| FreshRange.from_string(range) }
ingredientIds = ingredientsStr.split(/\n/).map { |id| IngredientId.new(id) }
part1 = part1(ranges, ingredientIds)
part2 = part2(ranges)
puts "example solution part1: #{part1} part2: #{part2}"

# real input
lines = File.read("day5/input.txt")
rangesStr, ingredientsStr = lines.split(/\n{2}/)
ranges = rangesStr.split(/\n/).map { |range| FreshRange.from_string(range) }
ingredientIds = ingredientsStr.split(/\n/).map { |id| IngredientId.new(id) }
part1 = part1(ranges, ingredientIds)
part2 = part2(ranges)
puts "real input solution part1: #{part1} part2: #{part2}"
