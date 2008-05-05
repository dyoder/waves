class Proc
  
  def |(lambda)
    lambda do
      lambda.call( self.call )
    end
  end
  
end