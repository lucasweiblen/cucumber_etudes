require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    let!(:login) { mock_model("Login").as_new_record }
    
    it 'sends new message' do
      expect(Login).to receive(:new)
      get :new
    end

    it 'renders new template' do
      get :new
      expect(response).to render_template :new
    end

    it 'assigns @login instance variable to the view' do
      allow(Login).to receive(:new).and_return(login)
      get :new
      expect(assigns[:login]).to eq login
    end
  end

  describe 'post create' do
    let(:params) { { email: 'email@email.com', password: 'pass' } }
    let!(:login) { stub_model(Login) }

    before do
      allow(Login).to receive(:new).and_return(login)
    end

    context 'when data is valid' do
      before do
        allow(login).to receive(:valid?).and_return(true)
      end

      it 'sends authenticate message to Login model' do
        expect(login).to receive(:authenticate)
        post :create, login: params
      end

      context 'when authenticate method returns true' do
        before do
          allow(login).to receive(:authenticate).and_return(true)
          post :create, login: params
        end
        
        it 'redirects to root url' do
          expect(response).to redirect_to root_url
        end

        it 'assigns success message' do
          expect(flash[:notice]).not_to be_nil
        end

        it 'authenticates reader' do
          expect(session[:reader_id]).not_to be_nil
        end
      end
    end
  end
end
