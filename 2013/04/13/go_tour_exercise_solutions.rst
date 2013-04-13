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
        for diff := 1.0; math.Abs(diff) > 1e-10; {
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
        for diff := complex128(1.0); cmplx.Abs(diff) > 1e-10; {
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

        z := 1.0
        for diff := 1.0; math.Abs(diff) > 1e-10; {
            diff = ((math.Pow(z, 2) - x) / (2.0 * x))
            z = z - diff
        }
        return z, nil
    }

    func main() {
        fmt.Println(Sqrt(2))
        fmt.Println(Sqrt(-2))
    }

*****************
#57 HTTP Handlers
*****************

::

    package main

    import (
        "fmt"
        "net/http"
    )

    type String string

    type Struct struct {
        Greeting string
        Punct    string
        Who      string
    }

    func (str String) ServeHTTP(
        w http.ResponseWriter,
        r *http.Request) {
        fmt.Fprintf(w, "%s", str)
    }

    func (str *Struct) ServeHTTP(
        w http.ResponseWriter,
        r *http.Request) {
        fmt.Fprintf(w, "%s%s%s", str.Greeting, str.Punct, str.Who)
    }

    func main() {
        http.Handle("/string", String("I'm a frayed knot."))
        http.Handle("/struct", &Struct{"Hello", ":", "Gophers!"})
        http.ListenAndServe("localhost:4000", nil)
    }

**********
#59 Images
**********

::

    package main

    import (
        "code.google.com/p/go-tour/pic"
        "image"
        "image/color"
    )

    type Image struct{
        w, h int
    }

    func (r *Image) Bounds() image.Rectangle {
        return image.Rect(0, 0, r.w, r.h)
    }

    func (r *Image) ColorModel() color.Model {
        return color.RGBAModel
    }

    func (r *Image) At(x, y int) color.Color {
        return color.RGBA{uint8(x), uint8(y), 255, 255}
    }

    func main() {
        m := &Image{256, 256}
        pic.ShowImage(m)
    }

****************
#60 Rot13 Reader
****************

::

    package main

    import (
        "io"
        "os"
        "strings"
    )

    type rot13Reader struct {
        r io.Reader
    }

    func (rot *rot13Reader) Read(p []byte) (n int, err error) {
        n, err = rot.r.Read(p)
        for i := 0; i < len(p); i++ {
            if (p[i] >= 'A' && p[i] < 'N') || (p[i] >='a' && p[i] < 'n') {
                p[i] += 13
            } (p[i] > 'M' && p[i] <= 'Z') || (p[i] > 'm' && p[i] <= 'z'){
                p[i] -= 13
            }
        }
        return
    }

    func main() {
        s := strings.NewReader(
            "Lbh penpxrq gur pbqr!")
        r := rot13Reader{s}
        io.Copy(os.Stdout, &r)
    }

***************************
#68 Equivalent Binary Trees
***************************

::

    package main

    import (
        "fmt"
        "code.google.com/p/go-tour/tree"
    )

    func Walk(t *tree.Tree, c chan int) {
        if t != nil {
            _walk(t, c)
        }
        close(c)
    }

    func _walk(t *tree.Tree, c chan int) {
        if t != nil {
            _walk(t.Left, c)
            c <- t.Value
            _walk(t.Right, c)
        }
    }

    func Same(t1, t2 *tree.Tree) bool {
        c1 := make(chan int)
        c2 := make(chan int)

        go Walk(t1, c1)
        go Walk(t2, c2)

        for v1 := range c1 {
            v2 := <- c2
            if v1 != v2 {
                return false
            }
        }

        _, ok := <- c2
        if ok {
            return false
        }

        return true
    }

    func main() {
        fmt.Println(Same(tree.New(1), tree.New(1)))
        fmt.Println(Same(tree.New(1), tree.New(2)))
    }

***************
#70 Web Crawler
***************

微妙。多分複数のgoroutineを上手く扱うパッケージがあるはずなので、それを使えばもっと綺麗に書けるはず。

::

    package main

    import (
        "fmt"
    )

    type Fetcher interface {
        // Fetch returns the body of URL and
        // a slice of URLs found on that page.
        Fetch(url string) (body string, urls []string, err error)
    }

    // Crawl uses fetcher to recursively crawl
    // pages starting with url, to a maximum of depth.
    func Crawl(url string, depth int, fetcher Fetcher) {
        fetched := map[string]bool{ url:true }

        if depth <= 0 {
            return
        }


        c := make(chan []string)
        urls := []string{url}
        for i := 0; i < depth; i++ {
            var next []string

            for _, u := range(urls) {
                go _crawl(u, fetcher, c)
            }

            for j := 0; j < len(urls); j++ {
                res := <- c
                for _, r := range(res) {
                    if !fetched[r] {
                        fetched[r] = true
                        next = append(next, r)
                    }
                }
            }
            urls = next
        }
    }

    func _crawl(url string, fetcher Fetcher, c chan []string) {
        body, urls, err := fetcher.Fetch(url)

        if err != nil {
            fmt.Println(err)
            c <- []string{}
            return
        }

        fmt.Printf("found: %s %q\n", url, body)

        c <- urls
    }

    func main() {
        Crawl("http://golang.org/", 4, fetcher)
    }

    // fakeFetcher is Fetcher that returns canned results.
    type fakeFetcher map[string]*fakeResult

    type fakeResult struct {
        body string
        urls []string
    }

    func (f *fakeFetcher) Fetch(url string) (string, []string, error) {
        if res, ok := (*f)[url]; ok {
            return res.body, res.urls, nil
        }
        return "", nil, fmt.Errorf("not found: %s", url)
    }

    // fetcher is a populated fakeFetcher.
    var fetcher = &fakeFetcher{
        "http://golang.org/": &fakeResult{
        "The Go Programming Language",
        []string{
            "http://golang.org/pkg/",
            "http://golang.org/cmd/",
        },
    },
    "http://golang.org/pkg/": &fakeResult{
    "Packages",
    []string{
        "http://golang.org/",
        "http://golang.org/cmd/",
        "http://golang.org/pkg/fmt/",
        "http://golang.org/pkg/os/",
    },
        },
        "http://golang.org/pkg/fmt/": &fakeResult{
        "Package fmt",
        []string{
            "http://golang.org/",
            "http://golang.org/pkg/",
        },
    },
    "http://golang.org/pkg/os/": &fakeResult{
    "Package os",
    []string{
        "http://golang.org/",
        "http://golang.org/pkg/",
    },
        },
    }
