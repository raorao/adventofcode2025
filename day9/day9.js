fs = require('fs');

const EXAMPLE_INPUT = `7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3`

function largestRectangle(coordinates, areaCalculator) {
  let largest = 0;

  for ([x, y] of coordinates) {
    for ([x2, y2] of coordinates) {
      const minX = Math.min(x, x2)
      const maxX = Math.max(x, x2)
      const minY = Math.min(y, y2)
      const maxY = Math.max(y, y2)

      const maxPossible = (maxX - minX + 1) * (maxY - minY + 1);
      if (maxPossible <= largest) continue;

      const area = areaCalculator({minX, maxX, minY, maxY});

      if (area > largest) {
        largest = area;
      }
    }
  }
  return largest;
}

function part1(coordinates) {
  function calculateArea({minX, maxX, minY, maxY}) {
    return (maxX - minX + 1) * (maxY - minY + 1);
  }
  return largestRectangle(coordinates, calculateArea);
}

function part2(coordinates) {
  const redTiles = coordinates
  const greenTiles = [];
  let [currentX, currentY] = redTiles[0]

  for ([x,y] of [...redTiles, redTiles[0]]) {
    if (x === currentX) {
      for (let i = Math.min(currentY, y) + 1; i < Math.max(currentY, y); i++) {
        greenTiles.push([x, i]);
      }
    } else if (y === currentY) {
      for (let i = Math.min(currentX, x) + 1; i < Math.max(currentX, x); i++) {
        greenTiles.push([i, y]);
      }
    } else {
      throw new Error('Invalid input')
    }

    currentX = x;
    currentY = y;
  }

  const perimeterCandidates = [...redTiles, ...greenTiles];
  const validRangesByY = new Map();

  for (const [x, y] of perimeterCandidates) {
    if (!validRangesByY.has(y)) {
      validRangesByY.set(y, {minX: Infinity, maxX: -Infinity});
    }
    const range = validRangesByY.get(y);
    range.minX = Math.min(range.minX, x);
    range.maxX = Math.max(range.maxX, x);
  }

  function calculateArea({minX, maxX, minY, maxY}) {
    let area = 0;

    for (let y = minY; y <= maxY; y++) {
      const range = validRangesByY.get(y);
      if (!range) return 0;

      if (minX < range.minX || maxX > range.maxX) {
        return 0;
      }

      area += (maxX - minX + 1);
    }

    return area;
  }

  return largestRectangle(redTiles, calculateArea);
}

// example input
let coordinates = EXAMPLE_INPUT.split("\n").map(line => line.split(",").map(Number));
console.log(`Example part1: ${part1(coordinates)}`)
console.log(`Example part2: ${part2(coordinates)}`);


// real input
coordinates = fs.readFileSync('day9/input.txt', 'utf8')
  .split("\n")
  .filter(line => line.trim())
  .map(line => line.split(",").map(Number));

console.log(`Real part1: ${part1(coordinates)}`);
console.log(`Real part2: ${part2(coordinates)}`);
