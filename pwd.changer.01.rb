#! /usr/bin/env ruby
# encoding: utf-8

require 'gooddata'
require 'csv'

GoodData.logging_on

CSV.foreach("/Users/jbasko/Documents/ruby/gooddata-ruby-examples/snippets/01_core/input01.csv") do |row|
  $old_password = row[0]
  $new_password = row[1]

  # puts "old_password=#{row[0]}  new_password =#{row[1]}"
end

CSV.foreach("/Users/jbasko/Documents/ruby/gooddata-ruby-examples/snippets/01_core/input.csv") do |row|
  $hostname = row[0]
  $username = row[1]

  puts "Reading hostname=#{row[0]} and username =#{row[1]}"


  puts "Connecting as #{$username}"

  begin
  GoodData.with_connection(login: $username,
                           password: $old_password,
                           server: $hostname) do |client|
    # just so you believe us we are printing names of all the project under this account

    ##zde zacne vykonavat akci

    # puts client
    first_name = client.user.first_name
    last_name = client.user.last_name
    email = client.user.email
    profileID = client.user.obj_id
    uri = client.user.uri

# puts "first_name , last_name, email, profileID ,uri"

    #puts "First name: #{first_name}"
    #puts "Last name: #{last_name}"
    #puts "Email: #{email}"
    #puts "Profile ID: #{profileID}"
    puts "URI: #{uri}"

    nas_json = "{
    \"accountSetting\" : {
        \"firstName\" : \"#{first_name}\",
        \"lastName\" : \"#{last_name}\",
        \"password\" : \"#{$new_password}\",
        \"verifyPassword\" : \"#{$new_password}\",
        \"old_password\" : \"#{$old_password}\"
    }
}"

    begin
      # puts "SENDING: #{nas_json.inspect}"
      puts "Sending request..."
      GoodData.put uri, nas_json
      puts "Request finished, password changed..."
    rescue => e
      puts "Request failed ... See details"
      puts e.inspect
    end


    ##zde skonci vykonavat akci

    puts 'Disconnecting ...'
    GoodData.disconnect
  end
  rescue => e
    puts "Request failed ... See details"
    puts e.inspect

  end
end

