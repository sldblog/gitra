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

      new_commits = []
      new_commits << git.commit_to(:master)
      new_commits << git.commit_to(:master)

      tracker.commits_on(:master, :since => :release).must_equal new_commits
    end

    it 'should fail if :since is not resolvable' do
      proc { tracker.commits_on(:master, :since => :new_branch) }.must_raise Git::GitExecuteError
    end

    it 'should fail if :since is not given' do
      proc { tracker.commits_on(:master) }.must_raise Git::GitExecuteError
    end
  end

  describe 'Shows unmerged commits on "completed" branches' do
    it 'should contain all unmerged commits' do
      git.commit_to :master
      git.branch_off :master => :release
      git.commit_to :release
      git.commit_to :master
      git.merge :release => :master
      git.commit_to :master
      missing_commit = git.commit_to :release

      tracker.missing_on(:master, :from => :release).must_equal [missing_commit]
    end

    it 'should fail if :from is not resolvable' do
      proc { tracker.missing_on(:master, :from => :neverwhere) }.must_raise Git::GitExecuteError
    end

    it 'should fail if :from is not given' do
      proc { tracker.missing_on(:master) }.must_raise Git::GitExecuteError
    end
  end

end
