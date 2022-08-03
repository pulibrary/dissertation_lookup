#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'json'
require 'openssl'
require 'nokogiri'

require 'pry'

def lookup_by_title(title)

  host = "https://dataspace.princeton.edu"
  uri = URI.parse("#{host}/rest/items/find-by-metadata-field")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request["Accept"] = "application/json"
  request.body = JSON.dump({
    "key" => "dc.title",
    "value" => title,
    "language" => ""
  })

  req_options = {
    use_ssl: uri.scheme == "https",
    verify_mode: OpenSSL::SSL::VERIFY_NONE,
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.code == "200"
    results = JSON.parse(response.body)

    results.each do |result|
      result_uri = URI.parse("#{host}/#{result['link']}/metadata")
      result_response = Net::HTTP.get_response(result_uri)
      xml_payload = JSON.parse(result_response.body)

      if xml_payload.select{ |entries| entries["key"]== "dc.type" && entries["value"] == "Academic dissertations (Ph.D.)"}.length == 1
        ark = xml_payload.select{ |entries| entries["key"]== "dc.identifier.uri"}.first["value"]
        ark.slice!("http://arks.princeton.edu/")

        puts "#{title}\t#{ark}\n"

      else
        puts "Not a dissertation, exiting"
      end
    end

  else
    puts "Response code: #{response.code}, exiting"
  end
end



titles = File.open('manifest').readlines

titles.each do |title|
  title.chomp!
  lookup_by_title(title)
end
