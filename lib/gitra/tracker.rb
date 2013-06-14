require 'git'

module Gitra

  class Tracker
    def initialize(repository)
      @git = Git.open(repository)
    end

    def branch(branch)
      TrackedBranch.new(@git, branch)
    end

    def method_missing(name, *args, &block)
      raise NoMethodError, "method `#{name}' should be used as `<tracker>.branch(reference).#{name}(<args>)'" if TrackedBranch.method_defined? name
      super
    end
  end

  private

  class TrackedBranch
    def initialize(git, branch)
      @git = git
      @branch = branch.to_s
    end

    def commits_since(reference)
      since = @git.object(reference.to_s)
      base = @git.merge_base(@branch, since)
      @git.lib.log_commits(:between => [base, @branch]).reverse
    end

    def missing_commits_from(reference)
      from = @git.object(reference.to_s)
      base = @git.merge_base(@branch, from)
      @git.log.between(base, from).collect { |commit| commit.sha }
    end
  end

end
