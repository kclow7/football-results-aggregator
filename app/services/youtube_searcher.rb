require 'google/apis/youtube_v3'
require 'json'
require 'pry'
require 'httparty'
require 'open-uri'

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
    # matches = get_matches
    matches = Match.where(id: 49)
    matches.each do |match|
      binding.pry
      next if match.video_thumbnail.attached?
      match_video_details = get_match_video_details(match)
      update_match(match, match_video_details)
    end
  end

  private

  def set_service
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.key = DEVELOPER_KEY
  end

  def get_matches
    league_id = League.find_by(name: @league_name)
    matches = Match.where(matchday: @matchday, league_id: league_id)
  end

  def get_match_video_details(match)
    match_video = get_match_video(match)
    json_object = JSON.parse(match_video.to_json)
    match_video_details = extract_video_details(json_object)
  end

  def get_match_video(match)
    query = "#{match.team_1.name} #{match.score_1} - #{match.score_2} #{match.team_2.name} highlights"
    fields="items(id(videoId),snippet(title,thumbnails(medium(url))))"
    # we only retrieve the video's title, thumbnail URL, and its ID (which we can make into a link)
    result = @service.list_searches("snippet", type: "video", max_results: 1, q: query, fields: fields)
  end

  def extract_video_details(json_object)
    youtube_link = "https://www.youtube.com/watch?v=" + json_object["items"][0]["id"]["videoId"]
    match_video_details = {
        thumbnail_url: json_object["items"][0]["snippet"]["thumbnails"]["medium"]["url"],
        title: json_object["items"][0]["snippet"]["title"],
        youtube_link: youtube_link
    }
  end

  def update_match(match, match_video_details)
    match.video_title = match_video_details[:title]
    match.youtube_link = match_video_details[:youtube_link]
    thumbnail_temp_file = open(match_video_details[:thumbnail_url])
    match.video_thumbnail.attach(io: thumbnail_temp_file, filename: "match_#{match.id}.png")
    match.save
  end
end
