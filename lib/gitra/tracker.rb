require 'git'

module Gitra
  class Tracker
    def initialize(repository)
      @git = Git.open(repository)
    end

    def commits_on(branch_sym, options = {})
      since = @git.object(options[:since].to_s)
      branch = branch_sym.to_s

      base = @git.merge_base(branch, since)
      @git.lib.log_commits(:between => [base, branch]).reverse
    end
  end
end
