require 'database_helpers'

require 'comment'
require 'peep'

describe Comment do 
  describe '.create' do
    it 'creates a new comment' do
      user = User.create(email: 'test@example.com', password: 'password123')
      peep = Peep.create(text: 'Test 123', user_id: user.id)
      comment = Comment.create(text: 'This is a test comment', peep_id: peep.id)

      persisted_data = persisted_data(table: 'comments', id: comment.id)

      expect(comment).to be_a Comment
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'This is a test comment'
      expect(comment.peep_id).to eq peep.id
    end
  end

  describe '.where' do
    it 'gets the relevant comments from the database' do
      user = User.create(email: 'test@example.com', password: 'password123')
      peep = Peep.create(text: 'Testing 123', user_id: user.id)
      Comment.create(text: 'This is a test comment', peep_id: peep.id)
      Comment.create(text: 'This is a second test comment', peep_id: peep.id)

      comments = Comment.where(peep_id: peep.id)
      comment = comments.first
      persisted_data = persisted_data(table: 'comments', id: comment.id)

      expect(comments.length).to eq 2
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'This is a test comment'
      expect(comment.peep_id).to eq peep.id
    end

  end

end
