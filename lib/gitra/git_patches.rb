require 'git'

module Git
  class Base
    def merge_base(commit1, commit2)
      self.lib.merge_base(commit1, commit2)
    end

    def log_ancestry(from, to)
      self.lib.log_ancestry(from, to).map { |c| Git::Object::Commit.new(self, c['sha'], c) }
    end
  end

  class Lib
    def merge_base(commit1, commit2)
      command('merge-base', [commit1, commit2])
    end

    def log_ancestry(from, to)
      arr_opts = ['--pretty=raw']
      arr_opts << "#{from.to_s}..#{to.to_s}"
      arr_opts << '--ancestry-path'
      full_log = command_lines('log', arr_opts, true)
      process_commit_log_data(full_log)
    end
  end
end
