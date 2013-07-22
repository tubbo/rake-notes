require 'rake'
require 'rake/tasklib'

require 'rake/notes/source_annotation_extractor'

module Rake
  module Notes
    class Task < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      def initialize(*args)
        yield self if block_given?

        options = args.first || {}

        desc "Enumerate all annotations (use notes:optimize, :fixme, :todo for focus)"
        task :notes do
          options[:tag] = true
          SourceAnnotationExtractor.enumerate "OPTIMIZE|FIXME|TODO", options
        end

        namespace :notes do
          %w(OPTIMIZE FIXME TODO).each do |annotation|
            desc "Enumerate all #{annotation} annotations"
            task annotation.downcase.intern do
              SourceAnnotationExtractor.enumerate annotation, options
            end
          end

          desc "Enumerate a custom annotation, specify with ANNOTATION=CUSTOM"
          task :custom do
            SourceAnnotationExtractor.enumerate ENV['ANNOTATION'], options
          end
        end
      end
    end
  end
end


