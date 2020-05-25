(: answer for 1.6 :)
(:
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE biblio[
<!ELEMENT biblio (book*)>
<!ELEMENT book (title,category,rating,price,author*)>
<!ATTLIST book year CDATA #REQUIRED> ]>
<!ELEMENT title (#PCDATA)>
<!ELEMENT category(#PCDATA)> 
<!ELEMENT rating(#PCDATA)> 
<!ELEMENT price (#PCDATA)>
<!ELEMENT author (name)>
<!ELEMENT name (#PCDATA)>
:)
let $authors := doc("/db/books.xml")/biblio/author
let $titles := distinct-values($authors/book/title)
let $result := (for $author in $authors, $title in $titles  
where $author/book/title = $title     
group by $title                 
return 
<book year="{distinct-values($author/book[title=$title]/@year)}">  
<title> {$title} </title>
<category>{distinct-values($author/book[title=$title]/category)}</category>
<rating>{distinct-values($author/book[title=$title]/rating)}</rating>
<price>{distinct-values($author/book[title=$title]/price)} </price>  
{for $coauthor in $author/name return
<author>{$coauthor}</author>}  
</book>)
return <biblio>{$result}</biblio>