(: answer for 1.1 :)
for $author in doc("/db/books.xml")/biblio/author
where $author/name = 'Jeff'
  for $t in $author/book/title
  return (for $author2 in doc("/db/books.xml")/biblio/author
          where $author2/book/title = $t
            and $author2/name != 'Jeff'
          return <book>
                       {$t}
                       {$author2/name}
                       <name>Jeff</name>
                 </book>)