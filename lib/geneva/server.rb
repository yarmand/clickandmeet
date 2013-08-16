class Geneva::Server
  attr_accessor :store, :rooms

  def initialize(opts={})
    @store = YAML::Store.new(opts.fetch(:store,'./geneva_store.yml'))
    @store.transaction do
      @store[:rooms] ||= opts.fetch(:rooms, {})
    end
  end

  def room(id)
    transaction do
      @store[:rooms][id]
    end
  end

  def create_room(title='', creation_date=Time.now)
    room = Geneva::Room.new(random_string, title, [], creation_date)
    add_room(room)
  end

  def add_room(r)
    transaction do
      @store[:rooms][r.id] = r
    end
  end

  def transaction(&block)
    @store.transaction(&block)
  end

  def random_string
    (0...20).map{ ('a'..'z').to_a[rand(26)] }.join
  end

end
