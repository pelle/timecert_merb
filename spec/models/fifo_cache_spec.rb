require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe FifoCache do
  before(:each) do
    @call_count=0
    @cache=FifoCache.new(4) do |key|
      @call_count+=1
      key*2
    end
  end
  
  it "should have been called 0 times" do
    @call_count.should==0
  end
  
  it "should have 0 size" do
    @cache.size.should==0
  end
  
  it "should be empty" do
    @cache.should be_empty
  end
  
  it "should not have a value" do
    @cache.has_key?(1).should==false
  end
  
  it "should have an empty array" do
    @cache.to_a.should==[]
  end
  
  describe "Single Entry" do
    before(:each) do
      @cache[1]
    end
    
    it "should have a call count of 1" do
      @call_count.should==1
    end
    
    it "should return value and not increase call count" do
      @cache[1].should==2
      @call_count.should==1
    end
    
    it "should have 1 item" do
      @cache.size.should==1
    end

    it "should not be empty" do
      @cache.should_not be_empty
    end
  
    it "should have a value" do
      @cache.has_key?(1).should==true
    end

    it "should have an array" do
      @cache.to_a.should==[1]
    end

  end

  describe "Full" do
    before(:each) do
      (1..4).each{|i| @cache[i]}
    end
    
    it "should have a call count of 4" do
      @call_count.should==4
    end
    
    it "should return value and not increase call count" do
      @cache[4].should==8
      @call_count.should==4
    end
    
    it "should have 4 item" do
      @cache.size.should==4
    end

    it "should not be empty" do
      @cache.should_not be_empty
    end
  
    it "should have a value" do
      @cache.has_key?(1).should==true
    end

    it "should have an  array" do
      @cache.to_a.should==[1,2,3,4]
    end
    
    describe "Expire a value" do
      before(:each) do
        @cache[10]
      end
      
      it "should have a call count of 4" do
        @call_count.should==5
      end

      it "should return value and not increase call count" do
        @cache[10].should==20
        @call_count.should==5
      end
      
      it "should return an increased value and increase call count" do
        @cache[1].should==2
        @call_count.should==6
      end
      
      it "should have 4 item" do
        @cache.size.should==4
      end

      it "should not be empty" do
        @cache.should_not be_empty
      end

      it "should not contain expired value" do
        @cache.has_key?(1).should==false
      end

      it "should have a value" do
        @cache.has_key?(10).should==true
      end

      it "should have an array" do
        @cache.to_a.should==[2,3,4,10]
      end
    end
  end
end