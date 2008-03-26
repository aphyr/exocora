require File.dirname(__FILE__) + '/../helper.rb'

describe 'an array' do
  it 'should make sentences with 0 elements' do
    [].to_sentence.should.equal ''
  end

  it 'should make sentences with 1 elements' do
    [0].to_sentence.should.equal '0'
  end

  it 'should make sentences with 2 elements' do
    [0, 1].to_sentence.should.equal '0 and 1'
  end

  it 'should make sentences with many elements' do
    [0, 1, 2, 3, 4].to_sentence.should.equal '0, 1, 2, 3, and 4'
  end
end
