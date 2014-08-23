#!/usr/bin/env ruby
require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever

  Thread.start(server.accept) do |client| # Wait for a client to connect and multithread
   # puts client.read_nonblock(256)
     request = client.read_nonblock(256)          # reads at most 256bytes of data ans raises an exception if the data is non readable.
     request_header, request_body = request.split("\r\n\r\n", 2)   # splits request into header and body
     path = request_header.split[1]#[1..-1]                         # gets path from request header
     method = request_header.split[0]
    
    
    
    if File.exist?(path)
      response_body = File.read(path)
      client.puts "HTTP/1.1 200 OK\r\nContent-type:text/html\r\n\r\n"
       if method == 'GET'
         client.puts response_body
       elsif method == 'POST'
        params = JSON.parse(request_body)
        user_data = "<li>name: #{params['person']['name']}</li><li>e-mail: #{params['person']['email']}</li>"
        client.puts response_body.gsub('<%= yield %>', user_data)
       else
        client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
        client.puts '404 Error, File Could not be Found'
       end
      client.puts(Time.now.ctime)  # Send the time to the client
      client.puts "Closing the connection. Bye!"
      client.close                 # Disconnect from the client
    end
  end
}