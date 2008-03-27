context "A developer can map requests to filters." do
  
  specify "Map a path to a 'before', 'after' and 'wrap' filters." do
    get('/filters').body.should == 'Before::Wrap:During:Wrap::After'
  end
  
  specify "Map a POST to a path to a 'before', 'after' and 'wrap' filters" do
    post('/filters').body.should == 'Before post:Before::Wrap post::Wrap:During:Wrap post::Wrap:After post::After'
  end
  
  specify "The 'before', 'after' and 'wrap' filters accept a regular expression and can extract parameters from the request path" do            
    get('/filters/xyz').body.should == 'Before xyz::Wrap xyz:During:Wrap xyz::After xyz'
  end
  
  specify "When having 'before', 'after' and 'wrap' filters but no corresponding map action this results in a 404" do
    get('/filters_with_no_map').body.should =~ '404'
  end
  
end