require 'sinatra'

class Sincapun < Sinatra::Base
  get '/' do
    "Hello world"
  end

  get '/:id' do |id|
    "Hello #{id}"
  end
end
