# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Repo and provides access to its data attributes.
  class Branch < Entity
    attr_reader :name, :commit

    private

    def natural_key
      [data['owner']['login'], data['name']]
    end
  end
end

