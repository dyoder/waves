context "A developer can map requests to filters." do
  
  specify "Map a path to a 'before' filter." do
    get('/filters').body[0..5].should == 'Before'
  end
  
  specify "Map a path to an 'after' filter." do
    get('/filters').body[-5..-1].should == 'After'
  end
  
end