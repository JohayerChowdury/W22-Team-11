require "application_system_test_case"
# Acceptance Criteria
# 1. As a professor, I will receive a delete confirmation message when I want to delete a student account
class ConfirmDeleteUsersTest < ApplicationSystemTestCase
  setup do 
    @prof = User.new(email: 'msmucker@gmail.com', password: 'professor', password_confirmation: 'professor', first_name: 'Mark',last_name: 'Smith', is_admin: true)
    @prof.save
    @user1 = User.new(email: 'adam@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'Adam', last_name: 'Smith', is_admin: false)
    @user1.save

    @team1 = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    @team1.user = @prof
    @team1.save
    @user1.teams << @team1
  end
  
  def test_confirmation_page_when_deleting_user
    #Passes acceptance criteria 1: As a professor, I will receive a delete confirmation message when I want to delete a student account
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    
    click_on 'Manage Users'
    assert_current_path users_url
    
    within('#user' + @user1.id.to_s) do
      assert_text @user1.email
      assert_text @user1.first_name
      click_on 'Delete User'
    end
    
    assert_equal 2, User.count
    
    assert_current_path user_confirm_delete_path(@user1)
    assert_text "Confirm Delete #{@user1.first_name + ' ' + @user1.last_name}"
    click_on "Delete User"
    
    assert_current_path users_url 
    assert_text "User was successfully destroyed."
    assert_equal 1, User.count
    assert_no_text @user1.email
    assert_no_text @user1.first_name
  end 
end
