define [
  'underscore',
  'backbone',
  'apps/lib/twitter/model/tweetModel'
], (_, Backbone, TweetModel) ->
  
  class TweetsCollection extends Backbone.Collection
    model: TweetModel 
    url: "http://search.twitter.com/search.json?callback=?",
    
    parse: (response) ->

      return response.results
      