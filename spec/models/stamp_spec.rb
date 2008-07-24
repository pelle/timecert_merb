require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Stamp do
  before do
    DataMapper.auto_migrate!
    Stamp.clear_cache
  end
  
  it "should not have any stamps" do
    Stamp.count.should==0
  end
  
  describe "Validation" do
    it "should not be valid" do
      @stamp=Stamp.new
      @stamp.should_not be_valid
    end
    
    it "should be valid with key of correct length" do
      @stamp=Stamp.new :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
      @stamp.digest="a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
      @stamp.should be_valid
    end
    
    it "should be invalid with too long a digest" do
      @stamp=Stamp.new :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd31"
      @stamp.should_not be_valid
    end
    
    it "should be invalid with too short a digest" do
      @stamp=Stamp.new :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd"
      @stamp.should_not be_valid
    end
    
    it "should be invalid with too short a digest" do
      @stamp=Stamp.new :digest=>"abcdefghijklmnopqrstuvwxyz1234567890abcd"
      @stamp.should_not be_valid
    end
  end
  
  describe "Timestamping" do
    before(:each) do
      @stamp=Stamp.create :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
    end
    
    it "should have a timestamp" do
      @stamp.timestamp.should_not be_nil
    end
    
    it "should have a utc" do
      @stamp.utc.should_not be_nil
    end
    
    it "should have 1 timestamp" do
      Stamp.count.should==1
    end
    
  end
  
  describe "by_digest" do
    before(:each) do
      @stamp=Stamp.by_digest "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
    end
    
    it "should description" do
      @stamp.digest.should=="a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
    end
    
    it "should have a timestamp" do
      @stamp.created_at.should_not be_nil
    end
    
    it "should be saved" do
      @stamp.should_not be_new_record
    end
    
    it "should be valid" do
      @stamp.should be_valid
    end
    
    it "should not have any errors" do
      @stamp.errors.full_messages.should==[]
    end
    
    it "should find created stamp by digest" do
      Stamp.first.should==@stamp
    end
    
    it "should find created stamp by digest" do
      Stamp.first(:digest=>@stamp.digest).should==@stamp
    end
    
    it "should have 1 timestamp" do
      Stamp.count.should==1
    end
    
    describe "second time" do
      before(:each) do
        @stamp2=Stamp.by_digest "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
      end
      
      it "should be the same as previous" do
        @stamp2.should==@stamp
      end
      
      it "should description" do
        @stamp2.digest.should=="a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
      end
    
      it "should be saved" do
        @stamp.should_not be_new_record
      end

      it "should have a timestamp" do
        @stamp2.created_at.should_not be_nil
      end

      it "should have 1 timestamp" do
        Stamp.all.size.should==1
      end
    end
  end
  
  
  describe "Formats" do
    before(:each) do
      @stamp=Stamp.create :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
    end
    
    describe "yaml" do
      it "should parse the yaml" do
        YAML.load( @stamp.to_yaml).should=={:timestamp=>@stamp.utc.to_s,:digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"}
      end
    end
    
    describe "json" do
      it "should parse the json" do
        JSON.parse( @stamp.to_json).should=={'digest'=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",'timestamp'=>@stamp.utc.to_s}
      end
    end
    
  end
end