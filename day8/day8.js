const fs = require("fs");

const testInput = `162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689`;

// Parse command line arguments
const args = process.argv.slice(2);
let inputType = "example";
let phase = 1;

for (let i = 0; i < args.length; i++) {
  if (args[i] === "--input" && i + 1 < args.length) {
    inputType = args[i + 1];
    i++;
  } else if (args[i] === "--phase" && i + 1 < args.length) {
    phase = parseInt(args[i + 1]);
    i++;
  }
}

const input = inputType === "example" ? testInput : fs.readFileSync("day8/input.txt", "utf-8");
const limit = inputType === "example" ? 10 : 1000;

const nodes = input.split("\n").filter(line => line.trim()).map((line) => {
  const [x, y, z] = line.split(",");
  return {
    x: +x,
    y: +y,
    z: +z,
  };
});

const circuits = [];

const distanceMap = new Map();
for (let i in nodes) {
  circuits.push([i]);
  for (let j in nodes) {
    const nodeA = nodes[i];
    const nodeB = nodes[j];
    if (nodeA !== nodeB) {
      const distance = Math.sqrt(
        (nodeA.x - nodeB.x) ** 2 +
          (nodeA.y - nodeB.y) ** 2 +
          (nodeA.z - nodeB.z) ** 2
      );
      const keys = [+i, +j];
      keys.sort();
      distanceMap[keys] = distance;
    }
  }
}

const distances = Object.entries(distanceMap);
distances.sort((a, b) => a[1] - b[1]);

if (phase === 1) {
  distances.slice(0, limit).forEach((distanceObj) => {
    const [key, _distance] = distanceObj;
    const [a, b] = key.split(",");
    const circuitAIndex = circuits.findIndex((nodeIds) => nodeIds.includes(a));
    const circuitBIndex = circuits.findIndex((nodeIds) => nodeIds.includes(b));

    if (circuitAIndex === circuitBIndex) {
      return;
    }

    const circuitA = circuits[circuitAIndex];
    const circuitB = circuits[circuitBIndex];
    circuitB.forEach((id) => circuitA.push(id));
    circuits.splice(circuitBIndex, 1);
  });

  const [a, b, c] = circuits.sort((a, b) => b.length - a.length).slice(0, 3);
  const answer = a.length * b.length * c.length;

  console.log({
    answer,
  });
} else {
  let answer = 0;
  distances.forEach((distanceObj) => {
    const [key, _distance] = distanceObj;
    const [a, b] = key.split(",");
    const circuitAIndex = circuits.findIndex((nodeIds) => nodeIds.includes(a));
    const circuitBIndex = circuits.findIndex((nodeIds) => nodeIds.includes(b));

    if (circuitAIndex === circuitBIndex) {
      return;
    }

    const circuitA = circuits[circuitAIndex];
    const circuitB = circuits[circuitBIndex];
    circuitB.forEach((id) => circuitA.push(id));
    circuits.splice(circuitBIndex, 1);
    if (circuits.length === 1) {
      answer = nodes[a].x * nodes[b].x;
    }
  });

  console.log({
    answer,
  });
}
