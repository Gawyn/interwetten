require 'spec_helper'

describe Interwetten::MarketsClient do
  before do
    stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
    @results_client = Interwetten::MarketsClient.new(666)
  end

  describe :methods do
    describe :get_competitions do
      it "should return the correct array of names" do
        @results_client.get_competitions.should == ["Austria Bundesliga "]
      end
    end

    describe :get_competitions_with_id do
      before do
        @competitions = @results_client.get_competitions_with_id
        @competition = @competitions.first
      end

      it "should return the correct amount of competitions" do
        @competitions.size.should == 1
      end

      it "should return competitions with the correct fields" do
        @competition.keys.should == [:name, :id]
      end
    end

    describe :get_events_for_competition do
      before do
        @events = @results_client.get_events_for_competition(405366)
        @event = @events.first
      end

      it "should return the correct amount of events" do
        @events.size.should == 1
      end

      it "should return events with the correct fields" do
        @event.keys.should == [:name, :time, :id]
      end
    end

    describe :get_market_types_for_competition do
      before do
        @market_types = @results_client.get_market_types_for_competition(405366)
      end

      it "should return the correct market types" do
        @market_types.should == ["Match", "Handicap USA", "Over/Under USA"]
      end
    end

    describe :get_markets_for_competition do
      before do
        @markets = @results_client.get_markets_for_competition(405366, "Match")
        @market = @markets.first
        @option = @market.first
      end

      it "should return the correct number of markets" do
        @markets.size.should == 1
      end

      it "should return the correct number of options inside the market" do
        @market.size.should == 2
      end

      it "should return an option with id, player1, player2, tip and odds" do
        @option.keys.should == [:id, :player1, :player2, :tip, :odds]
      end
    end
  end
end
