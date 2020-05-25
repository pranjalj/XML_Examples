(: answer for 1.3 :)
let $books := doc("/db/books.xml")/biblio/author/book
let $titles := distinct-values($books/title)
let $booklist := for $title in $titles return(
let $book_lt := <booklist>
                  {<category>
                    {distinct-values(for $book in $books 
                                     where $book/title = $title 
                                     return $book/(category))}
                   </category>}
                   <book>
                     <title>{$title}</title>
                     {for $author in db:open("books", "books.xml")/biblio/author
                      where $author/book/title = $title
                      return $author/name}
                     <price>{distinct-values(for $book2 in $books 
                                                  where $book2/title = $title 
                                                  return $book2/price)}</price>
                  </book>
                 </booklist>
return $book_lt)
let $categorylist := distinct-values($booklist/category)
let $booklist2 := for $category in $categorylist 
                  return (<list> 
                            {<category>{$category}</category>}
                            {for $book3 in $booklist
                             where $book3/category = $category 
                             return <book>{$book3/book/(title,price,name)}</book>}
                          </list>)
let $avg_price := (<avg>{avg(for $match in $booklist2 
                              return $booklist2/book/price)}</avg>)
let $avg_category := for $list in $booklist2 
                     return (<maincategory>{($list/category,
                     <avg>{avg(for $match in $list 
                               return $list/book/price)}
                     </avg>)}
                     </maincategory>)

let $category_data := for $category in $avg_category return
                      if ($category/avg > $avg_price) 
                      then(for $categorylist in $booklist2 
                            where $categorylist/category = $category/category
                            return $categorylist)
return <result>
        {for $data in $category_data
          let $max := <price>{max(for $match in $data 
                                  return $data/book/price/text())}
                      </price>
          return <categories>
                  <output>{($data/category,for $category in $data/book
                                                      where $category/price=$max 
                                                      return $category/(title,name,price))}
                  </output>
                 </categories>}
       </result>
