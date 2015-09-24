+++
title = "A Tour of Goの解答"
date = "2013-04-13"
categories = ["Programming"]
tags = ["golang"]
+++

[Go Conference 2013 spring](http://connpass.com/event/1906/) で [A Tour of Go](http://tour.golang.org/) をやっているのでExcersiseの解答をメモ

Goらしくかけているかは分からないのでコメント歓迎です

<!--more-->


#23 Loops and Functions
------------------------

package main

import (
"fmt"
"math"
)

func Sqrt(x float64) float64 {
}
return z
}

func main() {
fmt.Println(Sqrt(2))
fmt.Println(math.Sqrt(2))
}

#35 Slices
-----------

package main

import "code.google.com/p/go-tour/pic"

func Pic(dx, dy int) [][]uint8 {

}
}

return ret
}

func main() {
pic.Show(Pic)
}

#40 Maps
---------

package main

import (
"strings"
"code.google.com/p/go-tour/wc"
)

func WordCount(s string) map[string]int {
}
return ret
}

func main() {
wc.Test(WordCount)
}

#43 Fibonacci closure
----------------------

package main

import "fmt"

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
return func() int {
return i
}
}

func main() {
fmt.Println(f())
}
}

#47 Complex cube roots
-----------------------

package main

import (
"fmt"
"math/cmplx"
)

func Cbrt(x complex128) complex128 {
}
return z
}

func main() {
fmt.Println(Cbrt(2))
fmt.Println(cmplx.Pow(Cbrt(2),3))
}

#55 Errors
-----------

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

}
return z, nil
}

func main() {
fmt.Println(Sqrt(2))
fmt.Println(Sqrt(-2))
}

#57 HTTP Handlers
------------------

package main

import (
"fmt"
"net/http"
)

type String string

type Struct struct {
Greeting string
Punct string
Who string
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

#59 Images
-----------

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
pic.ShowImage(m)
}

#60 Rot13 Reader
-----------------

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
}
}
return
}

func main() {
"Lbh penpxrq gur pbqr!")
io.Copy(os.Stdout, &r)
}

#68 Equivalent Binary Trees
----------------------------

package main

import (
"fmt"
"code.google.com/p/go-tour/tree"
)

func Walk(t *tree.Tree, c chan int) {
_walk(t, c)
}
close(c)
}

func _walk(t *tree.Tree, c chan int) {
_walk(t.Left, c)
c <- t.Value
_walk(t.Right, c)
}
}

func Same(t1, t2 *tree.Tree) bool {

go Walk(t1, c1)
go Walk(t2, c2)

return false
}
}

if ok {
return false
}

return true
}

func main() {
fmt.Println(Same(tree.New(1), tree.New(1)))
fmt.Println(Same(tree.New(1), tree.New(2)))
}

#70 Web Crawler
----------------

微妙。多分複数のgoroutineを上手く扱うパッケージがあるはずなので、それを使えばもっと綺麗に書けるはず。

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

return
}


var next []string

go _crawl(u, fetcher, c)
}

if !fetched[r] {
}
}
}
}
}

func _crawl(url string, fetcher Fetcher, c chan []string) {

fmt.Println(err)
c <- []string{}
return
}

fmt.Printf("found: %s %qn", url, body)

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
return res.body, res.urls, nil
}
return "", nil, fmt.Errorf("not found: %s", url)
}

// fetcher is a populated fakeFetcher.
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
