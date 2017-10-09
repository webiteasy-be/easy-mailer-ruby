module EasyMailer
  module Tracker
    module Configurator

      class << self
        def validate_global_options
          errors = []

          if EasyMailer::Tracker.options[:user].nil?
            # it's ok !
          elsif EasyMailer::Tracker.options[:user].respond_to? :call
            begin
              mailer = ::EasyMailer::ApplicationMailer.new

              mail = ::Mail.new do
                to 'mikel@test.lindsaar.net'
                from 'bob@test.lindsaar.net'
                subject 'This is an email'
                body 'This is the body'
              end

              EasyMailer::Tracker.options[:user].call(mail, mailer)
            rescue => e
              case e
                when NameError
                  errors << "Tracker.options[:user] raised '#{e}', this is usually because option[:user] is not properly set with a real User model"
                else
                  # TODO errors when table, database or "email" attribute doesn't exist
                  errors << "Something went wrong with Tracker.options[:user] call : #{e}"
              end
            end
          elsif !EasyMailer::Tracker.options[:user].is_a?(ActiveRecord::Base)
            errors << "Tracker.options[:user] must be a callable or an Active Record"
          end

          errors
        end

        def validate_db
          errors = []
          warnings = []
          success = []
          begin
            # Next call will raise error if no DB, no table, ...
            columns = EasyMailer.mail_model.columns_hash

            if EasyMailer.mail_model.primary_key.nil?
              errors << "A primary key is required to be able to track messages !"
            end
            # TODO check in column if every column accepts null + check type


            ## attribute open_at
            if !columns.has_key?('opened_at')
              if EasyMailer::Tracker.options[:open]
                errors << "missing attribute opened_at in the table #{EasyMailer.mail_model.table_name}."
              else
                warnings << "No opened_at attribute in the table #{EasyMailer.mail_model.table_name}. Openings will not be tracked"
              end
            elsif columns['opened_at']
              unless columns['opened_at'].null
                errors << "attribute opened_at should be nullable."
              end

              if columns['opened_at'].type != :datetime
                errors << "attribute `opened_at` should be of type `datetime`. Type `#{columns['opened_at']}` found"
              end
            end

            if !columns.has_key?('clicked_at')
              if EasyMailer::Tracker.options[:click]
                errors << "missing attribute `clicked_at` in the table #{EasyMailer.mail_model.table_name}."
              else
                warnings << "No `clicked_at` attribute in the table #{EasyMailer.mail_model.table_name}. Clicks will not be tracked"
              end
            elsif columns['clicked_at']
              unless columns['clicked_at'].null
                errors << "attribute `clicked_at` should be nullable."
              end

              if columns['clicked_at'].type != :datetime
                errors << "attribute `clicked_at` should be of type `datetime`. Type `#{columns['clicked_at']}` found"
              end
            end

            # TODO check, if has token, token length
            #unless columns.has_key?('token')
            #  errors << "missing attribute token in the table #{EasyMailer.mail_model.table_name}. This field should be at least #{EasyMailer::Tracker::MailProcessor::TOKEN_LENGTH} length"
            #end

            if reflection = EasyMailer.mail_model.reflections['user']
              # TODO check attribute type
              unless EasyMailer.mail_model.has_attribute?(reflection.foreign_key)
                errors << "Missing #{reflection.foreign_key} attribute in table #{EasyMailer.mail_model.table_name}"
              end

              # TODO check attribute type
              if reflection.options[:polymorphic] && !EasyMailer.mail_model.has_attribute?(reflection.foreign_type)
                errors << "Missing #{reflection.foreign_type} attribute in table #{EasyMailer.mail_model.table_name}"
              end
            else
              errors << "Missing user relation in #{EasyMailer.mail_model.class.name}"
            end

          rescue => e
            if e.is_a?(ActiveRecord::NoDatabaseError)
              errors << "Missing database #{Rails.configuration.database_configuration[Rails.env]['database']}"
            elsif e.is_a?(ActiveRecord::StatementInvalid) && /Table '.*' doesn't exist/.match?(e.to_s)
              errors << "Missing table #{EasyMailer.mail_model.table_name}"
            elsif e.is_a?(ActiveRecord::ActiveRecordError)
              errors << "Something went wrong with database : #{e}"
            else
              errors << "Something went wrong : #{e}"
            end
          end
          errors
        end
      end

    end
  end
end