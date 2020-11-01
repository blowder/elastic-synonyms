curl -X DELETE http://localhost:9200/my_index 2>/dev/null
curl -X PUT http://localhost:9200/my_index \
-H "Content-Type: application/json" \
-d '
{
    "mappings": {
        "_doc": {
            "properties": {
                "my_document_field": {
                    "type": "text",
                    "analyzer": "my_synonyms"
                }
            }
        }
    },
    "settings": {
        "analysis": {
            "filter": {
                "my_synonym_filter": {
                    "type": "synonym",
                    "synonyms": [
                        "usa,united states,u s a,united states of america,U.S.A"
                    ]
                }
            },
            "analyzer": {
                "my_synonyms": {
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "my_synonym_filter"
                    ]
                }
            }
        }
    }
}'

curl -X POST http://localhost:9200/my_index/_doc \
-H "Content-Type: application/json" \
--data '{"my_document_field":"xyz"}'

curl -X POST http://localhost:9200/my_index/_doc \
-H "Content-Type: application/json" \
--data '{"my_document_field":"u.s.a"}'

curl -X POST http://localhost:9200/my_index/_doc \
-H "Content-Type: application/json" \
--data '{"my_document_field":"United States"}'

curl -X POST http://localhost:9200/my_index/_doc \
-H "Content-Type: application/json" \
--data '{"my_document_field":"States"}'


echo ''
echo 'Need some time to index documents!!!'
sleep 3

curl http://localhost:9200/my_index/_search?pretty \
-H "Content-Type: application/json" \
-d '
{
    "query": {
        "match" : {
            "my_document_field" : "u s A"
        }
    }
}'
