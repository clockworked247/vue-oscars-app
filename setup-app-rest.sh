#!/bin/sh

DATABASE="oscars-new-01"
SERVER="oscars-new-01"
PORT="8021"
COLLECTION="oscars"

#-- Create Database --
echo "---> Database creation ... setup in progress"

curl -X POST  --anyauth -u admin:admin --header "Content-Type:application/json" \
  -d '{"database-name":"'"$DATABASE"'"}' http://localhost:8002/manage/v2/databases

echo "---> Database creation DONE"

#-- Create Forest --
echo "---> Forest creation ... setup in progress"

curl -X POST  --anyauth -u admin:admin --header "Content-Type:application/json" \
  -d '{"forest-name":"'"$DATABASE"'-forest-01", "database": "'"$DATABASE"'"
 }' http://localhost:8002/manage/v2/forests

echo "---> Forest creation ... DONE"

#-- Load Data --
echo "---> Data loading ... setup in progress"

sh /Users/sbrooks/Desktop/mlcp-9.0.1/bin/mlcp.sh import -database $DATABASE -host localhost -port 8000 -username admin \
 -password admin -input_file_path data/oscars -mode local \
 -output_uri_replace "data,''" \
 -output_collections "$COLLECTION"

echo "---> Data loading ... DONE"

#-- Create server --
echo "---> REST Server creation ... setup in progress"

 curl -v -X POST  --anyauth -u admin:admin \
  --header "Content-Type:application/json" \
  -d '{"rest-api": { "name": "'"$SERVER"'", "port": "'"$PORT"'", "database": "'"$DATABASE"'" } }' \
  http://localhost:8002/v1/rest-apis

curl -v -X PUT --anyauth -u admin:admin \
  --header "Content-Type:application/json" \
  -d '{"collection-lexicon":true}' \
  http://localhost:8002/manage/v2/databases/$DATABASE/properties

echo "---> REST Server creation ... DONE"

#-- Users --
echo "---> User creation ... setup in progress"

curl -v -X POST  --anyauth -u admin:admin \
  --header "Content-Type:application/json" \
  -d '{"user-name":"rest-writer", "password": "x", "role": ["rest-writer"]}' \
  http://localhost:8002/manage/v2/users

  curl -v -X POST  --anyauth -u admin:admin \
  --header "Content-Type:application/json" \
  -d '{"user-name":"rest-admin", "password": "x", "role": ["rest-admin"]}' \
  http://localhost:8002/manage/v2/users

echo "---> User creation ... DONE"

#-- custom search --
echo "---> Custom search ... setup in progress"

