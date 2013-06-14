require 'git'

module Git
  class Base
    def merge_base(commit1, commit2)
      self.lib.merge_base(commit1, commit2)
    end

    def log_ancestry(from, to)
      self.lib.log_ancestry(from, to)
    end
  end

  class Lib
    def merge_base(commit1, commit2)
      command('merge-base', [commit1, commit2])
    end

    def log_ancestry(from, to)
      arr_opts = ['--pretty=oneline']
      arr_opts << "#{from.to_s}..#{to.to_s}"
      arr_opts << '--ancestry-path'
      command_lines('log', arr_opts, true).map { |l| l.split.first }
    end
  end
end
