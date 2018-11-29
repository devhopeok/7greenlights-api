require 'spec_helper'

describe DomainRedirectionMiddleware do
  describe 'call' do
    let(:app) { double('Rack Application')}

    subject(:call_middleware) do
      DomainRedirectionMiddleware
        .new(app, 'api.7greenlights.com', 'www.7greenlights.com')
        .call(env)
    end

    context 'when the request is for an alternative host' do
      let(:env) do
        {
          'HTTP_HOST' => '7g.rocks',
          'REQUEST_PATH' => '/some/content'
        }
      end

      it 'returns redirect status' do
        expect(call_middleware[0]).to eq(301)
      end

      it 'saves the redirection hit' do
        expect{ call_middleware }.to change(RedirectionHit, :count).by(1)
      end

      it 'saves where the redirection came from' do
        call_middleware
        expect(RedirectionHit.last.origin).to eq('7g.rocks')
        expect(RedirectionHit.last.path).to eq('/some/content')
      end

      it 'returns redirect to the main host' do
        expect(call_middleware[1]['Location'])
          .to eq('https://www.7greenlights.com/some/content')
      end
    end

    context 'when the request is for the api host' do
      let(:env) do
        {
          'HTTP_HOST' => 'api.7greenlights.com',
          'REQUEST_PATH' => '/api/v1/status'
        }
      end

      it 'returns success status' do
        expect(app).to receive(:call).and_return([200, {}, {}])
        expect(call_middleware[0]).to eq(200)
      end
    end
  end
end
