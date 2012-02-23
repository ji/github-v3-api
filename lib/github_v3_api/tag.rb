# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Tag and provides access to it's data attributes.
  class Tag < Entity
    attr_reader :name, :commit, :zipball_url, :tarball_url

    private

    def natural_key
      [data['owner']['login'], data['name']]
    end
  end
end

