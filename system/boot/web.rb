GameOnAuth::Application.boot(:web) do
  init do
    require 'roda'
    require 'mail'

    Mail.defaults do
      delivery_method :smtp, address: 'mailcatcher', port: 1025
    end
  end
end
