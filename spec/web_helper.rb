require 'spec_helper'
require 'rack/test'

module RequestHelpers
  def app
    GameOnAuth::Web.app
  end

  def post_json(path, data, headers: {})
    post path, data.to_json, 'CONTENT_TYPE' => 'application/json', **headers
  end

  def parsed_body
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/requests/}) do |metadata|
    metadata[:request] = true
  end

  config.include Rack::Test::Methods, request: true
  config.include RequestHelpers, request: true
end
