require "application_system_test_case"

# Acceptance Criteria:
# 1. Rating should be populated when prof edits feedback

class PopulateEditFeedbackWithRatingTest < ApplicationSystemTestCase
  setup do
    @user = User.new(email: 'test@gmail.com', password: 'password', password_confirmation: 'password', first_name: 'Zac', last_name: 'Smith', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
    @user.teams << @team
    @user.save
    
    datetime =  Time.zone.parse("2021-3-21 23:30:00")
    feedback_time = Time.zone.parse("2021-3-20 23:30:00")
    travel_to datetime
    @feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", @user, Time.zone.now.to_datetime - 30, @team, 2) 
  end 
    
  def population_test
       visit root_url 
       login 'msmucker@gmail.com', 'professor'
       
       click_on "Feedback & Ratings"
       click_on "Edit"
       assert_text "Student Name: Zac Smith"
       assert_text "Your Current Team: Test Team"
       assert_text "10"
       assert_text "This team is disorganized"
       assert_text "Low"
    
  end
end
