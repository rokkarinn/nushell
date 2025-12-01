export def images [] {
  ( ^docker image ls --format '{{json .}}'
  | lines
  | par-each {|l| $l | from json }
  | upsert CreatedAt {|r| $r.CreatedAt | str replace 'GMT' '' | into datetime }
  | upsert Size {|r| $r.Size | into filesize }
  | reject Containers CreatedSince Digest SharedSize UniqueSize VirtualSize
  | move Size --after Tag
  | move CreatedAt --after Size
  | move Repository --before Tag
  | move ID --before Repository
  | sort-by Repository Tag CreatedAt
  )
}

export def ps [] {
  ( ^docker ps --format '{{json .}}'
  | lines 
  | par-each {|$l| $l | from json }
  | upsert CreatedAt {|r| $r.CreatedAt | str replace 'GMT' '' | into datetime }
  | reject Labels Mounts Networks LocalVolumes State Size RunningFor 
  | move ID --before Command 
  | move Status --before Names
  | sort-by CreatedAt
  )
}
