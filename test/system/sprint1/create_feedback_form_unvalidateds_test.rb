require "application_system_test_case"

# Acceptance Criteria: 
# 1. When I submit the feedback form, all the input data should be added to
#    the database
# 2. When I select the rating dropdown, all the appropriate ratings should
#    appear
# 3. When I submit the feedback form, the data shold be associated with my 
#    team in the database

class CreateFeedbackFormUnvalidatedsTest < ApplicationSystemTestCase
  setup do
    # create prof, team, and user
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @bob.teams << @team
  end
  
  # Test that feedback can be added using correct form (1, 2)
  def test_add_feedback 
    visit root_url 
    login 'bob@gmail.com', 'testpassword'    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    assert_text "Your Current Team: Test Team"
    
    #select "5", from: "Communication"
    #select "4", from: "Team Support"
    find(:xpath, "//*[@id='feedback_collaboration']").set 5
    find(:xpath, "//*[@id='feedback_communication']").set 4
    find(:xpath, "//*[@id='feedback_team_support']").set 3
    find(:xpath, "//*[@id='feedback_responsibility']").set 2
    find(:xpath, "//*[@id='feedback_work_quality']").set 1
    #select "3", from: "Responsibility"
    #select "2", from: "Work Quality"
    select "Urgent", from: "feedback_priority"
    fill_in "General Comments", with: "This week has gone okay."
    click_on "Create Feedback"
    
    assert_current_path root_url
    
    Feedback.all.each{ |feedback| 
      assert_equal(6 , feedback.rating)
      assert_equal(0 , feedback.priority)
      assert_equal('This week has gone okay.', feedback.comments)
      assert_equal(@bob, feedback.user)
      assert_equal(@team, feedback.team)
    }
  end
  
  # Test that feedback that is added can be viewed (1, 3)
  def test_view_feedback 
    feedback = Feedback.new(communication:5, collaboration:5, team_support:5, responsibility:5, work_quality:5, comments: "This team is disorganized", priority: 0)
    datetime = Time.current
    feedback.timestamp = feedback.format_time(datetime)
    feedback.user = @bob
    feedback.team = @bob.teams.first
    feedback.save
    
    visit root_url 
    login 'msmucker@gmail.com', 'professor'
    
    click_on "Details"
    assert_current_path team_url(@team)
    assert_text "This team is disorganized"
    assert_text "10"
    assert_text "Urgent"
    assert_text "Test Team"
    assert_text datetime.strftime("%Y-%m-%d %H:%M")
  end
end
