# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra'
require 'yaml'
require 'yaml/store'
require 'json'

$:.unshift File.expand_path('../..',__FILE__)
require 'geneva'
CONF='geneva_conf.yml'

set :port, 8090

get '/' do
  "store=#{geneva.store}"
  erb :index
end

get '/new_room' do
  room = geneva.create_room(params[:title])
  @url="skype:#{room.id}?meetandclick&server=#{server_uri}"
  erb :new_room
end

get %r{/connect/(.*)} do |token|
  room = geneva.room(token)
  host=conf['default_host']
  result = {
    :uri => "skype:#{host}?call&token=#{room.id}",
    :room => room.to_h.to_json
  }
  content_type :json
  result.to_json
end

private
def server_uri
  request.env['HTTP_HOST']
end

def conf
  @conf ||=YAML.load_file(CONF)
end

def geneva(store=conf['store'])
  @geneva ||= Geneva::Server.new({:store => store})
end


