require 'mail/files_mailer'
require 'easy_mailer/rails/action_mailer'

module EasyMailer
  class Engine < ::Rails::Engine
    isolate_namespace EasyMailer

    initializer "include.files_mailer" do |app|
      ::ActionMailer::Base.add_delivery_method :files, ::Mail::FilesMailer,
                                               dir: defined?(Rails.root) ? "#{Rails.root}/tmp/mails" : "#{Dir.tmpdir}/mails"
    end

    initializer "easy_mailer.configure_action_mailer" do |app|
      ::ActionMailer::Base.send :include, EasyMailer::ActionMailer

      # Load mailers from file system
      Dir[Rails.root.join('app', 'mailers', '*.rb')].each do |mailer|
        klass_name = File.basename(mailer, '.rb')
        klass = klass_name.camelize.constantize

        EasyMailer::Core::Mailer.add(EasyMailer::Core::Mailer.new(klass))
      end
    end
  end
end
