require 'yaml'

module Gitra
  class Parser
    def initialize(rule_file)
      rule_file ||= '.gitra-rules.yml'
      @rules = YAML.load_file(rule_file)

      @uses = {}
      @rules.each_pair do |name, patterns|
        @uses[name] = {}
        patterns.map! { |p| Regexp.new p }
      end
    end

    def use(commit)
      @rules.each_pair do |name, patterns|
        matches = patterns.collect { |p| p.match commit['message'] }
        matches.each do |m|
          next unless m
          (@uses[name][m[1].to_i] ||= []) << commit
        end
      end
    end

    def result
      @uses
    end
  end
end
