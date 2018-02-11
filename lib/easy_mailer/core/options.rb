module EasyMailer
  module Core
    class Options < Hash

      # returns a hash shared between the Option class and all its children classes
      # this hash contains the values with the lowest priority
      #
      # == example
      #
      # class OptionsA < Options
      # end
      #
      def self.shared
        @@shared ||= {
            message_record: EasyMailer::MailModel,
            mailer: proc { |mail| mail.model.mailer_name },
            model: proc { |mail| mail.model.name }
        }
      end

      def self.shared=(options)
        self.shared.merge! options
      end

      class << self

        # returns the default set of values, shared with the current class and all its instances
        def default
          if self.class == EasyMailer::Core::Options
            shared
          else
            @default ||= Hash.new
          end
        end

        # Set the default set of values, shared with the current class and all its instances
        def default=(options)
          self.default.merge!(options)
        end

        # Defines class accessors, instance accessors and default values for the current class
        #
        # == Exampcd le
        #
        # class OptionsA < Options
        #   opt_accessors opt_1: 'OptionsA.opt_1'
        # end
        #
        # OptionsA.opt_1        # => "OptionsA.opt1"
        # t = OptionsA.new.opt_1    # => "OptionsA.opt1"
        # t.opt_1 = 'optionsA.opt_1'
        # OptionsA.opt_1        # => "OptionsA.opt1"
        # t.opt_1    # => "optionsA.opt_1"
        def opt_accessor(options={})
          self.default.merge!(options)

          # Define class and instance accessors for every keys
          options.each do |k, _|

            # Init default global attr and value
            define_singleton_method k.to_sym do
              self[k.to_sym]
            end

            define_singleton_method "#{k}=".to_sym do |c_v|
              self[k.to_sym] = c_v
            end

            # Define instance method
            define_method k.to_sym do
              self[k.to_sym]
            end

            define_method "#{k}=".to_sym do |i_v|
              self[k.to_sym] = i_v
            end
          end
        end

        def []=(k,v)
          self.default[k.to_sym] = v
        end

        def [](k)
          self.default[k.to_sym]
        end

        def merge!(*args, &block)
          self.default.merge!(*args, &block)
        end

        def merge(*args, &block)
          self.default.merge(*args, &block)
        end
      end

      def [](k)
        has_key?(k) ?
            super :
            self.class.default[k]
      end

      def []=(k,v)
        super(k.to_sym, v)
      end

      def to_s
        self.merge({}).to_s
      end

      def inner_merge
        self.merge({})
      end

      def merge(*args, &block)
        if block
          self.class.shared.merge(self.class.default.merge(self)).merge(*args, &block)
        else
          self.class.shared.merge(self.class.default.merge(self)).merge(*args)
        end
      end

      def each(&block)
        if block
          self.class.shared.merge(self.class.default.merge(self)).each &block
        else
          self.class.shared.merge(self.class.default.merge(self)).each
        end
      end

      def initialize(options={})
        self.merge! options
      end
    end
  end
end