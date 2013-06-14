require 'term/ansicolor'

class String
  include Term::ANSIColor
end

module Gitra

  module CLI
    def self.analyze(reference_branch)
      tracker = Tracker.new '.'
      reference_branch ||= tracker.current_branch

      puts "---- Analyzing branches in relation to #{reference_branch.yellow} ----"
      branches = ([reference_branch] + tracker.branches).uniq!

      print "Analysing #{branches.size} branches: "
      branch_analysis = branches.map do |branch|
        print '.'
        unmerged = tracker.branch(branch).commits_since(reference_branch)
        behind = tracker.branch(reference_branch).commits_since(branch)
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
  end

end
