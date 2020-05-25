(: answer for 1.5a :)
let $books := doc("/db/books.xml")/biblio/author/book
let $category_list := distinct-values($books/category)
let $booklist := for $category in $category_list
                 return (<booklist>
                          {<category>{$category}</category>}
                          {for $book in $books 
                           where $book/category=$category 
                           return <book>{$book/(title,price)}</book>}
                         </booklist>)

for $tempbook in $booklist
let $book1 := <book>{$tempbook/category} {for $finalbook in $tempbook/book 
                                          where $finalbook/price = min(for $match in //book return $tempbook/book/price/text())
                                          return ($finalbook/title,$finalbook/price)}
              </book>
return for $syllabus in $book1
       return (<title>
                 {distinct-values($syllabus/title)}
               </title>,
               <price>
                 {distinct-values($syllabus/price)}
               </price>,
               $syllabus/category)