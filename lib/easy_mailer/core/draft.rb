module EasyMailer
  module Core
    class Draft
      attr_reader :model

      def initialize(model)
        @model = model
      end

      def params=(params)
        @params = params
      end

      def params(params=nil)
        return @params if params.nil?

        @params = params
        self
      end

      def to_mail
        args = []
        @model.parameters.each do |param|
          args << @params[param.last.to_s] if @params.has_key?(param.last.to_s)
        end

        args.map! { |a|
          begin
            JSON.parse(a)
          rescue => e
            a
          end
        }

        @model.generate_mail(*args)
      end
    end
  end
end