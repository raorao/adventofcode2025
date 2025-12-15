# --- Day 11: Reactor ---
# You hear some loud beeping coming from a hatch in the floor of the factory, so you decide to check it out. Inside, you find several large electrical conduits and a ladder.

# Climbing down the ladder, you discover the source of the beeping: a large, toroidal reactor which powers the factory above. Some Elves here are hurriedly running between the reactor and a nearby server rack, apparently trying to fix something.

# One of the Elves notices you and rushes over. "It's a good thing you're here! We just installed a new server rack, but we aren't having any luck getting the reactor to communicate with it!" You glance around the room and see a tangle of cables and devices running from the server rack to the reactor. She rushes off, returning a moment later with a list of the devices and their outputs (your puzzle input).

# For example:

# aaa: you hhh
# you: bbb ccc
# bbb: ddd eee
# ccc: ddd eee fff
# ddd: ggg
# eee: out
# fff: out
# ggg: out
# hhh: ccc fff iii
# iii: out
# Each line gives the name of a device followed by a list of the devices to which its outputs are attached. So, bbb: ddd eee means that device bbb has two outputs, one leading to device ddd and the other leading to device eee.

# The Elves are pretty sure that the issue isn't due to any specific device, but rather that the issue is triggered by data following some specific path through the devices. Data only ever flows from a device through its outputs; it can't flow backwards.

# After dividing up the work, the Elves would like you to focus on the devices starting with the one next to you (an Elf hastily attaches a label which just says you) and ending with the main output to the reactor (which is the device with the label out).

# To help the Elves figure out which path is causing the issue, they need you to find every path from you to out.

# In this example, these are all of the paths from you to out:

# Data could take the connection from you to bbb, then from bbb to ddd, then from ddd to ggg, then from ggg to out.
# Data could take the connection to bbb, then to eee, then to out.
# Data could go to ccc, then ddd, then ggg, then out.
# Data could go to ccc, then eee, then out.
# Data could go to ccc, then fff, then out.
# In total, there are 5 different paths leading from you to out.

# How many different paths lead from you to out?
#
# --- Day 11: Reactor ---
# You hear some loud beeping coming from a hatch in the floor of the factory, so you decide to check it out. Inside, you find several large electrical conduits and a ladder.

# Climbing down the ladder, you discover the source of the beeping: a large, toroidal reactor which powers the factory above. Some Elves here are hurriedly running between the reactor and a nearby server rack, apparently trying to fix something.

# One of the Elves notices you and rushes over. "It's a good thing you're here! We just installed a new server rack, but we aren't having any luck getting the reactor to communicate with it!" You glance around the room and see a tangle of cables and devices running from the server rack to the reactor. She rushes off, returning a moment later with a list of the devices and their outputs (your puzzle input).

# For example:

# aaa: you hhh
# you: bbb ccc
# bbb: ddd eee
# ccc: ddd eee fff
# ddd: ggg
# eee: out
# fff: out
# ggg: out
# hhh: ccc fff iii
# iii: out
# Each line gives the name of a device followed by a list of the devices to which its outputs are attached. So, bbb: ddd eee means that device bbb has two outputs, one leading to device ddd and the other leading to device eee.

# The Elves are pretty sure that the issue isn't due to any specific device, but rather that the issue is triggered by data following some specific path through the devices. Data only ever flows from a device through its outputs; it can't flow backwards.

# After dividing up the work, the Elves would like you to focus on the devices starting with the one next to you (an Elf hastily attaches a label which just says you) and ending with the main output to the reactor (which is the device with the label out).

# To help the Elves figure out which path is causing the issue, they need you to find every path from you to out.

# In this example, these are all of the paths from you to out:

# Data could take the connection from you to bbb, then from bbb to ddd, then from ddd to ggg, then from ggg to out.
# Data could take the connection to bbb, then to eee, then to out.
# Data could go to ccc, then ddd, then ggg, then out.
# Data could go to ccc, then eee, then out.
# Data could go to ccc, then fff, then out.
# In total, there are 5 different paths leading from you to out.

# How many different paths lead from you to out?

