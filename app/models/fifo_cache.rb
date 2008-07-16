class FifoCache
  def initialize(size=1000,&block)
    @max_size=size
    @keys=[]
    @lookup={}
    @factory=block
  end
  
  def size
    @keys.size
  end
  
  def to_a
    @keys.clone
  end
  
  def empty?
    @keys.empty?
  end
  
  def [](key)
    @lookup[key]||self[key]=@factory.call(key)
  end
  
  def has_key?(key)
    @lookup.has_key?(key)
  end
  
  protected
  
  def []=(key,value)
    @lookup[key]=value
    self<<key
  end
  
  def <<(key)
    @keys<<key
    @lookup.delete(@keys.shift) if @keys.size>@max_size
  end
end