require 'google/apis/youtube_v3'
require 'json'
require 'pry'

class YoutubeSearcher < ApplicationService
  DEVELOPER_KEY = ENV['YOUTUBE_DATA_API_KEY']
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize(matchday:, league_name:)
    @matchday = matchday
    @league_name = league_name
  end

  def call
    set_service
    matches = get_matches
    all_video_details = get_all_videos_details(matches)
    # save_matches_video_details(all_video_details)
  end

  # private

  def set_service
    Youtube = Google::Apis::YoutubeV3 # Alias the module
    @service = Youtube::YouTubeService.new
    @service.key = DEVELOPER_KEY
  end

  def get_matches
    league_id = League.find_by(name: @league_name)
    matches = Match.where(matchday: @matchday, league_id: league_id)
  end

  def get_all_videos_details(matches)
    all_video_details = []
    matches.each do |match|
      match_video = get_match_video(match)
      json_object = JSON.parse(match_video.to_json)
      video_detail = extract_video_detail(json_object)
      all_video_details << video_detail
    end
    all_video_details
  end

  def get_match_video(match)
    query = "#{match.team_1.name} #{match.score_1} - #{match.score_2} #{match.team_2.name}"
    fields="items(id(videoId),snippet(title,thumbnails(medium(url))))"
    # we only retrieve the video's title, thumbnail URL, and its ID (which we can make into a link)
    result = @service.list_searches("snippet", type: "video", max_results: 1, q: query, fields: fields)
  end

  def extract_video_detail(json_object)
    youtube_link = "https://www.youtube.com/watch?v=" + json_object["items"][0]["id"]["videoId"]
    video_detail = {
        thumbnail_url: json_object["items"][0]["snippet"]["thumbnails"]["medium"]["url"],
        title: json_object["items"][0]["snippet"]["title"],
        youtube_link: youtube_link
    }
  end

  # def save_matches_video_details(all_video_details)
  #
  # end
end
