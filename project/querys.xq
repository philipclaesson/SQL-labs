let $doc := doc("videos.xml")
let $nl := "&#10;"

(:1:)
(:
for $x in $doc/result/videos/video
where $x/genre = 'special' 
return $x/title
:)


(:2 :)

(:
for $director in fn:distinct-values($doc/result/videos/video/director)
	let $count := count($doc/result/videos/video[director = $director])
	where $count >= 2
	return <movie director = "{$director}"><title> {for $movie in $doc/result/videos/video[director = $director] return ("&#10;", $movie/title)} </title> </movie>
:)

(:3 :)
(:
return subsequence(
	reverse(
		for $movie in $doc/result/videos/video 
			order by $movie/user_rating
				return $movie/title),1,10)
:)

(: 4 Utput kommer i fel ordning, vet inte om det är viktigt! :)

(:
return subsequence(reverse(
	for $actor in $doc/result/actors/actor
		let $count := count(
			for $movie in $doc/result/videos/video
				where some $ref in $movie/actorRef satisfies data($ref) = $actor/@id
					return 1)
		order by ($count)
		return data($actor)),1,2)
:)


(: 5 Which is one of the highest rating movie starring both Brad Pitt and Morgan Freeman? :)
(:
return subsequence(reverse(
	for $movie in $doc/result/videos/video
		where $movie[actorRef = "916503208"] and $movie[actorRef = "916503209"]
		order by $movie/user_rating
		return $movie/title), 1,1)
:)

(: 6  Which actors have starred in a PG-13 movie between 1997 and 2006 (including 1997 and 2006)? :)
(:
return distinct-values(
	for $actor in $doc/result/actors/actor
		for $movie in $doc/result/videos/video
			where $movie[rating = 'PG-13'] and $movie[year >= 1997] and $movie[year <= 2006] and $movie[actorRef = $actor/@id] 
				return $actor)
:)


(: 7 Who have starred in the most distinct types of genre? INTE HELT RÄTT OUTPUT  :)
(:

return subsequence(
	reverse(
		for $actor in $doc/result/actors/actor
			let $count := count(distinct-values(
				for $movie in $doc/result/videos/video
					where $movie[actorRef = $actor/@id]
						return $movie/genre
						))
			order by $count
			return data($actor)
	)
,1, 1)

:)

(:8. Which director have the highest sum of user ratings? :)
(:
return subsequence(
	reverse(
		for $director in distinct-values($doc/result/videos/video/director)
			let $rating := sum(
				for $movie in $doc/result/videos/video
					where $movie[director = $director]
					return $movie/user_rating)
		order by $rating
		return $director
	)
,1,1)
:)


(:9. Which movie should you recommend to a customer if they want to see a horror
movie and do not have a laserdisk? :)
(:
for $movie in $doc/result/videos/video
	where $movie[genre = "horror"] 
	and $movie[dvd_stock+vhs_stock > 0]
	order by $movie/user_rating
	return $movie/title

:)



(:10. Group the movies by genre and sort them by user rating within each genre:)


for $genre in distinct-values($doc/result/videos/video/genre)
	order by $genre
	let $movies_in_genre := reverse(
		for $movie in $doc/result/videos/video
			where $movie[genre = $genre]
			order by $movie/user_rating
			return ($nl,$movie/title))
	return <genre genre = "{$genre}"> {$movies_in_genre} </genre>






