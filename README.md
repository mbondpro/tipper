# Tips and Commissions Tracker

This is a Ruby on Rails 3.2 application that allows the tracking of one's own tips and commissions. This is especially helpful for those in the beauty or skin care industry who would like to compare their annotation of their earnings against those on a pay stub, as errors can occur. Additionally, the user can access reports that show weekly or pay-period-based stats in both table form and in graphs.

See a video walkthrough here: https://mbondpro.blogspot.com/2018/11/tips-and-commissions-tracker-code-and.html

To set up, don't forget to perform the following actions:

For Capistrano deployment, configure deploy.rb with your info.
Configre config/database.yml with your DB info.
Set the secret key within config/initializers/secret_token.rb
Set your email info within config/initializers/devise.rb
Set config/environments/
Update views, as desired, with customized text.
