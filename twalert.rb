require 'twitter'

class Twalert
	TWEET_LENGTH = 140
	@@config = JSON.parse File.open("./settings/twitter.json").read
	@@client = Twitter::REST::Client.new do |c|
		c.consumer_key = @@config["consumer_key"]
		c.consumer_secret = @@config["consumer_secret"]
		c.access_token = @@config["oauth_token"]
		c.access_token_secret = @@config["oauth_token_secret"]
	end

	def self.get_title_from_request(request, cf)
		return "caravan-heroes"
	end
	def self.devide_member_within_a_tweet(members, body)
		tweets = []
		tweet = ""
		members.each do |u|
			username = "@#{u.username} "
			if (tweet.length + username.length + body.length) > TWEET_LENGTH then
					p "tweet ##{tweets.length + 1}: #{tweet + body}"
					tweets.push(tweet + body)
					tweet = ""
			end
			tweet = (tweet + username)
		end
		if tweet.length > 0 then
			tweets.push(tweet + body)
		end
		return tweets
	end
	def self.alert(request, detail = nil)
		alert_cf = JSON.parse File.open("./settings/alert.json").read
		title = self.get_title_from_request request, alert_cf["lists"]
		if title then
			# get follower of dokyogames who is in list 'title'
			members = @@client.list_members(@@config["user"], title)
			# create message contains @ mention of above list
			self.devide_member_within_a_tweet(members, alert_cf["alert message"] % [title, Time.now.to_s]).each do |tw|
				# and tweet.
				@@client.update(tw)
			end
		end
	end
end


