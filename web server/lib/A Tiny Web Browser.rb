#!/usr/bin/env ruby
require 'socket'
require 'json'
 
host = 'localhost'                  # The web server
port = 2000                           # Default HTTP port
params = Hash.new { |hash, key| hash[key] = Hash.new }                

input = ''
until input == 'GET' || input == 'POST'
  print 'What type of request do you want to submit [GET, POST]? '
  input = gets.chomp
end

if input == 'POST'
  print 'Enter name: '
  name = gets.chomp
  print 'Enter e-mail: '
  email = gets.chomp
  params[:person][:name] = name
  params[:person][:email] = email
  body = params.to_json
  # create request line to send to server
  request = 
    "POST /thanks.html HTTP/1.0\r\nContent-Length: #{params.to_json.length}\r\n\r\n#{body}"
else
  request = "GET index.html HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
puts ''
puts request
response = socket.read              # Read complete response
headers,body = response.split("\r\n\r\n", 2) # Split response at first blank line into headers and body 
puts ''
print headers
puts ''
print body                           # And display it
socket.close                         # end session
