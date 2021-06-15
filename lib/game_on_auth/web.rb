module GameOnAuth
  module Web
    def self.app
      Rack::Builder.new do
        run GameOnAuth::Web::Router
      end
    end
  end
end
