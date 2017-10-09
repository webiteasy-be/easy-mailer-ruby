module EasyMailer
  # TODO check locale
  class PreviewerController < EasyMailer::ApplicationController
    before_action :allowed_action?, only: [:edit, :update, :deliver]
    before_action :load_draft, except: [:index]
    before_action :load_email, only: [:raw, :attachment, :deliver]
    around_action :perform_with_locale, only: [:show, :raw, :deliver]

    def index
    end

    def show
      begin
        @email = @draft.params(params).to_mail

        if @email.nil? || @email.to_s.start_with?('#<ActionMailer::Base::NullMail')
          @email = StandardError.new("no email generated for these parameters")
        end
      rescue => e
        @email = e
      end
    end

    def raw
      content = if @email.parts.present?
        params[:part] == 'text' ? @email.text_part.body : @email.html_part.body
      else
        @email.body
      end

      if params[:part] == 'text'
        render plain: content.raw_source, layout: false
      else
        render html: content.raw_source, layout: false
      end
    end

    def attachment
      attachment = @email.attachments.find { |elem| elem.filename == params[:attachment] }

      send_data attachment.body, filename: attachment.filename, type: attachment.content_type
    end

    def edit
      @template = @draft.template(params[:part])
    end

    def update
      @draft.update_template(params[:body], params[:part])

      redirect_to easy_draft_path(
                      params.permit(
                          [:mailer, :model, :part] +
                              @draft.all_parameters(EasyMailer.mailer_args_prefix)
                      ))
    end

    def deliver
      @email.to = params[:to] if params[:to].present?

      @email.deliver

      redirect_to easy_view_model_url(mailer: params[:mailer], model: params[:model])
    end

    private

    def allowed_action?
      EasyMailer.public_send("allow_#{action_name}") || redirect_to(root_path, alert: "EasyMailer: action #{action_name} not allowed!")
    end

    def load_draft
      mailer = EasyMailer::Core::Mailer.find(params[:mailer])
      @draft = mailer.draft_for(params[:model])
    end

    def load_email
      @email = @draft.params(params).to_mail
    end

    def perform_with_locale
      I18n.with_locale(params[:locale]) do
        yield
      end
    end
  end
end
