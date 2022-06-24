package main

import "testing"

func TestFindMin(t *testing.T) {
  data := []struct {
    value []int; res int
  }{
    {[]int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}, 9},
    {[]int{1,6,2,10}, 1},
    {[]int{5,18,37,-2,19,1}, -2},
  }
  for _, d := range data {
    if got := FindMin(d.value); got != d.res {
      t.Error("For series", d.value, "expect", d.res, "but got", got)
    }
  }
}
