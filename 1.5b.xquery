(: answer for 1.5b :)
let $books := doc("/db/books.xml")/biblio/author/book
let $category_list := distinct-values($books/category)
let $booklist := for $category in $category_list
                 return (<booklist>
                          {<category>{$category}</category>}
                          {for $book in $books 
                           where $book/category=$category 
                           return <book>{$book/(title,rating)}</book>}
                         </booklist>)

for $tempbook in $booklist
let $book1 := <book>{$tempbook/category} {for $finalbook in $tempbook/book 
                                          where $finalbook/rating = max(for $match in //book return $tempbook/book/rating/text())
                                          return ($finalbook/title,$finalbook/rating) }
              </book>
return for $syllabus in $book1
       return (<title>
                 {distinct-values($syllabus/title)}
               </title>,
               <rating>
                 {distinct-values($syllabus/rating)}
               </rating>,
               $syllabus/category)