require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Site do
  before(:each) do
    DataMapper.auto_migrate!
  end
  
  describe "creation" do
    before(:each) do
      @site=Site.create :url=>"http://timecert.org",:title=>"TimeCert",:description=>"A timestamping service"
    end
    
    it "should be valid" do
      @site.should be_valid
    end
    
    it "should be saved" do
      @site.should_not be_new_record
    end
    
    it "should have url" do
      @site.url.should=="http://timecert.org"
    end
    
    it "should have a title" do
      @site.title.should=="TimeCert"
    end

    it "should have a description" do
      @site.description.should=="A timestamping service"
    end
    
    it "should have a created_at" do
      @site.created_at.should_not be_nil
    end
    
    describe "to_s" do
      it "should use title if available" do
        @site.to_s.should=="TimeCert"
      end

      it "should use url if title not available" do
        @site.title=nil
        @site.to_s.should=="http://timecert.org"
      end
    end
  end
  
  describe "validation" do
    before(:each) do
      @site=Site.new :url=>"http://timecert.org",:title=>"TimeCert",:description=>"A timestamping service"
    end
    
    it "should be valid" do
      @site.should be_valid
    end
    
    it "should require url" do
      @site.url=nil
      @site.should_not be_valid
    end
    
    it "should not require title" do
      @site.title=nil
      @site.should be_valid
    end
    
    it "should not require description" do
      @site.description=nil
      @site.should be_valid
    end
    
  end
end