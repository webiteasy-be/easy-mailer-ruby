EasyMailer.setup do |config|

  # Enable and setup default options for Tracker
  config.tracker.setup do |tracker_config|

    # Host used to build URL's to track clicks and opens. This value
    # is required unless you use Rails and you already set
    # Rails.configuration.action_mailer.default_url_options.host
    #
    # tracker_config.host = "http://tracker.example.com/"

  end

  # Enable and setup default options for Viewer
  config.viewer.setup do |viewer_config|

    viewer_config.adapter = :files, { mail_dir: Rails.root.join('tmp', 'mails') }

  end

end