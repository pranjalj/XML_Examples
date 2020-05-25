(: answer for 1.4a :)
let $books := doc("/db/books.xml")/biblio/author/book
for $book in $books
let $title := $book/title
let $price := xs:integer($book/price)
group by $title, $price
order by $price
return (<title>{$title}</title>,<price>{$price}</price>)