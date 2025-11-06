# lib/repository.rb
class Repository
  attr_reader :data

  def initialize
    @data = []
  end

  def add(item)
    @data << item
    save
    item
  end

  def all
    @data.dup
  end

  def find_by_id(id)
    @data.find { |item| item.id == id }
  end

  def find_all_by(attribute, value)
    @data.select { |item| item.send(attribute) == value }
  end

  def update(id, attributes)
    item = find_by_id(id)
    return false unless item

    attributes.each do |key, value|
      item.send("#{key}=", value) if item.respond_to?("#{key}=")
    end
    save
    true
  end

  def delete(id)
    @data.reject! { |item| item.id == id }
    save
  end

  def count
    @data.length
  end

  def next_id
    return 1 if @data.empty?
    @data.map(&:id).max + 1
  end

  protected

  def load_data
    raise NotImplementedError, "#{self.class} debe implementar load_data"
  end

  def save
    raise NotImplementedError, "#{self.class} debe implementar save"
  end
end