package main

import "fmt"

func FindMin(x []int) int {
  var min int = x[0]
  for i := 1; i < len(x); i++ {
    if min > x[i] {
      min = x[i]
    }
  }
  return min
}

var x = []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}

func main() {
  fmt.Println("Search in", x)
  min := FindMin(x)
  fmt.Println("Minumal value is",min)
}
