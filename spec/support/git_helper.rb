require 'git'
require 'fileutils'

class GitHelper

  def initialize
    path = File.join(Dir.tmpdir, "#{Time.now.to_i}_#{rand(1000)}")
    FileUtils.mkdir_p path
    Dir.chdir path do
      @git = Git.init
      @git.config('user.name', 'John Testable')
      @git.config('user.email', 'john.testable@testing.it')

      File.new(".gitignore", "w")
      @git.add(".gitignore")
      @git.commit "Initial commit."
    end
  end

  def path
    @git.dir.path
  end

  def cleanup
    FileUtils.rm_rf(path, :secure => true)
  end

  def commit_to(branch_sym, parent_sym = :master)
    branch = branch_sym.to_s
    parent = parent_sym.to_s

    @git.checkout parent
    @git.branch(branch).create
    @git.checkout branch
    file = File.new(File.join(path, "file_of_#{branch}"), "a+")
    file.puts("additional line")
    file.close
    @git.add file.path
    @git.commit "Update #{branch}"
    @git.checkout 'master'

    @git.object(branch).sha
  end

  def branch_off(branch_hash)
    branch_hash.collect do |branch_sym, into_sym|
      branch = branch_sym.to_s
      into = into_sym.to_s

      @git.checkout branch
      @git.branch(into).create
      @git.checkout 'master'

      @git.object(into).sha
    end
  end

  def merge(merge_hash)
    merge_hash.collect do |branch_sym, into_sym|
      branch = branch_sym.to_s
      into = into_sym.to_s

      @git.checkout into
      @git.merge branch, "Merge #{branch}"
      @git.checkout 'master'

      @git.object(into).sha
    end
  end

end
