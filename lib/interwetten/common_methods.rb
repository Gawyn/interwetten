# encoding: utf-8
require 'open-uri'

module Interwetten
  module CommonMethods
    attr_reader :sport_id, :language, :xml

    def initialize(sport_id, options = {})
      @sport_id = sport_id.is_a?(Array) ? sport_id.join(",") : sport_id
      process_options(options)
      url = generate_url

      begin
        @xml = Nokogiri::XML(open(URI.escape(url))).remove_namespaces!
      rescue
      end
    end

    def self.get_sports(language = "EN")
      params = {
        "FEEDPARAMS" => "ValidKindofsports",
        "LANGUAGE" => language
      }
      sports_url = "http://ad.interwetten.com/XMLFeeder/feeder.asmx/getfeed?#{params.to_query.gsub("&", "|")}"
      begin
        sports_xml = Nokogiri::XML(open(URI.escape(sports_url))).remove_namespaces!
        sports_xml.search("KINDOFSPORT").inject({}) do |res, value|
          res.merge( { value.get_attribute("NAME") => value.get_attribute("ID") } )
        end
      rescue
      end
    end

    private

    def generate_url
      params = {
        "FEEDPARAMS" => feed_params,
        "LANGUAGE" => @language,
        "KINDOFSPORTIDS" => @sport_id
      }

      CGI.unescape("http://ad.interwetten.com/XMLFeeder/feeder.asmx/getfeed?" + params.to_query.gsub("&", "|"))
    end

    def process_options(options)
      @language = options[:language] || "EN"
    end
  end
end
