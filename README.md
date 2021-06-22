
<!-- README.md is generated from README.Rmd. Please edit that file -->

# semscholar: interfacing Semantic Scholar search engine with R

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/njahn82/semscholar/workflows/R-CMD-check/badge.svg)](https://github.com/njahn82/semscholar/actions)
[![Codecov test
coverage](https://codecov.io/gh/njahn82/semscholar/branch/master/graph/badge.svg)](https://codecov.io/gh/njahn82/semscholar?branch=master)
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
#>   abstract   arxiv_id  authors citation_veloci… citations doi   influential_cit…
#>   <chr>      <chr>     <list>             <int> <list>    <chr>            <int>
#> 1 T-DNA ins… <NA>      <tibbl…               31 <tibble … 10.1…               28
#> 2 T-DNA ins… <NA>      <tibbl…               31 <tibble … 10.1…               28
#> 3 Publicati… <NA>      <tibbl…                8 <tibble … 10.7…                3
#> 4 Abstract … 0711.0914 <tibbl…               16 <tibble … 10.1…               12
#> # … with 7 more variables: paper_id <chr>, references <list>, title <chr>,
#> #   topics <list>, url <chr>, venue <chr>, year <int>
```

Authors

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$authors
#> [[1]]
#> # A tibble: 5 x 3
#>   author_id  author_name        author_url                                      
#>   <chr>      <chr>              <chr>                                           
#> 1 2099949665 Nils Kleinboelting https://www.semanticscholar.org/author/20999496…
#> 2 1922491    G. Huep            https://www.semanticscholar.org/author/1922491  
#> 3 3096048    A. Kloetgen        https://www.semanticscholar.org/author/3096048  
#> 4 2092957728 Prisca Viehoever   https://www.semanticscholar.org/author/20929577…
#> 5 2204561    B. Weisshaar       https://www.semanticscholar.org/author/2204561
```

Citations

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$citations
#> [[1]]
#> # A tibble: 283 x 10
#>    citations_arxiv_id citations_authors citations_doi           citations_intent
#>    <lgl>              <list>            <chr>                   <list>          
#>  1 NA                 <df [3 × 2]>      10.1101/2021.01.06.425… <chr [1]>       
#>  2 NA                 <df [5 × 2]>      10.1186/s12870-021-030… <chr [0]>       
#>  3 NA                 <df [3 × 2]>      10.1101/2021.03.03.433… <chr [1]>       
#>  4 NA                 <df [5 × 2]>      10.3389/fpls.2021.6286… <chr [0]>       
#>  5 NA                 <df [5 × 2]>      10.1101/2021.06.03.446… <chr [0]>       
#>  6 NA                 <df [5 × 2]>      10.1101/2021.02.17.431… <chr [0]>       
#>  7 NA                 <df [12 × 2]>     10.1038/s41467-020-205… <chr [0]>       
#>  8 NA                 <df [3 × 2]>      10.3389/fpls.2021.6524… <chr [1]>       
#>  9 NA                 <df [13 × 2]>     10.1101/2021.01.28.428… <chr [1]>       
#> 10 NA                 <df [12 × 2]>     10.1101/2020.04.02.021… <chr [1]>       
#> # … with 273 more rows, and 6 more variables: citations_is_influential <lgl>,
#> #   citations_paper_id <chr>, citations_title <chr>, citations_url <chr>,
#> #   citations_venue <chr>, citations_year <int>
```

References

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$references
#> [[1]]
#> # A tibble: 13 x 10
#>    references_arxiv_… references_autho… references_doi          references_inte…
#>    <lgl>              <list>            <chr>                   <list>          
#>  1 NA                 <df [4 × 2]>      10.1093/nar/gkl753      <chr [3]>       
#>  2 NA                 <df [1 × 2]>      10.1038/35048692        <chr [0]>       
#>  3 NA                 <df [2 × 2]>      10.1111/j.1365-313X.20… <chr [1]>       
#>  4 NA                 <df [7 × 2]>      10.1093/NAR/GKH134      <chr [1]>       
#>  5 NA                 <df [3 × 2]>      10.1385/1-59259-192-2:… <chr [0]>       
#>  6 NA                 <df [3 × 2]>      10.1093/NAR/23.24.4992  <chr [1]>       
#>  7 NA                 <df [1 × 2]>      <NA>                    <chr [0]>       
#>  8 NA                 <df [12 × 2]>     10.1104/pp.103.022251   <chr [1]>       
#>  9 NA                 <df [5 × 2]>      10.1093/bioinformatics… <chr [0]>       
#> 10 NA                 <df [39 × 2]>     10.1126/SCIENCE.1086391 <chr [2]>       
#> 11 NA                 <df [6 × 2]>      10.2144/03356ST01       <chr [0]>       
#> 12 NA                 <df [6 × 2]>      10.1023/B:PLAN.0000009… <chr [1]>       
#> 13 NA                 <df [16 × 2]>     10.1093/nar/gkm965      <chr [1]>       
#> # … with 6 more variables: references_is_influential <lgl>,
#> #   references_paper_id <chr>, references_title <chr>, references_url <chr>,
#> #   references_venue <chr>, references_year <int>
```

Topics

``` r
s2_papers("14a22b032524573d15593abed170f9f76359e581")$topics
#> [[1]]
#> # A tibble: 13 x 3
#>    topic                      topic_id topic_url                                
#>    <chr>                      <chr>    <chr>                                    
#>  1 KickassTorrents            2106063  https://www.semanticscholar.org/topic/21…
#>  2 Gabi software              1885631  https://www.semanticscholar.org/topic/18…
#>  3 Index                      35133    https://www.semanticscholar.org/topic/35…
#>  4 Clinical act of insertion  2803     https://www.semanticscholar.org/topic/28…
#>  5 KAT 250                    7277553  https://www.semanticscholar.org/topic/72…
#>  6 Reverse Genetics           21005    https://www.semanticscholar.org/topic/21…
#>  7 Annotation                 37540    https://www.semanticscholar.org/topic/37…
#>  8 Silo (dataset)             130506   https://www.semanticscholar.org/topic/13…
#>  9 fostriecin                 5652     https://www.semanticscholar.org/topic/56…
#> 10 DNA Sequence - Cloning Si… 653134   https://www.semanticscholar.org/topic/65…
#> 11 Collections (publication)  23835    https://www.semanticscholar.org/topic/23…
#> 12 Nuclear Proteins           252416   https://www.semanticscholar.org/topic/25…
#> 13 Insertion Mutation         999582   https://www.semanticscholar.org/topic/99…
```

## Author Lookup

Provide one or many S2 Author IDs

``` r
s2_authors(c("2204561", "144128278", "49930593"))
#> # A tibble: 3 x 6
#>   aliases  author_id author_name  author_url          influential_citat… papers 
#>   <list>   <chr>     <chr>        <chr>                            <int> <list> 
#> 1 <chr [3… 2204561   B. Weisshaar https://www.semant…               1891 <df [2…
#> 2 <chr [1… 144128278 G. Buzsáki   https://www.semant…               4088 <df [4…
#> 3 <chr [2… 49930593  M. Salmon    https://www.semant…                  5 <df [3…
```
