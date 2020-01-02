shared_examples 'simple crud for destroy' do
  describe 'DELETE #destroy' do
    let(:model_class) do
      described_class.to_s.split('::')
                     .last.sub('Controller', '').singularize.underscore
    end
    let(:model) do
      create(model_class)
    end

    context 'without authenticated user' do
      subject!(:req) { delete :destroy, params: { id: 1 } }

      include_examples 'unauthorized when not logged in'
    end

    context 'when ID is valid' do
      include_context 'with authenticated user'

      before do
        model
        delete :destroy, params: { id: model.id }
      end

      it 'response with 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when ID is invalid' do
      include_context 'with authenticated user'

      before do
        model
        delete :destroy, params: { id: model.id.next }
      end

      it 'response with 404 status code' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
