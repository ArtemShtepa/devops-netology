package main

import "fmt"

func CalcFut(m float32) float32 {
  return m / 0.3048
}

func main() {
  var value_m float32
  fmt.Print("Enter number of meters: ")
  fmt.Scanf("%f", &value_m)
  value_f := CalcFut(value_m)
  fmt.Println(value_m, "m =", value_f, "f")
}
