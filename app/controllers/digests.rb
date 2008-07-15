class Digests < Application
  def generate
    @body=request.raw_post
    render
  end
  
  def digest
    @data=params[:body]||request.raw_post
    if @data && @data!=""
      redirect "/#{Digest::SHA1.hexdigest @data}"
    else
      throw :halt, [ 500, "No data to digest"]
    end
  end
  
  def show
    provides :html,:text,:yml,:yaml,:json,:xml,:csv,:ini,:time,:iframe
    
    @stamp=Stamp.first_or_create(:digest=>params[:digest])
    @stamp.record_referrer(request.referer)
    if content_type==:iframe
      headers["Content-Type"]="text/html"
    end
    display @stamp
    
  end
end
