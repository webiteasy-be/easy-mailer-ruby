module EasyMailer
  class ApplicationController < EasyMailer.base_controller.constantize
    before_action :easy_mailer_enabled?

    layout 'easy_mailer/application'

    private

    def easy_mailer_enabled?
      EasyMailer.enabled || head(404, message: "EasyMailer disabled")
    end
  end
end
