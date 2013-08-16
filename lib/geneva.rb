require 'json'
module Geneva
  Room = Struct.new(:id,:title,:users,:creation_date)
end

require 'geneva/server'

