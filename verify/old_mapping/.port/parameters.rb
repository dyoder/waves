context "A developer can extract parameters from a request path or URL." do

  specify 'Extract a parameter via a regexp match of the path.' do
    get('/param/elephant').body.should == 'You asked for: elephant.'
  end

  specify 'Extract a parameter via a regexp match of the URL.' do
    get('/port').body.should == '3000'
  end

end
