require 'date'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/youtube_v3'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
SCOPE = 'https://www.googleapis.com/auth/youtube'
USER_ID = "youtuber"

def authorize
  client_id = Google::Auth::ClientId.from_file('./client_secrets.json')
  token_store = Google::Auth::Stores::FileTokenStore.new(
  :file => './tokens.yaml')
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

  credentials = authorizer.get_credentials(USER_ID)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI )
    puts "Open #{url} in your browser and enter the resulting code:"
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
    user_id: USER_ID, code: code, base_url: OOB_URI)
  end
  credentials
end

youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.client_options.application_name = "youtube_new_videos"
youtube.authorization = authorize

channels = []
token = ''

until token.nil?
  page = youtube.list_subscriptions(part="snippet", mine: true, page_token: token, max_results: 50)
  page.items.each do |el|
    channels << el.snippet.resource_id.channel_id
  end
  token = page.next_page_token
end

videos = []

channels.each do |ch|
  token = ''
  until token.nil?
    page = youtube.list_searches(part="snippet", type: "video", channel_id: ch, page_token: token, max_results: 50)
    page.items.each do |el|
      if el.snippet.published_at > DateTime.now - ARGV[0].to_i
       videos << "https://youtube.com/watch?v="+el.id.video_id
      end  
    end
    token = page.next_page_token
  end
end
p videos