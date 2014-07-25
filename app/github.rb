require 'json'
module Goodluck
  class Github
    def archive_link(ref, repo_with_owner)
      response = http.get do |req|
        req.url "repos/#{repo_with_owner}/tarball/#{ref}"
      end
      response.headers['Location']
    end

    private
    def http_options
      {
        :url     => "https://api.github.com",
        :headers => {
          "Accept"        => "application/vnd.github.v3+json",
          "Content-Type"  => "application/json",
          "Authorization" => "token #{ENV['GITHUB_TOKEN']}"
        }
      }
    end

    def http
      @http ||= Faraday.new(http_options) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
