module EasyMailer
  class ViewerController < EasyMailer::ApplicationController

    before_action :require_module_loaded

    def index
      @mails = EasyMailer::Viewer.adapter.where
    end

    def show
      @mail = EasyMailer::Viewer.adapter.find(params[:mail_id])
    end

    def raw
      @mail = EasyMailer::Viewer.adapter.find(params[:mail_id])

      if params[:part] == 'text'
        render plain: @mail.text_part ? @mail.text_part.body.to_s.html_safe : @mail.body.to_s.html_safe, layout: nil
      else
        render html: @mail.html_part ? @mail.html_part.body.to_s.html_safe : @mail.body.to_s.html_safe, layout: nil
      end
    end

    private
    def require_module_loaded
      render plain: 'Viewer module not setup', status: :internal_server_error unless EasyMailer.feature_enabled?(:viewer)
    end
  end
end
