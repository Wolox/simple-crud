shared_examples 'simple crud for update' do
  describe 'PUT #update' do
    let(:model_class) do
      described_class.to_s.split('::')
                     .last.sub('Controller', '').singularize.underscore
    end
    let(:model_class_object) do
      model_class.classify.constantize
    end
    let(:model) do
      create(model_class)
    end

    context 'without authenticated user' do
      subject!(:req) { put :update, params: attributes_for(model_class).merge(id: model.id) }

      include_examples 'unauthorized when not logged in'
    end

    context 'when successfully updating an model' do
      include_context 'with authenticated user'
      let(:model_params) do
        attributes_for(model.class.to_s.underscore.to_sym)
      end

      before do
        model
        put :update, params: model_params.merge(id: model.id)
      end

      it 'response with 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates an model' do
        expect(model_class_object.count).to be 1
      end

      it 'updates an model with valid attributes' do
        expect(model_class.classify.constantize.last).to have_attributes(model_params)
      end
    end

    context 'when updating a model that doesn\'t exist' do
      include_context 'with authenticated user'

      before { put :update, params: { id: 1 } }

      it 'response with 422 status code' do
        expect(response).to have_http_status(:not_found)
      end

      it 'doesn\'t create an model' do
        expect(model_class_object.count).to be 0
      end
    end
  end
end
