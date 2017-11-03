let $doc := doc("ships.xml")
let $nl := "&#10;"

(:a. 

for $Class in $doc/Ships/Class
	where $Class/@numGuns >= 12
		for $Ship in $Class
			return $Ship/@name

:)
(:
for $Class in $doc/Ships/Class
	for $Ship in $Class/Ship
		for $Battle in $Ship/Battle
			where $Battle/@outcome = 'damaged'
				return $Ship/@name

:)

(:
for $Class in $doc/Ships/Class
	where sum(for $Ship in $Class/Ship return 1) >= 4
		return $Class/@name
:)

for $Class in $doc/Ships/Class
	where $Class/@displacement >= 40000
		return $Class/@name