curl -v -X POST \
  --digest --user rest-admin:x \
  -H "Content-type: application/json" \
  -d'{"options":{"fragment-scope":"documents", "quality-weight":0, "search-option":["unfiltered"], "page-length":10, "term":{"apply":"term", "empty":{"apply":"all-results"}, "term-option":["punctuation-insensitive"]}, "grammar":{"quotation":"\"", "implicit":"<cts:and-query strength=\"20\" xmlns:search=\"http:\/\/marklogic.com\/appservices\/search\" xmlns:cts=\"http:\/\/marklogic.com\/cts\"\/>", "starter":[{"strength":"30", "apply":"grouping", "delimiter":")", "label":"("}, {"strength":"40", "apply":"prefix", "cts-element":"cts:not-query", "label":"-"}], "joiner":[{"strength":"10", "apply":"infix", "cts-element":"cts:or-query", "tokenize":"word", "label":"OR"}, {"strength":"20", "apply":"infix", "cts-element":"cts:and-query", "tokenize":"word", "label":"AND"}, {"strength":"30", "apply":"infix", "cts-element":"cts:near-query", "tokenize":"word", "label":"NEAR"}, {"strength":"30", "apply":"near2", "consume":"2", "cts-element":"cts:near-query", "label":"NEAR\/"}, {"strength":"32", "apply":"boost", "cts-element":"cts:boost-query", "tokenize":"word", "label":"BOOST"}, {"strength":"35", "apply":"not-in", "cts-element":"cts:not-in-query", "tokenize":"word", "label":"NOT_IN"}, {"strength":"50", "apply":"constraint", "label":":"}, {"strength":"50", "apply":"constraint", "compare":"LT", "tokenize":"word", "label":"LT"}, {"strength":"50", "apply":"constraint", "compare":"LE", "tokenize":"word", "label":"LE"}, {"strength":"50", "apply":"constraint", "compare":"GT", "tokenize":"word", "label":"GT"}, {"strength":"50", "apply":"constraint", "compare":"GE", "tokenize":"word", "label":"GE"}, {"strength":"50", "apply":"constraint", "compare":"NE", "tokenize":"word", "label":"NE"}]}, "constraint":[{"name":"award", "range":{"collation":"http:\/\/marklogic.com\/collation\/", "type":"xs:string", "facet":true, "facet-option":["limit=10"], "attribute":{"ns":"", "name":"award"}, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"nominee"}}}, {"name":"centroid", "custom":{"facet":true, "parse":{"apply":"parse-structured", "ns":"http:\/\/marklogic.com\/appservices\/viz\/geo", "at":"\/application\/constraint\/geo.xqy"}, "start-facet":{"apply":"start", "ns":"http:\/\/marklogic.com\/appservices\/viz\/geo", "at":"\/application\/constraint\/geo.xqy"}, "finish-facet":{"apply":"finish", "ns":"http:\/\/marklogic.com\/appservices\/viz\/geo", "at":"\/application\/constraint\/geo.xqy"}, "facet-option":["limit=10000"]}, "annotation":[{"geo-elem-pair":{"heatmap":{"n":89.999, "e":179.999, "s":-89.999, "w":-179.999, "latdivs":10, "londivs":10}, "parent":{"ns":"http:\/\/where.yahooapis.com\/v1\/schema.rng", "name":"centroid"}, "lat":{"ns":"http:\/\/where.yahooapis.com\/v1\/schema.rng", "name":"latitude"}, "lon":{"ns":"http:\/\/where.yahooapis.com\/v1\/schema.rng", "name":"longitude"}}}]}, {"name":"decade", "range":{"type":"xs:gYear", "facet":true, "bucket":[{"ge":"2000", "name":"2000s", "label":"2000s"}, {"lt":"2000", "ge":"1990", "name":"1990s", "label":"1990s"}, {"lt":"1990", "ge":"1980", "name":"1980s", "label":"1980s"}, {"lt":"1980", "ge":"1970", "name":"1970s", "label":"1970s"}, {"lt":"1970", "ge":"1960", "name":"1960s", "label":"1960s"}, {"lt":"1960", "ge":"1950", "name":"1950s", "label":"1950s"}, {"lt":"1950", "ge":"1940", "name":"1940s", "label":"1940s"}, {"lt":"1940", "ge":"1930", "name":"1930s", "label":"1930s"}, {"lt":"1930", "name":"1920s", "label":"1920s"}], "facet-option":["limit=10"], "attribute":{"ns":"", "name":"year"}, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"nominee"}}}, {"name":"win", "range":{"collation":"http:\/\/marklogic.com\/collation\/", "type":"xs:string", "facet":true, "facet-option":["limit=10"], "attribute":{"ns":"", "name":"winner"}, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"nominee"}}}, {"name":"name", "range":{"collation":"http:\/\/marklogic.com\/collation\/", "type":"xs:string", "facet":true, "facet-option":["frequency-order", "descending", "limit=10"], "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"name"}}}, {"name":"film", "range":{"collation":"http:\/\/marklogic.com\/collation\/", "type":"xs:string", "facet":true, "facet-option":["frequency-order", "descending", "limit=10"], "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"film-title"}}}, {"name":"inname", "word":{"element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"name"}, "term-option":["punctuation-insensitive"]}, "annotation":[""]}, {"name":"intitle", "word":{"element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"film-title"}, "term-option":["punctuation-insensitive"]}, "annotation":[""]}], "operator":[{"name":"sort", "state":[{"name":"relevance", "sort-order":[{"score":null}]}, {"name":"year", "sort-order":[{"direction":"descending", "type":"xs:gYear", "attribute":{"ns":"", "name":"year"}, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"nominee"}}, {"score":null}]}]}, {"name":"results", "state":[{"name":"compact", "transform-results":{"apply":"snippet", "preferred-elements":{"element":{"ns":"http:\/\/www.w3.org\/1999\/xhtml", "name":"p"}}, "max-matches":"2", "max-snippet-chars":"150", "per-match-tokens":"20"}}, {"name":"detailed", "transform-results":{"apply":"snippet", "preferred-elements":{"element":{"ns":"http:\/\/www.w3.org\/1999\/xhtml", "name":"p"}}, "max-matches":"2", "max-snippet-chars":"400", "per-match-tokens":"30"}}]}], "transform-results":{"apply":"snippet", "preferred-elements":{"element":{"ns":"http:\/\/www.w3.org\/1999\/xhtml", "name":"p"}}, "max-matches":"2", "max-snippet-chars":"150", "per-match-tokens":"20"}, "additional-query":"<directory-query xmlns:search=\"http:\/\/marklogic.com\/appservices\/search\" xmlns=\"http:\/\/marklogic.com\/cts\">\n  <uri>\/oscars\/<\/uri>\n<\/directory-query>", "default-suggestion-source":{"range":{"collation":"http:\/\/marklogic.com\/collation\/", "type":"xs:string", "facet":false, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"film-title"}}}, "return-query":true, "values":[{"name":"decade", "range":{"type":"xs:gYear", "facet":true, "element":{"ns":"http:\/\/marklogic.com\/wikipedia", "name":"nominee"}, "attribute":{"ns":"", "name":"year"}}, "aggregate":[{"apply":"min"}, {"apply":"max"}]}], "extract-metadata":{"qname":[{"elem-ns":"http:\/\/marklogic.com\/wikipedia", "elem-name":"name"}, {"elem-ns":"http:\/\/marklogic.com\/wikipedia", "elem-name":"film-title"}, {"elem-ns":"http:\/\/marklogic.com\/wikipedia", "elem-name":"nominee", "attr-ns":"", "attr-name":"award"}, {"elem-ns":"http:\/\/marklogic.com\/wikipedia", "elem-name":"nominee", "attr-ns":"", "attr-name":"year"}], "constraint-value":[{"ref":"award"}, {"ref":"decade"}, {"ref":"win"}, {"ref":"name"}, {"ref":"film"}]}, "annotation":["Delta options here"]}}' \
  'http://localhost:'"$PORT"'/v1/config/query/all'

echo "---> Custom search ... DONE"

echo "---> SETUP COMPLETE!"
