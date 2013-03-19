require 'git'

module Git
  class Base
    def merge_base(commit1, commit2)
      self.lib.merge_base(commit1, commit2)
    end
  end

  class Lib
    def merge_base(commit1, commit2)
      command('merge-base', [commit1, commit2])
    end
  end
end
