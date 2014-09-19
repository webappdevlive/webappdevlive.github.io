#!/bin/bash
#

readonly HEADER=$(cat header.ejs)
readonly FOOTER=$(cat footer.ejs)

makeIndex () {
  local index=$(cat index.ejs)
  echo "$HEADER" > index.html
  echo "$index" >> index.html
  echo "$FOOTER" >> index.html
}

getEpisodeCount () {
  local episodeListDir=$(find episode \
                          | xargs grep episode-title \
                          | grep -v Binary \
                          | grep -v index.html
                        )
  local count=$(echo "$episodeListDir" | wc -l)
  echo "$count"
}

makeEpisodeList () {
  echo "$HEADER" > episodes/index.html
  local count=$(getEpisodeCount)
  local i
  for (( i=$count; i>0; i-- ))
  do
    local text=$(find episode \
                  | xargs grep "Episode $i" \
                  | grep -v Binary \
                  | grep -v index.html \
                  | sed s/\<.h1\>// \
                  | sed s/^.*\"\>//
                )
    echo "<h1><a href='/episode/$i/'>$text</a></h1>" >> episodes/index.html
  done
  
  echo "$FOOTER" >> episodes/index.html
}

makeEachEpisode () {
  local episode=$1
  local index=$(cat episode/$episode/index.ejs)
  echo "$HEADER" > episode/$episode/index.html
  echo "$index" >> episode/$episode/index.html
  echo "$FOOTER" >> episode/$episode/index.html
}

makeAllEpisodes () {
  local count=$(getEpisodeCount)
  local i
  for (( i=$count; i>0; i-- ))
  do
    makeEachEpisode $i
  done
}

main () {
  makeIndex
  makeEpisodeList
  makeAllEpisodes
}

main

  
