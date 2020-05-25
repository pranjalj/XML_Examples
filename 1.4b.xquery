(: answer for 1.4b :)
let $books := doc("/db/books.xml")/biblio/author/book
for $book in $books
let $title := $book/title
let $rating := xs:decimal($book/rating)
group by $title, $rating
order by $rating descending
return (<title>{$title}</title>,<rating>{$rating}</rating>)