require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    describe "comments#create action" do
        it "should allow users to create comments for grams" do
            gram = FactoryBot.create(:gram)
            user = FactoryBot.create(:user)
            sign_in user
            
            post :create, params: { gram_id: gram.id, comment: { message: 'cool gram dude' } }
            
            expect(response).to redirect_to root_path
            expect(gram.comments.length).to eq 1
            expect(gram.comments.first.message).to eq "awesome gram"
        end
        
        it "should only allow authorized users to create comments" do
            gram = FactoryBot.create(:gram)
            post :create, params: { gram_id: gram.id, comment: { message: 'cool gram dude' } }
            expect(response).to redirect_to new_user_session_path
        end
        
        it "should show a 404 message for comment attempts on invalid gram ids" do 
            user = FactoryBot.create(:user)
            sign_in user
            
            post :create, params: { gram_id: 'YOLO', comment: { message: 'cool gram dude' } }
            expect(response).to have_http_status :not_found
        end
    end

end
