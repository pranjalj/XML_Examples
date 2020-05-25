(: answer for 1.2 :)
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
let $bookdetail := for $category in $categorylist
                 return (<booklist>
                        {for $book4 in $booklist
                         where $book4/category = $category
                         return <book>{$book4/book/@year}
                                {<category>{$category}</category>}
                                {$book4/book/(title,price,name,rating)}</book>}
                  </booklist>)

let $authorname := distinct-values(doc("/db/books.xml")/biblio/author/name)
let $names := for $name at $count in $authorname order by $name
              return (<names>
                        <name>{$name}</name>
                        <count>{$count}</count>
                     </names>)
let $name_pairs := for $n1 in $names
                    for $n2 in $names
                    where $n1/count < $n2/count
                    return <author>{$n1/name}{$n2/name}</author>

let $pairs := for $category at $count1 in $bookdetail/book
              for $pair in $name_pairs
              where $category/name[1]/data() = $pair/name[1]/data()
                and $category/name[2]/data() = $pair/name[2]/data()
              return <output>
                      <pair_name>
                        {$pair/name/data()}
                      </pair_name>
                      <namelist>
                        {$pair/name}
                      </namelist>
                      <book year="{$category/@year}">
                        {$category/(title,category,price,rating)}
                      </book>
                     </output>

for $author_pair in distinct-values($pairs/pair_name)
where count(index-of($pairs/pair_name, $author_pair)) > 1
 return <coauthor>{
            (for $pair in $pairs where $pair/pair_name/data() = $author_pair
            return <output>
                      {$pair/namelist/name}
                      {$pair/book}
                   </output>)}
        </coauthor>
