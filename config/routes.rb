EasyMailer::Engine.routes.draw do
  root  :to => 'previewer#index'

  get   'previewer/'                                  => 'previewer#index',           as: :easy_previewer
  get   'previewer/:mailer/:model'                    => 'previewer#show',            as: :easy_draft
  get   'previewer/:mailer/:model/attachment'         => 'previewer#attachment',      as: :easy_draft_attachment
  get   'previewer/:mailer/:model/raw'                => 'previewer#raw',             as: :easy_raw_draft
  get   'previewer/:mailer/:model/edit'               => 'previewer#edit',            as: :easy_edit_template
  patch 'previewer/:mailer/:model'                    => 'previewer#update',          as: :easy_update_template
  post  'previewer/:mailer/:model/deliver'            => 'previewer#deliver',         as: :easy_deliver_draft

  ##### SUBSCRIBER
  get   'subscriber'                                  => 'subscriber#index',          as: :easy_subscriber
  get   'subscriber/:mailer/:model'                   => 'subscriber#model_index',    as: :easy_model_subscriber
  get   'subscriber/:mailer/:model/unsubscribe'       => 'subscriber#unsubscribe',    as: :easy_model_unsubscribe
  get   'subscriber/:mailer/:model/subscribe'         => 'subscriber#subscribe',      as: :easy_model_subscribe

  get   'viewer'                                      => 'viewer#index',              as: :easy_viewer
  get   'viewer/:mail_id'                             => 'viewer#show',               as: :easy_view_mail
  # TODO with this route, "raw" model is not allowed
  get   'viewer/:mail_id/raw'                         => 'viewer#raw',                as: :easy_raw_mail
  get   'viewer/:mailer/:model'                       => 'viewer#index',              as: :easy_view_model

  get   'tracker'                                     => 'tracker#index',             as: :easy_tracker
  get   'tracker/:mail_id'                            => 'tracker#show',              as: :easy_track_mail
  # TODO with this route, "OPEN" and "LINK" model is not allowed
  get   'tracker/:mail_id/open'                       => 'tracker#open',              as: :easy_email_open
  get   'tracker/:mail_id/link/'                      => 'tracker#link',              as: :easy_email_link,
        :constraints                                  => { :url => /[.]+/ }
  get   'tracker/:mailer/:model'                      => 'tracker#track_model',       as: :easy_track_model
end
