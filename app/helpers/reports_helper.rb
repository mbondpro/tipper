module ReportsHelper

  # Create img tags for data plots within report
  def plot(filename)    
    path = File.join("plot", filename)
    tag("img", :src => path)
  end
end
