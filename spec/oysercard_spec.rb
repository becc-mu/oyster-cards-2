require 'oystercard'
describe Oystercard do

  describe '#balance' do
    it 'new card should have zero balance' do
      expect(subject.balance).to eq 0
    end
  end

end
