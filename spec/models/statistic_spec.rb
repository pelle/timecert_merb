require File.join( File.dirname(__FILE__), "..", "spec_helper" )
require 'digest/sha1'
describe Statistic do
  before(:each) do
    DataMapper.auto_migrate!
  end
  
  describe "creation" do
    before(:each) do
      @statistic=Statistic.create :date=>DateTime.parse("2008-07-23"),:digests=>5,:requests=>20,:referrers=>10,:sites=>2
    end
    
    it "should be valid" do
      @statistic.should be_valid
    end
    
    it "should be saved" do
      @statistic.should_not be_new_record
    end
        
    it "should have a date" do
      @statistic.date.to_s.should=="2008-07-23T00:00:00+00:00"
    end

    it "should have a digest count" do
      @statistic.digests.should==5
    end

    it "should have a requests count" do
      @statistic.requests.should==20
    end
    
    it "should have a ratio" do
      @statistic.ratio.should=="0.2500"
    end

    it "should have a referrers count" do
      @statistic.referrers.should==10
    end

    it "should have a sites count" do
      @statistic.sites.should==2
    end
    
  end
  
  describe "update_stats" do
    
    def create_entry(options={})
      options={:url=>"http://myblog.com/page/1",:date=>DateTime.now}.merge(options)
      stamp=Stamp.create(:digest=>Digest::SHA1.hexdigest(options[:url]))
      stamp.created_at=options[:date]
      stamp.save
      
      options[:url]=~/((\w+:\/*)((\w+\-+)|(\w+\.))*\w{1,63}\.[0-9a-zA-Z]{1,6})/i
      site_url=$1.downcase if $1
      
      site=Site.first_or_create(:url=>site_url)
      site.created_at=options[:date]
      site.save
      
      ref=stamp.record_referrer(options[:url])
      ref.created_at=options[:date]
      ref.save
      stamp
    end
    
    def clear_and_update_stats
      Statistic.all.each{|s|s.destroy!} # How the hell do you do delete_all in DM?
      Statistic.update_stats
    end
    
    describe "no data" do
      before(:each) do
        clear_and_update_stats        
      end
      
      it "should have no entries" do
        Statistic.count.should==0
      end
    end

    describe "Should ignore todays date" do
      before(:each) do
        create_entry
        clear_and_update_stats        
      end
      
      it "should have no entries" do
        Statistic.count.should==0
      end
    end
    
    describe "Single entry other day" do
      before(:each) do
        @date=2.days.ago
        @stamp=create_entry(:date=>@date)
        clear_and_update_stats        
        @statistic=Statistic.first
      end
      
      it "should have correct base data" do
        Stamp.count.should==1
        Stamp.first.created_at.yday.should===@date.yday
        Referrer.count.should==1
        Referrer.first.created_at.yday.should==@date.yday
        Site.count.should==1
        Site.first.created_at.yday.should==@date.yday
      end
      
      it "should have 1 entry" do
        Statistic.count.should==1
      end
      
      it "should have a digest count" do
        @statistic.digests.should==1
      end

      it "should have a requests count" do
        @statistic.requests.should==1
      end

      it "should have a ratio" do
        @statistic.ratio.should=="1.0000"
      end

      it "should have a referrers count" do
        @statistic.referrers.should==1
      end

      it "should have a sites count" do
        @statistic.sites.should==1
      end
      
    end
    
  end
  
end