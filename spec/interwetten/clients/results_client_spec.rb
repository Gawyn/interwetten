require 'spec_helper'

describe Interwetten::ResultsClient do
  before do
    stub_request(:any, /.*/).to_return(:body => mock_output("results.xml"))
    @results_client = Interwetten::ResultsClient.new(666)
  end

  describe :methods do
    describe :get_result do
      before do
        @result = @results_client.get_result(9754897)
      end

      it "should return the correct result" do
        @result.should == "0:0"
      end
    end
  end
end
