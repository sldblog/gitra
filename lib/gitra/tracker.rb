require 'git'

module Gitra

  class Tracker
    def initialize(repository)
      @git = Git.open(repository)
    end

    def current_branch
      @git.current_branch
    end

    def branches
      @git.branches.select do |branch|
        name = branch.full.gsub(%r{^remotes/}, '')
        next if name =~ / -> /
        block_given? ? yield(name) : true
      end.map { |branch| branch.full.gsub(%r{^remotes/}, '') }
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
      @git.log_ancestry(base, @branch).reverse
    end
  end

end
