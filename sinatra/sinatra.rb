require 'pg'
require 'sinatra'
require 'puma'
require 'httparty'

pghost = ENV['PGHOST']
pgdatabase = ENV['PGDATABASE']
pguser = ENV['PGUSER']
pgpassword = ENV['PGPASSWORD']

counterhost = ENV['COUNTERHOST']
counterport = ENV['COUNTERPORT']

set :port, ENV['PORT']

conn = PG.connect(host: pghost, dbname: pgdatabase, user: pguser, password: pgpassword)
conn.exec("create table if not exists test_data (id bigserial, t text)")
conn.close

get '/' do
  conn = PG.connect(host: pghost, dbname: pgdatabase, user: pguser, password: pgpassword)
  conn.exec("insert into test_data (t) values ('Hello, World')")
  counter = HTTParty.get("http://#{counterhost}:#{counterport}/").body
  output = "<pre>counter: #{counter}</pre><pre>"
  counter = 0
  conn.exec("select id, t from test_data order by id desc limit 25")  do |result|
    result.each do |row|
      counter += 1
      output += "#{counter}  %-7d %s\n" % row.values_at('id', 't')
    end
  end
  conn.close
  output + "</pre>"
end