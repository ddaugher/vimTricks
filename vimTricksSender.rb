#!/usr/bin/env ruby -w
# Monitor an RSS feed, and post its articles to twitter.
require 'rubygems'
require 'twitter'
require 'simple-rss'
require 'shorturl'
require 'open-uri'
require 'mysql'

class Tweet
  attr_accessor :username
  attr_accessor :password
  attr_accessor :tweet

  def initialize(username = "vimtricks", password = "vim123")
	@username = username
	@password = password
  end

  def send_tweet
	httpauth = Twitter::HTTPAuth.new(@username, @password)
	twitter = Twitter::Base.new( httpauth )
	twitter.update(@tweet)
  end
end

begin
  # connect to the MySQL server
  dbh = Mysql.real_connect("localhost", "intuitim_Vim123", "kinkybr00mstick", "intuitim_vimtricks")
  # get server version string and display it
  puts "Server version: " + dbh.get_server_info

# issue a retrieval query, perform a fetch loop, print the row count, and free the result set
res = dbh.query("SELECT id, command, nexttweet FROM commands order by nexttweet limit 1")
    
id = 0
while row = res.fetch_row do
  printf "%s, %s, %s\n", row[0], row[1], row[2]
  tweet = Tweet.new
  id = row[0]
  tweet.tweet = row[1]
  tweet.send_tweet
end

puts "Number of rows returned: #{res.num_rows}"
res.free

puts "id = #{id}"
dbh.query("UPDATE commands set nexttweet = nexttweet+1 where id = #{id}")
puts "Number of rows inserted: #{dbh.affected_rows}"

rescue Mysql::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  # disconnect from server
  dbh.close if dbh
end
