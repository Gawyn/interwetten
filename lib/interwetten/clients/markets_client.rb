module Interwetten
  class MarketsClient
    include Interwetten::CommonMethods

    def feed_params
      "BettingOffers"
    end

    def get_competitions
      @competitions ||= @xml.search("LEAGUE").map { |value| value.get_attribute("NAME") }
    end

    def get_competitions_with_id
      @competitions_with_id ||= @xml.search("LEAGUE").map { |value| { :name => value.get_attribute("NAME"), :id => value.get_attribute("ID") } }
    end

    def get_events_for_competition(competition_id)
      @xml.search("LEAGUE[ID='#{competition_id}']").search("EVENT").map { |value| { :name => value.get_attribute("NAME"),
        :time => value.get_attribute("START_TIME") + " +2", :id => value.get_attribute("EVENTID") } }
    end

    def get_markets_for_competition(competition_id, type)
      xml_events = @xml.search("LEAGUE[ID='#{competition_id}']").search("EVENT")
      xml_events.map do |xml_event|
        xml_event.search("BET[TYPENAME='#{type}']").map { |value| { :id => value.get_attribute("ID"), :player1 => value.get_attribute("PLAYER1"),
          :player2 => value.get_attribute("PLAYER2"), :tip => value.get_attribute("TIP"), :odds => value.get_attribute("QUOTE") } }
      end
    end

    def get_market_for_event(event_id, type)
      @xml.search("EVENT[EVENTID='#{event_id}']").search("BET[TYPENAME='#{type}']").map { |value| { :id => value.get_attribute("ID"),
        :player1 => value.get_attribute("PLAYER1"), :player2 => value.get_attribute("PLAYER2"), :tip => value.get_attribute("TIP"), 
        :odds => value.get_attribute("QUOTE") } }
    end

    def get_market_types_for_competition(competition_id)
      @xml.search("LEAGUE[ID='#{competition_id}']").search("BET").map { |value| value.get_attribute "TYPENAME" }.uniq
    end

    def get_market_types_for_event(event_id)
      @xml.search("EVENT[EVENTID='#{event_id}']").search("BET").map { |value| value.get_attribute "TYPENAME" }.uniq
    end

    def get_option(option_id)
      option = @xml.search("BET[ID='#{option_id}']").first
      { :odds => option.get_attribute("QUOTE"), :player1 => option.get_attribute("PLAYER1"), :player2 => option.get_attribute("PLAYER2"), :tip => option.get_attribute("TIP") } if option
    end

    def get_odds_for_option(option_id)
      @xml.search("BET[ID='#{option_id}']").first.get_attribute("QUOTE")
    end
  end
end
