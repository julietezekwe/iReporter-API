require 'rails_helper'

RSpec.describe CommentReply, type: :model do
  describe "Associations" do
    it { should belong_to(:comment) }
    it { should belong_to(:reporter) }
  end

  describe "Validations" do
    it { validate_presence_of(:body) }
    it { validate_presence_of(:reporter_id) }
    it { validate_presence_of(:comment_id) }
  end
end
