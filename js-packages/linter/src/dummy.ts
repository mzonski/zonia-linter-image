// This file contains numerous ESLint and Prettier issues

var unusedVariable = "I'm never used anywhere";

// Missing semicolons
const foo = "bar"
let baz = 123

// Mixed quotes
const greeting = "hello";
const name = 'world';

// Extra spaces and inconsistent spacing
const   weirdSpacing=   {
    first : 1,
    second:2,
      third:   3
};

// Too long line that should be wrapped according to most formatting standards
const reallyLongLine = "This line is intentionally very very very very very very very very very very very very very very very very very very very very very very very very very long";

// Unnecessary console logs
console.log('Debug info');
console.log(weirdSpacing);

// Use of == instead of ===
if(baz == "123") {
    console.log("This is bad practice")
}

// Inconsistent indentation
function badFunction () {
  const x = 1;
    const y = 2;
        return x+y;
}

// Trailing whitespace at end of line    
const trailingSpace = "look behind me";    

// No space after keywords
if(foo){
    console.log(foo)
}

// Using var (instead of let/const)
for(var i=0; i<5; i++){
  console.log(i)
}

// Unused function parameters
function unusedParams(one: number, two: boolean, three) {
    return one;
}

// Unreachable code
function unreachableCode() {
    return "early return";
    console.log("I'll never run");
}

// Multiple blank lines


// Complex expression without parentheses
const crazyMath = 1 + 2 * 3 / 4 % 5 & 6 | 7;

// Dangling comma issue
const array = [
    1,
    2,
    3
]

// Not following line length limits by writing extremely long comments that go way beyond what most style guides consider acceptable and would typically be flagged by linters

export default badFunction;