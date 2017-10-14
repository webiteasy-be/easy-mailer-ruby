module EasyMailer
  # TODO check locale
  class SubscriberController < EasyMailer::ApplicationController

    def index
      @subscriptions_hash = EasyMailer::Subscriber::Options.adapter.subscriptions_hash
      @subscriptions_array = EasyMailer::Subscriber::Options.adapter.subscriptions_array
      @bounces_hash = EasyMailer::Subscriber::Options.adapter.bounces_hash
    end

    def model_index
      @subscriptions_hash = EasyMailer::Subscriber::Options.adapter.subscriptions_hash(params.permit(:mailer, :model))
      @subscriptions_array = EasyMailer::Subscriber::Options.adapter.subscriptions_array(params.permit(:mailer, :model))
      @bounces_hash = EasyMailer::Subscriber::Options.adapter.bounces_hash(params.permit(:mailer, :model))

      render 'index'
    end

    def unsubscribe
      if ['yes', '1', 'true', 't', 'y'].include?(params[:confirm])
        @success = EasyMailer::Subscriber::Options.adapter.unsubscribe(params.permit(:email, :mailer, :model, :message_id))
      end

      render layout: 'easy_mailer/empty'
    end

    def subscribe
      if ['yes', '1', 'true', 't', 'y'].include?(params[:confirm])
        @success = EasyMailer::Subscriber::Options.adapter.subscribe(params.permit(:email, :mailer, :model))
      end

      render layout: 'easy_mailer/empty'
    end
  end
end
