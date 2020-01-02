shared_examples 'simple crud for create' do
  describe 'POST #create' do
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
      subject!(:req) { post :create, params: attributes_for(model_class) }

      include_examples 'unauthorized when not logged in'
    end

    context 'when successfully creating an article' do
      include_context 'with authenticated user'
      let(:model_params) do
        attributes_for(model_class)
      end

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
