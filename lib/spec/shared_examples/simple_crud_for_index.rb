shared_examples 'simple crud for index' do
  describe 'GET #index' do
    let(:created_models) { create_list(model_class, 10) }

    before { created_models }

    context 'without authenticated user' do
      subject!(:req) { get :index }

      include_examples 'unauthorized when not logged in' if check_authenticate(:create)
    end

    if check_authorize(:create)
      context 'when not authorized' do
        subject!(:req) { get :index }

        it 'fails with forbidden' do
          make_policies_fail(:index)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with authenticated user' do
      include_context 'with authenticated user' if check_authenticate(:index)
      before do
        make_policies_succeed(:index)
        get :index
      end

      if check_paginate(:index)
        it 'renders models correctly serialized' do
          expect(response_body).to have_been_serialized_with(model_serializer).to_json
        end

        it 'renders the correct models' do
          expect(response_body.map(&:id)).to eq(model.all.map(&:id))
        end
      else
        it 'renders models correctly serialized' do
          ### TODO: fix
          # expect(response_body['page']).to have_been_serialized_with(model_serializer).to_json
        end

        it 'renders the correct models' do
          ids = response_body['page'].map { |a| a['id'] }
          expect(ids).to eq(model_class_object.all.map(&:id).take(ids.count))
        end
      end
    end
  end
end
