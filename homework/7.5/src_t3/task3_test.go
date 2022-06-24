package main

import "testing"

func TestFindMin(t *testing.T) {
  data := []struct {
    v_min, v_max, v_div int; res string
  }{
    {1, 100, 3, "3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99"},
    {10, 40, 5, "10 15 20 25 30 35 40"},
    {66, 99, 18, "72 90"},
    {48, 20, 10, "20 30 40"},
  }
  for _, d := range data {
    if got := EchoDiv(d.v_min, d.v_max, d.v_div); got != d.res {
      t.Errorf("Within %d..%d divided by %d expected %s, but got %s", d.v_min, d.v_max, d.v_div, d.res, got)
    }
  }
}
