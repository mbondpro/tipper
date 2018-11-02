class Report

  # Generates reports. Uses R, via RServe, to plot graphs

  require 'rserve'
  include Rserve  # Install separately

  attr_accessor :ver, :c,
    :treatments_by_period, :total_costs, :average_costs,
    :total_tips, :average_tips, :total_commissions, :average_commissions, 
    :total_earned, :average_earned, :this_period, :last_date,
    :treatments_by_date, :current_user,
    :treatments,  :treatments_by_week,
    :weekly_average_costs, :weekly_average_tips, :weekly_average_commissions, :weekly_average_earned,
    :weekly_costs, :weekly_commissions, :weekly_tips, :weekly_total_earned

  # Generate report via several batches of data
  def initialize(current_user)
    @current_user = current_user

    # Period-by-period data
    dates = PayPeriod.period_dates  # [period, first, last]
    treatments = dates.map {|d| @current_user.treatments.between(d[1],d[2])}
    costs = treatments.map {|t| t.sum(&:cost) }
    commissions = treatments.map {|t| t.sum(&:commission_earned) }
    tips = treatments.map {|t| t.sum(:tip) }
    total_earned = treatments.map {|t| t.sum(&:total_earned) }
    #all in reverse period order
    @treatments_by_period = [dates, costs, commissions, tips, total_earned].transpose.reverse

    # Summary data
    @total_costs = costs.sum.to_f
    @average_costs = @total_costs / costs.length
    @total_tips = tips.sum.to_f
    @average_tips = @total_tips / tips.length
    @total_commissions = commissions.sum.to_f
    @average_commissions = @total_commissions / commissions.length
    @total_earned = total_earned.sum.to_f
    @average_earned = @total_earned / total_earned.length

    #Current period, day-by-day
    @this_period = @treatments_by_period.first
    @last_date = PayPeriod.last_date
    each_date = PayPeriod.each_date
    t_by_date = each_date.map {|d| treatments.last.select{|t| t.date == d } }
    cur_costs = t_by_date.map {|t| t.sum(&:cost) }
    cur_commissions = t_by_date.map {|t| t.sum(&:commission_earned) }
    cur_tips = t_by_date.map {|t| t.sum(&:tip) }
    cur_total_earned = t_by_date.map {|t| t.sum(&:total_earned) }
    @treatments_by_date = [each_date, cur_costs, cur_commissions, cur_tips, cur_total_earned].transpose.reverse

    #Week-by-week data
    weekly_dates = PayPeriod.weekly_dates  # [period, first, last]
    weekly_treatments =  weekly_dates.map {|d| @current_user.treatments.between(d[1],d[2])}
    @weekly_costs = weekly_treatments.map {|t| t.sum(&:cost) }
    @weekly_commissions = weekly_treatments.map {|t| t.sum(&:commission_earned) }
    @weekly_tips = weekly_treatments.map {|t| t.sum(:tip) }
    @weekly_total_earned = weekly_treatments.map {|t| t.sum(&:total_earned) }
    @treatments_by_week = [weekly_dates, @weekly_costs, @weekly_commissions, @weekly_tips, @weekly_total_earned].transpose.reverse

    #Weekly Summary
    @weekly_average_costs = @total_costs / weekly_costs.length
    @weekly_average_tips = @total_tips / weekly_tips.length
    @weekly_average_commissions = @total_commissions / weekly_commissions.length
    @weekly_average_earned = @total_earned / weekly_total_earned.length

    plot
  end

  # Generate R plots based on table data
  def plot
    @c = Connection.new #RServe connection

    # Assign Ruby vars to R vars
    @c.assign("wcosts", @weekly_costs)
    @c.assign("wcosts_path", File.join(Rails.root, "public", "plot", "#{@current_user.id.to_s}_weekly_costs.png"))
    @c.assign("wcoms", @weekly_commissions)  
    @c.assign("wcoms_path", File.join(Rails.root, "public", "plot", "#{@current_user.id.to_s}_weekly_coms.png"))
    @c.assign("wtips", @weekly_tips)  
    @c.assign("wtips_path", File.join(Rails.root, "public", "plot", "#{@current_user.id.to_s}_weekly_tips.png"))
    @c.assign("wtots", @weekly_total_earned)  
    @c.assign("wtots_path", File.join(Rails.root, "public", "plot", "#{@current_user.id.to_s}_weekly_tots.png"))
   
    #############################
    # R code between OEFs below
    #############################

    # Costs
    @c.void_eval <<-EOF
      png(filename=wcosts_path)
      plot(wcosts, main='Cost of Services Provided Each Week', xlab='Week No.', ylab='Cost of Services', type="l")
      dev.off()
    EOF

    # Commissions
    @c.void_eval <<-EOF
      png(filename=wcoms_path)
      plot(wcoms, main='Commissions Earned Each Week', xlab='Week No.', ylab='Commissions', type="l")
      dev.off()
    EOF

    # Tips
    @c.void_eval <<-EOF
      png(filename=wtips_path)
      plot(wtips, main='Tips Earned Each Week', xlab='Week No.', ylab='Tips', type="l")
      dev.off()
    EOF

    # Totals
    @c.void_eval <<-EOF
      png(filename=wtots_path)
      plot(wtots, main='Total Amount Earned Each Week', xlab='Week No.', ylab='Total Earnings', type="l")
      dev.off()
    EOF


  end

end

