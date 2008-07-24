require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Referrer do
  before(:each) do
    DataMapper.auto_migrate!
    @stamp=Stamp.create :digest=>"a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"
  end
  
  describe "Creation" do
    before(:each) do
      @referrer=Referrer.create :stamp=>@stamp,:url=>"http://www.someapplication.com/article/1"
    end
    
    it "should be valid" do
      @referrer.should be_valid
    end
    
    it "should be saved" do
      @referrer.should_not be_new_record
    end
    
    it "should have the correct url" do
      @referrer.url.should=="http://www.someapplication.com/article/1"
    end
    
    it "should have a site_url" do
      @referrer.site_url.should=="http://www.someapplication.com"
    end
    
    it "should have a created_at" do
      @referrer.created_at.should_not be_nil
    end
    
    it "should have a stamp" do
      @referrer.stamp.should==@stamp
      @referrer.stamp.should be_is_a(Stamp)
    end
    
    it "should have a site" do
      @referrer.site.should_not be_nil
      @referrer.site.should be_is_a(Site)
      @referrer.site.url.should=="http://www.someapplication.com"
    end
    
    it "should have created only one site" do
      Site.count.should==1
    end
    
    describe "New referrer from same url" do
      before(:each) do
        @referrer=Referrer.create :stamp=>@stamp,:url=>"http://www.someapplication.com/article/1"
      end

      it "should be valid" do
        @referrer.should be_valid
      end

      it "should be saved" do
        @referrer.should_not be_new_record
      end
      
      it "should have the correct url" do
        @referrer.url.should=="http://www.someapplication.com/article/1"
      end

      it "should have a site_url" do
        @referrer.site_url.should=="http://www.someapplication.com"
      end

      it "should have a created_at" do
        @referrer.created_at.should_not be_nil
      end

      it "should have a stamp" do
        @referrer.stamp.should==@stamp
        @referrer.stamp.should be_is_a(Stamp)
      end

      it "should have a site" do
        @referrer.site.should_not be_nil
        @referrer.site.should be_is_a(Site)
        @referrer.site.url.should=="http://www.someapplication.com"
      end

      it "should have created only one site" do
        Site.count.should==1
      end
      
    end
    describe "New referrer from other url from same site" do
      before(:each) do
        @referrer=Referrer.create :stamp=>@stamp,:url=>"http://www.someapplication.com/article/2"
      end

      it "should be valid" do
        @referrer.should be_valid
      end

      it "should be saved" do
        @referrer.should_not be_new_record
      end
      
      it "should have the correct url" do
        @referrer.url.should=="http://www.someapplication.com/article/2"
      end

      it "should have a site_url" do
        @referrer.site_url.should=="http://www.someapplication.com"
      end

      it "should have a created_at" do
        @referrer.created_at.should_not be_nil
      end

      it "should have a stamp" do
        @referrer.stamp.should==@stamp
        @referrer.stamp.should be_is_a(Stamp)
      end

      it "should have a site" do
        @referrer.site.should_not be_nil
        @referrer.site.should be_is_a(Site)
        @referrer.site.url.should=="http://www.someapplication.com"
        @referrer.site.referrers.should include(@referrer)
      end

      it "should have created only one site" do
        Site.count.should==1
      end
      
    end

  end
  
  describe "Validation" do
    before(:each) do
      @referrer=Referrer.new :stamp=>@stamp,:url=>"http://www.someapplication.com/article/1"
    end
    
    it "should be valid" do
      @referrer.should be_valid
    end
    
    it "should require url" do
      @referrer.url=nil
      @referrer.should_not be_valid
    end

    
    it "should require stamp" do
      @referrer.stamp=nil
      @referrer.should_not be_valid
    end
    
  end

end