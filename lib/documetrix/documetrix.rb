require_relative "store"

module Documetrix
  class Documetrix
      RDoc::RDoc.add_generator self

      ##
      # Description of this generator

      DESCRIPTION = 'creates report on documentation coverage'

      def initialize options
        @options     = options
        @old_siginfo = nil
        @current     = nil

        @store          = Store.new
        @store.dry_run  = @options.dry_run
        @store.encoding = @options.encoding if @options.respond_to? :encoding
      end

      def generate top_levels
        install_siginfo_handler

        RDoc::TopLevel.all_classes_and_modules.each do |klass|
          @current = "#{klass.class}: #{klass.full_name}"

          @store.save_class klass
        end

        @current = 'saving cache'

        @store.save_cache

      ensure
        @current = nil

        remove_siginfo_handler
      end

      ##
      # Installs a siginfo handler that prints the current filename.

      def install_siginfo_handler
        return unless Signal.list.key? 'INFO'

        @old_siginfo = trap 'INFO' do
          puts @current if @current
        end
      end

      ##
      # Removes a siginfo handler and replaces the previous

      def remove_siginfo_handler
        return unless Signal.list.key? 'INFO'

        handler = @old_siginfo || 'DEFAULT'

        trap 'INFO', handler
      end

  end
end
