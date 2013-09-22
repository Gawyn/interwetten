 module Interwetten 
  class ResultsClient
    include Interwetten::CommonMethods

    def feed_params
      "EventResults"
    end

    def url
      "http://ad.interwetten.com/XMLFeeder/feeder.asmx/getfeed?"
    end

    def get_result(event_id)
      xml_node = @xml.search("EVENT[ID='#{event_id}']").first
      xml_node.get_attribute "RESULT" if xml_node
    end
  end
end
