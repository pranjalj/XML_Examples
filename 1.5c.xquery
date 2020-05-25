(: answer for 1.5c :)
let $books := doc("/db/books.xml")/biblio/author/book
let $titles := distinct-values($books/title)
let $booklist := for $title in $titles return(
let $book_lt := <booklist>
                  {<category>
                    {distinct-values(for $book in $books 
                                     where $book/title = $title 
                                     return $book/(category))}
                   </category>}
                   <book year="{distinct-values(for $book1 in $books 
                                                where $book1/title = $title 
                                                return $book1/@year)}">
                     <title>{$title}</title>
                     {for $author in doc("/db/books.xml")/biblio/author
                      where $author/book/title = $title
                      return $author/name}
                     <price>{distinct-values(for $book2 in $books 
                                                  where $book2/title = $title 
                                                  return $book2/price)}</price>
                     <rating>{distinct-values(for $book3 in $books 
                                                  where $book3/title = $title 
                                                  return $book3/rating)}</rating>
                  </book>
                 </booklist>
return $book_lt)

let $categorylist := distinct-values(for $tempbook in $booklist return ($tempbook/category))
let $categorycount := for $category at $count in $categorylist 
                      return (<booklist><list id="{$count}"> 
                      {for $book4 in $booklist 
                       where $book4/category = $category 
                       return <book>
                               {<category>{$category}</category>}
                               {$book4/book/(title,price,name,rating)}
                              </book>}
                      </list></booklist>)

let $group := for $category1 in $categorycount[1]/list/book
for $category2 in $categorycount[2]/list/book
for $category3 in $categorycount[3]/list/book
for $category4 in $categorycount[4]/list/book
return <pairlist>
        <pairs>
        {$category1}
        {$category2}
        {$category3}
        {$category4}
        </pairs>
       </pairlist>
       
let $group_total := for $pair in $group/pairs
                    let $total_price := sum($pair/book/price/data())
                    let $total_rating :=sum($pair/book/rating/data())
                    return <result>
                            <total_price>{$total_price}</total_price>
                            <total_rating>{$total_rating}</total_rating>
                            {$pair}
                            </result>
        
let $sorted_group := for $total in $group_total where $total/total_price <= 1800
                      order by $total/ratingtotal descending
                      return $total
return $sorted_group[1]/pairs/book/(title,category,rating)