# Your puzzle answer was 690.

# The first half of this puzzle is complete! It provides one gold star: *

# --- Part Two ---
# Thanks in part to your analysis, the Elves have figured out a little bit about the issue. They now know that the problematic data path passes through both dac (a digital-to-analog converter) and fft (a device which performs a fast Fourier transform).

# They're still not sure which specific path is the problem, and so they now need you to find every path from svr (the server rack) to out. However, the paths you find must all also visit both dac and fft (in any order).

# For example:

# svr: aaa bbb
# aaa: fft
# fft: ccc
# bbb: tty
# tty: ccc
# ccc: ddd eee
# ddd: hub
# hub: fff
# eee: dac
# dac: fff
# fff: ggg hhh
# ggg: out
# hhh: out
# This new list of devices contains many paths from svr to out:

# svr,aaa,fft,ccc,ddd,hub,fff,ggg,out
# svr,aaa,fft,ccc,ddd,hub,fff,hhh,out
# svr,aaa,fft,ccc,eee,dac,fff,ggg,out
# svr,aaa,fft,ccc,eee,dac,fff,hhh,out
# svr,bbb,tty,ccc,ddd,hub,fff,ggg,out
# svr,bbb,tty,ccc,ddd,hub,fff,hhh,out
# svr,bbb,tty,ccc,eee,dac,fff,ggg,out
# svr,bbb,tty,ccc,eee,dac,fff,hhh,out
# However, only 2 paths from svr to out visit both dac and fft.

# Find all of the paths that lead from svr to out. How many of those paths visit both dac and fft?

def count_paths(outputsByDevices)
  total = 0
  queue = ["you"]

  while !queue.empty?
    device = queue.shift
    outputs = outputsByDevices[device]

    if device == "out"
      total += 1
    else
      outputs.each do |output|
        queue << output
      end
    end
  end

  total
end

def count_paths_with_breadcrumbs(outputsByDevices)
  path_counts = Hash.new(0)
  path_counts[["svr", false, false]] = 1
  queue = [["svr", false, false]]
  seen = Set.new

  while !queue.empty?
    device, visitedDac, visitedFft = queue.shift
    state = [device, visitedDac, visitedFft]
    seen.delete(state)

    outputs = outputsByDevices[device] || []
    newVisitedDac = device == "dac" || visitedDac
    newVisitedFft = device == "fft" || visitedFft

    outputs.each do |output|
      next_state = [output, newVisitedDac, newVisitedFft]
      path_counts[next_state] += path_counts[state]

      unless seen.include?(next_state)
        queue << next_state
        seen.add(next_state)
      end
    end
  end

  path_counts[["out", true, true]]
end

def parse_input(lines)
  outputsByDevices = {}
  lines.each do |line|
    device, outputs = line.split(": ")
    outputsByDevices[device] = outputs.split(" ")
  end

  outputsByDevices
end

# example input
EXAMPLE_INPUT_PART_1 = [
"aaa: you hhh",
"you: bbb ccc",
"bbb: ddd eee",
"ccc: ddd eee fff",
"ddd: ggg",
"eee: out",
"fff: out",
"ggg: out",
"hhh: ccc fff iii",
"iii: out"
]

EXAMPLE_INPUT_PART_2 = [
  "svr: aaa bbb",
  "aaa: fft",
  "fft: ccc",
  "bbb: tty",
  "tty: ccc",
  "ccc: ddd eee",
  "ddd: hub",
  "hub: fff",
  "eee: dac",
  "dac: fff",
  "fff: ggg hhh",
  "ggg: out",
  "hhh: out"
]

parsed1 = parse_input(EXAMPLE_INPUT_PART_1)
parsed2 = parse_input(EXAMPLE_INPUT_PART_2)

puts "example input part1: #{count_paths(parsed1)} part2: #{count_paths_with_breadcrumbs(parsed2)}"

## real input
lines = File.readlines("day11/input.txt").map(&:chomp)
parsed = parse_input(lines)
puts "real input part1: #{count_paths(parsed)} part2: #{count_paths_with_breadcrumbs(parsed)}"
