# Interwetten

Interwetten is a Ruby wrapper of the Interwetten API. As most betting companies APIs, this one provides data of bet markets (matches, options, odds...). But this one also offers the user the result of the offered matches and even livescores.

## Installation

Add this line to your application's Gemfile:

    gem 'interwetten'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interwetten

## Usage

This gem gives you three different clients.

The Interwetten gem is divided in three clients. But the three of them have one common method: `get_sports'. It returns a hash with the name of the available sports as key and the id in the Interwetten system as value. The latter is important, as you need the sport id to get any kind of information.

### Interwetten::MarketsClient

You initialize a MarketsClient with `Interwetten::MarketsClient.new(sport_id)`.

This client give you the following methods:

+ `get_competitions`
+ `get_events_for_competition(competition_id)`
+ `get_events_for_competition`
+ `get_market_types_for_competition(competition_id)`

### Interwetten::ResultsClient

You initialize a ResultsClient with `Interwetten::ResultsClient.new(sport_id)`.

This client give you the following methods:

+ `get_result(event_id)`


### Interwetten::LivescoreClient

The livescore feature is only available if you register in Interwetten as an affiliate. Anyway, it's pretty simple, you can do it through [this link](http://affiliates.interwetten.com/).

You initialize a LivescoreClient with `Interwetten::MarketsClient.new(MY_INTERWETTEN_AFFILIATE_NUMBER)`.

This client give you the following methods:

+ `get_events`
+ `get_score(event_id)`


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
