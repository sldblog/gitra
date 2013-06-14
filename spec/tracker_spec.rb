require 'minitest_helper'
require 'git'

describe Gitra::Tracker do
  let(:git) { GitHelper.new }
  let(:tracker) { Gitra::Tracker.new(git.path) }

  after do
    git.cleanup
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
      tracker.branch(:master).commits_since(:release).must_equal after_branch_off_commits
    end

    it 'should fail if "since" branch is not resolvable' do
      proc { tracker.branch(:master).commits_since(:new_branch) }.must_raise Git::GitExecuteError
    end
  end

  describe 'Shows unmerged commits between two branches' do
    it 'should contain all unmerged commits' do
      git.commit_to :master
      git.branch_off :master => :release
      missing_commit = git.commit_to :release

      tracker.branch(:master).missing_commits_from(:release).must_equal [missing_commit]
    end

    it 'should fail if reference is not resolvable' do
      proc { tracker.branch(:master).missing_commits_from(:neverwhere) }.must_raise Git::GitExecuteError
    end
  end

end
