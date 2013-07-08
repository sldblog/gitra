require 'term/ansicolor'

class String
  include Term::ANSIColor
end

module Gitra

  class CLI
    def initialize
      @tracker = Tracker.new '.'
    end

    def analyze(reference_branch)
      reference_branch ||= @tracker.current_branch

      puts "---- Analyzing branches in relation to #{reference_branch.yellow} ----"
      branches = ([reference_branch] + @tracker.branches).uniq!

      print "Analysing #{branches.size} branches: "
      branch_analysis = branches.map do |branch|
        print '.'
        unmerged = @tracker.branch(branch).commits_since(reference_branch).collect { |c| c['sha'] }
        behind = @tracker.branch(reference_branch).commits_since(branch).collect { |c| c['sha'] }
        {:name => branch, :behind => behind.size, :unmerged => unmerged.size}
      end
      puts

      name_max_size = branch_analysis.map { |item| item[:name].size }.sort.last
      branch_analysis.each do |item|
        state = []
        state << "#{item[:unmerged]} ahead (unmerged)".red if item[:unmerged] > 0
        state << "(but #{item[:behind]} behind)" if item[:unmerged] > 0 and item[:behind] > 0
        state << 'merged'.green if state.empty?
        puts "%#{name_max_size}s %s" % [item[:name], state.join(', ')]
      end
    end

    def history(since_revision)
      current = @tracker.current_branch

      puts "---- Analyzing commit history from #{since_revision.yellow} to #{current.yellow} ----"
      commits = @tracker.branch(current).commits_since(since_revision)

      print "Analysing #{commits.size} commits: "
      commit_parser = Gitra::Parser.new('.gitra-rules.yml')
      commits.each do |commit|
        print '.'
        commit_parser.use(commit)
      end
      puts

      commit_parser.result.each_pair do |type, ids|
        ids.sort.each do |id, commits|
          description = ''
          puts "  #{type.to_s.yellow} #{id.to_s.yellow} - #{description}"
        end
      end
    end
  end

end
