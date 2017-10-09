module EasyMailer
  module Core
    class Mailer
      @@collection = []

      attr_reader :models, :name

      def initialize(active_mailer_klass)
        @active_mailer_klass_name = active_mailer_klass.name
        @name = active_mailer_klass.name.to_s.underscore
        @models = active_mailer_klass.send(:public_instance_methods, false).map {
            |model_name|
          EasyMailer::Core::Model.new(self, model_name, active_mailer_klass.instance_method(model_name).parameters)
        }
      end

      def draft_for(model_name)
        model = find_model(model_name)

        EasyMailer::Core::Draft.new(model) if model
      end

      def find_model(model_name)
        @models.find { |model| model.name == model_name}
      end

      def mail(model_name, *args)
        if args.length == 0
          active_mailer_klass.public_send(model_name)
        else
          active_mailer_klass.public_send(model_name, *args)
        end
      end

      def options_for(feature)
        active_mailer_klass.public_send(:options_for, feature)
      end

      def self.all
        @@collection
      end

      def self.add(mailer)
        self.all <<(mailer)
      end

      def self.find(mailer_name)
        all.find { |mailer| mailer.name == mailer_name }
      end

      def self.remove(mailer_name)
        all.reject!{ |mailer| mailer.name == mailer_name }
      end

      private
      def active_mailer_klass
        # From active_support/dependencies.rb :
        #
        #unless qualified_const_defined?(@active_mailer_klass.name) && Inflector.constantize(@active_mailer_klass.name).equal?(@active_mailer_klass)
        #  raise ArgumentError, "A copy of #{from_mod} has been removed from the module tree but is still active!"
        #end

        # see Inflector.constantize(@active_mailer_klass.name).equal?(@active_mailer_klass)

        @active_mailer_klass_name.constantize
      end
    end
  end
end