require 'minitest_helper'
require 'git'

describe Gitra::Tracker do
  let(:git) { GitHelper.new }
  let(:tracker) { Gitra::Tracker.new(git.path) }

  after do
    git.cleanup
  end

  describe 'Selects branches' do
    it 'should list all branches without block' do
      git.commit_to :b1
      git.commit_to :b2
      tracker.branches.sort.must_equal %w{master b1 b2}.sort
    end

    it 'should list matching branches with block' do
      git.commit_to :b1
      git.commit_to :b2
      tracker.branches { |name| name =~ /^b/ }.sort.must_equal %w{b1 b2}.sort
    end
  end

  describe 'Shows commits from merge base' do
    it 'should contain all commits from branching point' do
      git.commit_to :master
      git.branch_off :master => :release
      git.commit_to :release
      after_branch_off_commits = [
          git.commit_to(:master),
          git.commit_to(:master)
      ]
      tracker.branch(:master).commits_since(:release).map { |c| c['sha'] }.must_equal after_branch_off_commits
    end

    it 'should only contain commits with real ancestry' do
      git.commit_to :master
      git.branch_off :master => :release
      2.times { git.commit_to :release }
      2.times { git.commit_to :master }

      only_on_master = []
      only_on_master += git.merge(:release => :master)
      only_on_master << git.commit_to(:master)
      git.commit_to :release

      tracker.branch(:master).commits_since(:release).map { |c| c['sha'] }.must_equal only_on_master
    end

    it 'should be able to show more than the default log limit (30)' do
      git.commit_to :master
      git.branch_off :master => :release

      limit = 40
      limit.times { git.commit_to :release }
      tracker.branch(:release).commits_since(:master).size.must_equal limit
    end

    it 'should fail if "since" branch is not resolvable' do
      proc { tracker.branch(:master).commits_since(:new_branch) }.must_raise Git::GitExecuteError
    end

    it 'should fail if "from" branch is not resolvable' do
      proc { tracker.branch(:neverwhere).commits_since(:master) }.must_raise Git::GitExecuteError
    end
  end

  describe 'Shows unmerged commits between two branches' do
    it 'should contain all unmerged commits' do
      git.commit_to :master
      git.branch_off :master => :release
      missing_commit = git.commit_to :release

      tracker.branch(:release).commits_since(:master).map { |c| c['sha'] }.must_equal [missing_commit]
    end
  end

end
