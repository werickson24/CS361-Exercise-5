# Exercise 5

class LaunchDiscussionWorkflow

  def initialize(discussion)
    @discussion = discussion
  end

  def run
    return unless valid?
    
    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        run_discussion!
      end
    end
  end
  
  #this may be better off in its own class, however i don't know how these functions, or the transaction callbacks work. 
  def run_discussion!
    @discussion.save!
    create_discussion_roles!
    @successful = true
  end
  
  # ...

end

# add this to user class or perhaps a different utility class
def generate_participant_users_from_email_string(participants_email_string)
  raise "participant string cannot be blank" if participants_email_string.blank?
  
  user_array = []
  
  participants_email_string.split.uniq.map do |email_address|
    new user = User.new(email: email_address.downcase, password: Devise.friendly_token)
    user.create
    user_array << user
  end
  
end

# this process of retrieving all the parts of a discussion should be done in a way to not require such a complicated process. 
## for example, processing the participant string when recieving it as input.
host = User.find(42)
participants_string = "fake1@example.com\nfake2@example.com\nfake3@example.com"
participants = User.generate_participant_users_from_email_string(participants_string);
discussion = Discussion.new(title: "fake", host: host, participants: participants)

workflow = LaunchDiscussionWorkflow.new(discussion)
workflow.run
