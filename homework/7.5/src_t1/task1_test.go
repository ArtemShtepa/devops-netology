package main

import "testing"

func TestCalcFut(t *testing.T) {
  data := []struct {
    value, res float32
  }{
    {5, 16.4042},
    {0, 0},
    {-3, -9.84252},
  }
  for _, d := range data {
    if got := CalcFut(d.value); got != d.res {
      t.Errorf("For value %.5f expected %.5f but found %.5f", d.value, d.res, got)
    }
  }
}
