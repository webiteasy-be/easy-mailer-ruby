module EasyMailer
  module Core
    class OptionsHolder
      # Returns a options Hash for the given EasyMailer feature. If no feature is provided,
      # global options are provided.
      def options_for(feature=nil)
        feature ? global_options.merge(feature_options(feature).inner_merge) : global_options.dup
      end

      def feature_options(feature)
        raise "Feature #{feature} not enabled" unless EasyMailer.feature_enabled?(feature)

        features_options[feature] ||= default_feature_options(feature)
      end

      def features_options
        @features_options ||= {}
      end

      def global_options
        @global_options ||= EasyMailer::Core::Options.new
      end

      def merge(options_holder)
        out = OptionsHolder.new

        out.global_options.merge!(self.global_options).merge!(options_holder.global_options)
        # TODO remore rails deep_merge
        out.features_options.deep_merge!(self.features_options).deep_merge!(options_holder.features_options)

        out
      end

      private
      def default_feature_options(feature)
        # TODO do not use Rails humanize and constantize
        "EasyMailer::#{feature.to_s.humanize}::Options".constantize.new
      end
    end
  end
end
