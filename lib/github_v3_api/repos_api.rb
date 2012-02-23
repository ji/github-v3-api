# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Provides access to the GitHub Repos API (http://developer.github.com/v3/repos/)
  #
  # example:
  #
  #   api = GitHubV3API.new(ACCESS_TOKEN)
  #
  #   # get list of all of the user's public and private repos
  #   repos = api.repos.list
  #   #=> returns an array of GitHubV3API::Repo instances
  #
  #   repo = api.repos.get('octocat', 'hello-world')
  #   #=> returns an instance of GitHubV3API::Repo
  #
  #   repo.name
  #   #=> 'hello-world'
  #
  class ReposAPI
    # Typically not used directly. Use GitHubV3API#repos instead.
    #
    # +connection+:: an instance of GitHubV3API
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubV3API::Repo instances representing the
    # user's public and private repos
    def list
      @connection.get('/user/repos').map do |repo_data|
        GitHubV3API::Repo.new(self, repo_data)
      end
    end

    # Returns a GitHubV3API::Repo instance for the specified +user+ and
    # +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def get(user, repo_name)
      org_data = @connection.get("/repos/#{user}/#{repo_name}")
      GitHubV3API::Repo.new_with_all_data(self, org_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The repository #{user}/#{repo_name} does not exist or is not visible to the user."
    end

    # Returns an array of GitHubV3API::User instances for the collaborators of the
    # specified +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_collaborators(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/collaborators").map do |user_data|
        GitHubV3API::User.new(@connection.users, user_data)
      end
    end

    # Returns an array of GitHubV3API::User instances containing the users who are
    # watching the repository specified by +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_watchers(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/watchers").map do |user_data|
        GitHubV3API::User.new(@connection.users, user_data)
      end
    end

    # Returns an array of GitHubV3API::Repo instances containing the repositories
    # which were forked from the repository specified by +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_forks(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/forks").map do |repo_data|
        GitHubV3API::Repo.new(self, repo_data)
      end
    end

    # Returns an array of the GitHubV3API::Branch instances containing the branches for
    # the repository specified by repo_name, that the user specified by user has access
    # to.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_branches(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/branches").map do |branch_data|
        GitHubV3API::Branch.new(self, branch_data)
      end
    end

    # Returns an array of the GitHubV3API::Tag instances containing the tags for
    # the repository specified by repo_name, that the user specified by user has access
    # to.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_tags(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/tags").map do |tag_data|
        GitHubV3API::Tag.new(self, tag_data)
      end
    end
  end
end
