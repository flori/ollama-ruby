require 'spec_helper'

RSpec.describe Ollama::Documents do
  let :ollama do
    double('Ollama::Client')
  end

  let :model do
    'mxbai-embed-large'
  end

  let :documents do
    described_class.new ollama:, model:
  end

  it 'can be instantiated' do
    expect(documents).to be_a described_class
  end

  it 'no texts can be added to it' do
    expect(documents.add([])).to eq documents
  end

  it 'texts can be added to it' do
    expect(ollama).to receive(:embed).
      with(model:, input: %w[ foo bar ], options: nil).
      and_return(double(embeddings: [ [ 0.1 ], [ 0.2 ] ]))
    expect(documents.add(%w[ foo bar ])).to eq documents
    expect(documents.exist?('foo')).to eq true
    expect(documents.exist?('bar')).to eq true
    expect(documents['foo']).to be_a Ollama::Documents::Record
  end

  it 'a text can be added to it' do
    expect(ollama).to receive(:embed).
      with(model:, input: %w[ foo ], options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    expect(documents << 'foo').to eq documents
    expect(documents.exist?('foo')).to eq true
    expect(documents.exist?('bar')).to eq false
    expect(documents['foo']).to be_a Ollama::Documents::Record
  end

  it 'can find strings' do
    allow(ollama).to receive(:embed).
      with(model:, input: [ 'foo' ], options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    expect(documents << 'foo').to eq documents
    expect(ollama).to receive(:embed).
      with(model:, input: 'foo', options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    records = documents.find('foo')
    expect(records).to eq [
      Ollama::Documents::Record[text: 'foo', embedding: [ 0.1 ], similarity: 1.0 ]
    ]
    expect(records[0].to_s).to eq '#<Ollama::Documents::Record "foo" 1.0>'
  end

  it 'can find only tagged strings' do
    allow(ollama).to receive(:embed).
      with(model:, input: [ 'foo' ], options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    expect(documents.add('foo', tags: %i[ test ])).to eq documents
    expect(ollama).to receive(:embed).
      with(model:, input: 'foo', options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    records = documents.find('foo', tags: %i[ nix ])
    expect(records).to eq []
    expect(ollama).to receive(:embed).
      with(model:, input: 'foo', options: nil).
      and_return(double(embeddings: [ [ 0.1 ] ]))
    records = documents.find('foo', tags: %i[ test ])
    expect(records).to eq [
      Ollama::Documents::Record[text: 'foo', embedding: [ 0.1 ], similarity: 1.0 ]
    ]
    expect(records[0].to_s).to eq '#<Ollama::Documents::Record "foo" #test 1.0>'
  end

  context 'it uses cache' do
    before do
      allow(ollama).to receive(:embed).
        with(model:, input: %w[ foo ], options: nil).
        and_return(double(embeddings: [ [ 0.1 ] ]))
    end

    it 'can delete texts' do
      expect(documents << 'foo').to eq documents
      expect {
        documents.delete('foo')
      }.to change { documents.exist?('foo') }.from(true).to(false)
    end

    it 'tracks size' do
      expect {
        expect(documents << 'foo').to eq documents
      }.to change { documents.size }.from(0).to(1)
    end

    it 'can clear texts' do
      expect(documents << 'foo').to eq documents
      expect {
        documents.clear
      }.to change { documents.size }.from(1).to(0)
    end

    it 'returns collections' do
      expect(documents.collections).to eq [ :default ]
    end

    it 'can change collection' do
      expect(documents.instance_eval { @cache }).to receive(:prefix=).
        with(/#@collection/).and_call_original
      expect { documents.collection = :new_collection }.
        to change { documents.collection }.
        from(:default).
        to(:new_collection)
    end
  end
end
