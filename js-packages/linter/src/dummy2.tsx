import React from "react"
import {useState} from 'react'
 
var SimpleComponent = () => {
  const [count, setCount] = useState(0)
  var unusedVariable = "This will cause an unused variable error"
  
  return (
    <div className="simple-component">
      <h1>Hello World</h1>
      <p>This is a simple React component</p>
      <button onClick={() => { alert('Mixing quotes'); setCount(count + 1) }}>
        Click me ({count})
      </button>
    </div>
  )
}

function unused() {
  console.log("This function is never used")
}

export default SimpleComponent
