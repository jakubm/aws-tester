require 'sinatra'
require 'puma'
require 'httparty'
require 'pg'
require 'ffaker'

counterhost = ENV['COUNTERHOST']
counterport = ENV['COUNTERPORT']

pghost = ENV['PGHOST']
pgdatabase = ENV['PGDATABASE']
pguser = ENV['PGUSER']
pgpassword = ENV['PGPASSWORD']

set :port, ENV['PORT']

begin
  conn = PG.connect(host: pghost, dbname: pgdatabase, user: pguser, password: pgpassword)
  conn.exec("create table if not exists test_data (id bigserial, t text)")
  conn.close
rescue StandardError => e
  puts e
end

get '/' do
  begin
    counter = HTTParty.get("http://#{counterhost}:#{counterport}/").body
    output = "<pre>counter: #{counter}</pre><pre>"

    conn = PG.connect(host: pghost, dbname: pgdatabase, user: pguser, password: pgpassword)
    conn.exec("insert into test_data (t) values ('#{FFaker::Lorem.phrase}')")
    counter = 0
    conn.exec("select id, t from test_data order by id desc limit 25") do |result|
      result.each do |row|
        counter += 1
        output += "#{counter}  %-7d %s\n" % row.values_at('id', 't')
      end
    end
    conn.close

    return output + "</pre>"
  rescue StandardError => e
    return e.to_s
  end
end
