require 'spec_helper'

RSpec.describe Ollama::Image do
  let :image do
    described_class.for_filename(asset('kitten.jpg'))
  end

  it 'can be instantiated' do
    expect(image).to be_a described_class
  end

  it 'cannot be created via .new' do
    expect {
      described_class.new('nix')
    }.to raise_error NoMethodError
  end

  it 'can be converted to base64 string' do
    expect(image.to_s.size).to eq 134400
    expect(image.to_s.sum).to eq 42460
    expect(image.to_s[0, 40]).to eq '/9j/4AAQSkZJRgABAQAASABIAAD/4QBYRXhpZgAA'
  end

  it 'tracks path of file' do
    expect(image.path).to eq asset('kitten.jpg')
  end
end
