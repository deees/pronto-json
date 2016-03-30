require 'pronto'
require 'oj'

module Pronto
  module Json
    class Runner < Runner
      def run
        return [] unless @patches

        @patches
          .select { |patch| patch.delta.status != :deleted }
          .select { |patch| json_file?(patch.new_file_full_path) }
          .map { |patch| inspect(patch) }
      end

      def inspect(patch)
        begin
          Oj.load_file(patch.new_file_full_path.to_s)
        rescue Oj::ParseError => e
          error = oj_error(e)
        end

        return unless error

        candidate_lines = patch.lines.select { |line| line.addition? || line.deletion? }
        new_message(error[:reason], detect_line(candidate_lines, error[:line]))
      end

      def detect_line(candidate_lines, error_line_no)
        candidate_lines.sort do |x, y|
          sort_result = (line_number(x) - error_line_no).abs <=> (line_number(y) - error_line_no).abs
          if sort_result.zero? # prefer addition line
            sort_result = x.addition? ? -1 : 1
          end
          sort_result
        end.first
      end

      def new_message(error, line)
        path = line.patch.delta.new_file[:path]
        level = :error

        Message.new(path, line, level, error)
      end

      def json_file?(path)
        File.extname(path) == '.json'
      end

      def oj_error(error)
        # ... at line 38, column 1
        error_message = error.message
        if match = error_message.match(/at line (\d+), column (\d+)/i)
          line, _column = match.captures
        else
          line = 1
        end

        { line: line.to_i, reason: error_message }
      end

      def line_number(line)
        line.addition? ? line.new_lineno : line.old_lineno
      end
    end
  end
end
