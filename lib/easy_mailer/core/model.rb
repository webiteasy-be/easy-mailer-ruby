module EasyMailer
  module Core
    class Model

      attr_reader :name, :mailer_name, :mailer, :parameters

      def initialize(mailer, name, parameters)
        @parameters = parameters
        @name = name.to_s
        @mailer = mailer
        @mailer_name = mailer.name
      end

      def self.find_or_initialize(action_mailer)
        mailer_name = action_mailer.class.name.to_s.underscore

        mailer = Mailer.find(mailer_name) || EasyMailer::Core::Mailer.new(action_mailer.class)

        mailer.find_model(action_mailer.action_name) || raise( "Unknown model #{action_mailer.action_name} for mailer #{mailer_name}" )
      end

      def options_for(feature)
        @mailer.options_for(feature)
      end

      def all_parameters(prefix=nil)
        parameters.map{|p| (prefix ? prefix : '') + p.last.to_s }
      end

      def template(part = nil)
        File.read(_template_path(part))
      end

      def update_template(new_content, part = nil)
        File.open(_template_path(part), 'w') do |f|
          f.write(new_content)
        end
      end

      def generate_mail(*args)
        @mailer.mail(@name, *args)
      end

      private
      def _template_path(part=nil)
        if part.nil?
          path = _template_path('html')

          File.exist?(path) ? path : _template_path('text')
        else
          if self.template_dir.start_with?('/')
            "#{self.template_dir}/#{self.name}.#{part}.erb"
          else
            "#{Rails.root}/app/views/#{self.template_dir}/#{self.name}.#{part}.erb"
          end
        end
      end
    end
  end
end