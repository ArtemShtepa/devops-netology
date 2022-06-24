package main

import (
  "fmt"
  "strconv"
)

func EchoDiv(v_min, v_max, v_div int) string {
  var res string = ""
  if v_min > v_max {
    v_min, v_max = v_max, v_min
  }
  for i := v_min; i <= v_max; i++ {
    if i % v_div == 0 {
      if res != "" {
        res += " "
      }
      res += strconv.Itoa(i)
    }
  }
  return res
}

const v_min, v_max, v_div int = 1, 100, 3

func main() {
  fmt.Printf("Print numbers from %d to %d with divided by %d:\n", v_min, v_max, v_div)
  x := EchoDiv(v_min, v_max, v_div)
  fmt.Println(x)
}
