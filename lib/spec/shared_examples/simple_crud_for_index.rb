shared_examples 'simple crud for index' do
  describe 'GET #index' do
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
    let(:model_serializer) do
      defined?(serializer) ? serializer : "#{model.class}_serializer".classify.constantize
    end

    let(:created_models) { create_list(model_class, 10) }

    before { created_models }

    if defined?(paginate) && !paginate
      context 'when getting all models' do
        include_context 'with authenticated user'
        before do
          get :index
        end

        it 'renders models correctly serialized' do
          expect(response_body).to have_been_serialized_with(model_serializer).to_json
        end

        it 'renders the correct models' do
          expect(response_body.map(&:id)).to eq(model.all.map(&:id))
        end
      end
    else
      context 'when getting paginated models' do
        include_context 'with authenticated user'
        before do
          get :index
        end

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
