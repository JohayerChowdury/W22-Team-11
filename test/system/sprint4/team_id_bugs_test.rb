require "application_system_test_case"

# Acceptance Criteria:
# 1. Team name shows correctly on feedbacks index page

class TeamIdBugsTest < ApplicationSystemTestCase
  def test_display_feedback
    prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1')
    team.user = prof 
    team.save!
    
    feedback1 = save_feedback(4, 4, 4, 4, 4, "Data1", user1, DateTime.civil_from_format(:local, 2021, 02, 15), team, 2)
    feedback2 = save_feedback(4, 3, 4, 3, 4, "Data2", user2, DateTime.civil_from_format(:local, 2021, 02, 16), team, 2)

    # log professor in
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Feedback & Ratings'
    
    assert_text 'Team 1'
  end
end
