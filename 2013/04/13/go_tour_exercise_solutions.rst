##################
A Tour of Goの解答
##################



.. author:: default
.. categories:: Programming
.. tags:: golang
.. comments::

.. highlight:: go

`Go Conference 2013 spring <http://connpass.com/event/1906/>`_ で `A Tour of Go <http://tour.golang.org/>`_ をやっているのでExcersiseの解答をメモ

Goらしくかけているかは分からないのでコメント歓迎です

***********************
#23 Loops and Functions
***********************

::

    package main

    import (
        "fmt"
        "math"
    )

    func Sqrt(x float64) float64 {
        z := 1.0
        for diff := 1.0; math.Abs(diff) > 0.00000001; {
            diff = ((math.Pow(z, 2) - x) / (2.0 * x))
            z = z - diff
        }
        return z
    }

    func main() {
        fmt.Println(Sqrt(2))
        fmt.Println(math.Sqrt(2))
    }

**********
#35 Slices
**********

::

    package main

    import "code.google.com/p/go-tour/pic"

    func Pic(dx, dy int) [][]uint8 {
        ret := make([][]uint8,dy)

        for i := 0; i < dy; i++ {
            ret[i] = make([]uint8, dx)
            for j := 0; j < dx; j++ {
                ret[i][j] = uint8(i * j)
            }
        }

        return ret
    }

    func main() {
        pic.Show(Pic)
    }

********
#40 Maps
********

::

    package main

    import (
        "strings"
        "code.google.com/p/go-tour/wc"
    )

    func WordCount(s string) map[string]int {
        ret := make(map[string]int)
        for _, v := range(strings.Fields(s)) {
            ret[v] += 1
        }
        return ret
    }

    func main() {
        wc.Test(WordCount)
    }

*********************
#43 Fibonacci closure
*********************

::

    package main

    import "fmt"

    // fibonacci is a function that returns
    // a function that returns an int.
    func fibonacci() func() int {
        i,j := 1,1
        return func() int {
            i,j = j, i+j
            return i
        }
    }

    func main() {
        f := fibonacci()
        for i := 0; i < 10; i++ {
            fmt.Println(f())
        }
    }

**********************
#47 Complex cube roots
**********************

::

    package main

    import (
        "fmt"
        "math/cmplx"
    )

    func Cbrt(x complex128) complex128 {
        z := complex128(1.0)
        for diff := complex128(1.0); cmplx.Abs(diff) > 1e-17; {
            diff = (cmplx.Pow(z, 3) - x) / (3 * cmplx.Pow(z, 2))
            z -= diff
        }
        return z
    }

    func main() {
        fmt.Println(Cbrt(2))
        fmt.Println(cmplx.Pow(Cbrt(2),3))
    }

**********
#55 Errors
**********

::

    package main

    import (
        "fmt"
        "math"
    )

    type ErrNegativeSqrt float64

    func (e ErrNegativeSqrt) Error() string {
        return fmt.Sprintf("cannot Sqrt negative number: %f" ,float64(e))
    }

    func Sqrt(x float64) (float64, error) {
        if x < 0.0 {
            return 0, ErrNegativeSqrt(x)
        }

        r := 1.0
        for diff := 1.0; math.Abs(diff) > 0.00000001; {
            diff = ((math.Pow(r, 2) - x) / (2.0 * x))
            r = r - diff
        }
        return r, nil
    }

    func main() {
        fmt.Println(Sqrt(2))
        fmt.Println(Sqrt(-2))
    }
