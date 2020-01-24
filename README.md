
<!-- README.md is generated from README.Rmd. Please edit that file -->

# semscholar: interfacing Semantic Scholar search engine with R

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/njahn82/semscholar.svg?branch=master)](https://travis-ci.org/njahn82/semscholar)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/njahn82/semscholar?branch=master&svg=true)](https://ci.appveyor.com/project/njahn82/semscholar)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

This web client wraps the Semantic Scholar RESTful API. [Semantic
Scholar](https://www.semanticscholar.org/) is a free, nonprofit,
academic search engine from the [Allen Institute for
AI](https://allenai.org/).

The client supports search for author profiles and mined metadata of
scholarly works including citations, references and topics.

API Docs: <https://api.semanticscholar.org/>

## Installation

You can install the develpment version of semscholar from GitHub:

``` r
remotes::install_github("njahn82/semscholar")
```

## Paper Lookup

``` r
library(semscholar)
s2_papers(
  c("10.1093/nar/gkr1047", 
             "14a22b032524573d15593abed170f9f76359e581", 
             "10.7717/peerj.2323", 
             "arXiv:0711.0914")
  )
#> # A tibble: 4 x 14
#>   abstract arxiv_id authors citation_veloci… citations doi  
#>   <chr>    <chr>    <list>             <int> <list>    <chr>
#> 1 T-DNA i… <NA>     <tibbl…               15 <tibble … 10.1…
#> 2 T-DNA i… <NA>     <tibbl…               15 <tibble … 10.1…
#> 3 Publica… <NA>     <tibbl…                0 <tibble … 10.7…
#> 4 Abstrac… 0711.09… <tibbl…               10 <tibble … 10.1…
#> # … with 8 more variables: influential_citation_count <int>,
#> #   paper_id <chr>, references <list>, title <chr>, topics <list>,
#> #   url <chr>, venue <chr>, year <int>
```

Authors

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$authors
#> [[1]]
#> # A tibble: 5 x 3
#>   author_id author_name        author_url                                  
#>   <chr>     <chr>              <chr>                                       
#> 1 31697714  Nils Kleinboelting https://www.semanticscholar.org/author/3169…
#> 2 1922491   Gunnar Huep        https://www.semanticscholar.org/author/1922…
#> 3 3096048   Andreas Kloetgen   https://www.semanticscholar.org/author/3096…
#> 4 3236938   Prisca Viehoever   https://www.semanticscholar.org/author/3236…
#> 5 2204561   Bernd Weisshaar    https://www.semanticscholar.org/author/2204…
```

Citations

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$citations
#> [[1]]
#> # A tibble: 143 x 10
#>    citations_arxiv… citations_autho… citations_doi citations_intent
#>    <lgl>            <list>           <chr>         <list>          
#>  1 NA               <df[,3] [1 × 3]> <NA>          <chr [0]>       
#>  2 NA               <df[,3] [9 × 3]> 10.1105/tpc.… <chr [0]>       
#>  3 NA               <df[,3] [9 × 3]> 10.1007/s107… <chr [1]>       
#>  4 NA               <df[,3] [8 × 3]> 10.1111/tpj.… <chr [1]>       
#>  5 NA               <df[,3] [8 × 3]> 10.1111/tpj.… <chr [1]>       
#>  6 NA               <df[,3] [11 × 3… <NA>          <chr [1]>       
#>  7 NA               <df[,3] [14 × 3… 10.1016/j.cu… <chr [0]>       
#>  8 NA               <df[,3] [9 × 3]> 10.1111/tpj.… <chr [1]>       
#>  9 NA               <df[,3] [5 × 3]> 10.1016/j.pl… <chr [1]>       
#> 10 NA               <df[,3] [7 × 3]> 10.1038/s415… <chr [0]>       
#> # … with 133 more rows, and 6 more variables:
#> #   citations_is_influential <lgl>, citations_paper_id <chr>,
#> #   citations_title <chr>, citations_url <chr>, citations_venue <chr>,
#> #   citations_year <int>
```

References

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$references
#> [[1]]
#> # A tibble: 11 x 10
#>    references_arxi… references_auth… references_doi references_inte…
#>    <lgl>            <list>           <chr>          <list>          
#>  1 NA               <df[,3] [12 × 3… 10.1104/pp.10… <chr [1]>       
#>  2 NA               <df[,3] [4 × 3]> 10.1093/nar/g… <chr [3]>       
#>  3 NA               <df[,3] [6 × 3]> 10.1023/B:PLA… <chr [1]>       
#>  4 NA               <df[,3] [7 × 3]> 10.1093/nar/2… <chr [0]>       
#>  5 NA               <df[,3] [16 × 3… 10.1093/nar/g… <chr [1]>       
#>  6 NA               <df[,3] [7 × 3]> 10.1093/nar/g… <chr [1]>       
#>  7 NA               <df[,3] [3 × 3]> 10.1093/nar/2… <chr [1]>       
#>  8 NA               <df[,3] [2 × 3]> 10.1111/j.136… <chr [1]>       
#>  9 NA               <df[,3] [6 × 3]> 10.2144/03356… <chr [1]>       
#> 10 NA               <df[,3] [39 × 3… 10.1126/scien… <chr [2]>       
#> 11 NA               <df[,3] [5 × 3]> 10.1093/bioin… <chr [1]>       
#> # … with 6 more variables: references_is_influential <lgl>,
#> #   references_paper_id <chr>, references_title <chr>,
#> #   references_url <chr>, references_venue <chr>, references_year <int>
```

Topics

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$topics
#> [[1]]
#> # A tibble: 13 x 3
#>    topic                    topic_id topic_url                             
#>    <chr>                    <chr>    <chr>                                 
#>  1 KickassTorrents          2106063  https://www.semanticscholar.org/topic…
#>  2 Gabi software            1885631  https://www.semanticscholar.org/topic…
#>  3 Index                    35133    https://www.semanticscholar.org/topic…
#>  4 Clinical act of inserti… 2803     https://www.semanticscholar.org/topic…
#>  5 KAT 250                  7277553  https://www.semanticscholar.org/topic…
#>  6 Reverse Genetics         21005    https://www.semanticscholar.org/topic…
#>  7 Annotation               37540    https://www.semanticscholar.org/topic…
#>  8 Silo (dataset)           130506   https://www.semanticscholar.org/topic…
#>  9 fostriecin               5652     https://www.semanticscholar.org/topic…
#> 10 DNA Sequence - Cloning … 653134   https://www.semanticscholar.org/topic…
#> 11 Collections (publicatio… 23835    https://www.semanticscholar.org/topic…
#> 12 Nuclear Proteins         252416   https://www.semanticscholar.org/topic…
#> 13 Insertion Mutation       999582   https://www.semanticscholar.org/topic…
```
