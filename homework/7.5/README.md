# Домашнее задание по лекции "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Обязательная задача 1: Установите golang

1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

Список файлов версий для разных ОС доступен по адресу [go.dev/dl](https://go.dev/dl/)

### **Решение** - Установка **Go** в **Linux** (для версии **1.18.3**):

1. Скачивание дистрибутива: `wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz`
1. Удаление старой версии (**обязательно**): `sudo rm -rf /usr/local/go`
1. Распаковка загруженного дистрибутива: `sudo tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz`
1. Добавление каталога Go в переменную PATH (потребуется переавторизация): `echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile`

Вывод текущей установленной версии:

```console
sa@debian:~/go$ go version
go version go1.18.3 linux/amd64
sa@debian:~/go$
```

---

## Обязательная задача 2: Знакомство с gotour

У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.

---

## Обязательная задача 3: Написание кода

Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию `Scanf`
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)
    }
    ```
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

**Решение**:

> Все программы написаны с учётом будущего тестирования

### Программа для перевода метров в футы (1 фут = 0.3048 м): [task1.go](src_t1/task1.go)

```go
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
```

```console
sa@debian:~/go/t1$ go run task1.go
Enter number of meters: 5
5 m = 16.4042 f
sa@debian:~/go/t1$
```

### Программа поиска наименьшего элемента в списке: [task2.go](src_t2/task2.go)

```go
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
```

```console
sa@debian:~/go/t2$ go run task2.go
Search in [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
Minumal value is 9
sa@debian:~/go/t2$
```

### Программа вывода чисел от 1 до 100, которые делятся на 3: [task3.go](src_t3/task3.go)

```go
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
```

```console
sa@debian:~/go/t3$ go run task3.go
Print numbers from 1 to 100 with divided by 3:
3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99
sa@debian:~/go/t3$
```

---

## Дополнительная задача 4: Протестировать код

### Тест первой программы (вычисление футов): [task1_test.go](src_t1/task1_test.go)

```go
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
```

```console
sa@debian:~/go/t1$ go test
PASS
ok      _/home/sa/go/t1 0.002s
sa@debian:~/go/t1$
```

### Тест второй программы (поиск наименьшего числа): [task2_test.go](src_t2/task2_test.go)

```go
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
```

```console
sa@debian:~/go/t2$ go test
PASS
ok      _/home/sa/go/t2 0.003s
sa@debian:~/go/t2$
```

### Тест третьей программы (вывод чисел из диапазона, которые делятся без остатка): [task3_test.go](src_t3/task3_test.go)

```go
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
```

```console
sa@debian:~/go/t3$ go test
PASS
ok      _/home/sa/go/t3 0.002s
sa@debian:~/go/t3$
```
