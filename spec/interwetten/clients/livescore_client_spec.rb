require 'spec_helper'

describe Interwetten::LivescoreClient do
  before do
    stub_request(:any, /.*/).to_return(:body => mock_output("livescore.xml"))
    @livescore_client = Interwetten::LivescoreClient.new(666)
  end

  describe :methods do
    describe :get_events do
      before do
        @events = @livescore_client.get_events
      end

      it "should return an array with the events" do
        @events.should == [9759527, 9759529, 9759228]
      end
    end

    describe :get_score do
      before do
        @livescore = @livescore_client.get_score(9759527)
      end

      it "sends back the correct keys" do
        @livescore.keys.should == [:interwetten_id, :gametime, :status, :name, :sport_id, :result]
      end
    end
  end
end
