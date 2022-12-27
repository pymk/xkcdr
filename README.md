# xkcdr

<!-- badges: start -->
[![test-coverage](https://github.com/pymk/xkcdr/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/pymk/xkcdr/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

An R package to retrieve xkcd comics.

It retrieves xkcd comic as JSON from [https://xkcd.com/json.html](https://xkcd.com/json.html) and parses it into 
a {gt} table.

---

### Usage

Show the latest comic:

```r
xkcdr::get_xkcd()
```

Show a specific comic:

```r
xkcdr::get_xkcd(2716)
```
---

![image](https://user-images.githubusercontent.com/9125028/209604977-a429e6bb-5197-46f7-8905-9c3fa02d4856.png)
