module Documetrix
  class Store

    ##
    # If true this Store will not do anything

    attr_accessor :dry_run

    ##
    # The encoding of the contents in the Store

    attr_accessor :encoding

    ##
    # The contents of the Store

    attr_reader :cache

    def initialize
      @dry_run  = false
      @encoding = nil

      @cache = {
        :attributes       => {},
        :class_methods    => {},
        :instance_methods => {},
        :modules          => {},
      }
    end


    def save_class klass
      full_name = klass.full_name

      @cache[:modules][full_name] ||= 0
      @cache[:modules][full_name] += comment_word_count(klass.comment)

      @cache[:attributes][full_name] ||= {}

      klass.attributes.each do |attribute|
        @cache[:attributes][full_name][attribute.name] ||= 0
        @cache[:attributes][full_name][attribute.name] += comment_word_count(attribute.comment)
      end

      unless klass.method_list.empty?
        @cache[:class_methods][full_name]    ||= {}
        @cache[:instance_methods][full_name] ||= {}

        class_methods, instance_methods =
          klass.method_list.partition { |meth| meth.singleton }

        class_methods.each do |class_method|
          @cache[:class_methods][full_name][class_method.name] ||= 0
          @cache[:class_methods][full_name][class_method.name] += comment_word_count(class_method.comment)
        end

        instance_methods.each do |instance_method|
          @cache[:instance_methods][full_name][instance_method.name] ||= 0
          @cache[:instance_methods][full_name][instance_method.name] += comment_word_count(instance_method.comment)
        end
      end
    end

    ##
    # Gets naive comment word count

    def comment_word_count comment
      comment = comment.text unless comment.is_a?(String)
      comment.split(/\s+/).length
    end

    ##
    # Writes the cache file for this store

    def save_cache
      return if @dry_run

      print_cache
    end

    def print_cache
      File.open "./coverage_report.txt", 'wb' do |file|
        @cache[:modules].each do |klass, wcount|
          file.write "#{klass}: #{wcount}\n"
          if @cache[:attributes][klass] && !@cache[:attributes][klass].empty?
            file.write "Attributes\n"
            @cache[:attributes][klass].each do |attr, wcount|
              file.write "  #{attr}: #{wcount}\n"
            end
          end

          if @cache[:instance_methods][klass] && !@cache[:instance_methods][klass].empty?
            file.write "Instance Methods\n"
            @cache[:instance_methods][klass].each do |imeth, wcount|
              file.write "  #{imeth}: #{wcount}\n"
            end
          end

          if @cache[:class_methods][klass] && !@cache[:class_methods][klass].empty?
            file.write "Class Methods\n"
            @cache[:class_methods][klass].each do |cmeth, wcount|
              file.write "  #{cmeth}: #{wcount}\n"
            end
          end

          file.write "\r"
        end
      end
    end

  end
end