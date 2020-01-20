require_relative 'helpers.rb'

shared_examples 'simple crud for create' do
  describe 'POST #create' do
    context 'without authenticated user' do
      subject!(:req) { post :create, params: attributes_for(model_class) }

      include_examples 'unauthorized when not logged in' if check_authenticate(:create)
    end

    if check_authorize(:destroy)
      context 'when not authorized' do
        subject!(:req) { post :create, params: model_params }

        it 'fails with forbidden' do
          make_policies_fail(:create)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when successfully creating an article' do
      include_context 'with authenticated user' if check_authenticate(:create)

      before do
        post :create, params: model_params
      end

      it 'response with 200 status code' do
        expect(response).to have_http_status(:created)
      end

      it 'creates an article' do
        expect(model_class_object.count).to be 1
      end

      it 'creates an article with valid attributes' do
        expect(model_class_object.last).to have_attributes(model_params)
      end
    end
  end
end
