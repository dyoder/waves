class Proc

  # calls the given lambda with the receiver as its argument
  def |(lambda)
    lambda do
      lambda.call( self.call )
    end
  end

end
