module Interwetten
  class LivescoreClient
    def initialize(affiliate, options = {})
      params = {
        "LanguageID" => options[:language] || "EN",
        "Filter" => options[:filter],
        "b" => affiliate
      }
      url = "https://ad.interwetten.com/ticker_temp/offer.asmx/GetLiveEventList?" + params.to_query

      begin
        @xml = Nokogiri::XML(open(URI.escape(url))).remove_namespaces!
      rescue
      end
    end

    def pluck_events(attribute)
      @xml.search("EVENT").map { |value| value.get_attribute(attribute).to_i } if @xml
    end

    def get_events_id
      @events_id ||= pluck_events('ID')
    end

    def get_events_clone_id
      @events_clone_id ||= pluck_events('CLONEID')
    end

    def get_events
      get_events_clone_id
    end

    def get_score_by_clone_id(event_id)
      event = @xml.search("EVENT[CLONEID='#{event_id}']").first
      process_score(event)
    end

    def get_score(event_id)
      get_score_by_clone_id(event_id)
    end

    def get_last_entry_by_clone_id(event_id)
      event = @xml.search("EVENT[CLONEID='#{event_id}']").first
      entry = event.search("ENTRY").first
      { :id => entry.get_attribute("ID"), :display_time => entry.get_attribute("DISPLAYTIME"),
        :message => entry.get_attribute("MESSAGE") } 
    end

    def process_score(event)
      case event.get_attribute("LIVE_KOSID")
        when "10", "15"
          process_default(event)
        when "11"
          process_tennis(event)
      end
    end

    def transform_format(value)
      value.split('=').last.delete(' ').gsub(':', '-')
    end

    def common_process(event)
      gametime = event.get_attribute("GAMETIME").delete("´")
      sport_id = event.get_attribute("LIVE_KOSID")
      status = event.get_attribute("STATUS")
      interwetten_id = event.get_attribute("ID")
      start_time = Time.parse(event.get_attribute("START_TIME"))
      name = event.get_attribute("NAME").gsub("(LIVE)", "").gsub("(live)", "")
      name = name.split("-").map { |contender| contender.strip }.join("-")
      {interwetten_id: interwetten_id, :gametime => gametime, :status => status, :name => name, sport_id: sport_id, start_time: start_time}
    end

    def process_default(event)
      result = transform_format(event.get_attribute("SCORE").split("|").first)
      common_process(event).merge(:result => result)
    end

    def process_tennis(event)
      score = event.get_attribute("SCORE")
      splitted_score = score.split "|"

      sets = splitted_score.select { |value| value=~/^Set / }.map do |set|
        transform_format(set)
      end

      in_game = get_value_in_score(splitted_score, "InGame")
      tie_break = get_value_in_score(splitted_score, "Tiebreak")
      serving = get_value_in_score(splitted_score, "#Serving")

      common_process(event).merge(:sets => sets, :in_game => in_game, :serving => serving, :tie_break => tie_break)
    end

    def get_value_in_score(score, attribute)
      transform_format(score.detect { |value| value =~/^#{attribute}/ })
    end
  end
end
