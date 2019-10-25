host = if Rails.env.test? then "localhost:9200" else ENV['ELASTICSEARCH_URL'] end

Elasticsearch::Model.client = Elasticsearch::Client.new host: host 
